#include <httpN_Windows_lib.au3>



;ОТРИСОВЫВАЕМ ОСНОВНОЕ ОКНО
#RequireAdmin
Global $GUI = GUICreate("GetStand Windows version", 384, 336, -1, -1, $WS_DLGFRAME)
Local $Label1 = GUICtrlCreateLabel("Приветствую вас в системе GetStand!" , 12, 12, 360, 30, $WS_BORDER, $WS_EX_DLGMODALFRAME)
GUICtrlSetFont($Label1, 15)
Local $Label2 = GUICtrlCreateLabel("Регистрация", 24, 54, 336, 45)
GUICtrlSetFont($Label2, 16)
Local $Label3 = GUICtrlCreateLabel("Пожалуйста, введите свои данные в следующем формате: Иванов Иван(iva)", 24, 80, 336, 45)
GUICtrlSetFont($Label3, 14)
Local $Input = GUICtrlCreateInput('Фамилия Имя(username)', 24, 130, 336, 30)
GUICtrlSetFont($Input, 14)
Local $Label4 = GUICtrlCreateLabel("Остальные настройки будут выполнены автоматически.", 24, 168, 336, 38)
GUICtrlSetFont($Label4, 12)
Local $ButtonCreate = GUICtrlCreateButton("Продолжить", 48, 240, 132, 54)
GUICtrlSetFont($ButtonCreate, 16)
Local $ButtonCancel = GUICtrlCreateButton("Выход", 210, 240, 132, 54)
GUICtrlSetFont($ButtonCancel, 16)
GUISetState()



Global $appfolder = StringTrimRight(@ScriptDIr, 8)
While True					;Следим за нажатием кнопок

	Switch GUIGetMsg()

		Case $ButtonCreate	;Если согласны подключиться
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

	Local $text = GUICtrlRead($Input)		;Читаем ввод и проверяем по шаблону
	Local $a = StringRegExp($text, "[а-яА-Я]{1,}\s{1,}[а-яА-Я]{1,}\(\w+\)", 3)
	If IsArray($a) = 0 Then					;Если ошибка

		MsgBox(16, "Ошибка", "Ошибка в записи имени" & @CRLF & "Введите данные по шаблону", 5, $GUI)
		Return 1							;Выходим обратно в цикл

	Else

		;Задаем в реестре основные записи
		RegWrite("HKEY_CLASSES_ROOT\httpn", "", "REG_SZ", "URL:httpn Protocol")
		RegWrite("HKEY_CLASSES_ROOT\httpn", "URL Protocol", "REG_SZ", "")
		RegWrite("HKEY_CLASSES_ROOT\httpn\shell\open\command", "", "REG_SZ", $appfolder & "\App\httpN\httpN_Windows.exe " & "%1" )
		RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Google\Chrome", "ExternalProtocolDialogShowAlwaysOpenCheckbox", "REG_DWORD", "00000001")
		RegWrite("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Command Processor", "DisableUNCCheck", "REG_DWORD", "00000001")
		RegWrite("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\ZoneMap\Domains\main", "file", "REG_DWORD", "00000001")
		;Проверим запись, если она не создалась, предлагаем записать вручную
		If RegRead("HKEY_CLASSES_ROOT\httpn\shell\open\command", "") <> $appfolder & "\App\httpN\httpN_Windows.exe %1" Then

			Local $PID = Run(@ComSpec&' /c regedit', '', @SW_HIDE, $STDOUT_CHILD)	;Запускаем реестр и показываем строку
			MsgBox(16, "Ошибка", "Запись в реестр не добавлена" & @CRLF & "Попробуйте добавить вручную:" & @CRLF & @CRLF & "HKEY_CLASSES_ROOT\httpn\shell\open\command," & @CRLF & "(по умолчанию) -> " & $appfolder & "\App\httpN\httpN_Windows.exe %1" & @CRLF & @CRLF & "HKEY_CLASSES_ROOT\httpn, два параметра:" & @CRLF & "(по умолчанию) -> URL:httpn Protocol" & @CRLF & "URL Protocol -> без значений" & @CRLF & "Все параметры строковые(REG_SZ)", 0, $GUI)
			ProcessWaitClose($PID)
			Return 1		;Ждем закрытия реестра и проверяем по новой

		EndIf

		Local $username = @ComputerName
		If StringLen($username) = 0 Then	;Если имя не определилось

			BotMsg("🛑<b>Имя пользователя не определено</b>" & @CRLF & "❌" & $text & @CRLF & "⏱" & _Now(), 0)
			FileWriteLine($appfolder & "\App\httpN\system\log\system.txt", StringFormat("%-19s", _Now()) & " | " & "Имя пользователя не определено. Проверьте адрес пользователя: " & $text)
			MsgBox(16, "Ошибка", "Имя пользователя не определено" & @CRLF & "Обратитесь в Отдел Тестирования", 5, $GUI)
			Exit

		Else								;Если имя определили, делаем запись о пользователе

			FileWriteLine($appfolder & "\App\httpN\system\USERS", @CRLF & $username & " " & $text & " default")
			FileWrite($appfolder & "\App\httpN\system\temp\Achievments\" & $text, "0" & @CRLF & "0 " & _NowCalc() & @CRLF & "0" & @CRLF & "0" & @CRLF & "0" & @CRLF & "0" & @CRLF & "0" & @CRLF & "0" & @CRLF & "0")
			If StringLen(FileReader($appfolder & "\App\httpN\system\USERS", $username)) = 1 Then

				BotMsg("🛑<b>Пользователь не зарегистрирован</b>" & @CRLF & "❌" & $text & @CRLF & "⏱" & _Now(), 0)
				FileWriteLine($appfolder & "\App\httpN\system\log\system.txt", StringFormat("%-19s", _Now()) & " | " & "Пользователь не зарегистрирован. Проверьте адрес пользователя: " & $text)
				MsgBox(16, "Ошибка", "Не удалось зарегистрировать пользователя" & @CRLF & "Обратитесь в Отдел Тестирования", 5, $GUI)
				Exit

			EndIf

			BotMsg("✅<b>Новый пользователь добавлен</b>" & @CRLF & "👤" & $text & " 🪟Windows" & @CRLF & "⏱" & _Now(), 0)
			FileWriteLine($appfolder & "\App\httpN\system\log\system.txt", StringFormat("%-19s", _Now()) & " | " & "Добавлен новый пользователь Windows: " & $text)
			FileCreateShortCut($appfolder & "\Diagrams\DiagramsOT.html", @DesktopDir & "\DiagramsOT")	;Делаем ярлык схемы на десктоп
			TeleLink($GUI)
			ShellExecute(@DesktopDir & "\DiagramsOT.lnk", "", "", "open")

		EndIf

	EndIf

Return 0
EndFunc

Func TeleLink($GUI)			;Функция отрисовки последнего окошка с ссылкой на телеграм

	Opt("GUIOnEventMode", 1)	;Включить режим обработки событий мыши
	Local $G = GUICreate("GetStand", 280, 180, -1, -1, $WS_DLGFRAME, -1, $GUI)
	GUISetOnEvent($GUI_EVENT_CLOSE, "AboutOK")

	GUICtrlCreateIcon($appfolder & "\App\ChromePortable\GetStand.ICO", -1, 10, 10, 64, 64)
	Local $Label = GUICtrlCreateLabel("Аккаунт успешно создан!" & @CRLF & "Приятного пользования :)", 76, 20, 200, 60)
	GUICtrlSetFont($Label, 12)

	Local $link = GUICtrlCreateLabel("Подписывайтесь на telegram канал" & @CRLF & "Здесь вся информация о стендах", 24, 70, 250, 50)
	GuiCtrlSetFont($link, 11, -1, 4)
	GuiCtrlSetColor($link, 0x0000ff)
	GuiCtrlSetCursor($link, 0)
	GUICtrlSetOnEvent(-1, "OnLink")

	Local $But = GUICtrlCreateButton ("Продолжить", 90, 115, 100, 30)
	GUICtrlSetFont($But, 12)
	GUICtrlSetState (-1, $GUI_FOCUS)
	GUICtrlSetOnEvent(-1, "AboutOK")
	GUISetState(@SW_SHOW, $G)

		While true				;Цикл опроса

			Sleep(400)

		WEnd

EndFunc

Func OnLink()				;Функция открытия ссылки при нажатии на надпись

    Run(@ComSpec & " /c " & 'start https://t.me/+e8d9JjwJMtY4NzYy', "", @SW_HIDE)

EndFunc

Func AboutOK()				;Функция выхода из программы при нажитии Продолжить

    Exit

EndFunc