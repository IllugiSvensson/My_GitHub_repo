#include <MsgSender_lib.au3>

;Проверка бинаря на права администратора
If IsAdmin() = 0 Then		;Приложение должно быть запущено под рутом

	MsgBox(16, "Ошибка", "Пожалуйста, запустите приложение" & @CRLF & "с правами администратора.", 5)
	Exit

EndIf



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

				If CreateAccount() Then ContinueLoop	;Создание аккаунта и настройка
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
		Return 1			;Выходим обратно в цикл

	Else

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
		;Проверим запись, если она не создалась, предлагаем записать вручную
		If RegRead("HKEY_CLASSES_ROOT\httpn\shell\open\command", "") <> "\\main\GetStand\App\httpN\httpN_Windows.exe %1" Then

			$PID = Run(@ComSpec&' /c regedit', '', @SW_HIDE, $STDOUT_CHILD)	;Запускаем реестр и показываем строку
			MsgBox(16, "Ошибка", "Запись в реестр не добавлена" & @CRLF & "Попробуйте добавить вручную:" & @CRLF & @CRLF & "HKEY_CLASSES_ROOT\httpn\shell\open\command," & @CRLF & "(по умолчанию) -> \\main\GetStand\App\httpN\httpN_Windows.exe %1" & @CRLF & @CRLF & "HKEY_CLASSES_ROOT\httpn, два параметра:" & @CRLF & "(по умолчанию) -> URL:httpn Protocol" & @CRLF & "URL Protocol -> без значений" & @CRLF & "Все параметры строковые(REG_SZ)", 0, $GUI)
			ProcessWaitClose($PID)
			Return 1	;Ждем закрытия реестра и проверяем по новой

		EndIf

		$ipAddr = ""
		For $i = 0 To (UBound($ip) - 1) Step +1			;Перебираем адреса

			$PID = Run(@ComSpec&' /c ipconfig | findstr ' & $ip[$i], '', @SW_HIDE, $STDOUT_CHILD) ;Ищем свой ip адрес
			$sStdOutRead = ""		;В консоли получаем строку со своим адресом, запишем её в переменную
				While 1				;Конструкция нужна, чтобы прочитать вывод из консоли(строку с найденным адресом)

					$sStdOutRead &= StdoutRead($PID)	;Читаем строку из консоли
					If @error Then ExitLoop

				WEnd
			if $sStdOutRead <> "" Then					;Если нашли подходящий адрес

				$ipAddr = StringRegExp($sStdOutRead, "((\d{1,3}\.){3}\d{1,3})", 3) 	;Выделяем адрес из строки вывода
				$MAC = GetMac($ipAddr[0])				;Получаем мак
				FileWrite("\\main\GetStand\App\httpN\system\MAC", @CRLF & $MAC & " " & $text & " ts7kvm5")

			EndIf

		Next

		if IsArray($ipAddr) = 0 Then					;Если адресов не нашли

			BotMsg("🛑MAC-адрес не определен" & @CRLF & "❌" & $text & @CRLF & "⏱" & _Now(), $sBotKey, $nChatId)
			FileWriteLine("\\main\GetStand\App\httpN\system\log\system.txt", StringFormat("%-19s", _Now()) & " | " & "MAC-адрес не определен. Проверьте адрес пользователя: " & $text)
			$PID = Run(@ComSpec&' /c control.exe NETCONNECTIONS', '', @SW_HIDE, $STDOUT_CHILD)
			MsgBox(16, "Ошибка", "MAC-адрес не определен." & @CRLF & "Обратитесь в Отдел Тестирования.", 5, $GUI)
			ProcessWaitClose($PID)						;Ждем когда отредактируют сеть
			Return 1

		Else											;Если адрес нашли, завершаем настройку

			BotMsg("✅Новый пользователь добавлен" & @CRLF & "👤" & $text & "🪟Windows" & @CRLF & "⏱" & _Now(), $sBotKey, $nChatId)
			FileWriteLine("\\main\GetStand\App\httpN\system\log\system.txt", StringFormat("%-19s", _Now()) & " | " & "Добавлен новый пользователь Windows: " & $text)
			FileCreateShortCut("\\main\GetStand\Diagrams\DiagramsOT.html", @DesktopDir & "\DiagramsOT")			;Делаем ярлык схемы на десктоп
			MsgBox(64, "GetStand", "Аккаунт успешно создан!" & @CRLF & "Приятного пользования 😉", 5, $GUI)
			GUIDelete($GUI)
			ShellExecute(@DesktopDir & "\DiagramsOT.lnk")

		EndIf

	EndIf

Return 0
EndFunc