#include <ProgressConstants.au3>
#include <ProgressConstants.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstants.au3>
#include <GuiComboBox.au3>
#include <Array.au3>
#include <File.au3>
#include <Date.au3>


;НАСТРОЙКИ ПРОГРАММЫ
AutoItSetOption("MustDeclareVars", 1)
Opt("TrayMenuMode", 1 + 2)


;ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ И КОНСТАНТЫ
Const $path_to_script = @ScriptDir
Const $path_to_profiles = $path_to_script & "\Profiles"
Global $profile_path = $path_to_profiles
Global $path_to_background = @ScriptDir & "\background"
Global $path_to_sound = @ScriptDir & "\sound"
Global $past = 0, $file
Global $name = "Таймер"
Global $duration = 60
Global $secundomer = 0, $secStart


;СТАРТ ОКНО И ВЫХОД К ДРУГИМ ОКНАМ
Local $start_window = GUICreate("Таймер Задач", 500, 750, -1, -1, $WS_DLGFRAME, $WS_EX_TOPMOST)
	GUICtrlCreatePic($path_to_script & "\Start.jpg", 0, 0, 500, 750)
	GUICtrlSetState(-1, $GUI_DISABLE)
	Local $start_window_label = GUICtrlCreateLabel("Начнем работу?", 75, 215, 350, 50, $SS_CENTER)
		GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
		GUICtrlSetFont(-1, 25, 1000)
	Local $time_label = GUICtrlCreateLabel(_NowTime(), 162, 255, 175, 30, $SS_CENTER)
		GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
		GUICtrlSetFont(-1, 20, 1000)	
	Local $start_button = GUICtrlCreateButton("Начнем", 162, 290, 175, 40)
		GUICtrlSetFont(-1, 20, 1000)
	Local $continue_button = GUICtrlCreateButton("Продолжить", 162, 330, 175, 40)
		GUICtrlSetFont(-1, 20, 1000)
	Local $settings_button = GUICtrlCreateButton("Настройки", 162, 370, 175, 40)
		GUICtrlSetFont(-1, 20, 1000)
	Local $info_button = GUICtrlCreateButton("Справка", 162, 410, 175, 40)
		GUICtrlSetFont(-1, 20, 1000)
	Local $exit_button = GUICtrlCreateButton("Выход", 162, 450, 175, 40)
		GUICtrlSetFont(-1, 20, 1000)
	Global $profile_combo = GUICtrlCreateCombo("", 162, 680, 175, 50, $CBS_DROPDOWNLIST + $WS_VSCROLL)
		GUICtrlSetFont(-1, 20, 1000)
		Dim $Array
		If FileExists($path_to_script & "\_profiles") == 0 Then

			FileWrite($path_to_script & "\_profiles", "default")
			ProfileCreate($path_to_profiles & "\default")

		EndIf
		_FileReadToArray($path_to_script & "\_profiles", $Array)
		For $i = 1 To $Array[0]

			GUICtrlSetData($profile_combo, $Array[$i], $Array[1])

		Next

GUISetState()
	If FileExists($path_to_script & "\command") == 0 Then
		FileWrite($path_to_script & "\command", 'date":1685611930,"text":"Profile:Work')
	EndIf
Local $c = 0, $msg = GUIGetMsg(), $cc = 0
Global $tele_bot_key = StringTrimLeft(FileReader($profile_path & "\" & GUICtrlRead($profile_combo) & "\other", "Бот"), 4)
Global $tele_chat_id = StringTrimLeft(FileReader($profile_path & "\" & GUICtrlRead($profile_combo) & "\other", "Чат"), 4)
Global $control = StringTrimLeft(FileReader($profile_path & "\" & GUICtrlRead($profile_combo) & "\other", "Контроль"), 9)

While true

	If $c == 20 Then
		GUICtrlSetData($time_label, _NowTime())
		$c = 0
	EndIf
	If $cc == 80 Then
		If $control == "#1" Then  
			$msg = Commands(FileRead($path_to_script & "\command"), $tele_bot_key, $tele_chat_id)
		Else
			$msg = GUIGetMsg()
		EndIf
		$cc = 0
	EndIf
	Select
		Case $msg = 555
			$file = FileOpen($profile_path & "\" & GUICtrlRead($profile_combo) & "\time", 2)
			FileWrite($file, _NowCalc())
			FileClose($file)
			Global $start_time = _NowCalc()
			$file = FileOpen($profile_path & "\" & GUICtrlRead($profile_combo) & "\pause", 2)
			FileWrite($profile_path & "\" & GUICtrlRead($profile_combo) & "\pause", 0)
			FileClose($file)
			Global $p_count = 0
			ExitLoop

		Case $msg = $start_button
			SetStartTime($start_window)
			Global $start_time = FileRead($profile_path & "\" & GUICtrlRead($profile_combo) & "\time")
			$file = FileOpen($profile_path & "\" & GUICtrlRead($profile_combo) & "\pause", 2)
			FileWrite($profile_path & "\" & GUICtrlRead($profile_combo) & "\log", "---Старт Интервалов---" & @CRLF)
			FileWrite($profile_path & "\" & GUICtrlRead($profile_combo) & "\pause", 0)
			FileClose($file)
			Global $p_count = 0
			ExitLoop

		Case $msg = $continue_button
			If FileExists($profile_path & "\" & GUICtrlRead($profile_combo) & "\time") == 0 Then FileWrite($profile_path & "\" & GUICtrlRead($profile_combo) & "\time", "2022/08/24 10:00:00")
			Global $start_time = FileRead($profile_path & "\" & GUICtrlRead($profile_combo) & "\time")
			Global $p_count = FileRead($profile_path & "\" & GUICtrlRead($profile_combo) & "\pause")
			ExitLoop

		Case $msg = $settings_button
			Settings($start_window, $profile_path & "\" & GUICtrlRead($profile_combo), GUICtrlRead($profile_combo))

		Case $msg = $info_button
			Info($start_window)

		Case $msg = $exit_button
			Exit 0

	EndSelect
	$c += 1
	$cc += 1
	Sleep(25)
	$msg = GUIGetMsg()

WEnd
$profile_path = $profile_path & "\" & GUICtrlRead($profile_combo)
$path_to_background = $profile_path & "\background"
	;Костыль для распознавания ссылок
	Local $tmp = FileGetShortCut($path_to_background)
		If isArray($tmp) == 1 Then $path_to_background = $tmp[0]
$path_to_sound = $profile_path & "\sound"
GUIDelete($start_window)



;ЗАЧИТЫВАНИЕ НАСТРОЕК
$tele_bot_key = StringTrimLeft(FileReader($profile_path & "\other", "Бот"), 4)
$tele_chat_id = StringTrimLeft(FileReader($profile_path & "\other", "Чат"), 4)
$control = StringTrimLeft(FileReader($profile_path & "\other", "Контроль"), 9)
Global $resolution_x = StringRegExpReplace(StringTrimLeft(FileReader($profile_path & "\geometry", "Разрешение"), 11), "#[0-9]{1,4}", "")
Global $resolution_y = StringRegExpReplace(StringTrimLeft(FileReader($profile_path & "\geometry", "Разрешение"), 11), "[0-9]{1,4}#", "")
Global $coordinate_x = StringRegExpReplace(StringTrimLeft(FileReader($profile_path & "\geometry", "Координаты"), 11), "#\-{0,1}[0-9]{1,4}", "")
Global $coordinate_y = StringRegExpReplace(StringTrimLeft(FileReader($profile_path & "\geometry", "Координаты"), 11), "\-{0,1}[0-9]{1,4}#", "")
Global $position_x = StringRegExpReplace(StringTrimLeft(FileReader($profile_path & "\geometry", "Позиция"), 8), "#[0-9]{1,4}", "")
Global $position_y = StringRegExpReplace(StringTrimLeft(FileReader($profile_path & "\geometry", "Позиция"), 8), "[0-9]{1,4}#", "")



;СТАРТ ИНТЕРВАЛОВ ВРЕМЕНИ
Global $continue_time = _DateDiff("s", $start_time, _NowCalc())
Global $sum_intervals = 0
$file = FileRead($profile_path & "\intervals")
Global $lines = StringSplit($file, @CRLF, 1)
Local $number
	For $i = 1 To $lines[0]

		$number = StringRegExp($lines[$i], "#[0-9]{1,3}", 3)
		If IsArray($number) == 0 Then ContinueLoop
		$number = StringTrimLeft($number[0], 1)
		$sum_intervals = $sum_intervals + $number

	Next
Global $remain = TimeCalc(StringRight(StringTrimRight($start_time, 3), 5), $sum_intervals, 0)
For $i = 1 To $lines[0]

	$number = StringRegExp($lines[$i], "#[0-9]{1,3}", 3)
	If IsArray($number) == 0 Then ContinueLoop
	$duration = StringTrimLeft($number[0], 1)
	$name = StringReplace($lines[$i], $number[0], "")
	IntervalGUI($past, $name, $duration * 60, $path_to_sound & "\" & $i & ".mp3", $profile_path, $i)
	$past = $past + $duration

Next
SoundPlay("")
Local $sound
If FileExists($path_to_sound & "\" & "End.mp3") Then
	$sound = "End.mp3"
Else
	$sound = $i & ".mp3"
EndIf
BotMsg("⏱ Интервалы Закончились", $tele_bot_key, $tele_chat_id)
FileWrite($profile_path & "\log", _NowCalc() & " " & $name & @CRLF & "Всего прошло: " & Int((_DateDiff("s", $start_time, _NowCalc())) / 60) & @CRLF & "-----------------------------" & @CRLF)
SoundPlay($path_to_sound & "\" & $sound)
MsgBox(64 + 4096, "Таймер Задач", "Интервалы окончены :)", 10)
If $secundomer <> 0 Then MsgBox(64 + 4096, "Таймер Задач", "Таймер остановился в " & _NowTime() & @CRLF & "Секундомер насчитал " & Int($secundomer / 60) & ":" & Mod($secundomer, 60))





Func SetStartTime($parent)

	If MsgBox(32 + 4 + 256 + 262144, "Установка времени", "Задать время отсчета?") == 6 Then

		Local $time_window = GUICreate("Установка времени", 200, 120, -1, -1, $WS_DLGFRAME, $WS_EX_TOPMOST, $parent)

			Local $hour_combo = GUICtrlCreateCombo("", 10, 10, 60, 120, $CBS_NOINTEGRALHEIGHT + $CBS_DROPDOWNLIST)
				GUICtrlSetFont(-1, 20, 1000)
				Local $h = StringTrimRight(_NowTime(5), 6)
			Local $minute_combo = GUICtrlCreateCombo("", 70, 10, 60, 120, $CBS_NOINTEGRALHEIGHT + $CBS_DROPDOWNLIST)
				GUICtrlSetFont(-1, 20, 1000)
				Local $m = StringTrimLeft(StringTrimRight(_NowTime(5), 3), 3)
			Local $second_combo = GUICtrlCreateCombo("", 130, 10, 60, 120, $CBS_NOINTEGRALHEIGHT + $CBS_DROPDOWNLIST)
				GUICtrlSetFont(-1, 20, 1000)
				Local $s = StringTrimLeft(_NowTime(5), 6)

				Dim $A[10] = ["00", "01", "02", "03", "04", "05", "06", "07", "08", "09"]
				For $i = 0 To 9
					GUICtrlSetData($hour_combo, $A[$i], $h)
					GUICtrlSetData($minute_combo, $A[$i], $m)
					GUICtrlSetData($second_combo, $A[$i], $s)
				Next
				For $i = 10 To 23
					GUICtrlSetData($hour_combo, $i, $h)
				Next
				For $i = 10 To 59
					GUICtrlSetData($minute_combo, $i, $m)
					GUICtrlSetData($second_combo, $i, $s)
				Next

			Local $set_button = GUICtrlCreateButton("Установить", 10, 60, 100, 30)
				GUICtrlSetFont(-1, 12, 1000)
			Local $exit_button = GUICtrlCreateButton("Отмена", 110, 60, 80, 30)
				GUICtrlSetFont(-1, 12, 1000)

		GUISetState()
		While true
			Select
				Case $msg = $set_button
					Local $datetime = _NowCalcDate() & " " & GUICtrlRead($hour_combo) & ":" & GUICtrlRead($minute_combo) & ":" & GUICtrlRead($second_combo)
					If _DateDiff("s", $datetime, _NowCalc()) < 0 Then
						If _start($datetime, $time_window) == 1 Then
							Local $file = FileOpen($profile_path & "\" & GUICtrlRead($profile_combo) & "\time", 2)
							FileWrite($file, _NowCalc())
							FileClose($file)
							ExitLoop
						Else
							ContinueLoop
						EndIf
					EndIf
					Local $file = FileOpen($profile_path & "\" & GUICtrlRead($profile_combo) & "\time", 2)
					FileWrite($profile_path & "\" & GUICtrlRead($profile_combo) & "\log", $datetime & " Отсроченный старт" & @CRLF)
					FileWrite($file, $datetime)
					FileClose($file)
					ExitLoop

				Case $msg = $exit_button
					Local $file = FileOpen($profile_path & "\" & GUICtrlRead($profile_combo) & "\time", 2)
					FileWrite($file, _NowCalc())
					FileClose($file)
					ExitLoop

			EndSelect
			Sleep(25)
			$msg = GUIGetMsg()

		WEnd
		GUIDelete()

	Else

		Local $file = FileOpen($profile_path & "\" & GUICtrlRead($profile_combo) & "\time", 2)
		FileWrite($file, _NowCalc())
		FileClose($file)

	EndIf

EndFunc

Func _start($datetime, $parent)

	Local $file = FileOpen($profile_path & "\" & GUICtrlRead($profile_combo) & "\time", 2)
	FileWrite($profile_path & "\" & GUICtrlRead($profile_combo) & "\log", _NowCalc() & " Отложенный старт" & @CRLF)
	FileWrite($file, $datetime)
	FileClose($file)

	Local $start_window = GUICreate("Отложенный старт", 200, 120, -1, -1, $WS_DLGFRAME, $WS_EX_TOPMOST, $parent)
		Local $progress = GUICtrlCreateProgress(10, 10, 180, 40, $PBS_SMOOTH)
		Local $diff = 100 / _DateDiff("s", _NowCalc(), $datetime)
		Local $sum = _DateDiff("s", _NowCalc(), $datetime)
		Local $set_button = GUICtrlCreateButton("Начать", 10, 60, 100, 30)
			GUICtrlSetFont(-1, 12, 1000)
		Local $exit_button = GUICtrlCreateButton("Отмена", 110, 60, 80, 30)
			GUICtrlSetFont(-1, 12, 1000)
		Local $timeS = 0, $cnt = 0

		GUISetState()
		While true
			Select
				Case $msg = $set_button
					GUIDelete()
					Return 1

				Case $msg = $exit_button
					GUIDelete()
					Return 0

			EndSelect
			If $cnt == 20 Then
				$cnt = 0
				$timeS = _DateDiff("s", _NowCalc(), $datetime)
				GUICtrlSetData($set_button, "Старт: " & $timeS)
				GUICtrlSetData($progress, ($sum - $timeS) * $diff)
				If $timeS <= 0 Then
					GUIDelete()
					Return 1
				EndIf

			EndIf
			Sleep(25)
			$msg = GUIGetMsg()
			$cnt = $cnt + 1

		WEnd

EndFunc

Func IntervalGUI($s_past, $s_name, $s_duration, $s_sound, $s_profile_path, $nb)

	If $continue_time - $p_count < $s_duration Then

		Local $pic, $pic_count
		Local $interval_window = GUICreate("Таймер Задач", $resolution_x, $resolution_y, $coordinate_x, $coordinate_y, $WS_DLGFRAME + $WS_MINIMIZEBOX, $WS_EX_TOPMOST)
			If FileExists($path_to_background & "\1.jpg") == 0 Then FileWrite($path_to_background & "\1.jpg", "")
			If StringTrimLeft(FileReader($s_profile_path & "\other", "Ресурсы"), 8) == "#1" Then
				$pic_count = _FileListToArray($path_to_background, "*.jpg", 1)
				$pic = GUICtrlCreatePic($path_to_background & "\" & Random(1, $pic_count[0], 1) & ".jpg", 0, 0, $resolution_x, $resolution_y)
			Else
				$pic = GUICtrlCreatePic($path_to_background & "\" & $nb & ".jpg", 0, 0, $resolution_x, $resolution_y)
			EndIf
				GUICtrlSetState(-1, $GUI_DISABLE)
			Local $interval_window_t_label = GUICtrlCreatelabel(_NowTime(), $position_x, $position_y, 150, 35)
				GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
				GUICtrlSetFont(-1, 26, 1000)
			Local $interval_window_time_label = GUICtrlCreateLabel("", $position_x + 155, $position_y, 190, 35)
				GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
				GUICtrlSetFont(-1, 26, 1000)
			Local $interval_window_common_progress = GUICtrlCreateProgress($position_x, $position_y + 40, 365, 30, $PBS_SMOOTH)
			Local $interval_window_name_label = GUICtrlCreateLabel($s_name, $position_x, $position_y + 70, 350, 55)
				GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
				GUICtrlSetFont(-1, 32, 1000)
			Local $interval_window_remain_label = GUICtrlCreateLabel("0 из " & $s_duration / 60 & " минут", $position_x, $position_y + 145, 350, 40, $SS_LEFT)
				GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
				GUICtrlSetFont(-1, 26, 1000)
			Local $interval_window_local_progress = GUICtrlCreateProgress($position_x, $position_y + 115, 365, 30, $PBS_SMOOTH)

			Local $interval_window_exit_button = GUICtrlCreateButton("Выход", $position_x, $position_y + 190, 80, 30, $BS_CENTER)
				GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
				GUICtrlSetFont(-1, 14, 1000)
			Local $interval_window_pause_button = GUICtrlCreateButton("⏯", $position_x + 83, $position_y + 190, 30, 30, $BS_CENTER)
				GUICtrlSetFont(-1, 16, 1000)
				GUICtrlSetTip(-1, "Остановить интервал", "", 2, 3)
			Local $interval_skip_button = GUICtrlCreateButton("⏭️", $position_x + 113, $position_y + 190, 30, 30, $BS_CENTER)
				GUICtrlSetFont(-1, 16, 1000)
				GUICtrlSetTip(-1, "Пропустить интервал", "", 2, 3)
			Local $secundomer_button = GUICtrlCreateButton("⏱", $position_x + 145, $position_y + 190, 75, 30, $BS_CENTER)
				GUICtrlSetFont(-1, 16, 1000)
				GUICtrlSetTip(-1, "Запустить Секундомер", "", 2, 3)
				If $secundomer <> 0 Then
					GUICtrlSetData($secundomer_button, Int($secundomer / 60) & ":" & Mod($secundomer, 60))
					GUICtrlSetBkColor($secundomer_button, 0x00FF00)
					GUICtrlSetTip($secundomer_button, "Остановить Секундомер", "", 2, 3)
				EndIf
			Local $interval_window_change_button = GUICtrlCreateButton("🔄", $position_x + 222, $position_y + 190, 30, 30, $BS_CENTER)
				GUICtrlSetFont(-1, 16, 1000)
				GUICtrlSetTip(-1, "Сменить фон", "", 2, 3)
			Local $interval_window_hide_button = GUICtrlCreateButton("_", $position_x + 252, $position_y + 190, 30, 30, $BS_CENTER)
				GUICtrlSetFont(-1, 16, 1000)
				GUICtrlSetTip(-1, "Свернуть", "", 2, 3)
			Local $interval_window_task_button = GUICtrlCreateButton("Меню", $position_x + 285, $position_y + 190, 80, 30, $BS_CENTER)
				GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
				GUICtrlSetFont(-1, 14, 1000)
			If StringTrimLeft(FileReader($s_profile_path & "\other", "Ресурсы"), 8) == "#0" Then GUICtrlSetState($interval_window_change_button, $GUI_DISABLE)

		GUISetState()

			SoundPlay("")
			SoundPlay($s_sound)
			BotMsg("✅ Интервал начался" & @CRLF & "   ➡️" & $s_name, $tele_bot_key, $tele_chat_id)
			FileWrite($s_profile_path & "\log", _NowCalc() & " " & $s_name & @CRLF)
			Local $continue = $continue_time
			$continue_time = 0
			Local $go_time = _NowCalc(), $cnt = 0, $stm = 0, $gtm = 0, $msg = GUIGetMsg(), $cc = 0
			Global $s_count = 0, $p, $p_time
			Dim $Array
			While _DateDiff("s", $go_time, _NowCalc()) + $continue - $p_count < $s_duration

				If $cc == 80 Then
					If $control == "#1" Then 
						$msg = Commands(FileRead($path_to_script & "\command"), $tele_bot_key, $tele_chat_id)
					Else
						$msg = GUIGetMsg()
					EndIf
					$cc = 0
				EndIf
				Select

					Case $msg = $interval_window_exit_button
						$file = FileOpen($s_profile_path & "\pause", 2)
						FileWrite($file, $p_count)
						FileClose($file)
						Exit 0

					Case $msg = $interval_window_change_button
						GUICtrlSetImage($pic, $path_to_background & "\" & Random(1, $pic_count[0], 1) & ".jpg")

					Case $msg = $interval_window_pause_button
						If GUICtrlRead($interval_window_pause_button) == "⏯" Then

							GUICtrlSetState($interval_skip_button, $GUI_DISABLE)
							GUICtrlSetData($interval_window_pause_button, "▶️")
							GUICtrlSetData($interval_window_name_label, "ПАУЗА")
							GUICtrlSetColor($interval_window_name_label, 0xFF0000)
							$s_count = _NowCalc()
							$p_time = _NowCalc()
							$p = FileRead($s_profile_path & "\pause")

						ElseIf GUICtrlRead($interval_window_pause_button) == "▶️" Then

							GUICtrlSetData($interval_window_pause_button, "⏯")
							GUICtrlSetData($interval_window_name_label, $s_name)
							GUICtrlSetColor($interval_window_name_label, 0x000000)
							$file = FileOpen($s_profile_path & "\pause", 2)
							FileWrite($file, $p_count)
							FileClose($file)
							GUICtrlSetState($interval_skip_button, $GUI_ENABLE)

						EndIf

					Case $msg = $interval_skip_button
						$p_count = _DateDiff("s", $go_time, _NowCalc()) + $continue - $s_duration
						$file = FileOpen($s_profile_path & "\pause", 2)
						FileWrite($file, $p_count)
						FileClose($file)

					Case $msg = $interval_window_hide_button
						GUISetState(@SW_MINIMIZE)

					Case $msg = $interval_window_task_button
						Tasks($interval_window, $s_profile_path, Int($gtm / 60) + $s_past, $sum_intervals)

					Case $msg = $secundomer_button
						If GUICtrlRead($secundomer_button) == "⏱" Then
							GUICtrlSetData($secundomer_button, 0)
							GUICtrlSetBkColor($secundomer_button, 0x00FF00)
							GUICtrlSetTip($secundomer_button, "Остановить Секундомер", "", 2, 3)
							$secStart = _NowCalc()

						ElseIf GUICtrlRead($secundomer_button) <> "⏱" Then
							GUICtrlSetStyle($secundomer_button, 0)
							GUICtrlSetData($secundomer_button, "⏱")
							GUICtrlSetTip($secundomer_button, "Запустить Секундомер", "", 2, 3)
							$secundomer = 0

						EndIf

					Case Else
							;Костыль для распознавания ссылок
							Local $taskPath = $s_profile_path & "\tasks"
							Local $tmp = FileGetShortCut($taskPath)
								If isArray($tmp) == 1 Then $taskPath = $tmp[0]
						If $cnt == 20 Then
							If GUICtrlRead($secundomer_button) <> "⏱" Then
								$secundomer = _DateDiff("s", $secStart, _NowCalc())
								GUICtrlSetData($secundomer_button, Int($secundomer / 60) & ":" & Mod($secundomer, 60))
							EndIf
							If GUICtrlRead($interval_window_pause_button) == "▶️" Then

								$p_count = _DateDiff("s", $s_count, _NowCalc()) + $p
								GUICtrlSetData($interval_window_name_label, "ПАУЗА    " & _DateDiff("n", $p_time, _NowCalc()) & ":" & Mod(_DateDiff("s", $p_time, _NowCalc()), 60))

							Else

								$stm = _DateDiff("s", $start_time, _NowCalc()) - $p_count
								$gtm = _DateDiff("s", $go_time, _NowCalc()) + $continue - $p_count
								GUICtrlSetData($interval_window_common_progress, (100 / $sum_intervals) * ($stm / 60))
								GUICtrlSetData($interval_window_time_label, $sum_intervals - Int($gtm / 60) - $s_past & "   " & TimeCalc($remain, Int($p_count / 60), 0))
								GUICtrlSetData($interval_window_local_progress, (100 / $s_duration) * $gtm)
								GUICtrlSetData($interval_window_remain_label, Int($gtm / 60) & "/" & Int($s_duration / 60) & " мин.  " &  Int($gtm / 60) + $s_past & "/" & Int((_DateDiff("s", $start_time, _NowCalc())) / 60))

							EndIf
							GUICtrlSetData($interval_window_t_label, _NowTime())
								For $k = 10 To 2 Step -2

									Local $task = TimeCalc(_NowTime(4), $k, 0)
									Local $st = FileReader($taskPath, $task)
									If  StringLen($st) > 1 Then

										BotMsg("⚠️➡️" & "Событие через " & $k & " минут(ы)!" & @CRLF & $st, $tele_bot_key, $tele_chat_id)
										SoundPlay("")
										SoundPlay($s_sound)
										MsgBox(48 + 262144, "Таймер Задач", "Событие через " & $k & " минут(ы)!" & @CRLF & $st, 3)
										Tasks($interval_window, $s_profile_path, Int($gtm / 60) + $s_past, $sum_intervals)
										ExitLoop

									EndIf

								Next
								$cnt = 0

						EndIf
						$cnt += 1

				EndSelect
				$cc += 1
				Sleep(25)
				$msg = GUIGetMsg()

			WEnd
			$continue_time = _DateDiff("s", $go_time, _NowCalc()) + $continue - $s_duration
		GUIDelete($interval_window)

	Else

		$continue_time = $continue_time - $s_duration

	EndIf

EndFunc

Func Tasks($s_interval_window, $ss_profile_path, $s_com, $sum_intervals)

	Local $task_window = GUICreate("Таймер Задач", 300, 550, -1, -1, $WS_DLGFRAME, $WS_EX_TOPMOST, $s_interval_window)
			;Костыль для распознавания ссылок
			Local $taskPath = $ss_profile_path & "\tasks"
			Local $tmp = FileGetShortCut($taskPath)
				If isArray($tmp) == 1 Then $taskPath = $tmp[0]
		Local $file = FileRead($taskPath)
		Local $task_window_edit = GUICtrlCreateEdit($file, 10, 10, 280, 465, $ES_MULTILINE + $ES_WANTRETURN + $WS_VSCROLL)
			GUICtrlSetFont(-1, 14, 1000)
		Local $task_window_accept_button = GUICtrlCreateButton("Сохранить", 10, 485, 110, 30)
			GUICtrlSetFont(-1, 14, 1000)
		Local $task_window_exit_button = GUICtrlCreateButton("Отмена", 210, 485, 80, 30)
			GUICtrlSetFont(-1, 14, 1000)
		Local $task_window_log_button = GUICtrlCreateButton("📝", 180, 485, 30, 30)
			GUICtrlSetFont(-1, 14, 1000)
			GUICtrlSetTip($task_window_log_button, "Журнал", "", 2, 3)
		Local $task_window_remain_time = GUICtrlCreateButton("⏱", 120, 485, 30, 30)
			GUICtrlSetFont(-1, 14, 1000)
			GUICtrlSetTip($task_window_remain_time, "Счетчик времени", "", 2, 3)
		Local $task_window_settings = GUICtrlCreateButton("⚙️", 150, 485, 30, 30)
			GUICtrlSetFont(-1, 14, 1000)
			GUICtrlSetTip($task_window_settings, "Настройки", "", 2, 3)

	GUISetState()
	While true

		Switch GUIGetMsg()

			Case $task_window_accept_button
				$file = FileOpen($taskPath, 2)
				FileWrite($file, GUICtrlRead($task_window_edit))
				FileClose($file)
				ExitLoop

			Case $task_window_remain_time
				TimeChecker($task_window, $s_com, $sum_intervals)

			Case $task_window_settings
				Local $tsk
				$tsk = StringRegExp($ss_profile_path, "[a-zA-Z]{1,}", 3)
				Settings($task_window, $ss_profile_path, $tsk[UBound($tsk) - 1])

			Case $task_window_log_button
				ShellExecute("notepad.exe", $ss_profile_path & "\log")

			Case $task_window_exit_button
				ExitLoop

		EndSwitch

	WEnd
	GUIDelete($task_window)

EndFunc

Func TimeChecker($task_window, $s_com, $sum_intervals)

	Local $time_checher = GUICreate("Счетчик Времени", 300, 500, -1, -1, $WS_DLGFRAME, $WS_EX_TOPMOST, $task_window)
		Local $time_checker_edit = GUICtrlCreateEdit(" ", 10, 10, 280, 320, $ES_MULTILINE + $ES_WANTRETURN + $WS_VSCROLL + $ES_READONLY)
			GUICtrlSetFont(-1, 14, 1000)

		Local $start_label = GUICtrlCreateLabel("Начало", 10, 340, 80, 30)
			GUICtrlSetFont(-1, 14, 1000)
		Local $time_checker_start_hour = GUICtrlCreateInput("Час", 90, 340, 60, 30)
			GUICtrlSetFont(-1, 14, 1000)
		Local $time_checker_start_minute = GUICtrlCreateInput("Мин", 160, 340, 60, 30)
			GUICtrlSetFont(-1, 14, 1000)

		Local $start_label = GUICtrlCreateLabel("Конец", 10, 370, 80, 30)
			GUICtrlSetFont(-1, 14, 1000)
		Local $time_checker_stop_hour = GUICtrlCreateInput("Час", 90, 370, 60, 30)
			GUICtrlSetFont(-1, 14, 1000)
		Local $time_checker_stop_minute = GUICtrlCreateInput("Мин", 160, 370, 60, 30)
			GUICtrlSetFont(-1, 14, 1000)

		Local $remain_label = GUICtrlCreateLabel("Остаток: ", 10, 405, 280, 30)
			GUICtrlSetFont(-1, 14, 1000)
		Local $time_checker_calc = GUICtrlCreateButton("Посчитать", 10, 435, 100, 30)
			GUICtrlSetFont(-1, 14, 1000)
		Local $time_checker_exit = GUICtrlCreateButton("Выход", 190, 435, 100, 30)
			GUICtrlSetFont(-1, 14, 1000)
			
			Local $name = "", $time = 0, $text = "", $com = $s_com, $startHM = 0, $stopHM = 0
				For $i = 1 To $lines[0]

					$name = StringRegExpReplace($lines[$i], "#[0-9]{1,3}", "")
					$time = StringRegExp($lines[$i], "[0-9]{1,3}", 3)
					If IsArray($time) == 0 Then ContinueLoop
					If $time[0] < $com Then

						$com = $com - $time[0]

					ElseIf $time[0] > $com Then

						$text = $text & $name & " " & $time[0] - $com & @CRLF
						$com = 0

					Else

						$text = $text & $name & " " & $time[0] & @CRLF

					EndIf

				Next
				GUICtrlSetData($time_checker_edit, $text)

	GUISetState()
	While true

		Switch GUIGetMsg()

			Case $time_checker_calc
				$startHM = GUICtrlRead($time_checker_start_hour) * 60 + GUICtrlRead($time_checker_start_minute)
				$stopHM = GUICtrlRead($time_checker_stop_hour) * 60 + GUICtrlRead($time_checker_stop_minute)
				GUICtrlSetData($remain_label, "Остаток: " & $stopHM - $startHM - $sum_intervals)

			Case $time_checker_exit
				ExitLoop

		EndSwitch

	WEnd
	GUIDelete($time_checher)

EndFunc

Func Settings($s_start_window, $s_profile_path, $prof)

	Local $settings_window = GUICreate("Таймер Задач. Профиль: " & $prof, 350, 330, -1, -1, $WS_DLGFRAME, $WS_EX_TOPMOST, $s_start_window)

		Local $settings_window_accept_button = GUICtrlCreateButton("Сохранить", 10, 260, 125, 40)
			GUICtrlSetFont(-1, 14)
		Local $settings_window_exit_button = GUICtrlCreateButton("Выход", 215, 260, 125, 40)
			GUICtrlSetFont(-1, 14)
		Local $settings_window_resources_button = GUICtrlCreateButton("📂", 155, 260, 40, 40)
			GUICtrlSetFont(-1, 14)

		Local $settings_tab = GUICtrlCreateTab(5, 5, 340, 250)
			Local $settings_tab_1 = GUICtrlCreateTabItem("Время")
				Local $file_time = FileRead($s_profile_path & "\time")
				Local $settings_window_edit_time = GUICtrlCreateEdit($file_time, 10, 30, 330, 220, $ES_MULTILINE + $ES_WANTRETURN + $WS_VSCROLL)
					GUICtrlSetFont(-1, 14, 1000)

			Local $settings_tab_2 = GUICtrlCreateTabItem("Задачи")
					;Костыль для распознавания ссылок
					Local $taskPath = $s_profile_path & "\tasks"
					Local $tmp = FileGetShortCut($taskPath)
						If isArray($tmp) == 1 Then $taskPath = $tmp[0]
				Local $file_tasks = FileRead($taskPath)
				Local $settings_window_edit_tasks = GUICtrlCreateEdit($file_tasks, 10, 30, 330, 220, $ES_MULTILINE + $ES_WANTRETURN + $WS_VSCROLL)
					GUICtrlSetFont(-1, 14, 1000)

			Local $settings_tab_3 = GUICtrlCreateTabItem("Интервалы")
				Local $file_intervals = FileRead($s_profile_path & "\intervals")
				Local $settings_window_edit_intervals = GUICtrlCreateEdit($file_intervals, 10, 30, 330, 220, $ES_MULTILINE + $ES_WANTRETURN + $WS_VSCROLL)
					GUICtrlSetFont(-1, 14, 1000)

			Local $settings_tab_4 = GUICtrlCreateTabItem("Геометрия")
				Local $file_geometry = FileRead($s_profile_path & "\geometry")
				Local $settings_window_edit_geometry = GUICtrlCreateEdit($file_geometry, 10, 30, 330, 220, $ES_MULTILINE + $ES_WANTRETURN + $WS_VSCROLL)
					GUICtrlSetFont(-1, 14, 1000)

			Local $settings_tab_5 = GUICtrlCreateTabItem("Прочие")
				Local $file_other = FileRead($s_profile_path & "\other")
				Local $settings_window_edit_other = GUICtrlCreateEdit($file_other, 10, 30, 330, 220, $ES_MULTILINE + $ES_WANTRETURN + $WS_VSCROLL)
					GUICtrlSetFont(-1, 14, 1000)

			Local $settings_tab_6 = GUICtrlCreateTabItem("Профили")
				Local $file_profiles = FileRead($path_to_script & "\_profiles")
				Local $settings_window_edit_profiles = GUICtrlCreateEdit($file_profiles, 10, 30, 330, 220, $ES_MULTILINE + $ES_WANTRETURN + $WS_VSCROLL)
					GUICtrlSetFont(-1, 14, 1000)

	GUISetState()
	While true

		Switch GUIGetMsg()

			Case $settings_window_accept_button
				Local $file = FileOpen($s_profile_path & "\time", 2)
				FileWrite($file, GUICtrlRead($settings_window_edit_time))
				FileClose($file)
				$file = FileOpen($taskPath, 2)
				FileWrite($file, GUICtrlRead($settings_window_edit_tasks))
				FileClose($file)
				$file = FileOpen($s_profile_path & "\intervals", 2)
				FileWrite($file, GUICtrlRead($settings_window_edit_intervals))
				FileClose($file)
				$file = FileOpen($s_profile_path & "\geometry", 2)
				FileWrite($file, GUICtrlRead($settings_window_edit_geometry))
				FileClose($file)
				$file = FileOpen($s_profile_path & "\other", 2)
				FileWrite($file, GUICtrlRead($settings_window_edit_other))
				FileClose($file)
				$file = FileOpen($path_to_script & "\_profiles", 2)
				FileWrite($file, GUICtrlRead($settings_window_edit_profiles))
				FileClose($file)
					MsgBox(64, "Таймер Задач", "Сохранено", 3, $settings_window)
					Dim $Array
					_FileReadToArray($path_to_script & "\_profiles", $Array)
					For $i = 1 To $Array[0]

						DirCreate($path_to_profiles & "\" & $Array[$i])
							;Костыль для распознавания ссылок
							$tmp = FileGetShortCut($path_to_profiles & "\" & $Array[$i] & "\background")
								If isArray($tmp) == 0 Then DirCreate($path_to_profiles & "\" & $Array[$i] & "\background")
						DirCreate($path_to_profiles & "\" & $Array[$i] & "\sound")
							$taskPath = $path_to_profiles & "\" & $Array[$i] & "\tasks"
							$tmp = FileGetShortCut($taskPath)
								If isArray($tmp) == 1 Then $taskPath = $tmp[0]
						If FileExists($taskPath) == 0 Then

							FileWrite($taskPath, "Настроить профиль" & @CRLF & "10:00 Начало работы")

						Else 

							FileWrite($taskPath, "")

						EndIf
						If FileExists($path_to_profiles & "\" & $Array[$i] & "\other") == 0 Then

							FileWrite($path_to_profiles & "\" & $Array[$i] & "\other", "Бот " & @CRLF & "Чат " & @CRLF & "Ресурсы #1" & @CRLF & "Контроль #0")

						Else

							FileWrite($path_to_profiles & "\" & $Array[$i] & "\other", "")

						EndIf
						If FileExists($path_to_profiles & "\" & $Array[$i] & "\intervals") == 0 Then

							FileWrite($path_to_profiles & "\" & $Array[$i] & "\intervals", "Интервал I #5" & @CRLF & "Интервал II #10")

						Else

							FileWrite($path_to_profiles & "\" & $Array[$i] & "\intervals", "")

						EndIf
						If FileExists($path_to_profiles & "\" & $Array[$i] & "\geometry") == 0 Then

							FileWrite($path_to_profiles & "\" & $Array[$i] & "\geometry", "Разрешение 405#720" & @CRLF & "Координаты 20#235" & @CRLF & "Позиция 20#460")

						Else

							FileWrite($path_to_profiles & "\" & $Array[$i] & "\geometry", "")

						EndIf

					Next

			Case $settings_window_exit_button
				ExitLoop

			Case $settings_window_resources_button
				ShellExecute($path_to_profiles & "\" & $prof)

		EndSwitch

	WEnd
	GUIDelete($settings_window)

EndFunc

Func ProfileCreate($path)

	DirCreate($path & "\background")
	DirCreate($path & "\sound")
	FileWrite($path & "\geometry", "Разрешение 405#720" & @CRLF & "Координаты 20#235" & @CRLF & "Позиция 20#460")
	FileWrite($path & "\intervals", "Интервал I #5" & @CRLF & "Интервал II #10")
	FileWrite($path & "\other", "Бот " & @CRLF & "Чат " & @CRLF & "Ресурсы #1" & @CRLF & "Контроль #0")
	FileWrite($path & "\tasks", "Настроить профиль" & @CRLF & "10:00 Начало работы")
	FileWrite($path & "\time", 0)
	FileWrite($path & "\pause", 0)

EndFunc

Func Info($window)

	Local $info = "Для работы программы нужно создать свой профиль. Профилей может быть несколько, каждый со своими настройками. Для создания профиля перейти в Настройки->Профили. Написать имя профиля. Профиль в первой строке будет выбран по умолчанию при старте программы." & @CRLF & "Перезапустим настройки, выбрав профиль из выпадающего списка. Отредактируем параметры:" & @CRLF & "Прочие - Настройки телеграмм бота и ресурсов" & @CRLF & " - Бот пробел айди" & @CRLF & " - Чат пробел айди" & @CRLF & " - Ресурсы #1(об этом ниже)" & @CRLF & " - Контроль #1(управление через бота). Команды боту:" & @CRLF & "Start, Continue, Exit, Profile:X, End, Next, Pause, Cpause" & @CRLF & @CRLF & "Геометрия - задает вид окна, размер и положение надписей" & @CRLF & " - Здесь параметры задаются в пикселях в формате X#Y" & @CRLF & @CRLF & "Интервалы - интервалы времени по которым работает программа" & @CRLF & " - задается списком: Название #Время в минутах" & @CRLF & @CRLF & "Вкладки Время и Задачи можно не редактировать. Во Время записывается время старта программы, в Задачи можно написать свои задачи и напоминания. Если в задаче указать время, например 12:00, то за 10 минут до этого придет оповещение." & @CRLF & "Для старта программы нужно нажать Начнем, чтобы начать с текущего времени или можно Продолжить с ранее начатого момента" & @CRLF & @CRLF & "Программа поддерживает картинки и звуки. Стартовый фон, картинку Start.jpg положить в корень программы. Фон интервалов и звуки пронумеровать 1.jpg 1.mp3 и тд и положить в соответсвующие папки в своем профиле. Если в настройках Ресурсы #1, то картинки будут показываться в случайном порядке, если #0, то в упорядоченном."
	
	Local $info_window = GUICreate("Таймер Задач", 500, 750, -1, -1, $WS_DLGFRAME, -1, $window)
		Local $info_window_label = GUICtrlCreateLabel($info, 10, 10, 480, 650, $SS_SUNKEN)
			GUICtrlSetFont(-1, 12)
		Local $info_window_exit_button = GUICtrlCreateButton("Выход", 187, 670, 125, 40)
			GUICtrlSetFont(-1, 14)

	GUISetState()
	While true

		Switch GUIGetMsg()

			Case $info_window_exit_button
				ExitLoop

		EndSwitch

	WEnd
	GUIDelete($info_window)

EndFunc

Func TimeCalc($now, $num, $op)

	If $num < 0 Then
		$op = 1
		$num = -1 * $num
	EndIf
	Local $hours = StringLeft($now, 2)
	Local $minutes = StringRight($now, 2)
	Local $Hnum = Int($num / 60)
	Local $Mnum = $num - $Hnum * 60
	If $op = 0 Then

		If (Number($minutes) + $Mnum) >= 60 Then

			If ($Mnum + Number($minutes) - 60) < 10 Then

				$Mnum = "0" & String($Mnum + Number($minutes) - 60)

			Else

				$Mnum = $Mnum + Number($minutes) - 60

			EndIf
			$Hnum = $Hnum + 1 + Number($hours)

		Else

			If ($Mnum + Number($minutes)) < 10 Then

				$Mnum = "0" & String($Mnum + Number($minutes))

			Else

				$Mnum = $Mnum + Number($minutes)

			EndIf
			$Hnum = $Hnum + Number($hours)

		EndIf

	ElseIf $op = 1 Then

		If (Number($minutes) - $Mnum) <= 0 Then

			If (Number($minutes) - $Mnum + 60) < 10 Then

				$Mnum = "0" & String(Number($minutes) - $Mnum + 60)

			Else

				$Mnum = Number($minutes) - $Mnum + 60

			EndIf
			$Hnum = Number($hours) - $Hnum - 1

		Else

			If (Number($minutes) - $Mnum) < 10 Then

				$Mnum = "0" & String(Number($minutes) - $Mnum)

			Else

				$Mnum = Number($minutes) - $Mnum

			EndIf
			$Hnum = Number($hours) - $Hnum

		EndIf

	EndIf
	If $Hnum > 24 Then

		$Hnum -= 24
		If $Hnum < 10 Then $Hnum = "0" & $Hnum

	ElseIf $Hnum < 0 Then

		$Hnum += 24
		If $Hnum < 10 Then $Hnum = "0" & $Hnum

	ElseIf $Hnum == 0 Or $Hnum == 24 Then

		$Hnum = "0"

	EndIf
	Return $Hnum & ":" & $Mnum

EndFunc

Func _URIEncode($sData)

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

Func BotMsg($_TXT, $BotKey, $ChatId)

	Local $sText = _URIEncode($_TXT)
	ConsoleWrite(InetRead('https://api.telegram.org/' & $BotKey & '/sendMessage?chat_id=' & $ChatId & '&text=' & $sText, 17))

EndFunc

Func FileReader($pathToFile, $sSearchText)

	Local $sText = FileRead($pathToFile)
	Local $aLines = StringSplit($sText, @CRLF, 1)
		For $i = 1 To $aLines[0] Step +1

			If StringInStr($aLines[$i], $sSearchText) Then

				Return $aLines[$i]

			EndIf

		Next

EndFunc

Func Commands($Update, $BotKey, $ChatId)

	local $website = 'https://api.telegram.org/' & $BotKey & '/getUpdates?chat_id=' & $ChatId & '&limit=1&offset=-1'
	local $lstmsg = BinaryToString(InetRead($website, 17), 4)
	Local $msg = StringRegExp($lstmsg, 'date\":\d{1,},\"text\":\"\w{1,}[:]{0,}\w{0,}', 3)
	Local $return = 0
	If IsArray($msg) == 0 Then Return GUIGetMsg()
	If $Update <> $msg[0] Then
		Local $message = StringRegExp(StringRegExpReplace($msg[0], 'date\":\d{1,},\"text\":\"', ""), "\w{1,}", 3)
		Switch $message[0]
			Case "Start"
				$return = 555

			Case "Continue"
				$return = 7

			Case "Exit"
				$return = 10

			Case "Profile"
				If StringInStr(_GUICtrlComboBox_GetList($profile_combo), $message[1]) Then
					GUICtrlSetData($profile_combo, $message[1])
					BotMsg("✅ Выбран профиль:" & @CRLF & "   ➡️" & $message[1], $BotKey, $ChatId)
				Else
					BotMsg("❌ Профиль не найден!" , $BotKey, $ChatId)
				EndIf

			Case "End"
				$return = 10

			Case "Pause"
				$return = 12
				BotMsg("🤚 Интервал на паузе!", $BotKey, $ChatId)

			Case "Cpause"
				$return = 12
				BotMsg("➡️ Интервал возобновлен!", $BotKey, $ChatId)

			Case "Next"
				$return = 13

		EndSwitch
		FileClose(FileWrite(FileOpen($path_to_script & "\command", 2), $msg[0]))
		Return $return

	Else

		Return GUIGetMsg()

	EndIf

EndFunc