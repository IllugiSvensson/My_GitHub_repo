#include <MsgSender_lib.au3>

;Проверка бинаря на права администратора
;If IsAdmin() = 0 Then		;Приложение должно быть запущено под рутом
;
;	MsgBox(16, "Ошибка", "Пожалуйста, запустите приложение" & @CRLF & "с правами администратора.", 5)
;	Exit
;
;EndIf



;ОТРИСОВЫВАЕМ ОСНОВНОЕ ОКНО
$GUI = GUICreate("GetStand Windows version", 384, 336, -1, -1, $WS_DLGFRAME)
$Label1 = GUICtrlCreateLabel("   Приветствую вас в системе GetStand!" , 12, 12, 360, 30, $WS_BORDER, $WS_EX_DLGMODALFRAME)
GUICtrlSetFont($Label1, 14)
$Label2 = GUICtrlCreateLabel("Регистрация", 24, 54, 336, 45)
GUICtrlSetFont($Label2, 14)
$Label3 = GUICtrlCreateLabel("Пожалуйста, введите свои данные в следующем формате: Иванов Иван(iva)", 24, 80, 336, 38)
GUICtrlSetFont($Label3, 12)
$Input = GUICtrlCreateInput('Фамилия Имя(инициал)', 24, 120, 336, 30)
GUICtrlSetFont($Input, 14)
$Label4 = GUICtrlCreateLabel("Остальные настройки будут выполнены автоматически.", 24, 168, 336, 38)
GUICtrlSetFont($Label4, 12)
$ButtonCreate = GUICtrlCreateButton("Продолжить", 48, 240, 132, 54)
GUICtrlSetFont($ButtonCreate, 16)
$ButtonCancel = GUICtrlCreateButton("Выход", 210, 240, 132, 54)
GUICtrlSetFont($ButtonCancel, 16)
GUISetState()

While True	;Следим за нажатием кнопок

	Switch GUIGetMsg()

		Case $ButtonCreate		;Если согласны подключиться
			If MsgBox(36, "GetStand", "Подключиться к системе GetStand?", 0, $GUI) = 6 Then

				If CreateAccount() Then ContinueLoop	;Создание аккаунта
				RegEdit()								;Настройки реестра
				;ShortCut()								;Ссылка на схему
				ExitLoop

			EndIf

		Case $ButtonCancel
			ExitLoop

	EndSwitch

WEnd





;ПОЛЬЗОВАТЕЛЬСКИЕ ФУНКЦИИ
Func CreateAccount()		;Функция регистрации пользователя

	$text = GUICtrlRead($Input)			;Читаем ввод и проверяем по шаблону
	$a = StringRegExp($text, "[а-яА-Я]{1,}\s{1,}[а-яА-Я]{1,}\(\w+\)", 3)
	If IsArray($a) = 0 Then				;Если ошибка

		MsgBox(16, "Ошибка", "Ошибка в записи имени." & @CRLF & "Введите данные по шаблону", 5, $GUI)
		Return 1

	Else

		Dim $ip[4] = ["192.168.31.", "192.168.30.", "192.168.18.", "192.168.122."]	;Список может будет пополняться
		$ipAddr = ""
		For $i = 0 To (UBound($ip) - 1) Step +1			;Перебираем адреса

			$PID = Run(@ComSpec&' /c ipconfig | findstr ' & $ip[$i], '', @SW_HIDE, $STDOUT_CHILD) ;Ищем свой ip адрес
			$sStdOutRead = ""		;В консоли получаем строку со своим адресом, запишем её в переменную
				While 1				;Конструкция нужна, чтобы прочитать вывод из консоли(строку с найденным адресом)

					$sStdOutRead &= StdoutRead($PID)	;Читаем строку из консоли
					If @error Then ExitLoop

				WEnd
			if $sStdOutRead <> "" Then					;Пропускаем пустые строки

				$ipAddr = StringRegExp($sStdOutRead, "((\d{1,3}\.){3}\d{1,3})", 3) 	;Выделяем наш адрес из строки вывода
				$MAC = GetMac($ipAddr[0])
				FileWrite("\\main\GetStand\App\httpN\system\MAC", @CRLF & $MAC & " " & $text & " ts7kvm5")

			EndIf

		Next

		if IsArray($ipAddr) = 0 Then

			BotMsg("🛑Ошибка при установке" & @CRLF & "❌MAC-адрес не определен" & @CRLF & " ⏱" & _Now(), $sBotKey, $nChatId)
			FileWriteLine("\\main\GetStand\App\httpN\system\log\system.txt", StringFormat("%-19s", _Now()) & " | " & "MAC-адрес не определен при установке. Проверьте адрес пользователя.")
			MsgBox(16, "Ошибка", "MAC-адрес не определился." & @CRLF & "Обратитесь в Отдел Тестирования.", 5, $GUI)
			Exit

		Else

			MsgBox(64, "GetStand", "Аккаунт пользователя создан", 3, $GUI)

		EndIf

	EndIf

Return 0
EndFunc






Func RegEdit()				;Функция редактирования реестра

	;Задаем в реестре основные записи
	RegWrite("HKEY_CLASSES_ROOT\httpn", "", "REG_SZ", "URL:httpn Protocol")
	RegWrite("HKEY_CLASSES_ROOT\httpn", "URL Protocol", "REG_SZ", "")
	RegWrite("HKEY_CLASSES_ROOT\httpn\shell\open\command", "", "REG_SZ", "\\main\GetStand\App\httpN\httpN_Windows.exe " & "%1" )
	RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome", "ExternalProtocolDialogShowAlwaysOpenCheckbox", "REG_DWORD", "00000001")
	RegWrite("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Command Processor", "DisableUNCCheck", "REG_DWORD", "00000001")
	RegWrite("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\main", "file", "REG_DWORD", "00000001")
	RegWrite("HKEY_CURRENT_USER\SOFTWARE\RealVNC\vncviewer", "EnableAnalytics", "REG_SZ", "0")
	RegWrite("HKEY_CURRENT_USER\SOFTWARE\RealVNC\vncviewer", "_SplashVer", "REG_SZ", "1")
	RegWrite("HKEY_CURRENT_USER\SOFTWARE\RealVNC\vncviewer", "_Sidebar", "REG_SZ", "0")
	RegWrite("HKEY_CURRENT_USER\SOFTWARE\RealVNC\vncviewer", "_SortBy", "REG_SZ", "")
	RegWrite("HKEY_CURRENT_USER\SOFTWARE\RealVNC\vncviewer", "_SidebarWidth", "REG_SZ", "480")
	RegWrite("HKEY_CURRENT_USER\SOFTWARE\RealVNC\vncviewer", "AllowSignIn", "REG_SZ", "0")
	RegWrite("HKEY_CURRENT_USER\SOFTWARE\RealVNC\vncviewer", "Log", "REG_SZ", "*:file:10")
	RegWrite("HKEY_CURRENT_USER\SOFTWARE\RealVNC\vncviewer", "LogDir", "REG_SZ", "\\main\GetStand\App\vnc\Log")
	RegWrite("HKEY_CURRENT_USER\SOFTWARE\RealVNC\vncviewer", "UserName", "REG_SZ", "")
	RegWrite("HKEY_CURRENT_USER\SOFTWARE\RealVNC\vncviewer", "WarnUnencrypted", "REG_SZ", "0")
	RegWrite("HKEY_CURRENT_USER\SOFTWARE\RealVNC\vncviewer", "VerifyId", "REG_SZ", "0")
	RegWrite("HKEY_CURRENT_USER\SOFTWARE\RealVNC\vncviewer", "_ColumnWidths", "REG_SZ", "name:188,lastConn:185")
	RegWrite("HKEY_CURRENT_USER\SOFTWARE\RealVNC\vncviewer", "LogFile", "REG_SZ", "$USERDOMAIN.log")

	;Спрашиваем, нужны ли настройки прокси
	If MsgBox(36, "GetStand", "Включить прокси сервер proxy.nita.ru:3128?" & @CRLF & "Будут добавлены параметры прокси:" & @CRLF & "*.nita.ru;*.ot.net;10.7.*;192.168.*;pi.hole;<local>", 0, $GUI) = 6 Then

		$proxy = RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings", "ProxyOverride")
		RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings", "ProxyOverride", "REG_SZ", "*.nita.ru;*.ot.net;10.7.*;192.168.*;pi.hole;" & $proxy)
		RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings", "ProxyEnable", "REG_DWORD", "00000001")
		RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings", "ProxyServer", "REG_SZ", "http://proxy.nita.ru:3128")

	EndIf

	If RegRead("HKEY_CLASSES_ROOT\httpn\shell\open\command", "") <> "\\main\GetStand\App\httpN\httpN_Windows.exe %1" Then

		$PID = Run(@ComSpec&' /c regedit', '', @SW_HIDE, $STDOUT_CHILD)
		MsgBox(16, "Ошибка", "Запись в реестр не добавлена" & @CRLF & "Попробуйте добавить вручную:" & @CRLF & "HKEY_CLASSES_ROOT\httpn\shell\open\command, REG_SZ, \\main\GetStand\App\httpN\httpN_Windows.exe %1", 0, $GUI)
		ProcessWaitClose($PID)

	EndIf

EndFunc

Func ShortCut()			;Функция создания ссылки на схему и завершения работы

	Exit
	FileCreateShortCut("\\main\GetStand\Diagrams\DiagramsOT.html", @DesktopDir & "\DiagramsOT")
	GUIDelete($GUI)
	MsgBox(0, "GetStand", "Настройки произведены успешно", 5)
	ShellExecute(@DesktopDir & "\DiagramsOT.lnk")

EndFunc