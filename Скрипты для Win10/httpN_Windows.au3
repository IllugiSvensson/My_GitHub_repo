#include <httpN_Windows_lib.au3>



;ПРОВЕРКА И ЗАПУСК ЕХЕ ФАЙЛА
TraySetState(2)				;Удалить отображение в трее
If FileExists(@ScriptDir & "\system\temp\Sessions\UPDATE") = 1 Then 		;Проверка на обновления

	MsgBox(48, "Предупреждение", "Ведутся технические работы" & @CRLF & "Попробуйте позже", 3)
	Exit

EndIf
If $cmdLine[0] = 0 Then 	;Вызывается, если нет аргументов

	Local $inputText = EntryWindow(1, 1)									;Строим окно для ввода данных
	Dim $cmdLine[2]
	$cmdLine[0] = "1"		;Разбираем командную строку и запускаем подключение
	$cmdLine[1] = "httpn://" & StringLeft($InputText, 3) & "%20" & StringTrimLeft($InputText, 4)

EndIf



;ПРОВЕРКА ИМЕНИ И ПРАВ ПОЛЬЗОВАТЕЛЯ ПО СПИСКУ АВТОРИЗАЦИИ
Global $username = @ComputerName
	If StringLen($username) = 0 Then		;На случай, если не определилось имя

		BotMsg("🛑<b>Ошибка конфигурации</b>" & @CRLF & "❌Имя пользователя не определено" & @CRLF & "⏱" & _Now(), 0)
		Logger("Имя пользователя не определено. Проверьте компьютер пользователя.", "", "", "", 2)
		MsgBox(16, "Ошибка", "Имя пользователя не определено" & @CRLF & "Обратитесь в Отдел Тестирования", 3)
		Exit

	EndIf
Global $autorizedUser = FileReader(@ScriptDir & "\system\USERS", $username) ;Ищем пользователя в списке
;Захватим название выбранного пользователем компьютера в виде кода стойки-стенда.
Global $hostName = StringRegExp(StringTrimLeft($cmdLine[1], 14), "\w+", 3) 	;Выбираем имя компьютера
Global $exeFile = StringTrimLeft(StringLeft($cmdLine[1], 11), 8)
	If StringLen($autorizedUser) = 1 Then	;Если имя пользователя отсутствует в списке, заканчиваем работу

		BotMsg("👤<b>Неизвестный Пользователь</b>" & @CRLF & "⚠️Пытался подключиться к хосту" & @CRLF & "🖥️" & $hostname[0] & " 🕹" & $exeFile & " ⏱" & _Now(), 0)
		Logger("Неизвестный Пользователь(unknown)", $username, "Неавторизованный вход", $hostName[0] & ":" & $exeFile, 1)
		MsgBox(16, "Ошибка", "Авторизация не пройдена" & @CRLF & "Обратитесь в Отдел Тестирования", 3)
		Exit

	EndIf
;Выделяем имя пользователя из строки, которое будет использоваться в названии файлов
Global $name = StringRegExp($autorizedUser, "[а-яА-Я]{1,}\s{1,}[а-яА-Я]{1,}\(\w+\)", 3)
ChangesM()	;Проверяем наличие сообщений
	If $exeFile == "FBC" Then				;Окошко для фидбека

		Local $stend = StringTrimRight(StringTrimLeft($cmdLine[1], 14), 1)
		Local $feedback = EntryWindow(2, 1)
		AchievmentTracker($name[0], 7)
		BotMsg("@IllugiSven" & @CRLF & "👤" & $name[0] & @CRLF & "⚠️Новый вопрос или предложение" & @CRLF & "🖥️Стенд: " & $stend & " ⏱" & _Now(), 0)
		Logger($name[0] & ". Новый вопрос или предложение по стенду: " & $stend & ". " & $feedback, "", "", "", 2)
		MsgBox(64, "Информация", "Ваше сообщение передано" & @CRLF & "разработчику", 3)
		Exit

	EndIf
;Проверим права на подключение. Если в строке не найдем имя компьютера или ADMIN, то выдаем ошибку.
	If (StringInStr($autorizedUser, $hostName[0]) = 0) And (StringInStr($autorizedUser, "ADMIN") = 0) Then

		AchievmentTracker($name[0], 9)
		MsgBox(48, "Предупреждение", "Недостаточно пользовательских прав" & @CRLF & "на подключение к " & $hostName[0], 4)
		Exit

	EndIf



;ПОЛУЧЕНИЕ ИНФОРМАЦИИ О КОМПЬЮТЕРЕ СТЕНДА ИЗ КОМАНДНОЙ СТРОКИ ЗАПУСКА
ReDim $hostName[2]
$hostName[1] = FileReader(@ScriptDir & "\system\HOSTS", $hostName[0])		;Получим строку с хостом и адресом
Local $hn = StringRegExp($hostName[1], "\w+", 3)
	If ($hostName[1] = "0") Or (StringLen($hn[0]) <> StringLen($hostName[0])) Then	;Если имя не найдено

		BotMsg("🛑<b>Ошибка конфигурации</b>" & @CRLF & "❌Имя компьютера не найдено" & @CRLF & "🖥️" & $hostName[0] & " ⏱" & _Now(), 0)
		Logger("Имя компьютера " & $hostName[0] & " не найдено. Проверьте схему, список и строку запуска.", "", "", "", 2)
		MsgBox(16, "Ошибка", "Имя компьютера не найдено" & @CRLF & "Обратитесь в Отдел Тестирования", 3)
		Exit

	EndIf
;Разбираем строку адреса или маршрута
;Проверим правильность ip-адрессов на соответствие частным сетям ipv4
;"^((10|192|127|169)\.){1}((25[0..5]|(2[0..4]\d|1{0,1}\d){0,1}\d)(\.?)){3}$" пропускает значащие нули
Local $addcheck = Validator($hostName[1], "[A](([0-9]{1,3}\.){3}[0-9]{1,3})")
Local $portcheck = Validator($hostName[1], "[S][0-9]{2,5}")
Local $passcheck = Validator($hostName[1], "[#]\S+")
	If ($addcheck + $portcheck + $passcheck) <> 3 Then

		BotMsg("🛑<b>Ошибка конфигурации</b>" & @CRLF & "❌Ошибка в списке хостов" & @CRLF & "🖥️" & $hostName[0] & " ⏱" & _Now(), 0)
		Logger("В записи адреса " & $hostName[0] & " ошибка. Проверьте запись в списке хостов.", "", "", "", 2)
		MsgBox(16, "Ошибка", "Ошибка в списке хостов" & @CRLF & "Обратитесь в Отдел Тестирования", 3)
		Exit

	EndIf
$addcheck = StringRegExp($hostName[1], "[A]((\w+\.){3}\w+)", 2)				;Получаем шаблон адреса
$portcheck = StringRegExp($hostName[1], "[S][0-9]{2,5}", 2)					;Получаем шаблон порта
$passcheck = StringRegExp($hostName[1], "[#]\S+", 2)						;Получаем шаблон пароля
Global $address = StringTrimLeft($addcheck[0], 1)							;Получаем адрес компьютера
Global $port = StringTrimLeft($portcheck[0], 1)								;Получаем порт компьютера
Global $pass = StringTrimLeft($passcheck[0], 1)								;Получаем пароль компьютера
$pass = _Encoding_Base64Decode($pass)
$pass = StringReplace($pass, $hostName[0], "")
$pass = StringReplace($pass, $addcheck[0], "")
$pass = StringReplace($pass, $portcheck[0], "")



;ЗАПУСК ПРИЛОЖЕНИЯ И НАБЛЮДЕНИЕ ЗА ХОДОМ РАБОТЫ
Global $Config = ""
Global $appfolder = StringTrimRight(@ScriptDir, 6)
Switch $exeFile					;Запускаем приложение с нужными параметрами

	Case "VNC"
		$exeFile = $appfolder & "\vnc\VNC.exe"
		$Config = " -config " & $appfolder & "\vnc\config\" & $hostName[0] & ".vnc"
		TrackExeFile("VNC", $exeFile, $Config, 3)

	Case "KIT"
		$exeFile = $appfolder & "\kitty\kitty.exe"
		If $port <> 22 Then $port = $port - 1
		$Config = " -ssh root@" & $address & " -P " & $port & " -pw " & $pass
		TrackExeFile("Kitty", $exeFile, $Config, 4)

	Case "SCP"
		$exeFile = $appfolder & "\winscp\WinSCP.exe"
		If $port <> 22 Then $port = $port - 2
		$Config = " root:" & $pass & "@" & $address & ":" & $port
		TrackExeFile("WinSCP", $exeFile, $Config, 5)

	Case Else
		BotMsg("🛑<b>Ошибка конфигурации</b>" & @CRLF & "❌Ошибка ссылки на схеме" & @CRLF & "🖥️" & $hostName[0] & " ⏱" & _Now(), 0)
		Logger("При запуске " & $exeFile & " " & $hostName[0] & " произошла ошибка. Проверьте схему, записи и диск GetStand.", "", "", "", 2)
		MsgBox(16, "Ошибка", "Ошибка запуска приложения" & @CRLF & "Обратитесь в Отдел Тестирования", 3)
		Exit

EndSwitch