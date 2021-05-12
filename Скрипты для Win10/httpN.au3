#include <Array.au3>
#include <Date.au3>
#include <Constants.au3>

;ПРОВЕРКА ЗАПУСКА EXE ФАЙЛА
if $cmdLine[0] = 0 Then 	;Вызывается, если нет аргументов

   MsgBox(16, "Ошибка", "Недостаточно аргументов для запуска.")
   Exit

EndIf

;НАСТРОЙКА ОТОБРАЖЕНИЯ ПРИЛОЖЕНИЯ В ТРЕЕ
Opt("TrayMenuMode", 1 + 2)	;Не отображать стандартные панели
TraySetState(2)				;Удалить отображение в трее

;ПРОВЕРКА MAC АДРЕСА ПОЛЬЗОВАТЕЛЯ ПО СПИСКУ АВТОРИЗИРОВАННЫХ ПОЛЬЗОВАТЕЛЕЙ
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
$hostName = StringRegExp(StringTrimLeft($cmdLine[1], 14), "((\d{1,3}\.){3}\d{1,3})|(\w{1,10})", 2) ;Выбираем адрес компьютера
	if StringLeft($autorizedMac, 17) <> $MAC Then	;Если MAC пользователя отсутствует, заканчиваем работу

		$tempFile = FileOpen("\\main\GetStand\App\httpN\system\temp\PIDS\Неизвестный Пользователь(unknown)", 2) ;Делаем пометку
		FileWrite("\\main\GetStand\App\httpN\system\temp\PIDS\Неизвестный Пользователь(unknown)", "(" & $hostName[0] & ")")
		MsgBox(16, "Ошибка", "Авторизация не пройдена." & @CRLF & "Обратитесь в Отдел Тестирования.")
		Logger("Неизвестный Пользователь(unknown)", $ipAddr[0] & "(" & $MAC & ")", "Неавторизованный вход", $hostName[0], 1)
		FileClose($tempFile)
		FileDelete("\\main\GetStand\App\httpN\system\temp\PIDS\Неизвестный Пользователь(unknown)") 				;Удаляем пустой файл
		Exit

	EndIf

;ПОЛУЧЕНИЕ ИНФОРМАЦИИ О КОМПЬЮТЕРЕ СТЕНДА ИЗ КОМАНДНОЙ СТРОКИ ЗАПУСКА
$exeFile = StringLeft($cmdLine[1], 11)	;Выбираем из аргумента приложение для запуска
$hostName[1] = FileReader("\\main\GetStand\App\httpN\system\HOSTS", $hostName[0]) ;Получим строку с хостом и прочей инфой, если она есть
	;Ищем информацию о хосте из списка хостов
	if $hostName[0] <> StringLeft($hostName[1], StringLen($hostName[0])) Then		  ;Проверим, есть ли адрес в списке

		MsgBox(16, "Ошибка", "Адрес компьютера не найден." & @CRLF & "Обратитесь в Отдел Тестирования.")
		Logger("Адрес компьютера " & $hostName[0] & " не найден. Проверьте схему, список и строку запуска.", "", "", "", 2)
		Exit

	EndIf
	;Разбираем строку маршрута, если такая имеется
	$gwString = StringTrimLeft($hostName[1], StringLen($hostName[0]))	;Получим строку с маршрутом, либо ничего
		if $gwString = "" Then		;Если маршрута нет, устанавливаем флаг запуска напрямую

			$flag = 0
			$gateWay = 0
			$maskAddr = 0
			$MASK = 0

		ElseIf StringLen($gwString) > StringLen($hostName[0]) Then ;Если маршрут есть, устанавливаем флаг для запуска с маршрутом
			;Тут можно добавить проверку адресов регуляркой для соответствия стандарту ipv4
			$flag = 1
			$tmpGW = StringRegExp($gwString, "((\d{1,3}\.){3}\d{1,3})", 2) 	;Фильтруем строку после хостнейма
			$gateWay = $tmpGW[0]											;Получаем адрес шлюза
			$maskAddr = StringTrimLeft($gwString, StringLen($gateWay) + 1)	;Получаем адрес для маршрутизации
			$MASK = AddrToMask($maskAddr)									;Получаем маску сети

		Else						;Если есть ошибка в записи адреса или списке хостов

			MsgBox(16, "Ошибка", "Ошибка в списке хостов." & @CRLF & "Обратитесь в Отдел Тестирования.")
			Logger("В записи адреса " & $hostName[0] & " ошибка. Проверьте запись в списке хостов.", "", "", "", 2)
			Exit

		EndIf

;ЗАПУСК ПРИЛОЖЕНИЯ И НАБЛЮДЕНИЕ ЗА ХОДОМ РАБОТЫ
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
		MsgBox(16, "Ошибка", "Приложение для запуска не найдено." & @CRLF & "Обратитесь в Отдел Тестирования.")
		Logger("При запуске " & $exeFile & " произошла ошибка. Проверьте схему, записи и диск GetStand.", "", "", "", 2)
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

	Sleep(1000)
	return Ping($ADD)

EndFunc

Func AddrToMask($MSKADDR)						;Функция преобразования адреса в маску

	Switch "1"	;REGEX возвращает массив либо двоичное значение. Сравниваем с единицей для удобства

		Case StringRegExp($MSKADDR, "((\d{1,3}\.){2}0.0)", 0) ;Проверяем последние актеты на 0
			return "255.255.0.0"							  ;Возвращаем маску

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
		$ADDRES = StringFormat("%-33s", $ADDRES)
		$ACT = StringFormat("%-21s", $ACT)
		FileWriteLine($tmpPath, $TIME & " | " & $USER & " | " & $ADDRES & " | " & $ACT & " | " & $HOST )

	ElseIf $TYPE = 2 Then		;Запись лога ошибок

		FileWriteLine("\\main\GetStand\App\httpN\system\log\errors.txt", StringFormat("%-19s", _Now()) & " | " & $USER)

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

	RouteAddDel("route add " & $maskAddr & " mask " & $MASK & " " & $gateWay, $flg)	;Строим маршрут если он есть
	$filePath = "\\main\GetStand\App\httpN\system\temp\PIDS\" & StringTrimLeft($autorizedMac, 18)	;Путь к файлам
	;Если подключение будет не только через днс, то нужно поправить хостнейм[0]
	if (ConsolePing($hostName[0] & ".ot.net")) = 0 Then

		$hFile = FileOpen($filePath & "!", 2)		;Открываем для перезаписи
		FileWrite($filePath & "!", "0(" & $hostName[0] & "ZZ)")	;Индикатор неудачного подключения
		FileClose($hFile)					;Закрываем файл
		MsgBox(16, "Ошибка", "Невозможно подключиться к хосту." & @CRLF & "Обратитесь в Отдел Тестирования.")
		Logger(StringTrimLeft($autorizedMac, 18), $ipAddr[0] & "(" & $MAC & ")", "Хост не отвечает", $hostName[0] & ":" & $EXE, 1)
		FileDelete($filePath & "!") 				;Удаляем файл индикатор
		RouteAddDel("route delete " & $maskAddr, $flg)	;Удаляем построенный маршрут

	else

		Logger(StringTrimLeft($autorizedMac, 18), $ipAddr[0] & "(" & $MAC & ")", "Успешное подключение", $hostName[0] & ":" & $EXE, 1)
		$PID = Run($exeFile & $CONFIG & $hostName[0] & $RES)	;Запускаем приложение и фиксируем его PID
		;Фиксируем PID приложения, чтобы не обрывать маршрут при закрытии одного из окон
		;Так же будем отслеживать пользователей в онлайне
		FileWrite($filePath, $PID & "(" & $hostName[0] & ")")						;Записали PID в персональный файл пользователя
		ProcessWaitClose($PID)														;Ждем окончания конкретного процесса
		$sRead = FileRead($filePath)												;Читаем содержимое
		$sNew = StringReplace($sRead, $PID & "(" & $hostName[0] & ")", "")			;Убираем конкретный PID из файла
		$hFile = FileOpen($filePath, 2) 											;Открываем для перезаписи
		FileWrite($hFile, $sNew)													;Вписываем оставшиеся PID, если есть
		FileClose($hFile)															;Закрываем файл
		Logger(StringTrimLeft($autorizedMac, 18), $ipAddr[0] & "(" & $MAC & ")", "Завершение работы", $hostName[0] & ":" & $EXE, 1)
		if FileRead($filePath) = "" Then

			FileDelete($filePath) 	;Удаляем пустой файл
			RouteAddDel("route delete " & $maskAddr, $flg)	;Удаляем построенный маршрут после окончания работы

		EndIf

	Endif

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