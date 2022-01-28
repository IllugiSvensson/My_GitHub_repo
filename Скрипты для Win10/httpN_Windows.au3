#include <MsgSender_lib.au3>

;ПРОВЕРКА ЗАПУСКА EXE ФАЙЛА
if $cmdLine[0] = 0 Then 	;Вызывается, если нет аргументов

	$GUI = GUICreate("httpN отладка", 256, 144, -1, -1, $WS_DLGFRAME)
	$Input = GUICtrlCreateInput("Введите Хостнейм", 5, 15, 246, 40)
	GUICtrlSetFont($Input, 20)
	$BtnOk = GUICtrlCreateButton("Пуск", 53, 60, 70, 50)
	GUICtrlSetFont($BtnOk, 16)
	$BtnNO = GUICtrlCreateButton("Выход", 133, 60, 70, 50)
	GUICtrlSetFont($BtnNO, 16)
	GUISetState()

	While True

		Switch GUIGetMsg()
			Case $BtnNO
				Exit

			Case $BtnOk
				Dim $cmdLine[2]
				$cmdLine[0] = "1"
				$cmdLine[1] = "httpn://KIT%20" & GUICtrlRead($Input)
				GUIDelete($GUI)
				ExitLoop

			EndSwitch

	WEnd

EndIf
;НАСТРОЙКА ОТОБРАЖЕНИЯ ПРИЛОЖЕНИЯ В ТРЕЕ
Opt("TrayMenuMode", 1 + 2)	;Не отображать стандартные панели
TraySetState(2)				;Удалить отображение в трее
if FileExists("\\main\GetStand\App\httpN\system\temp\Sessions\UPDATE") = 1 Then ;Проверка на обновления

	MsgBox(48, "Предупреждение", "Ведутся технические работы" & @CRLF & "Попробуйте через минуту", 3)
	Exit

Endif



;ПРОВЕРКА MAC АДРЕСА И ПРАВ ПОЛЬЗОВАТЕЛЯ ПО СПИСКУ АВТОРИЗАЦИИ
$ipAddr = ""
	For $i = 0 To (UBound($ip) - 1) Step +1

		$PID = Run(@ComSpec&' /c ipconfig | findstr ' & $ip[$i], '', @SW_HIDE, $STDOUT_CHILD) ;Ищем свой ip адрес
		$sStdOutRead = ""		;В консоли получаем строку со своим адресом, запишем её в переменную
			While 1				;Конструкция нужна, чтобы прочитать вывод из консоли(строку с найденным адресом)

				$sStdOutRead &= StdoutRead($PID) ;Читаем строку из консоли
				If @error Then ExitLoop

			WEnd
		if $sStdOutRead <> "" Then

			$ipAddr = StringRegExp($sStdOutRead, "((\d{1,3}\.){3}\d{1,3})", 3) ;Выделяем наш адрес из строки вывода
			ExitLoop

		EndIf

	Next
	if IsArray($ipAddr) <> 1 Then	;На случай, если не определился мак адрес

		BotMsg("🛑Ошибка конфигурации" & @CRLF & "❌MAC-адрес не определен" & @CRLF & " ⏱" & _Now(), $sBotKey, $nChatId)
		Logger("MAC-адрес не определен. Проверьте адрес пользователя.", "", "", "", 2)
		MsgBox(16, "Ошибка", "MAC-адрес не определен." & @CRLF & "Обратитесь в Отдел Тестирования.", 3)
		Exit

	Endif
$MAC = GetMac($ipAddr[0])			;Передаем ip и получаем MAC сетевушки, на которой назначен этот ip
$autorizedMac = FileReader("\\main\GetStand\App\httpN\system\MAC", $MAC) 	;Ищем MAC в списке
;Захватим название выбранного пользователем компьютера в виде кода стойки-стенда.
$hostName = StringRegExp(StringTrimLeft($cmdLine[1], 14), "\w+", 3) 	;Выбираем имя компьютера
	if StringLeft($autorizedMac, 17) <> $MAC Then	;Если MAC пользователя отсутствует в списке, заканчиваем работу

		BotMsg("👤Неизвестный Пользователь" & @CRLF & "⚠️Пытался подключиться к хосту" & @CRLF & "🖥️" & $hostname[0] & " ⏱" & _Now(), $sBotKey, $nChatId)
		Logger("Неизвестный Пользователь(unknown)", $ipAddr[0] & "(" & $MAC & ")", "Неавторизованный вход", $hostName[0], 1)
		MsgBox(16, "Ошибка", "Авторизация не пройдена." & @CRLF & "Обратитесь в Отдел Тестирования.", 3)
		Exit

	EndIf
;Проверим права на подключение. Если в строке не найдем имя компьютера или ADMIN, то выдаем ошибку.
	if (StringInStr($autorizedMac, $hostName[0]) = 0) And (StringInStr($autorizedMac, "ADMIN") = 0) Then

		MsgBox(48, "Предупреждение", "Недостаточно пользовательских прав" & @CRLF & "на подключение к " & $hostName[0], 3)
		Exit

	Endif



;ПОЛУЧЕНИЕ ИНФОРМАЦИИ О КОМПЬЮТЕРЕ СТЕНДА ИЗ КОМАНДНОЙ СТРОКИ ЗАПУСКА
ReDim $hostName[2]
$hostName[1] = FileReader("\\main\GetStand\App\httpN\system\HOSTS", $hostName[0])	;Получим строку с хостом и прочей инфой, если она есть
$hn = StringRegExp($hostName[1], "\w+", 3)		;Получаем строку с адресом или 0
;Ищем информацию о хосте из списка хостов
	if ($hostName[1] = "0") Or (StringLen($hn[0]) <> StringLen($hostName[0])) Then	;Если адрес отличается или не найден

		BotMsg("🛑Ошибка конфигурации" & @CRLF & "❌Адрес хоста не найден" & @CRLF & "🖥️" & $hostName[0] & " ⏱" & _Now(), $sBotKey, $nChatId)
		Logger("Адрес компьютера " & $hostName[0] & " не найден. Проверьте схему, список и строку запуска.", "", "", "", 2)
		MsgBox(16, "Ошибка", "Адрес компьютера не найден." & @CRLF & "Обратитесь в Отдел Тестирования.", 3)
		Exit

	EndIf
;Разбираем строку маршрута, если такая имеется
$gwString = StringRegExp($hostname[1], "((\w+\.){3}\w+)", 2)	;Проверяем, есть ли в строке маршрут
	if IsArray($gwString) = 1 Then

		$flag = 1		;Если маршрут есть, устанавливаем флаг для запуска с маршрутом
		$gateWay = $gwString[0]			;Получаем адрес шлюза
		;Убираем лишние элементы
		$hostName[1] = StringRegExpReplace($hostName[1], $hostname[0], "")
		$hostName[1] = StringRegExpReplace($hostName[1], $gwString[0], "")
		$hostName[1] = StringRegExpReplace($hostName[1], " ", "")
		;Проверим правильность ip-адрессов на соответствие частным сетям ipv4
		if (Validator($gateWay, "^((10|192|127|169)\.){1}((25[0..5]|(2[0..4]\d|1{0,1}\d){0,1}\d)(\.?)){3}$") = 1) Or (Validator($hostName[1], "^((10|192|127|169)\.){1}((25[0..5]|(2[0..4]\d|1{0,1}\d){0,1}\d)(\.?)){3}$") = 1) Then

			BotMsg("🛑Ошибка конфигурации" & @CRLF & "❌Ошибка в списке хостов" & @CRLF & "🖥️" & $hostName[0] & " ⏱" & _Now(), $sBotKey, $nChatId)
			Logger("В записи адреса " & $hostName[0] & " ошибка. Проверьте запись в списке хостов.", "", "", "", 2)
			MsgBox(16, "Ошибка", "Ошибка в списке хостов." & @CRLF & "Обратитесь в Отдел Тестирования.", 3)
			Exit

		Endif
		$maskAddr = $hostName[1]		;Получаем адрес для маршрутизации
		$MASK = AddrToMask($maskAddr)	;Получаем маску сети

	else 					;Если маршрута нет, устанавливаем флаг запуска напрямую

		$flag = 0			;Обнуляем параметры, чтобы программа не падала
		$gateWay = 0
		$maskAddr = 0
		$MASK = 0

	EndIf



;ЗАПУСК ПРИЛОЖЕНИЯ И НАБЛЮДЕНИЕ ЗА ХОДОМ РАБОТЫ
$exeFile = StringLeft($cmdLine[1], 11)	;Выбираем из аргумента приложение для запуска
Switch $exeFile			;Запускаем приложение с нужными параметрами

	Case "httpn://VNC"
		$exeFile = "\\main\GetStand\App\vnc\VNC.exe"
		$Config = " -config \\main\GetStand\App\vnc\config\"
		TrackExeFile("VNC", $exeFile, $Config, ".vnc", $flag)

	Case "httpn://KIT"
		$exeFile = "\\main\GetStand\App\kitty\kitty.exe"
		$Config = " -load "
		TrackExeFile("Kitty", $exeFile, $Config, "", $flag)

	Case "httpn://SCP"
		$exeFile = "\\main\GetStand\App\winscp\WinSCP.exe"
		$Config = " "
		TrackExeFile("WinSCP", $exeFile, $Config, "", $flag)

	Case Else
		BotMsg("🛑Ошибка конфигурации" & @CRLF & "❌Ошибка в ссылке на схеме" & @CRLF & "🖥️" & $hostName[0] & " ⏱" & _Now(), $sBotKey, $nChatId)
		Logger("При запуске " & $exeFile & " произошла ошибка. Проверьте схему, записи и диск GetStand.", "", "", "", 2)
		MsgBox(16, "Ошибка", "Ошибка запуска приложения." & @CRLF & "Обратитесь в Отдел Тестирования.", 3)
		Exit

EndSwitch





;ПОЛЬЗОВАТЕЛЬСКИЕ ФУНКЦИИ
Func ConsolePing($ADD)							;Функция пинга

	Sleep(1000)		;Без паузы почему то нормально не пингуется
;ВОЗМОЖНО ПРИДЕТСЯ МЕНЯТЬ ВОЗВРАЩАЕМОЕ ЗНАЧЕНИЕ, ЕСЛИ НЕ БУДЕТ ДНС
	return Ping($ADD & ".ot.net")

EndFunc

Func AddrToMask($MSKADDR)						;Функция преобразования адреса в маску

	Switch "1"	;REGEX возвращает массив либо двоичное значение. Сравниваем с единицей для удобства

		Case StringRegExp($MSKADDR, "((\d{1,3}\.){1}0.0.0)", 0) ;Проверяем последние актеты на 0
			return "255.0.0.0"							 	 	;Возвращаем маску

		Case StringRegExp($MSKADDR, "((\d{1,3}\.){2}0.0)", 0)
			return "255.255.0.0"

		Case StringRegExp($MSKADDR, "((\d{1,3}\.){3}0)", 0)
			return "255.255.255.0"

		Case Else
			return "255.255.255.255"

	EndSwitch

EndFunc

Func Logger($USER, $ADDRES, $ACT, $HOST, $TYPE)	;Функция логирования действий пользователя

	If $TYPE = 1 Then			;Запись лога запусков приложений

		$tmpPath = "\\main\GetStand\App\httpN\system\log\log.txt"	;Путь до лога
		$TIME = StringFormat("%-19s", _Now())						;Форматируем вывод под стандарт
		$USER = StringFormat("%-33s", $USER)
		$ADDRES = StringFormat("%-34s", $ADDRES)
		$ACT = StringFormat("%-21s", $ACT)
		FileWriteLine($tmpPath, $TIME & " | " & $USER & " | " & $ADDRES & " | " & $ACT & " | " & $HOST )

	ElseIf $TYPE = 2 Then		;Запись системного лога

		FileWriteLine("\\main\GetStand\App\httpN\system\log\system.txt", StringFormat("%-19s", _Now()) & " | " & $USER)

	EndIf

EndFunc

Func RouteAddDel($ROUTE, $fl)					;Функция создания маршрута

	if $fl = 1 Then

		$hFile = FileOpen("\\main\GetStand\App\httpN\system\temp\system.bat", 2)	;Открывает батник для перезаписи
		FileWrite($hFile, $ROUTE) 													;Вписываем параметры
		ShellExecute("\\main\GetStand\App\httpN\system\temp\httpN.lnk")				;Запускаем батник для постройки/удаления маршрута
		FileClose($hFile)															;Закрываем файл

	EndIf

EndFunc

Func TrackExeFile($EXE, $exeFile, $CONFIG, $RES, $flg)	;Функция запуска и слежения за приложением

	;Выделяем имя пользователя из строки, которое будет использоваться в названии файлов
	$name = StringRegExp($autorizedMac, "[а-яА-Я]{1,}\s{1,}[а-яА-Я]{1,}\(\w+\)", 3)
	RouteAddDel("route add " & $maskAddr & " mask " & $MASK & " " & $gateWay, $flg)		;Строим маршрут если он есть
	if (ConsolePing($hostName[0])) = 0 Then		;Проверяем сеть. Если не пингуется

		BotMsg("👤" & $name[0] & @CRLF & "⚠️Неудачное подключение" & @CRLF & "🖥️" & $hostName[0] & " 🕹" & $EXE & " ⏱" & _Now(), $sBotKey, $nChatId)
		Logger($name[0], $ipAddr[0] & "(" & $MAC & ")", "Хост не отвечает", $hostName[0] & ":" & $EXE, 1)
		MsgBox(16, "Ошибка", "Неудается подключиться к хосту." & @CRLF & "Обратитесь в Отдел Тестирования.", 3)

	else		;Если пингуется, запускаем приложение

		$PID = Run($exeFile & $CONFIG & $hostName[0] & $RES)							;Запускаем приложение и фиксируем его PID
		BotMsg("👤" & $name[0] & @CRLF & "✅Подключился к хосту" & @CRLF & "🖥️" & $hostName[0] & " 🕹" & $EXE & " ⏱" & _Now(), $sBotKey, $nChatId)
		Logger($name[0], $ipAddr[0] & "(" & $MAC & ")", "Успешное подключение", $hostName[0] & ":" & $EXE, 1)
		;Запускаем сессию приложения
		$t = 0
		While True

			Sleep(1000)		;Отсчитываем условную секунду
			$t += 1
			;Условия окончания сессии
			If ProcessExists($PID) = 0	Then	;Если завершили процесс вручную

				BotMsg("👤" & $name[0] & @CRLF & "⬅️Отключился от хоста" & @CRLF & "🖥️" & $hostName[0] & " 🕹" & $EXE & " ⏱" & _Now(), $sBotKey, $nChatId)
				Logger($name[0], $ipAddr[0] & "(" & $MAC & ")", "Завершение работы", $hostName[0] & ":" & $EXE, 1)
				ExitLoop

			ElseIf FileExists("\\main\GetStand\App\httpN\system\temp\Sessions\UPDATE") = 1 Then ;Если начали обновление

				MsgBox(48, "Предупреждение", "Обновление системы. Сохраните работу." & @CRLF & "Приложение закроется через минуту.", 5)
				$j = 0
				While $j <> 55

					sleep(1000)
					$j += 1
					if ProcessExists($PID) = 0 Then ExitLoop
					if FileExists("\\main\GetStand\App\httpN\system\temp\Sessions\KILL") = 1 Then ExitLoop

				WEnd
				ProcessClose($PID)
				ExitLoop

			ElseIf $t = 30000 Then				;Если дождались таймаута

				ProcessClose($PID)
				BotMsg("👤" & $name[0] & @CRLF & "⬅️Сессия завершена" & @CRLF & "🖥️" & $hostName[0] & " 🕹" & $EXE & " ⏱" & _Now(), $sBotKey, $nChatId)
				Logger($name[0], $ipAddr[0] & "(" & $MAC & ")", "Сессия завершена", $hostName[0] & ":" & $EXE, 1)
				MsgBox(48, "Предупреждение", "Сессия " & $hostName[0] & ": " & $EXE & @CRLF & "завершена по таймауту", 3)
				ExitLoop

			Endif

			;Функции, действующие во время сессии
			if FileExists("\\main\GetStand\App\httpN\system\temp\Sessions\ONLINE") = 1 Then		;Говорим что онлайн

				;Создаем файлик-метку, обрабатываем его другой прогой, которая его удалит
				FileWrite("\\main\GetStand\App\httpN\system\temp\PIDS\" & $name[0] & "." & $hostName[0] & "." & Round($t/60), "")

			Endif

		WEnd

	Endif

	;Когда закончили работу или не смогли подключиться, нужно удалить маршрут за собой
	if UBound(ProcessList("httpN.exe")) = 2 Then			;Если файл один (наш файл)

		RouteAddDel("route delete " & $maskAddr, $flg)	;Удаляем построенный маршрут после окончания работы

	EndIf

EndFunc