#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ProgressConstants.au3>
#include <Date.au3>



If MsgBox(36, "Хамон Тренер", "Начнем тренировку?") = 7 Then		;Старт программы

	Exit 0

Endif



Global $remain = 93
Global $startTime = _NowCalc()						;ВременнЫе переменные
$path = "D:\Utilities\HamonTrainer\resources"		;Путь до файлов
GUI($path & "\1.jpg", 0, 620, 450, "Разминка", 15, $path & "\1.mp3", 0xD0ECE7)		;Тренировочные окна
GUI($path & "\2.jpg", 15, 10, 380, "Основная", 30, $path & "\2.mp3", 0x5DADE2)
GUI($path & "\3.jpg", 45, 10, 450, "Подготовка", 1, $path & "\3.mp3", 0xEBDEF0)
GUI($path & "\4.jpg", 46, 10, 350, "Функционал", 10, $path & "\4.mp3", 0xD5F5E3)
GUI($path & "\5.jpg", 56, 620, 450, "Перерыв", 3, $path & "\5.mp3", 0xE8DAEF)
GUI($path & "\6.jpg", 59, 20, 425, "Силовая", 20, $path & "\6.mp3", 0xAF7AC5)
GUI($path & "\7.jpg", 79, 620, 450, "Подготовка", 1, $path & "\7.mp3", 0xD6EAF8)
GUI($path & "\8.jpg", 80, 610, 460, "Повторение", 10, $path & "\8.mp3", 0x85C1E9)
GUI($path & "\9.jpg", 90, 20, 460, "Завершение", 3, $path & "\9.mp3", 0xFBFCFC)
SoundPlay($path & "\10.mp3")
MsgBox(64, "Хамон Тренер", "Красавчик!", 20)





Func GUI($pic, $rem, $xpos, $ypos, $work, $lt, $wav, $col)							;Отрисовываем окно текущей тренировки

	$MainWindow = GUICreate("Хамон Тренер", 1280, 720, -1, -1, $WS_DLGFRAME)		;Создаем окно и фон
	GUICtrlCreatePic($pic, 0, 0, 1280, 720)

	$time = GUICtrlCreateLabel(_NowTime() & "   " & $rem, $xpos, $ypos, 350, 55)	;Добавляем часы и обратный отсчет
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetFont(-1, 42, 1000)
	GUICtrlSetColor(-1, $col)
	$com = GUICtrlCreateProgress($xpos, $ypos + 65, 620, 35, $PBS_SMOOTH)			;Общий прогресс
	
	GUICtrlCreateLabel($work, $xpos, $ypos + 110, 350, 55)							;Создаем отсчет времени
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetFont(-1, 42, 1000)
	GUICtrlSetColor(-1, $col)
	$loctime = GUICtrlCreateLabel("0 из " & $lt, $xpos + 400, $ypos + 110, 350, 55, $SS_LEFT)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetFont(-1, 42, 1000)
	GUICtrlSetColor(-1, $col)
	$loc = GUICtrlCreateProgress($xpos, $ypos + 170, 620, 35, $PBS_SMOOTH)			;Текущий прогресс
	GUISetState(@SW_SHOW)

		SoundPlay($wav)
		$goTime = _NowCalc()														;Время текущего окна
		While true

			$stm = _DateDiff("n", $startTime, _NowCalc())							;Расчет общего времени
			$gtm = _DateDiff("n", $goTime, _NowCalc())								;Расчет текущего времени
			GUICtrlSetData($com, (100 / $remain) * $stm + ($rem / 100))
			GUICtrlSetData($time, _NowTime() & "   " & ($remain - $gtm - $rem))
			GUICtrlSetData($loc, (100 / $lt) * $gtm)
			GUICtrlSetData($loctime, $gtm & " из " & $lt)

			If $gtm >= $lt Then					;Условие выхода из цикла

				ExitLoop

			Endif

			sleep(800)

		WEnd

	GUIDelete($MainWindow)

EndFunc