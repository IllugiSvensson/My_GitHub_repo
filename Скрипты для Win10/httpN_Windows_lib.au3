;Библиотека функций и настроек
#include <Array.au3>
#include <File.au3>
#include <Date.au3>
#include <Constants.au3>
#include <WindowsConstants.au3>
#include <GuiComboBox.au3>
#include <GuiListBox.au3>
#include <GUIConstants.au3>
#include <Encoding.au3>



AutoItSetOption("MustDeclareVars", 1)
;Данные для телеграмм бота
Global $sBotKey = 'bot1844208783:AAHnDQhkV7kARiLCyus0vxV8jQdAYy4TZcY'	;api ключ
Global $nChatId = -1001460258261                                      	;Id группы



Func EntryWindow($type, $logout)						;Функция отрисовки окошка для записей

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

	ElseIf $type = 3 Then	;Для сообщений пользователям

		Local $title = "Сообщение пользователям"
		Local $inputText = "Введите ваше сообщение"
		Local $labelText1 = "Введите @username и текст сообщения для отправки"
		Local $labelText2 = "Метки: @ALL, @username"
		Local $btnOkText = "Отправить"

	ElseIf $type = 4 Then	;Для сообщений об изменениях

		Local $title = "Отчет"
		Local $inputText = "Изменения"
		Local $labelText1 = "Введите текст сообщения об изменениях в схеме и работе программ"
		Local $labelText2 = "Отправка всем пользователям"
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
						If $logout = 1 Then

							Exit

						Else

							ExitLoop

						EndIf

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

Func ChangesM()											;Функция прочитывания сообщений

	If FileExists(@ScriptDir & "\system\temp\Changes\" & $name[0]) = 1 Then	;Оповещаем пользователя

		;Ищем файлик-метку. Выводим содержимое и удаляем файлик
		Local $changes = FileRead(@ScriptDir & "\system\temp\Changes\" & $name[0])
		MsgBox(64 + 262144, "Информация", $changes, 30)
		FileDelete(@ScriptDir & "\system\temp\Changes\" & $name[0])

	EndIf

EndFunc

Func Validator($textstring, $pat)						;Функция проверки строки по шаблону

	$textstring = StringRegExp($textstring, $pat, 2)
	If IsArray($textstring) = 1 Then

		Return 1	;Строка прошла шаблон

	EndIf

Return 0
EndFunc

Func TrackExeFile($EXE, $exeFile, $CONFIG, $typ)		;Функция запуска и слежения за приложением

	If (Ping($address)) = 0 Then		;Проверяем сеть. Если не пингуется хост или шлюз

		AchievmentTracker($name[0], 8)
		BotMsg("👤" & $name[0] & @CRLF & "⚠️Неудачное подключение" & @CRLF & "🖥️" & $hostName[0] & " 🕹" & $EXE & " ⏱" & _Now(), 1)
		Logger($name[0], $username, "Хост или шлюз не отвечает", $hostName[0] & ":" & $EXE, 1)
		MsgBox(16, "Ошибка", "Не удается подключиться к хосту" & @CRLF & "Обратитесь в Отдел Тестирования", 3)

	Else								;Если пингуется, запускаем приложение

		AchievmentTracker($name[0], 1)
		AchievmentTracker($name[0], 2)
		AchievmentTracker($name[0], $typ)
		Local $PID = Run($exeFile & $CONFIG)			;Запускаем приложение и фиксируем его PID
		BotMsg("👤" & $name[0] & @CRLF & "✅Подключился к хосту" & @CRLF & "🖥️" & $hostName[0] & " 🕹" & $EXE & " ⏱" & _Now(), 1)
		Logger($name[0], $username, "Успешное подключение", $hostName[0] & ":" & $EXE, 1)
		;Запускаем сессию приложения
		Local $t = 0
		While True

			Sleep(1000)							;Отсчитываем условную секунду
			$t += 1
			;Условия окончания сессии
			If ProcessExists($PID) = 0	Then	;Если завершили процесс вручную

				BotMsg("👤" & $name[0] & @CRLF & "⬅️Отключился от хоста" & @CRLF & "🖥️" & $hostName[0] & " 🕹" & $EXE & " ⏱" & _Now(), 1)
				Logger($name[0], $username, "Завершение работы", $hostName[0] & ":" & $EXE, 1)
				ExitLoop

			ElseIf FileExists(@ScriptDir & "\system\temp\Sessions\UPDATE") = 1 Then ;Если начали обновление

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

			ElseIf $t = 18000 Then

				AchievmentTracker($name[0], 6)

			EndIf

			;Функции, действующие во время сессии
			If FileExists(@ScriptDir & "\system\temp\Sessions\ONLINE") = 1 Then		;Говорим что онлайн

				;Создаем файлик-метку, обрабатываем его другой прогой, которая его удалит
				FileWrite(@ScriptDir & "\system\temp\PIDS\" & $name[0] & "." & $hostName[0] & "." & Round($t/60), "")

			EndIf
			ChangesM()

		WEnd

	EndIf

EndFunc

Func ShowSplash($jpg, $user, $type)						;Функция демонстрации ачива

	$Array_achiev[$type] += 1
	Local $time = 0
	$File_achiev = FileOpen($path_to_users & $user, 2)	;Файл под запись новых данных
	_FileWriteFromArray($File_achiev, $Array_achiev, 1, 9)
	FileClose($File_achiev)
	SoundPlay($path_to_resources & "AchievmentEarned.wav", 0)
	Local $mainwindow = GUICreate("", 592, 98, 700, 600, $WS_POPUP, $WS_EX_TOPMOST)
	GUICtrlCreatePic($path_to_resources & $jpg, 0, 0, 592, 98, -1, $GUI_WS_EX_PARENTDRAG)
	GUISetState()
	While $time <> 4000

		Sleep(50)
		$time = $time + 50

	WEnd
	GUIDelete($mainwindow)

EndFunc

Func AchievmentTracker($user, $type)					;Функция обработки достижений

	Global $path_to_users = @ScriptDir & "\system\temp\Achievments\"
	Global $path_to_resources = @ScriptDir & "\system\temp\Achievments\Resources\"
	Global $Array_achiev, $File_achiev
	_FileReadToArray($path_to_users & $user, $Array_achiev)	;Массив с данными
		Switch $type

			Case "1"	;row1 - Регистрация/первое подключение 0-1
				If $Array_achiev[1] == 0 Then

					ShowSplash("1.jpg", $user, $type)

				EndIf

			Case "2"	;row2 - Подключения подряд 5 дней 0-4
				If StringLeft($Array_achiev[2], 1) == 4 Then

					ShowSplash("2.jpg", $user, $type)

				ElseIf StringLeft($Array_achiev[2], 1) < 5 Then

					If _DateDiff('D', StringTrimLeft($Array_achiev[2], 2), _NowCalc()) == 1 Then

						$Array_achiev[2] = (StringLeft($Array_achiev[2], 1) + 1) & " " & _NowCalc()
						_FileWriteFromArray($path_to_users & $user, $Array_achiev, 1, 9)

					ElseIf _DateDiff('D', StringTrimLeft($Array_achiev[2], 2), _NowCalc()) > 1 Then

						$Array_achiev[2] = "1 " & _NowCalc()
						_FileWriteFromArray($path_to_users & $user, $Array_achiev, 1, 9)

					EndIf

				EndIf

			Case "3"	;row3 - Подключения по внс 0-999

				If $Array_achiev[3] == 0 Then

					ShowSplash("3.jpg", $user, $type)

				ElseIf $Array_achiev[3] == 99 Then

					ShowSplash("4.jpg", $user, $type)

				ElseIf $Array_achiev[3] == 999 Then

					ShowSplash("5.jpg", $user, $type)

				ElseIf $Array_achiev[3] <= 1000 Then

					$Array_achiev[3] += 1
					_FileWriteFromArray($path_to_users & $user, $Array_achiev, 1, 9)

				EndIf

			Case "4"	;row4 - Подключения по консоли 0-999

				If $Array_achiev[4] == 0 Then

					ShowSplash("6.jpg", $user, $type)

				ElseIf $Array_achiev[4] == 99 Then

					ShowSplash("7.jpg", $user, $type)

				ElseIf $Array_achiev[4] == 999 Then

					ShowSplash("8.jpg", $user, $type)

				ElseIf $Array_achiev[4] <= 1000 Then

					$Array_achiev[4] += 1
					_FileWriteFromArray($path_to_users & $user, $Array_achiev, 1, 9)

				EndIf

			Case "5"	;row5 - Подключения по фтп 0-999
				If $Array_achiev[5] == 0 Then

					ShowSplash("9.jpg", $user, $type)

				ElseIf $Array_achiev[5] == 99 Then

					ShowSplash("10.jpg", $user, $type)

				ElseIf $Array_achiev[5] == 999 Then

					ShowSplash("11.jpg", $user, $type)

				ElseIf $Array_achiev[5] <= 1000 Then

					$Array_achiev[5] += 1
					_FileWriteFromArray($path_to_users & $user, $Array_achiev, 1, 9)

				EndIf

			Case "6"	;row6 - Полная сессия 0-1
				If $Array_achiev[6] == 0 Then

					ShowSplash("12.jpg", $user, $type)

				EndIf

			Case "7"	;row7 - Количество сообщений 0-9

				If $Array_achiev[7] == 0 Then

					ShowSplash("13.jpg", $user, $type)

				ElseIf $Array_achiev[7] == 9 Then

					ShowSplash("14.jpg", $user, $type)

				ElseIf $Array_achiev[7] <= 10 Then

					$Array_achiev[7] += 1
					_FileWriteFromArray($path_to_users & $user, $Array_achiev, 1, 9)

				EndIf

			Case "8"	;row8 - Неудачное подключение 0-1
				If $Array_achiev[8] == 0 Then

					ShowSplash("15.jpg", $user, $type)

				EndIf
			Case "9"	;row9 - Подключиться к запретному компу 0-1
				If $Array_achiev[9] == 0 Then

					ShowSplash("16.jpg", $user, $type)

				EndIf
			Case "show"	;Демонстрация полученных ачивов
				Global $achievments[1]
				Global $cnt = 0
				Global $cur = 0
				For $i = 0 To 8

					If ($i == 0) And ($Array_achiev[$i + 1] >= 1) Then

						$achievments[0] = 1
						$cnt = $cnt + 10

					ElseIf ($i == 1) And (StringLeft($Array_achiev[$i + 1], 1) >= 4) Then

						_ArrayAdd($achievments, 2)
						$cnt = $cnt + 50

					ElseIf ($i == 2) Then

						If $Array_achiev[$i + 1] >= 999 Then

							_ArrayAdd($achievments, 3)
							_ArrayAdd($achievments, 4)
							_ArrayAdd($achievments, 5)
							$cnt = $cnt + 85

						ElseIf $Array_achiev[$i + 1] >= 99 Then

							_ArrayAdd($achievments, 3)
							_ArrayAdd($achievments, 4)
							$cnt = $cnt + 35

						ElseIf $Array_achiev[$i + 1] >= 1 Then

							_ArrayAdd($achievments, 3)
							$cnt = $cnt + 10

						EndIf

					ElseIf ($i == 3) Then

						If $Array_achiev[$i + 1] >= 999 Then

							_ArrayAdd($achievments, 6)
							_ArrayAdd($achievments, 7)
							_ArrayAdd($achievments, 8)
							$cnt = $cnt + 85

						ElseIf $Array_achiev[$i + 1] >= 99 Then

							_ArrayAdd($achievments, 6)
							_ArrayAdd($achievments, 7)
							$cnt = $cnt + 35

						ElseIf $Array_achiev[$i + 1] >= 1 Then

							_ArrayAdd($achievments, 6)
							$cnt = $cnt + 10

						EndIf

					ElseIf ($i == 4) Then

						If $Array_achiev[$i + 1] >= 999 Then

							_ArrayAdd($achievments, 9)
							_ArrayAdd($achievments, 10)
							_ArrayAdd($achievments, 11)
							$cnt = $cnt + 85

						ElseIf $Array_achiev[$i + 1] >= 99 Then

							_ArrayAdd($achievments, 9)
							_ArrayAdd($achievments, 10)
							$cnt = $cnt + 35

						ElseIf $Array_achiev[$i + 1] >= 1 Then

							_ArrayAdd($achievments, 9)
							$cnt = $cnt + 10

						EndIf

					ElseIf ($i == 5) And ($Array_achiev[$i + 1] >= 1) Then

						_ArrayAdd($achievments, 12)
						$cnt = $cnt + 10

					ElseIf ($i == 6) Then

						If $Array_achiev[$i + 1] >= 9 Then

							_ArrayAdd($achievments, 13)
							_ArrayAdd($achievments, 14)
							$cnt = $cnt + 60

						ElseIf $Array_achiev[$i + 1] >= 1 Then

							_ArrayAdd($achievments, 13)
							$cnt = $cnt + 10

						EndIf

					ElseIf ($i == 7) And ($Array_achiev[$i + 1] >= 1) Then

						_ArrayAdd($achievments, 15)
						$cnt = $cnt + 10

					ElseIf ($i == 8) And ($Array_achiev[$i + 1] >= 1) Then

						_ArrayAdd($achievments, 16)
						$cnt = $cnt + 10

					EndIf

				Next

				_ArrayAdd($achievments, "end")
				Local $mainwindow = GUICreate("", 937, 378, 700, 600, $WS_POPUP, $WS_EX_TOPMOST)
				GUICtrlCreatePic($path_to_resources & "interface\background.jpg", 0, 0, 937, 378)
				GUICtrlSetState(-1, $GUI_DISABLE)

				Global $cur_Achiev = GUICtrlCreatePic($path_to_resources & "1.jpg", 294, 105, 592, 98, -1, $GUI_WS_EX_PARENTDRAG)

				Local $cnt_label = GUICtrlCreateLabel($cnt, 485, 46, -1, 15)
				GUICtrlSetFont($cnt_label, 11, 550, -1, "Friz Quadrate TT")
				GUICtrlSetColor($cnt_label, "0xffffff")
				GUICtrlSetBkColor($cnt_label, $GUI_BKCOLOR_TRANSPARENT)

				Local $p_bar = GUICtrlCreateProgress(292, 234, 595, 20)
				DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle($p_bar), "wstr", 0, "wstr", 0)
				GUICtrlSetData($p_bar, (UBound($achievments) - 1) * 6.25)
				GUICtrlSetColor($p_bar, "0x035d03")
				GUICtrlSetBkColor($p_bar, "0x2c200a")

				Local $p_label = GUICtrlCreateLabel((UBound($achievments) - 1) & "/16", 840, 235, 40, 20)
				GUICtrlSetFont($p_label, 11, 550, -1, "Friz Quadrate TT")
				GUICtrlSetColor($p_label, "0xffffff")
				GUICtrlSetBkColor($p_label, $GUI_BKCOLOR_TRANSPARENT)

				Local $exit_button = GUICtrlCreateButton("", 912, 52, 23, 22, $BS_BITMAP)
				GUICtrlSetImage($exit_button, $path_to_resources & "interface\exit.bmp")

				Global $next_button = GUICtrlCreateButton("", 704, 87, 15, 16, $BS_BITMAP + $BS_FLAT)
				GUICtrlSetImage($next_button, $path_to_resources & "interface\next.bmp")

				Global $prev_button = GUICtrlCreateButton("", 461, 87, 15, 16, $BS_BITMAP + $BS_FLAT)
				GUICtrlSetImage($prev_button, $path_to_resources & "interface\prev.bmp")
				GUICtrlSetState($prev_button, $GUI_DISABLE)

				GUISetState()
				Opt("GUIOnEventMode", 1)

				GUICtrlSetOnEvent($exit_button, "exit_pressed")
				GUICtrlSetOnEvent($next_button, "next_pressed")
				GUICtrlSetOnEvent($prev_button, "prev_pressed")
				While True

					sleep(10)

				WEnd

		EndSwitch

EndFunc

Func exit_pressed()

	Exit

EndFunc

Func next_pressed()

	If $cur <> UBound($achievments) - 1 Then

		$cur = $cur + 1
		GUICtrlSetImage($cur_Achiev, $path_to_resources & $achievments[$cur] & ".jpg")
		GUICtrlSetState($prev_button, $GUI_ENABLE)

	EndIf
	If $cur == UBound($achievments) - 2 Then

		GUICtrlSetState($next_button, $GUI_DISABLE)

	EndIf

EndFunc

Func prev_pressed ()

	If $cur <> 0 Then

		$cur = $cur - 1
		GUICtrlSetImage($cur_Achiev, $path_to_resources & $achievments[$cur] & ".jpg")
		GUICtrlSetState($next_button, $GUI_ENABLE)

	EndIf
	If $cur == 0 Then

		GUICtrlSetState($prev_button, $GUI_DISABLE)

	EndIf

EndFunc