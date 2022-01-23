;Библиотека некоторых функций
;В частности генератор сообщений для телеграмма



Func Validator($textstring, $pat)					;Функция проверки строки по шаблону

	$textstring = StringRegExp($textstring, $pat, 2)
	if IsArray($textstring) <> 1 Then

		Return 1

	Endif

EndFunc

Func _URIEncode($sData)								;Генератор сообщений для телеграм бота

    Local $aData = StringSplit(BinaryToString(StringToBinary($sData, 4), 1), "")
    Local $nChar
    $sData = ""
    For $i = 1 To $aData[0]

        $nChar = Asc($aData[$i])
        Switch $nChar

            Case 45, 46, 48 To 57, 65 To 90, 95, 97 To 122, 126
                $sData &= $aData[$i]

            Case 32
                $sData &= "+"

            Case Else
                $sData &= "%" & Hex($nChar,2)

        EndSwitch

    Next

Return $sData
EndFunc

Func BotMsg($_TXT, $sBotKey, $nChatId)				;Отправитель сообщений боту в телеграм

	$sText = _URIEncode($_TXT)		; Текст сообщения, не больше 4000 знаков
	ConsoleWrite(InetRead('https://api.telegram.org/' & $sBotKey & '/sendMessage?chat_id=' & $nChatId & '&text=' & $sText, 0))

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

Func ListDivider()

	$a = "_"
	For $i = 0 To 61 Step 1

		$a &= "_"				;Создаем строку разделитель

	Next

Return $a
EndFunc



;$PID = Run(@comSpec&' /c getmac', '', @SW_HIDE, $STDOUT_CHILD)	;Получаем список своих мак адресов
;$sStdOutRead = ""		;В консоли получим текст с адресами
;	While 1				;Конструкция нужна, чтобы прочитать вывод из консоли
;
;		$sStdOutRead &= StdoutRead($PID)
;		If @error Then ExitLoop
;
;	WEnd
;$ipAddr = _ArrayUnique(StringRegExp($sStdOutRead, "(([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2}))", 3))	;Массив своих маков
;$sText = FileRead("\\main\GetStand\App\httpN\system\MAC") 		;Читаем список
;$aLines = StringSplit($sText, @CRLF, 1)							;Делаем массив строк авторизованных маков
;$autorizedMac = ""
;$MAC = ""
;Перебираем свои адреса и ищем их в списке авторизованных адресов
;For $i = 1 To $ipAddr[0] Step +1
;
;	If StringLen($ipAddr[$i]) = 17 Then		;Приходится делать условие, потому что в массив попадает мусор
;
;		For $j = 1 To $aLines[0] Step +1					;Перебираем строки
;
;			$ipAddr[$i] = StringRegExpReplace($ipAddr[$i], "-", ":")
;			If StringInStr($aLines[$j], $ipAddr[$i]) Then	;Если есть совпадение, выдаем строку
;
;				$autorizedMac = $aLines[$j]					;Строка с информацией о пользователей
;				$MAC = $ipAddr[$i]							;Мак пользователя
;				ExitLoop
;
;			EndIf
;
;		Next
;
;	EndIf
;
;Next

;$NAME = FileRead("\\main\GetStand\App\httpN\system\temp\PIDS\_MasterPID")
;$WR = 0
;$WinHttpReq = ObjCreate('WinHttp.WinHttpRequest.5.1')			;Создаем объект, который отправляет http запросы
;$WinHttpReq.open("POST", "https://api.telegram.org/" & $sBotKey & "/sendMessage", false)	;Открываем URL
;$WinHttpReq.Option(4) = 13056																;Игнор SSL ошибок
;$WinHttpReq.SetRequestHeader('Content-Type', 'application/x-www-form-urlencoded')			;Заголовок запроса
;	if ($NAME = "") Or ($NAME = @ComputerName) Then	;Если файл пустой или в нем моё имя компьютера
;		;Перезаписываем моё имя и разрешаем передачу сообщений боту в телеграм
;		$f = FileOpen("\\main\GetStand\App\httpN\system\temp\PIDS\_MasterPID", 2)
;		FileWrite($f, @ComputerName)
;		FileClose($f)
;		$WR = 1
;	EndIf
;
;Func BotMsg($_TXT)									;Отправитель сообщений боту в телеграм
;
;	local $DATA = "chat_id=" & $nChatId & "&text=" & $_TXT
;	$WinHttpReq.send($DATA)
;	$ret = $WinHttpReq.ResponseText
;
;Return $ret
;EndFunc
;
;Func GetString($File)								;Получаем строку пользователя с подключенными стендами
;
;	$sText = FileRead("\\main\GetStand\App\httpN\system\temp\PIDS\" & $File)	;Читаем содержимое файла в строку
;	$sT = StringRegExp($sText, "\(\w{1,20}\)", 3)								;Выделяем только хосты в массив
;	$sText = _ArrayUnique($sT)													;Оставляем только уникальные значения
;	_ArrayDelete($sText, 0)														;Убираем лишний элемент из массива
;	$sT = _ArrayToString($sText, ", ")											;Собираем элементы в строку
;	$sText = StringRegExpReplace(StringRegExpReplace($sT, "\(", ""), "\)", "")	;Убираем лишние символы
;	$File &= ": " & $sText														;Соединяем строку
;
;	Return $File
;
;EndFunc
;
;		Dim $Array[0]		;Список пользователей для расчета
;		For $i = 2 To $Array[0]		;Расчитываем время в онлайне
;			$Arr = StringRegExpReplace($Array[$i], "\:\s((\w{1,20}))|\,\s\w{1,20}", "") 		;Выделяем имя пользователя;			
;			$Array[$i] &= "  -> в сети " & _DateDiff('n', $x, _NowCalc()) & " мин."				;Генерируем строку времени в онлайне
;			if $t = 1 Then
;				$TG = "👤" & $Arr		;Строка имени пользователя
;				$sText = FileRead("\\main\GetStand\App\httpN\system\temp\PIDS\" & $Arr)		;Читаем содержимое файла в строку
;				$sT = StringRegExp($sText, "\(\w{1,20}\)", 3)								;Выделяем только хосты в массив
;				$sText = _ArrayUnique($sT)													;Оставляем только уникальные значения
;				_ArrayDelete($sText, 0)														;Убираем лишний элемент из массива
;				$sT = _ArrayToString($sText, ", ")											;Собираем элементы в строку
;				$sText = StringRegExpReplace(StringRegExpReplace($sT, "\(", ""), "\)", "")	;Убираем лишние символы
;				$TGH = "🖥️" & $sText		;Строка запущенного хоста
;				$TGT = _DateDiff('n', $x, _NowCalc()) & " мин."		;Расчет времени
;				$Ar[$i - 2] = $TG & ":  " & $TGH & " ⏱ в сети " & $TGT	;Собираем строку имени, хоста и времени в онлайне
;			EndIf
;		Next
;		_ArrayDelete($Array, 0)		;Если есть, удаляем лишние строки
;		_ArrayDelete($Array, 0)
;		if $t = 1 Then
;			$AMsg = _ArrayToString($Ar, @CRLF & $a & @CRLF)		;Повторяем сообщение в телеграме
;			ConsoleWrite(BotMsg("Пользователи в сети: " & $a & @CRLF & $AMsg))
;		EndIf
;
;$iPIDClear = TrayCreateItem("*Очистить буфер")		;Очищаем устаревшие ПИД файлы если такие есть
;$iPause = TrayCreateItem("Оповещения")				;Вкл/выкл оповещения в винде
;	$pause = 1										;Индикатор чек-кнопки
;	TrayItemSetState($iPause, 1)					;Галочка
;
;		Case $iPause					;Включаем/выключаем оповещения
;			If $pause = 0 Then
;				$pause = 1
;				TrayItemSetState($iPause, 1)
;			Else
;				$pause = 0
;				TrayItemSetState($iPause, 4)
;			EndIf
;		Case $iPIDClear					;Предлагаем очистить устаревшие ПИД файлы
;			if MsgBox(65, "GetStand Manager", "Очистить буфер пользователей?" & @CRLF & "(Действие необратимо)") = 1 Then
;			EndIf
;
			;$f = FileOpen("\\main\GetStand\App\httpN\system\temp\PIDS\_MasterPID", 2)
			;FileWrite($f, "")			;Освобождаем место для других компьютеров
			;FileClose($f)
;
	;БЛОК СЛЕЖЕНИЯ ЗА СПИСКОМ ПОЛЬЗОВАТЕЛЕЙ
	;$FileList2 = _FileListToArray("\\main\GetStand\App\httpN\system\temp\PIDS")	;Создаем еще один список
	;	if $FileList1[0] > $FileList2[0] Then
	;		Searcher($FileList1, $FileList2, "вышел из сети!", $pause)			;Следим за созданием и удалением файлов
	;	ElseIf $FileList1[0] < $FileList2[0] Then
	;		Searcher($FileList2, $FileList1, "подключился к:", $pause)			;Сообщаем, если будут изменения в списках
	;	EndIf
	;$FileList1 = _FileListToArray("\\main\GetStand\App\httpN\system\temp\PIDS")
	;	if $FileList1[0] < $FileList2[0] Then
	;		Searcher($FileList1, $FileList2, "вышел из сети!", $pause)
	;	ElseIf $FileList1[0] > $FileList2[0] Then
	;		Searcher($FileList2, $FileList1, "подключился к:", $pause)
	;	EndIf
;
;Func Searcher($MajorList, $MinorList, $Message, $p)	;Функция поиска пользователя в списке
;
;	For $i = 1 To $MajorList[0]	Step 1		;Перебираем бОльший список
;
;		$cnt = 0		;Флаг - индикатор
;		For $j = 1 To $MinorList[0]	Step 1	;Перебираем меньший список
;
;			if $MajorList[$i] = $MinorList[$j] Then
;
;				ExitLoop	;Сбрасываем итерацию, если пользователь есть
;
;			Else
;
;				$cnt += 1
;				if $cnt = $MinorList[0]	Then ;Если счетчик равен числу элементов меньшего списка, значит не было совпадений с бОльшим
;
;					$a = StringTrimLeft(GetString($MajorList[$i]), StringLen($MajorList[$i]) + 1) ;Получаем строку с хостами
;					if $MajorList[$i] = "Неизвестный пользователь(unknown)" Then
;						;Сообщаем что подключался неавторизованный пользователь
;						if ($a <> -1) And ($p = 1) Then TrayTip("GetStand Manager", $MajorList[$i] & " пытался подключиться к" & $a, 1, 1)
;						if $a <> -1 Then $sTG = "👤" & $MajorList[$i] & @CRLF & "⚠️Пытался подключиться к хосту" & @CRLF & "🖥️" & $a
;
;					elseif StringRight($MajorList[$i], 1) = "!" Then
;						;Сообщаем что пользователь неудачно подключился
;						if ($a <> -1) And ($p = 1) Then TrayTip("GetStand Manager", StringTrimRight($MajorList[$i], 1) & " неудачное подключение к" & StringTrimRight($a, 2), 1, 1)
;						if $a <> -1 Then $sTG = "👤" & StringTrimRight($MajorList[$i], 1) & @CRLF & "❌Неудачное подключение к хосту" & @CRLF &  "🖥️" &  StringTrimRight($a, 2)
;
;					Else
;						;Сообщаем что пользователь подключился/отключился от хоста
;						if ($a <> -1) And ($p = 1) Then	;В личных уведомлениях
;
;							TrayTip("GetStand Manager", $MajorList[$i] & " подключился к" & $a, 1, 1)
;
;						elseif ($a = -1) And ($p = 1) Then
;
;							TrayTip("GetStand Manager", $MajorList[$i] & " вышел из сети!", 1, 1)
;
;						EndIf
;						if $a <> -1 Then				;В телеграме
;
;							$sTG = "👤" & $MajorList[$i] & @CRLF & "✅Подключился к хосту" & @CRLF & "🖥️" & $a
;
;						elseif $a = -1 Then
;
;							$sTG = "👤" & $MajorList[$i] & @CRLF & "➡️Вышел из сети!"
;							$a = " "
;
;						EndIf
;
;					EndIf	;Отправляем сообщение в телеграм
;					if ($WR = 1) And ($a <> -1) Then ConsoleWrite(BotMsg($sTG))
;
;				Endif
;
;			EndIf
;
;		Next
;
;	Next
;
;EndFunc