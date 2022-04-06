#include <httpN_Windows_lib.au3>



;ПРОВЕРКА И ЗАПУСК ЕХЕ ФАЙЛА
TraySetState(2)				;Удалить отображение в трее
If FileExists(@ScriptDir & "\system\temp\Sessions\UPDATE") = 1 Then 		;Проверка на обновления

	MsgBox(48, "Предупреждение", "Ведутся технические работы" & @CRLF & "Попробуйте позже", 3)
	Exit

EndIf
If $cmdLine[0] = 0 Then 	;Вызывается, если нет аргументов

	Local $inputText = EntryWindow(1)										;Строим окно для ввода данных
	Dim $cmdLine[2]
	$cmdLine[0] = "1"		;Разбираем командную строку и запускаем подключение
	$cmdLine[1] = "httpn://" & StringLeft($InputText, 3) & "%20" & StringTrimLeft($InputText, 4)

EndIf



;ПРОВЕРКА ИМЕНИ И ПРАВ ПОЛЬЗОВАТЕЛЯ ПО СПИСКУ АВТОРИЗАЦИИ
Global $username = @ComputerName
	If StringLen($username) = 0 Then		;На случай, если не определилось имя

		BotMsg("🛑<b>Ошибка конфигурации</b>" & @CRLF & "❌Имя компьютера не определено" & @CRLF & "⏱" & _Now(), 0)
		Logger("Имя компьютера не определено. Проверьте компьютер пользователя.", "", "", "", 2)
		MsgBox(16, "Ошибка", "Имя компьютера не определено" & @CRLF & "Обратитесь в Отдел Тестирования", 3)
		Exit

	EndIf
Global $autorizedUser = FileReader(@ScriptDir & "\system\USERS", $username) ;Ищем пользователя в списке
;Захватим название выбранного пользователем компьютера в виде кода стойки-стенда.
Global $hostName = StringRegExp(StringTrimLeft($cmdLine[1], 14), "\w+", 3) 	;Выбираем имя компьютера
	If StringLen($autorizedUser) = 1 Then	;Если имя пользователя отсутствует в списке, заканчиваем работу

		Local $eks = StringTrimRight(StringTrimLeft($cmdLine[1], 8), StringLen($hostName[0]) + 4)
		BotMsg("👤<b>Неизвестный Пользователь</b>" & @CRLF & "⚠️Пытался подключиться к хосту" & @CRLF & "🖥️" & $hostname[0] & " 🕹" & $eks & " ⏱" & _Now(), 0)
		Logger("Неизвестный Пользователь(unknown)", $username, "Неавторизованный вход", $hostName[0] & ":" & $eks, 1)
		MsgBox(16, "Ошибка", "Авторизация не пройдена" & @CRLF & "Обратитесь в Отдел Тестирования", 3)
		Exit

	EndIf
;Выделяем имя пользователя из строки, которое будет использоваться в названии файлов
Global $name = StringRegExp($autorizedUser, "[а-яА-Я]{1,}\s{1,}[а-яА-Я]{1,}\(\w+\)", 3)
	If StringLeft($cmdLine[1], 11) == "httpn://FBC" Then					;Окошко для фидбека

		Local $stend = StringTrimRight(StringTrimLeft($cmdLine[1], 14), 1)
		Local $feedback = EntryWindow(2)
		BotMsg("@IllugiSven" & @CRLF & "👤" & $name[0] & @CRLF & "⚠️Новый вопрос или предложение" & @CRLF & "🖥️Стенд: " & $stend & " ⏱" & _Now(), 0)
		Logger($name[0] & ". Стенд: " & $stend & ". " & $feedback, "", "", "", 2)
		MsgBox(64, "Информация", "Ваше сообщение передано" & @CRLF & "разработчику", 3)
		Exit

	EndIf
;Проверим права на подключение. Если в строке не найдем имя компьютера или ADMIN, то выдаем ошибку.
	If (StringInStr($autorizedUser, $hostName[0]) = 0) And (StringInStr($autorizedUser, "ADMIN") = 0) Then

		MsgBox(48, "Предупреждение", "Недостаточно пользовательских прав" & @CRLF & "на подключение к " & $hostName[0], 4)
		Exit

	EndIf



;ПОЛУЧЕНИЕ ИНФОРМАЦИИ О КОМПЬЮТЕРЕ СТЕНДА ИЗ КОМАНДНОЙ СТРОКИ ЗАПУСКА
ReDim $hostName[2]
$hostName[1] = FileReader(@ScriptDir & "\system\HOSTS", $hostName[0])		;Получим строку с хостом и прочей инфой, если она есть
Local $hn = StringRegExp($hostName[1], "\w+", 3)
	If ($hostName[1] = "0") Or (StringLen($hn[0]) <> StringLen($hostName[0])) Then	;Если имя не найдено

		BotMsg("🛑<b>Ошибка конфигурации</b>" & @CRLF & "❌Имя хоста не найдено" & @CRLF & "🖥️" & $hostName[0] & " ⏱" & _Now(), 0)
		Logger("Имя компьютера " & $hostName[0] & " не найдено. Проверьте схему, список и строку запуска.", "", "", "", 2)
		MsgBox(16, "Ошибка", "Имя компьютера не найдено" & @CRLF & "Обратитесь в Отдел Тестирования", 3)
		Exit

	EndIf
;Разбираем строку адреса и маршрута, если такой есть
Local $addcheck = StringRegExp($hostName[1], "[A]((\w+\.){3}\w+)", 2)		;Получаем шаблон днс адреса компьютера
;Проверим правильность ip-адрессов на соответствие частным сетям ipv4
;Вообще блок с адресом и адресами шлюза нужно переработать под проброс портов
;"^((10|192|127|169)\.){1}((25[0..5]|(2[0..4]\d|1{0,1}\d){0,1}\d)(\.?)){3}$" пропускает значащие нули
	If IsArray($addcheck) = 0 Then

		BotMsg("🛑<b>Ошибка конфигурации</b>" & @CRLF & "❌Ошибка в списке хостов" & @CRLF & "🖥️" & $hostName[0] & " ⏱" & _Now(), 0)
		Logger("В записи адреса " & $hostName[0] & " ошибка. Проверьте запись в списке хостов.", "", "", "", 2)
		MsgBox(16, "Ошибка", "Ошибка в списке хостов" & @CRLF & "Обратитесь в Отдел Тестирования", 3)
		Exit

	EndIf
Global $address = StringTrimLeft($addcheck[0], 1)							;Получаем днс адрес компьютера
Local $gwcheck = StringRegExp($hostName[1], "[G]((\w+\.){3}\w+)", 2)		;Получаем шаблон адреса шлюза
Local $mskcheck = StringRegExp($hostName[1], "[M]((\w+\.){3}\w+)", 2)		;Получаем шаблон маски шлюза
	If IsArray($gwcheck) = 1 Then

		Global $flag = 1		;Если маршрут есть, устанавливаем флаг для запуска с маршрутом
		Global $gateway = StringTrimLeft($gwcheck[0], 1)
		Global $maskAddr = StringTrimLeft($mskcheck[0], 1)
		Global $gatemask = AddrToMask($maskAddr)		;Получаем маску сети
		If (Validator($gateway, "((\w+\.){3}\w+)") = 1) Or (Validator($maskAddr, "((\w+\.){3}\w+)") = 1) Then

			BotMsg("🛑<b>Ошибка конфигурации</b>" & @CRLF & "❌Ошибка в списке хостов" & @CRLF & "🖥️" & $hostName[0] & " ⏱" & _Now(), 0)
			Logger("В записи адреса " & $hostName[0] & " ошибка. Проверьте запись в списке хостов.", "", "", "", 2)
			MsgBox(16, "Ошибка", "Ошибка в списке хостов" & @CRLF & "Обратитесь в Отдел Тестирования", 3)
			Exit

		EndIf

	Else 						;Если маршрута нет, устанавливаем флаг запуска напрямую

		Global $flag = 0		;Обнуляем параметры, чтобы программа не падала
		Global $gateway = 0
		Global $maskAddr = 0
		Global $gatemask = 0

	EndIf



;ЗАПУСК ПРИЛОЖЕНИЯ И НАБЛЮДЕНИЕ ЗА ХОДОМ РАБОТЫ
Global $Config, $exeFile = StringLeft($cmdLine[1], 11)	;Выбираем из аргумента приложение для запуска
Global $appfolder = StringTrimRight(@ScriptDir, 6)
Switch $exeFile					;Запускаем приложение с нужными параметрами

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
		BotMsg("🛑<b>Ошибка конфигурации</b>" & @CRLF & "❌Ошибка в ссылке на схеме" & @CRLF & "🖥️" & $hostName[0] & " ⏱" & _Now(), 0)
		Logger("При запуске " & $exeFile & " " & $hostName[0] & " произошла ошибка. Проверьте схему, записи и диск GetStand.", "", "", "", 2)
		MsgBox(16, "Ошибка", "Ошибка запуска приложения" & @CRLF & "Обратитесь в Отдел Тестирования", 3)
		Exit

EndSwitch