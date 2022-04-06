;Библиотека функций и настроек
#include <Array.au3>
#include <File.au3>
#include <Date.au3>
#include <Constants.au3>
#include <WindowsConstants.au3>
#include <GUIConstants.au3>



AutoItSetOption("MustDeclareVars", 1)
#RequireAdmin				;Убрать, когда будет проброс портов
;Данные для телеграмм бота
Global $sBotKey = 'bot1844208783:AAHnDQhkV7kARiLCyus0vxV8jQdAYy4TZcY'	;api ключ
Global $nChatId = -1001460258261                                      	;Id группы



Func EntryWindow($type)									;Функция отрисовки окошка для записей

	If $type = 1 Then		;Для запуска вручную

		Local $title = "httpn запуск"
		Local $inputText = "Введите хостнейм"
		Local $labelText1 = "Введите приложение VNC, KIT или SCP и хостнейм компьютера для подключения вручную"
		Local $labelText2 = "Пример: VNC default"
		Local $btnOkText = "Запуск"

	ElseIf $type = 2 Then	;Для обратной связи

		Local $title = "Обратная связь"
		Local $inputText = "Введите ваше сообщение"
		Local $labelText1 = "Все вопросы и предложения можете написать разработчику в этой форме"
		Local $labelText2 = "Разработчик: Смирнов А.Д. ОТ"
		Local $btnOkText = "Отправить"

	EndIf

		Local $text = ""	;Создаем окно с полями и кнопками
		Local $GUI = GUICreate($title, 256, 200, -1, -1, $WS_DLGFRAME)
		Local $Label1 = GUICtrlCreateLabel($labelText1, 5, 7, 246, 62, $WS_BORDER, $WS_EX_DLGMODALFRAME)
		GUICtrlSetFont($Label1, 12)
		Local $Label2 = GUICtrlCreateLabel($labelText2, 13, 75, 246, 30)
		GUICtrlSetFont($Label2, 12)
		Local $Input = GUICtrlCreateInput($inputText, 5, 95, 246, 30)
		GUICtrlSetFont($Input, 14)
		Local $BtnOk = GUICtrlCreateButton($btnOkText, 18, 130, 110, 40)
		GUICtrlSetFont($BtnOk, 16)
		Local $BtnNo = GUICtrlCreateButton("Отмена", 128, 130, 110, 40)
		GUICtrlSetFont($BtnNo, 16)
		GUISetState()
			While True		;Следим за нажатием кнопок

				Switch GUIGetMsg()

					Case $BtnOk
						$text = GUICtrlRead($Input)
						ExitLoop

					Case $BtnNo
						Exit

				EndSwitch

			WEnd
		GUIDelete($GUI)

Return $text
EndFunc

Func _URIEncode($sData)									;Конвертер текста для телеграм бота

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
                $sData &= "%" & Hex($nChar, 2)

        EndSwitch

    Next

Return $sData
EndFunc

Func BotMsg($_TXT, $sNotif)								;Отправитель сообщений боту

	Local $sText = _URIEncode($_TXT)					;Текст сообщения, не больше 4000 знаков
	ConsoleWrite(InetRead('https://api.telegram.org/' & $sBotKey & '/sendMessage?chat_id=' & $nChatId & '&parse_mode=html&disable_notification=' & $sNotif & '&text=' & $sText, 0))

EndFunc

Func Logger($USER, $ADDRES, $ACT, $HOST, $TYPE)			;Функция логирования действий пользователя

	If $TYPE = 1 Then		;Запись лога запусков приложений

		Local $tmpPath = @ScriptDir & "\system\log\log.txt"	;Путь до лога
		Local $TIME = StringFormat("%-19s", _Now())			;Форматируем вывод под стандарт
		$ADDRES = StringFormat("%-18s", $ADDRES)
		$HOST = StringFormat("%-20s", $HOST)
		$USER = StringFormat("%-35s", $USER)
		$ACT = StringFormat("%-18s", $ACT)
		FileWriteLine($tmpPath, $TIME & " | " & $ADDRES & " | " & $HOST & " | " & $USER & " | " & $ACT)

	ElseIf $TYPE = 2 Then	;Запись системного лога

		FileWriteLine(@ScriptDir & "\system\log\system.txt", StringFormat("%-19s", _Now()) & " | " & $USER)

	EndIf

EndFunc

Func FileReader($pathToFile, $sSearchText)				;Функция поиска строки в файле

	Local $sText = FileRead($pathToFile) 					;Читаем список
	Local $aLines = StringSplit($sText, @CRLF, 1)			;Делаем массив строк
		For $i = 1 To $aLines[0] Step +1					;Перебираем строки

			If StringInStr($aLines[$i], $sSearchText) Then	;Если есть совпадение, выдаем строку

				Local $auth = StringRegExp($aLines[$i], "\w+[-]{0,1}\w{0,}", 2)
				If StringCompare($auth[0], $sSearchText) <> 0 Then ContinueLoop
				Return $aLines[$i]

			EndIf

		Next

EndFunc

Func Validator($textstring, $pat)						;Функция проверки строки по шаблону

	$textstring = StringRegExp($textstring, $pat, 2)
	If IsArray($textstring) <> 1 Then

		Return 1

	EndIf

EndFunc

Func AddrToMask($MSKADDR)								;Функция преобразования адреса в маску

	Switch "1"	;REGEX возвращает массив либо двоичное значение. Сравниваем с единицей для удобства

		Case StringRegExp($MSKADDR, "((\d{1,3}\.){1}0.0.0)", 0) ;Проверяем последние актеты на 0
			Return "255.0.0.0"							 	 	;Возвращаем маску

		Case StringRegExp($MSKADDR, "((\d{1,3}\.){2}0.0)", 0)
			Return "255.255.0.0"

		Case StringRegExp($MSKADDR, "((\d{1,3}\.){3}0)", 0)
			Return "255.255.255.0"

		Case Else
			Return "255.255.255.255"

	EndSwitch

EndFunc

Func ConsolePing($ADD)									;Функция пинга

	Sleep(1500)			;Без паузы почему то нормально не пингуется
	Return Ping($ADD)

EndFunc

Func RouteAddDel($ROUTE, $fl)							;Функция создания маршрута

	if $fl = 1 Then

		Run(@ComSpec & " /c " & $ROUTE, '', @SW_HIDE)

	EndIf

EndFunc

Func TrackExeFile($EXE, $exeFile, $CONFIG, $RES, $flg)	;Функция запуска и слежения за приложением

	RouteAddDel("route add " & $maskAddr & " mask " & $gatemask & " " & $gateway, $flg)	;Строим маршрут если он есть
	If (ConsolePing($address)) = 0 Then	;Проверяем сеть. Если не пингуется

		BotMsg("👤" & $name[0] & @CRLF & "⚠️Неудачное подключение" & @CRLF & "🖥️" & $hostName[0] & " 🕹" & $EXE & " ⏱" & _Now(), 1)
		Logger($name[0], $username, "Хост не отвечает", $hostName[0] & ":" & $EXE, 1)
		MsgBox(16, "Ошибка", "Не удается подключиться к хосту" & @CRLF & "Обратитесь в Отдел Тестирования", 3)

	Else								;Если пингуется, запускаем приложение

		Local $PID = Run($exeFile & $CONFIG & $hostName[0] & $RES)						;Запускаем приложение и фиксируем его PID
		BotMsg("👤" & $name[0] & @CRLF & "✅Подключился к хосту" & @CRLF & "🖥️" & $hostName[0] & " 🕹" & $EXE & " ⏱" & _Now(), 1)
		Logger($name[0], $username, "Успешное подключение", $hostName[0] & ":" & $EXE, 1)
		;Запускаем сессию приложения
		Local $t = 0
		While True

			Sleep(1000)					;Отсчитываем условную секунду
			$t += 1
			;Условия окончания сессии
			If ProcessExists($PID) = 0	Then	;Если завершили процесс вручную

				BotMsg("👤" & $name[0] & @CRLF & "⬅️Отключился от хоста" & @CRLF & "🖥️" & $hostName[0] & " 🕹" & $EXE & " ⏱" & _Now(), 1)
				Logger($name[0], $username, "Завершение работы", $hostName[0] & ":" & $EXE, 1)
				ExitLoop

			ElseIf FileExists(@ScriptDir & "\system\temp\Sessions\UPDATE") = 1 Then 	;Если начали обновление

				MsgBox(48, "Предупреждение", "Обновление системы. Сохраните работу" & @CRLF & "Приложение закроется через минуту", 5)
				Local $j = 0
				While $j <> 55

					sleep(1000)
					$j += 1
					If ProcessExists($PID) = 0 Then ExitLoop
					If FileExists(@ScriptDir & "\system\temp\Sessions\KILL") = 1 Then ExitLoop

				WEnd
				ProcessClose($PID)
				ExitLoop

			ElseIf $t = 30000 Then				;Если дождались таймаута

				ProcessClose($PID)
				BotMsg("👤" & $name[0] & @CRLF & "⬅️Сессия завершена" & @CRLF & "🖥️" & $hostName[0] & " 🕹" & $EXE & " ⏱" & _Now(), 1)
				Logger($name[0], $username, "Сессия завершена", $hostName[0] & ":" & $EXE, 1)
				MsgBox(48, "Предупреждение", "Сессия " & $hostName[0] & ": " & $EXE & @CRLF & "завершена по таймауту", 3)
				ExitLoop

			EndIf

			;Функции, действующие во время сессии
			if FileExists(@ScriptDir & "\system\temp\Sessions\ONLINE") = 1 Then			;Говорим что онлайн

				;Создаем файлик-метку, обрабатываем его другой прогой, которая его удалит
				FileWrite(@ScriptDir & "\system\temp\PIDS\" & $name[0] & "." & $hostName[0] & "." & Round($t/60), "")

			Endif

		WEnd

	EndIf

	;Когда закончили работу или не смогли подключиться, нужно удалить маршрут за собой
	If UBound(ProcessList("httpN_Windows.exe")) = 2 Then	;Если файл один (наш файл)

		RouteAddDel("route delete " & $maskAddr, $flg)		;Удаляем построенный маршрут после окончания работы

	EndIf

EndFunc

Func ListDivider()										;Функция создания строки разделителя

	Local $a = "-"
	For $i = 0 To 61 Step 1

		$a &= "-"				;Создаем строку разделитель

	Next

Return $a
EndFunc

Func GetMac($_MACsIP)									;Функция получения MAC по айпи(взял из гугла)

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