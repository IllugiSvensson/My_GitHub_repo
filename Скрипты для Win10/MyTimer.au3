#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ProgressConstants.au3>
#include <Array.au3>
#include <File.au3>
#include <Date.au3>



Global $path = "D:\Programms\MyTimer\"
Global $BckG = "D:\Programms\MyTimer\characters\"
Global $Spch = "D:\Programms\MyTimer\speeches\"
;Данные для телеграмм бота
Global $sBotKey = 'bot1844208783:AAHnDQhkV7kARiLCyus0vxV8jQdAYy4TZcY'	;Ваш api ключ
Global $nChatId = -1001358462989                                      	;Id получателя
;Старт программы
$msg = MsgBox(35, "Таймер Задач", "Начнем работу?")
Switch $msg

	Case 2			;Если отмена, выходим
		Exit 0

	Case 7			;Если нет, продолжаем работу
		Global $startTime = FileRead($path & "\time.txt")

	Case 6			;Если да, начинаем сначала
		$f = FileOpen($path & "\time.txt", 2)
		FileWrite($f, _NowCalc())
		FileClose($f)
		Global $startTime = _NowCalc()

EndSwitch



Global $remain = 500
Global $strt = _DateDiff("n", $startTime, _NowCalc())
GUI(0, "Подготовка", 5, $Spch & "1.mp3")							;Рабочие окна
GUI(5, "Работа I", 52, $Spch & "2.mp3")
GUI(57, "Перерыв I", 3, $Spch & "3.mp3")
GUI(60, "Работа II", 53, $Spch & "4.mp3")
GUI(113, "Разминка I", 7, $Spch & "5.mp3")
GUI(120, "Работа III", 58, $Spch & "6.mp3")
GUI(178, "Перерыв II", 3, $Spch & "7.mp3")
GUI(181, "Работа IV", 59, $Spch & "8.mp3")
GUI(240, "Обед", 20, $Spch & "9.mp3")
GUI(260, "Работа V", 58, $Spch & "10.mp3")
GUI(318, "Перерыв III", 3, $Spch & "11.mp3")
GUI(321, "Работа VI", 59, $Spch & "12.mp3")
GUI(380, "Разминка II", 15, $Spch & "13.mp3")
GUI(395, "Работа VII", 48, $Spch & "14.mp3")
GUI(443, "Перерыв IV", 3, $Spch & "15.mp3")
GUI(446, "Работа VIII", 49, $Spch & "16.mp3")
GUI(495, "Завершение", 5, $Spch & "17.mp3")
GUI(500, "Переработка", 120, $Spch & "18.mp3")





Func GUI($rem, $work, $lt, $wav)								;Отрисовываем окно текущей работы

	If $strt < $lt Then

		$con = $strt
		$strt = 0
		$xpos = 20
		$ypos = 480
		$MainWindow = GUICreate("Таймер Задач", 405, 720, 2048, 235, $WS_DLGFRAME)		;Создаем окно и фон
		$piccount = DirGetSize($BckG, 1)
		GUICtrlCreatePic($BckG & Random(1, $piccount[1], 1) & ".jpg", 0, 0, 405, 700)

		$time = GUICtrlCreateLabel(_NowTime(), $xpos, $ypos, 350, 55)					;Добавляем часы и обратный отсчет
		GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
		GUICtrlSetFont(-1, 26, 1000)
		$com = GUICtrlCreateProgress($xpos, $ypos + 40, 365, 30, $PBS_SMOOTH)			;Общий прогресс

		GUICtrlCreateLabel($work, $xpos, $ypos + 70, 350, 55)							;Создаем отсчет времени
		GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
		GUICtrlSetFont(-1, 32, 1000)
		$loctime = GUICtrlCreateLabel("0 из " & $lt & " минут", $xpos, $ypos + 145, 350, 55, $SS_LEFT)
		GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
		GUICtrlSetFont(-1, 26, 1000)
		$loc = GUICtrlCreateProgress($xpos, $ypos + 115, 365, 30, $PBS_SMOOTH)			;Текущий прогресс
		GUISetState(@SW_SHOW)

			SoundPlay($wav)
			BotMsg("✅➡️" & $work, $sBotKey, $nChatId)
			$goTime = _NowCalc()														;Время текущего окна
			While true

				$stm = _DateDiff("n", $startTime, _NowCalc())							;Расчет общего времени
				$gtm = _DateDiff("n", $goTime, _NowCalc())								;Расчет текущего времени
				GUICtrlSetData($com, (100 / $remain) * $stm)
				GUICtrlSetData($time, _NowTime() & "   " & abs($remain - $gtm - $rem - $con))
				GUICtrlSetData($loc, (100 / $lt) * $gtm + $con * (100 / $lt))
				GUICtrlSetData($loctime, $gtm + $con & " из " & $lt & " минут")

				If $gtm + $con >= $lt Then					;Условие выхода из цикла

					ExitLoop

				Endif

				sleep(800)

			WEnd

		GUIDelete($MainWindow)

	Else

		$strt = $strt - $lt

	EndIf

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

Func BotMsg($_TXT, $BotKey, $ChatId)				;Отправитель сообщений боту в телеграм

	$sText = _URIEncode($_TXT)		; Текст сообщения, не больше 4000 знаков
	ConsoleWrite(InetRead('https://api.telegram.org/' & $BotKey & '/sendMessage?chat_id=' & $ChatId & '&text=' & $sText, 0))

EndFunc