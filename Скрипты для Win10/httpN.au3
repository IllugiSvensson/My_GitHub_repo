#include <Array.au3>
#include <File.au3>
#include <Date.au3>
#include <Constants.au3>
#include <WindowsConstants.au3>
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
;Данные для бота телеграм
$sBotKey = 'bot1844208783:AAHnDQhkV7kARiLCyus0vxV8jQdAYy4TZcY'	;Ваш api ключ
$nChatId = -1001460258261                                      	;Id получателя



;ПРОВЕРКА MAC АДРЕСА И ПРАВ ПОЛЬЗОВАТЕЛЯ ПО СПИСКУ АВТОРИЗАЦИИ
		;Поиск ведем только по 31й сети(возможно будет меняться)
$PID = Run(@ComSpec&' /c ipconfig | findstr 192.168.31.', '', @SW_HIDE, $STDOUT_CHILD) ;Ищем свой ip адрес
$sStdOutRead = ""		;В консоли получаем строку со своим адресом, запишем её в переменную
	While 1				;Конструкция нужна, чтобы прочитать вывод из консоли(строку с найденным адресом)

		$sStdOutRead &= StdoutRead($PID) ;Читаем строку из консоли
		If @error Then ExitLoop

	WEnd
$ipAddr = StringRegExp($sStdOutRead, "((\d{1,3}\.){3}\d{1,3})", 2) ;Выделяем наш адрес из строки вывода
$MAC = GetMac($ipAddr[0])							;Передаем ip и получаем MAC сетевушки, на которой назначен этот ip
$autorizedMac = FileReader("\\main\GetStand\App\httpN\system\MAC", $MAC) ;Ищем MAC в списке
	if $MAC = "" Then		;На случай, если не определился мак адрес

		MsgBox(16, "Ошибка", "MAC-адрес не определен." & @CRLF & "Назначьте адрес в 31й сети.")
		Exit

	Endif
;Захватим название выбранного пользователем компьютера в виде кода стойки-стенда.
$hostName = StringRegExp(StringTrimLeft($cmdLine[1], 14), "\w+", 3) ;Выбираем имя компьютера
ReDim $hostName[2]
	if StringLeft($autorizedMac, 17) <> $MAC Then	;Если MAC пользователя отсутствует в списке, заканчиваем работу

		;Алгоритм: Для сигнализации создается соответствующий файл, который регистрируется менеджером
		;FileWrite("\\main\GetStand\App\httpN\system\temp\PIDS\Неизвестный Пользователь(unknown)." & $hostName[0] & ".XXX", "")
		BotMsg("👤Неизвестный Пользователь" & @CRLF & "⚠️Пытался подключиться к хосту" & @CRLF & "🖥️" & $hostname[0] & " ⏱" & _Now(), $sBotKey, $nChatId)
		MsgBox(16, "Ошибка", "Авторизация не пройдена." & @CRLF & "Обратитесь в Отдел Тестирования.")
		Logger("Неизвестный Пользователь(unknown)", $ipAddr[0] & "(" & $MAC & ")", "Неавторизованный вход", $hostName[0], 1)
		;FileDelete("\\main\GetStand\App\httpN\system\temp\PIDS\Неизвестный Пользователь(unknown)." & $hostName[0] & ".XXX")
		Exit

	EndIf
;Проверим права на подключение. Если в строке не найдем имя компьютера или ADMIN, то выдаем ошибку.
	if (StringInStr($autorizedMac, $hostName[0]) = 0) And (StringInStr($autorizedMac, "ADMIN") = 0) Then

		MsgBox(16, "Ошибка", "Недостаточно пользовательских прав" & @CRLF & "на подключение к " & $hostName[0])
		Exit

	Endif



;ПОЛУЧЕНИЕ ИНФОРМАЦИИ О КОМПЬЮТЕРЕ СТЕНДА ИЗ КОМАНДНОЙ СТРОКИ ЗАПУСКА
$hostName[1] = FileReader("\\main\GetStand\App\httpN\system\HOSTS", $hostName[0]) ;Получим строку с хостом и прочей инфой, если она есть
;Ищем информацию о хосте из списка хостов
	if $hostName[0] <> StringLeft($hostName[1], StringLen($hostName[0])) Then	  ;Проверим, есть ли адрес в списке

		;FileWrite("\\main\GetStand\App\httpN\system\temp\PIDS\Ошибка Конфигурации(error)." & $hostName[0] & ".XXX", "")
		BotMsg("🛑Ошибка конфигурации" & @CRLF & "❌Адрес хоста не найден" & @CRLF & "🖥️" & $hostName[0] & " ⏱" & _Now(), $sBotKey, $nChatId)
		MsgBox(16, "Ошибка", "Адрес компьютера не найден." & @CRLF & "Обратитесь в Отдел Тестирования.")
		Logger("Адрес компьютера " & $hostName[0] & " не найден. Проверьте схему, список и строку запуска.", "", "", "", 2)
		;FileDelete("\\main\GetStand\App\httpN\system\temp\PIDS\Ошибка Конфигурации(error)." & $hostName[0] & ".XXX")
		Exit

	EndIf
;Разбираем строку маршрута, если такая имеется
$gwString = StringTrimLeft($hostName[1], StringLen($hostName[0]))	;Получим строку с маршрутом, либо ничего
	if $gwString = "" Then	;Если маршрута нет, устанавливаем флаг запуска напрямую

		$flag = 0		;Обнуляем параметры
		$gateWay = 0
		$maskAddr = 0
		$MASK = 0

	Else					;Если маршрут есть, устанавливаем флаг для запуска с маршрутом

		$flag = 1
		$tmpGW = StringRegExp($gwString, "((\d{1,3}\.){3}\d{1,3})", 2) 	;Фильтруем строку после хостнейма
		$gateWay = $tmpGW[0]											;Получаем адрес шлюза
		$maskAddr = StringTrimLeft($gwString, StringLen($gateWay) + 2)	;Получаем адрес для маршрутизации
		$MASK = AddrToMask($maskAddr)									;Получаем маску сети

		;Проверим правильность ip-адрессов на соответствие частным сетям ipv4
		if (Validator($gateWay, "^((10|192|127|169)\.){1}((25[0..5]|(2[0..4]\d|1{0,1}\d){0,1}\d)(\.?)){3}$") = 1) Or (Validator($maskAddr, "^((10|192|127|169)\.){1}((25[0..5]|(2[0..4]\d|1{0,1}\d){0,1}\d)(\.?)){3}$") = 1) Then

			;FileWrite("\\main\GetStand\App\httpN\system\temp\PIDS\Ошибка Конфигурации(error)." & $hostName[0] & ".XXX", "")
			BotMsg("🛑Ошибка конфигурации" & @CRLF & "❌Ошибка в списке хостов" & @CRLF & "🖥️" & $hostName[0] & " ⏱" & _Now(), $sBotKey, $nChatId)
			MsgBox(16, "Ошибка", "Ошибка в списке хостов." & @CRLF & "Обратитесь в Отдел Тестирования.")
			Logger("В записи адреса " & $hostName[0] & " ошибка. Проверьте запись в списке хостов.", "", "", "", 2)
			;FileDelete("\\main\GetStand\App\httpN\system\temp\PIDS\Ошибка Конфигурации(error)." & $hostName[0] & ".XXX")
			Exit

		Endif

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
		;FileWrite("\\main\GetStand\App\httpN\system\temp\PIDS\Ошибка Конфигурации(error)." & $hostName[0] & ".XXX", "")
		BotMsg("🛑Ошибка конфигурации" & @CRLF & "❌Ошибка ссылки в схеме" & @CRLF & "🖥️" & $hostName[0] & " ⏱" & _Now(), $sBotKey, $nChatId)
		MsgBox(16, "Ошибка", "Приложение для запуска не найдено." & @CRLF & "Обратитесь в Отдел Тестирования.")
		Logger("При запуске " & $exeFile & " произошла ошибка. Проверьте схему, записи и диск GetStand.", "", "", "", 2)
		;FileDelete("\\main\GetStand\App\httpN\system\temp\PIDS\Ошибка Конфигурации(error)." & $hostName[0] & ".XXX")
		Exit

EndSwitch





;ПОЛЬЗОВАТЕЛЬСКИЕ ФУНКЦИИ
Func FileReader($pathToFile, $sSearchText)		;Функция поиска строки в файле

	$sText = FileRead($pathToFile) 							;Читаем список
	$aLines = StringSplit($sText, @CRLF, 1)					;Делаем массив строк
		For $i = 1 To $aLines[0] Step +1					;Перебираем строки

			If StringInStr($aLines[$i], $sSearchText) Then	;Если есть совпадение, выдаем строку

				return $aLines[$i]
				ExitLoop

			EndIf

		Next

EndFunc

Func ConsolePing($ADD)							;Функция пинга

	Sleep(1000)		;Без паузы почему то нормально не пингуется
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

Func GetMac($_MACsIP)							;Функция получения MAC по айпи(взял из гугла)

    Local $_MAC, $_MACSize
    Local $_MACi, $_MACs, $_MACr, $_MACiIP
    $_MAC = DllStructCreate("byte[6]")
    $_MACSize = DllStructCreate("int")
    DllStructSetData($_MACSize, 1, 6)
    $_MACr = DllCall ("Ws2_32.dll", "int", "inet_addr", "str", $_MACsIP)
    $_MACiIP = $_MACr[0]
    $_MACr = DllCall ("iphlpapi.dll", "int", "SendARP", "int", $_MACiIP, "int", 0, "ptr", DllStructGetPtr($_MAC), "ptr", DllStructGetPtr($_MACSize))
    $_MACs  = ""

		For $_MACi = 0 To 5

			If $_MACi Then $_MACs = $_MACs & ":"
			$_MACs = $_MACs & Hex(DllStructGetData($_MAC, 1, $_MACi + 1), 2)

		Next

    DllClose($_MAC)
    DllClose($_MACSize)
    Return $_MACs

EndFunc

Func TrackExeFile($EXE, $exeFile, $CONFIG, $RES, $flg)	;Функция запуска и слежения за приложением

	;Выделяем имя пользователя из строки, которое будет использоваться в названии файлов
	$name = StringRegExp($autorizedMac, "\s{0,}\t{1,}\s{0,}(\w+(\W|\s){0,}){0,}", 2)
	$name[0] = StringTrimRight(StringTrimLeft($autorizedMac, 18), StringLen($name[0]))
	RouteAddDel("route add " & $maskAddr & " mask " & $MASK & " " & $gateWay, $flg)		;Строим маршрут если он есть
	if (ConsolePing($hostName[0])) = 0 Then		;Проверяем сеть. Если не пингуется

		;FileWrite("\\main\GetStand\App\httpN\system\temp\PIDS\" & $name[0] & "." & $hostName[0] & ".XXX", "")		;Создаем файл-метку
		BotMsg("👤" & $name[0] & @CRLF & "⚠️Неудачное подключение" & @CRLF & "🖥️" & $hostName[0] & " 🕹" & $EXE & " ⏱" & _Now(), $sBotKey, $nChatId)
		MsgBox(16, "Ошибка", "Невозможно подключиться к хосту." & @CRLF & "Обратитесь в Отдел Тестирования.")
		Logger($name[0], $ipAddr[0] & "(" & $MAC & ")", "Хост не отвечает", $hostName[0] & ":" & $EXE, 1)	;Оповещаем об ошибке
		;FileDelete("\\main\GetStand\App\httpN\system\temp\PIDS\" & $name[0] & "." & $hostName[0] & ".XXX") 			;Удаляем файл-метку

	else		;Если пингуется, запускаем приложение

		FileWrite("\\main\GetStand\App\httpN\system\temp\PIDS\" & $name[0] & "." & $hostName[0] & "." & $EXE, "")
		BotMsg("👤" & $name[0] & @CRLF & "✅Подключился к хосту" & @CRLF & "🖥️" & $hostName[0] & " 🕹" & $EXE & " ⏱" & _Now(), $sBotKey, $nChatId)
		Logger($name[0], $ipAddr[0] & "(" & $MAC & ")", "Успешное подключение", $hostName[0] & ":" & $EXE, 1)
		$PID = Run($exeFile & $CONFIG & $hostName[0] & $RES)					;Запускаем приложение и фиксируем его PID
		;Фиксируем PID приложения, чтобы не обрывать маршрут при закрытии одного из окон
		;Так же будем отслеживать пользователей в онлайне
		;ProcessWaitClose($PID)													;Ждем окончания конкретного процесса

		$t = 0
		While True		;Запускаем сессию

			If ProcessExists($PID) = 0	Then	;Если завершили процесс вручную

				BotMsg("👤" & $name[0] & @CRLF & "⬅️Отключился от хоста" & @CRLF & "🖥️" & $hostName[0] & " 🕹" & $EXE & " ⏱" & _Now(), $sBotKey, $nChatId)
				Logger($name[0], $ipAddr[0] & "(" & $MAC & ")", "Завершение работы", $hostName[0] & ":" & $EXE, 1)
				FileDelete("\\main\GetStand\App\httpN\system\temp\PIDS\" & $name[0] & "." & $hostName[0] & "." & $EXE)
				ExitLoop

			ElseIf $t = 28800 Then				;Если дождались таймаута

				ProcessClose($PID)
				BotMsg("👤" & $name[0] & @CRLF & "⬅️Сессия завершена" & @CRLF & "🖥️" & $hostName[0] & " 🕹" & $EXE & " ⏱" & _Now(), $sBotKey, $nChatId)
				MsgBox(48, "Предупреждение", "Сессия " & $hostName[0] & ":" & $EXE & @CRLF & "завершена", 3)
				Logger($name[0], $ipAddr[0] & "(" & $MAC & ")", "Сессия завершена", $hostName[0] & ":" & $EXE, 1)
				FileDelete("\\main\GetStand\App\httpN\system\temp\PIDS\" & $name[0] & "." & $hostName[0] & "." & $EXE)
				ExitLoop

			Endif
			Sleep(1000)
			$t += 1

		WEnd

	Endif

	;Когда закончили работу или не смогли подключиться, нужно удалить маршрут за собой
	$Pfiles =_FileListToArray("\\main\GetStand\App\httpN\system\temp\PIDS\")	;Получим список файлов
	if _ArraySearch($Pfiles, $name[0], "", "", "", 1) = -1 Then					;Если подобных файлов нет

		;BotMsg("👤" & $name[0] & @CRLF & "⬅️Вышел из сети" & @CRLF & "⏱" & _Now(), $sBotKey, $nChatId)
		RouteAddDel("route delete " & $maskAddr, $flg)	;Удаляем построенный маршрут после окончания работы

	EndIf

EndFunc