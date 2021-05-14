#include <File.au3>
#include <Array.au3>
#include <Date.au3>
#include <Constants.au3>

;СОЗДАЕМ МЕНЮ МЕНЕДЖЕРА В ТРЕЕ
Opt("TrayMenuMode", 1 + 2)							;Отключаем стандартные пункты меню
$iList = TrayCreateItem("Пользователи в сети")		;Создаем кнопки меню трея
$iLog = TrayCreateMenu("Логи")						;Логи работы httpN
	$iRuns = TrayCreateItem("Логи подключений", $iLog)
	$iErrors = TrayCreateItem("Логи ошибок", $iLog)
	$iKitLog = TrayCreateItem("Логи Kitty", $iLog)
	$iScpLog = TrayCreateItem("Логи WinSCP", $iLog)
	$iVncLog = TrayCreateItem("Логи VNC", $iLog)
	TrayCreateItem("", $iLog)
	$iLogClear = TrayCreateItem("*Очистить логи", $iLog)
$iScheme = TrayCreateMenu("Схема")					;GetStand схема в двух вариантах
	$iCom = TrayCreateItem("Оффлайн схема", $iScheme)
	$iEdit = TrayCreateItem("Редактор", $iScheme)
$iConfig = TrayCreateMenu("Конфигурации")			;Конфигурации подключений
	$iMac = TrayCreateItem("MAC-адреса", $iConfig)
	$iHosts = TrayCreateItem("Хостнеймы", $iConfig)
	$iKit = TrayCreateItem("Kitty сессии", $iConfig)
	$iScp = TrayCreateItem("WinSCP сессии", $iConfig)
	$iVnc = TrayCreateItem("VNC сессии", $iConfig)
$iSystem = TrayCreateMenu("Каталоги")				;Основные рабочие каталоги
	$iGS = TrayCreateItem("Каталог GetStand", $iSystem)
	$iHN = TrayCreateItem("Каталог httpN", $iSystem)
$iPIDClear = TrayCreateItem("*Очистить буфер")		;Очищаем устаревшие ПИД файлы если такие есть
$iPause = TrayCreateItem("Оповещения")				;Вкл/выкл оповещения в винде
	$pause = 1										;Индикатор чек-кнопки
	TrayItemSetState($iPause, 1)					;Галочка
	TrayCreateItem("")
$iExit = TrayCreateItem("Выход")					;Выход из приложения

;СТАРТ ПРОГРАММЫ, ПОКАЗЫВАЕМ ПОЛЬЗОВАТЕЛЕЙ ОНЛАЙН
$FileList1 = _FileListToArray("\\main\GetStand\App\httpN\system\temp\PIDS")	;Создаем список текущих пользователей
ShowList(GetArray($FileList1), 0)		;Отображаем список пользователей

;НАСТРОЙКИ ПОДКЛЮЧЕННОГО ТЕЛЕГРАМ БОТА
$sBotKey = 'bot1844208783:AAHnDQhkV7kARiLCyus0vxV8jQdAYy4TZcY'	;Ваш api ключ
$nChatId = -1001460258261                                      	;Id получателя
$NAME = FileRead("\\main\GetStand\App\httpN\system\temp\PIDS\_MasterPID")
$WR = 0
$WinHttpReq = ObjCreate('WinHttp.WinHttpRequest.5.1')			;Создаем объект, который отправляет http запросы
$WinHttpReq.open("POST", "https://api.telegram.org/" & $sBotKey & "/sendMessage", false)	;Открываем URL
$WinHttpReq.Option(4) = 13056																;Игнор SSL ошибок
$WinHttpReq.SetRequestHeader('Content-Type', 'application/x-www-form-urlencoded')			;Заголовок запроса
	if ($NAME = "") Or ($NAME = @ComputerName) Then	;Если файл пустой или в нем моё имя компьютера
		;Перезаписываем моё имя и разрешаем передачу сообщений боту в телеграм
		$f = FileOpen("\\main\GetStand\App\httpN\system\temp\PIDS\_MasterPID", 2)
		FileWrite($f, @ComputerName)
		FileClose($f)
		$WR = 1

	EndIf

;ТЕЛО ПРОГРАММЫ, РАБОТАЮЩЕЕ В ФОНОВОМ РЕЖИМЕ. ПРОЦЕСС ОТОБРАЖАЕТСЯ В ТРЕЕ
While True		;Бесконечный цикл, обеспечивающий мониторинг в фоновом режиме и меню трея

;БЛОК УПРАВЛЕНИЯ ПУНКТАМИ МЕНЮ ТРЕЯ
Switch TrayGetMsg()		;Обрабатываем пункты меню

	Case $iList						;Открываем список пользователей онлайн
		ShowList(GetArray($FileList1), 1)

	Case $iRuns						;Открываем лог подключений
		ShellExecute("\\main\GetStand\App\httpN\system\log\log.txt")

	Case $iErrors					;Открываем лог ошибок
		ShellExecute("\\main\GetStand\App\httpN\system\log\errors.txt")

	Case $iKitLog					;Открываем логи по kitty
		ShellExecute("\\main\GetStand\App\kitty\Log")

	Case $iScpLog					;Открываем логи по winscp
		ShellExecute("\\main\GetStand\App\winscp\Log")

	Case $iVncLog					;Открываем логи по vnc
		ShellExecute("\\main\GetStand\App\vnc\Log")

	Case $iLogClear					;Предложение очистить все логи
		if MsgBox(65, "GetStand Manager", "Очистить все логи?" & @CRLF & "(Действие необратимо)") = 1 Then

			FileDelete("\\main\GetStand\App\httpN\system\log\*.txt")
			FileDelete("\\main\GetStand\App\kitty\Log\*.log")
			FileDelete("\\main\GetStand\App\winscp\Log\*.XML")
			FileDelete("\\main\GetStand\App\vnc\Log\*")					;Удаляет не всё
			FileWrite("\\main\GetStand\App\httpN\system\log\log.txt", "")
			FileWrite("\\main\GetStand\App\httpN\system\log\errors.txt", "")

		EndIf

	Case $iCom						;Открываем схему оффлайн
		ShellExecute("\\main\GetStand\Diagrams\DiagramsOT.html")

	Case $iEdit						;Открываем редактор схемы
		ShellExecute("https://app.diagrams.net/?lang=ru&lightbox=0&highlight=1E90FF&layers=0&nav=1#G1RvU1U9lO0kD3spev2b_3A7aVjSFA5WGM")

	Case $iMac						;Открываем список маков
		ShellExecute("\\main\GetStand\App\notepad\notepad++.exe", "\\main\GetStand\App\httpN\system\MAC")

	Case $iHosts					;Открываем список хостнеймов
		ShellExecute("\\main\GetStand\App\notepad\notepad++.exe", "\\main\GetStand\App\httpN\system\HOSTS")

	Case $iKit						;Открываем сессии китти
		ShellExecute("\\main\GetStand\App\kitty\Sessions")

	Case $iScp						;Открываем сессии scp
		ShellExecute("\\main\GetStand\App\winscp")

	Case $iVnc						;Открываем список мак адресов
		ShellExecute("\\main\GetStand\App\vnc\config")

	Case $iGS						;Открываем основной каталог
		ShellExecute("\\main\GetStand")

	Case $iHN 						;Открыть каталог httpN
		ShellExecute("\\main\GetStand\App\httpN\system")

	Case $iPause					;Включаем/выключаем оповещения
		If $pause = 0 Then

			$pause = 1
			TrayItemSetState($iPause, 1)

		Else

			$pause = 0
			TrayItemSetState($iPause, 4)

		EndIf

	Case $iPIDClear					;Предлагаем очистить устаревшие ПИД файлы
		if MsgBox(65, "GetStand Manager", "Очистить буфер пользователей?" & @CRLF & "(Действие необратимо)") = 1 Then

			$lTime = _NowCalc()				;Фиксируем локальное время
			For $t = 2 To $FileList1[0]		;Перебираем каждый файл

				$fTime = FileGetTime("\\main\GetStand\App\httpN\system\temp\PIDS\" & $FileList1[$t], 0)	;Фиксируем время создания файла
				$TX = $fTime[0] & "/" & $fTime[1] & "/" & $fTime[2] & " " & $fTime[3] & ":" & $fTime[4] & ":" & $fTime[5]
				if _DateDiff("n", $TX, $lTime) > 1440 Then		;Если время существования файла больше 1440 мин(24 часа), удаляем

					FileDelete("\\main\GetStand\App\httpN\system\temp\PIDS\" & $FileList1[$t])	;Удаляем файлы старше 1го дня

				EndIf

			Next

		EndIf

	Case $iExit						;Закрываем программу
		$f = FileOpen("\\main\GetStand\App\httpN\system\temp\PIDS\_MasterPID", 2)
		FileWrite($f, "")			;Освобождаем место для других компьютеров
		FileClose($f)
		ExitLoop

EndSwitch

;БЛОК СЛЕЖЕНИЯ ЗА СПИСКОМ ПОЛЬЗОВАТЕЛЕЙ
$FileList2 = _FileListToArray("\\main\GetStand\App\httpN\system\temp\PIDS")	;Создаем еще один список
	if $FileList1[0] > $FileList2[0] Then

		Searcher($FileList1, $FileList2, "вышел из сети!", $pause)			;Следим за созданием и удалением файлов

	ElseIf $FileList1[0] < $FileList2[0] Then

		Searcher($FileList2, $FileList1, "подключился к:", $pause)			;Сообщаем, если будут изменения в списках

	EndIf
$FileList1 = _FileListToArray("\\main\GetStand\App\httpN\system\temp\PIDS")
	if $FileList1[0] < $FileList2[0] Then

		Searcher($FileList1, $FileList2, "вышел из сети!", $pause)

	ElseIf $FileList1[0] > $FileList2[0] Then

		Searcher($FileList2, $FileList1, "подключился к:", $pause)

	EndIf

WEnd





;ПОЛЬЗОВАТЕЛЬСКИЕ ФУНКЦИИ
Func GetString($File)								;Получаем строку пользователя с подключенными стендами

	$sText = FileRead("\\main\GetStand\App\httpN\system\temp\PIDS\" & $File)	;Читаем содержимое файла в строку
	$sT = StringRegExp($sText, "\(\w{1,20}\)", 3)								;Выделяем только хосты в массив
	$sText = _ArrayUnique($sT)													;Оставляем только уникальные значения
	_ArrayDelete($sText, 0)														;Убираем лишний элемент из массива
	$sT = _ArrayToString($sText, ", ")											;Собираем элементы в строку
	$sText = StringRegExpReplace(StringRegExpReplace($sT, "\(", ""), "\)", "")	;Убираем лишние символы
	$File &= ": " & $sText														;Соединяем строку

Return $File
EndFunc

Func GetArray($List)								;Получаем массив пользователей с подключенными стендами

	For $i = 2 To $List[0]							;Перебираем массив

		$List[$i] = GetString($List[$i])			;Вписываем в элементы нужные строки

	Next

Return $List
EndFunc

Func ShowList($Array, $t)								;Функция отображения списка пользователей

	if $Array[0] = 1 Then 			;Проверяем, есть ли кто в сети

		MsgBox(64, "GetStand Manager", "Пользователи не в сети")

	else

		$a = "_"
		For $i = 0 To 61 Step 1

			$a &= "_"				;Создаем строку разделитель

		Next

		Dim $Ar[$Array[0] - 1]		;Список пользователей для расчета
		For $i = 2 To $Array[0]		;Расчитываем время в онлайне

			$Arr = StringRegExpReplace($Array[$i], "\:\s((\w{1,20}))|\,\s\w{1,20}", "") 		;Выделяем имя пользователя
			$z = FileGetTime("\\main\GetStand\App\httpN\system\temp\PIDS\" & $Arr, 1, 0)		;Берем время файла
			$x = $z[0] & "/" & $z[1] & "/" & $z[2] & " " & $z[3] & ":" & $z[4] & ":" & $z[5]	;Собираем строку времени в нужном формате
			$Array[$i] &= "  -> в сети " & _DateDiff('n', $x, _NowCalc()) & " мин."				;Генерируем строку времени в онлайне
			if $t = 1 Then

				$TG = "👤" & $Arr		;Строка имени пользователя
				$sText = FileRead("\\main\GetStand\App\httpN\system\temp\PIDS\" & $Arr)		;Читаем содержимое файла в строку
				$sT = StringRegExp($sText, "\(\w{1,20}\)", 3)								;Выделяем только хосты в массив
				$sText = _ArrayUnique($sT)													;Оставляем только уникальные значения
				_ArrayDelete($sText, 0)														;Убираем лишний элемент из массива
				$sT = _ArrayToString($sText, ", ")											;Собираем элементы в строку
				$sText = StringRegExpReplace(StringRegExpReplace($sT, "\(", ""), "\)", "")	;Убираем лишние символы
				$TGH = "🖥️" & $sText		;Строка запущенного хоста
				$TGT = _DateDiff('n', $x, _NowCalc()) & " мин."		;Расчет времени
				$Ar[$i - 2] = $TG & ":  " & $TGH & " ⏱ в сети " & $TGT	;Собираем строку имени, хоста и времени в онлайне

			EndIf

		Next
		_ArrayDelete($Array, 0)		;Если есть, удаляем лишние строки
		_ArrayDelete($Array, 0)
		$MsgList = _ArrayToString($Array, @CRLF & $a & @CRLF) ;Вписываем в окно список пользователей
		MsgBox(64, "GetStand Manager", "Пользователи в сети: " & $a & @CRLF & $MsgList)
		if $t = 1 Then

			$AMsg = _ArrayToString($Ar, @CRLF & $a & @CRLF)		;Повторяем сообщение в телеграме
			ConsoleWrite(BotMsg("Пользователи в сети: " & $a & @CRLF & $AMsg))

		EndIf

	EndIf

EndFunc

Func Searcher($MajorList, $MinorList, $Message, $p)	;Функция поиска пользователя в списке

	For $i = 1 To $MajorList[0]	Step 1		;Перебираем бОльший список

		$cnt = 0		;Флаг - индикатор
		For $j = 1 To $MinorList[0]	Step 1	;Перебираем меньший список

			if $MajorList[$i] = $MinorList[$j] Then

				ExitLoop	;Сбрасываем итерацию, если пользователь есть

			Else

				$cnt += 1
				if $cnt = $MinorList[0]	Then ;Если счетчик равен числу элементов меньшего списка, значит не было совпадений с бОльшим

					$a = StringTrimLeft(GetString($MajorList[$i]), StringLen($MajorList[$i]) + 1) ;Получаем строку с хостами
					if $MajorList[$i] = "Неизвестный пользователь(unknown)" Then
						;Сообщаем что подключался неавторизованный пользователь
						if ($a <> -1) And ($p = 1) Then TrayTip("GetStand Manager", $MajorList[$i] & " пытался подключиться к" & $a, 1, 1)
						if $a <> -1 Then $sTG = "👤" & $MajorList[$i] & @CRLF & "⚠️Пытался подключиться к хосту" & @CRLF & "🖥️" & $a

					elseif StringRight($MajorList[$i], 1) = "!" Then
						;Сообщаем что пользователь неудачно подключился
						if ($a <> -1) And ($p = 1) Then TrayTip("GetStand Manager", StringTrimRight($MajorList[$i], 1) & " неудачное подключение к" & StringTrimRight($a, 2), 1, 1)
						if $a <> -1 Then $sTG = "👤" & StringTrimRight($MajorList[$i], 1) & @CRLF & "❌Неудачное подключение к хосту" & @CRLF &  "🖥️" &  StringTrimRight($a, 2)

					Else
						;Сообщаем что пользователь подключился/отключился от хоста
						if ($a <> -1) And ($p = 1) Then	;В личных уведомлениях

							TrayTip("GetStand Manager", $MajorList[$i] & " подключился к" & $a, 1, 1)

						elseif ($a = -1) And ($p = 1) Then

							TrayTip("GetStand Manager", $MajorList[$i] & " вышел из сети!", 1, 1)

						EndIf
						if $a <> -1 Then				;В телеграме

							$sTG = "👤" & $MajorList[$i] & @CRLF & "✅Подключился к хосту" & @CRLF & "🖥️" & $a

						elseif $a = -1 Then

							$sTG = "👤" & $MajorList[$i] & @CRLF & "➡️Вышел из сети!"
							$a = " "

						EndIf

					EndIf	;Отправляем сообщение в телеграм
					if ($WR = 1) And ($a <> -1) Then ConsoleWrite(BotMsg($sTG))

				Endif

			EndIf

		Next

	Next

EndFunc

Func BotMsg($_TXT)									;Отправитель сообщений боту в телеграм

	local $DATA = "chat_id=" & $nChatId & "&text=" & $_TXT
	$WinHttpReq.send($DATA)
	$ret = $WinHttpReq.ResponseText

Return $ret
EndFunc

Func _URIEncode($sData)								;Генератор сообщений для телеграм бота (не используется)

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