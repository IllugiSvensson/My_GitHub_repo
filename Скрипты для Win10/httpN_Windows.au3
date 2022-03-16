#include <httpN_Windows_lib.au3>



;ЗАПУСК EXE ФАЙЛА
Opt("TrayMenuMode", 1 + 2)	;Не отображать стандартные панели
TraySetState(2)				;Удалить отображение в трее
if FileExists(@ScriptDir & "\system\temp\Sessions\UPDATE") = 1 Then 		;Проверка на обновления

	MsgBox(48, "Предупреждение", "Ведутся технические работы" & @CRLF & "Попробуйте через минуту", 3)
	Exit

Endif
if $cmdLine[0] = 0 Then 	;Вызывается, если нет аргументов

	Local $GUI = GUICreate("httpN отладка", 256, 144, -1, -1, $WS_DLGFRAME)	;Строим окно для ввода данных
	Local $Input = GUICtrlCreateInput("Введите Хостнейм", 5, 15, 246, 40)
	GUICtrlSetFont($Input, 20)
	Local $BtnOk = GUICtrlCreateButton("Пуск", 53, 60, 70, 50)				;Кнопка запуска приложения
	GUICtrlSetFont($BtnOk, 16)
	Local $BtnNO = GUICtrlCreateButton("Выход", 133, 60, 70, 50)			;Кнопка Выход
	GUICtrlSetFont($BtnNO, 16)
	GUISetState()

	While True

		Switch GUIGetMsg()			;Следим за нажатием кнопок
			Case $BtnNO
				Exit

			Case $BtnOk
				Dim $cmdLine[2]
				$cmdLine[0] = "1"	;Разбираем командную строку и запускаем подключение
				$cmdLine[1] = "httpn://" & StringLeft(GUICtrlRead($Input), 3) & "%20" & StringTrimLeft(GUICtrlRead($Input), 4)
				GUIDelete($GUI)
				ExitLoop

			EndSwitch

	WEnd

EndIf



;ПРОВЕРКА ИМЕНИ И ПРАВ ПОЛЬЗОВАТЕЛЯ ПО СПИСКУ АВТОРИЗАЦИИ
Global $username = @ComputerName
	if StringLen($username) = 0 Then	;На случай, если не определилось имя

		BotMsg("🛑<b>Ошибка конфигурации</b>" & @CRLF & "❌Имя компьютера не определено" & @CRLF & " ⏱" & _Now(), 0, $sBotKey, $nChatId)
		Logger("Имя компьютера не определено. Проверьте компьютер пользователя.", "", "", "", 2)
		MsgBox(16, "Ошибка", "Имя компьютера не определено." & @CRLF & "Обратитесь в Отдел Тестирования.", 3)
		Exit

	Endif
Global $autorizedUser = FileReader(@ScriptDir & "\system\USERS", $username) ;Ищем пользователя в списке
;Захватим название выбранного пользователем компьютера в виде кода стойки-стенда.
Global $hostName = StringRegExp(StringTrimLeft($cmdLine[1], 14), "\w+", 3) 	;Выбираем имя компьютера
	if StringLen($autorizedUser) = 1 Then	;Если имя пользователя отсутствует в списке, заканчиваем работу

		BotMsg("👤<b>Неизвестный Пользователь</b>" & @CRLF & "⚠️Пытался подключиться к хосту" & @CRLF & "🖥️" & $hostname[0] & " ⏱" & _Now(), 0, $sBotKey, $nChatId)
		Logger("Неизвестный Пользователь(unknown)", $username, "Неавторизованный вход", $hostName[0], 1)
		MsgBox(16, "Ошибка", "Авторизация не пройдена." & @CRLF & "Обратитесь в Отдел Тестирования.", 3)
		Exit

	EndIf
;Проверим права на подключение. Если в строке не найдем имя компьютера или ADMIN, то выдаем ошибку.
	if (StringInStr($autorizedUser, $hostName[0]) = 0) And (StringInStr($autorizedUser, "ADMIN") = 0) Then

		MsgBox(48, "Предупреждение", "Недостаточно пользовательских прав" & @CRLF & "на подключение к " & $hostName[0], 3)
		Exit

	Endif



;ПОЛУЧЕНИЕ ИНФОРМАЦИИ О КОМПЬЮТЕРЕ СТЕНДА ИЗ КОМАНДНОЙ СТРОКИ ЗАПУСКА
ReDim $hostName[2]
$hostName[1] = FileReader(@ScriptDir & "\system\HOSTS", $hostName[0])		;Получим строку с хостом и прочей инфой, если она есть
Local $hn = StringRegExp($hostName[1], "\w+", 3)
;Ищем информацию о хосте из списка хостов
	if ($hostName[1] = "0") Or (StringLen($hn[0]) <> StringLen($hostName[0])) Then	;Если имя не найдено

		BotMsg("🛑<b>Ошибка конфигурации</b>" & @CRLF & "❌Имя хоста не найдено" & @CRLF & "🖥️" & $hostName[0] & " ⏱" & _Now(), 0, $sBotKey, $nChatId)
		Logger("Имя компьютера " & $hostName[0] & " не найдено. Проверьте схему, список и строку запуска.", "", "", "", 2)
		MsgBox(16, "Ошибка", "Имя компьютера не найдено." & @CRLF & "Обратитесь в Отдел Тестирования.", 3)
		Exit

	EndIf
;Разбираем строку адреса и маршрута, если такой есть
Local $addcheck = StringRegExp($hostName[1], "[A]((\w+\.){3}\w+)", 2)		;Получаем шаблон днс адреса компьютера
Global $address = StringTrimLeft($addcheck[0], 1)							;Получаем днс адрес компьютера
Local $gwcheck = StringRegExp($hostName[1], "[G]((\w+\.){3}\w+)", 2)		;Получаем шаблон адреса шлюза
Local $mskcheck = StringRegExp($hostName[1], "[M]((\w+\.){3}\w+)", 2)		;Получаем шаблон маски шлюза
	;Проверим правильность ip-адрессов на соответствие частным сетям ipv4
	;"^((10|192|127|169)\.){1}((25[0..5]|(2[0..4]\d|1{0,1}\d){0,1}\d)(\.?)){3}$" пропускает значащие нули
	if (Validator($address, "((\w+\.){3}\w+)") = 1) Then

		BotMsg("🛑<b>Ошибка конфигурации</b>" & @CRLF & "❌Ошибка в списке хостов" & @CRLF & "🖥️" & $hostName[0] & " ⏱" & _Now(), 0, $sBotKey, $nChatId)
		Logger("В записи адреса " & $hostName[0] & " ошибка. Проверьте запись в списке хостов.", "", "", "", 2)
		MsgBox(16, "Ошибка", "Ошибка в списке хостов." & @CRLF & "Обратитесь в Отдел Тестирования.", 3)
		Exit

	Endif
	if IsArray($gwcheck) = 1 Then

		Global $flag = 1							;Если маршрут есть, устанавливаем флаг для запуска с маршрутом
		Global $gateway = StringTrimLeft($gwcheck[0], 1)
		Global $maskAddr = StringTrimLeft($mskcheck[0], 1)
		Global $gatemask = AddrToMask($maskAddr)	;Получаем маску сети
		if (Validator($gateway, "^((10|192|127|169)\.){1}((25[0..5]|(2[0..4]\d|1{0,1}\d){0,1}\d)(\.?)){3}$") = 1) Or (Validator($maskAddr, "^((10|192|127|169)\.){1}((25[0..5]|(2[0..4]\d|1{0,1}\d){0,1}\d)(\.?)){3}$") = 1) Then

			BotMsg("🛑<b>Ошибка конфигурации</b>" & @CRLF & "❌Ошибка в списке хостов" & @CRLF & "🖥️" & $hostName[0] & " ⏱" & _Now(), 0, $sBotKey, $nChatId)
			Logger("В записи адреса " & $hostName[0] & " ошибка. Проверьте запись в списке хостов.", "", "", "", 2)
			MsgBox(16, "Ошибка", "Ошибка в списке хостов." & @CRLF & "Обратитесь в Отдел Тестирования.", 3)
			Exit

		Endif

	else 					;Если маршрута нет, устанавливаем флаг запуска напрямую

		Global $flag = 0			;Обнуляем параметры, чтобы программа не падала
		Global $gateway = 0
		Global $maskAddr = 0
		Global $gatemask = 0

	EndIf



;ЗАПУСК ПРИЛОЖЕНИЯ И НАБЛЮДЕНИЕ ЗА ХОДОМ РАБОТЫ
Global $Config, $exeFile = StringLeft($cmdLine[1], 11)	;Выбираем из аргумента приложение для запуска
Global $appfolder = StringTrimRight(@ScriptDir, 6)
Switch $exeFile				;Запускаем приложение с нужными параметрами

	Case "httpn://VNC"
		$exeFile = $appfolder & "\vnc\VNC.exe"
		$Config = " -config " & $appfolder & "\vnc\config\"
		TrackExeFile("VNC", $exeFile, $Config, ".vnc", $flag)

	Case "httpn://KIT"
		$exeFile = $appfolder & "\kitty\kitty.exe"
		$Config = " -load "
		TrackExeFile("Kitty", $exeFile, $Config, "", $flag)

	Case "httpn://SCP"
		$exeFile = $appfolder & "\winscp\WinSCP.exe"
		$Config = " "
		TrackExeFile("WinSCP", $exeFile, $Config, "", $flag)

	Case Else
		BotMsg("🛑<b>Ошибка конфигурации</b>" & @CRLF & "❌Ошибка в ссылке на схеме" & @CRLF & "🖥️" & $hostName[0] & " ⏱" & _Now(), 0, $sBotKey, $nChatId)
		Logger("При запуске " & $exeFile & " произошла ошибка. Проверьте схему, записи и диск GetStand.", "", "", "", 2)
		MsgBox(16, "Ошибка", "Ошибка запуска приложения." & @CRLF & "Обратитесь в Отдел Тестирования.", 3)
		Exit

EndSwitch