#include <ProgressConstants.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstants.au3>
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
	Local $profile_combo = GUICtrlCreateCombo("", 162, 680, 175, 50, $CBS_DROPDOWNLIST + $WS_VSCROLL)
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
Local $c = 0
While true

	If $c == 20 Then
		GUICtrlSetData($time_label, _NowTime())
		$c = 0
	EndIf
	Switch GUIGetMsg()

		Case $start_button
			$file = FileOpen($path_to_script & "\time", 2)
			FileWrite($file, _NowCalc())
			FileClose($file)
			Global $start_time = _NowCalc()
			$file = FileOpen($path_to_script & "\pause", 2)
			FileWrite($path_to_script & "\pause", 0)
			FileClose($file)
			Global $p_count = 0
			ExitLoop

		Case $continue_button
			If FileExists($path_to_script & "\time") == 0 Then FileWrite($path_to_script & "\time", "2022/08/24 10:00:00")
			Global $start_time = FileRead($path_to_script & "\time")
			Global $p_count = FileRead($path_to_script & "\pause")
			ExitLoop

		Case $settings_button
			Settings($start_window, $profile_path & "\" & GUICtrlRead($profile_combo))

		Case $info_button
			Info($start_window)

		Case $exit_button
			Exit 0

	EndSwitch
	$c += 1
	Sleep(25)

WEnd
$profile_path = $profile_path & "\" & GUICtrlRead($profile_combo)
$path_to_background = $profile_path & "\background"
$path_to_sound = $profile_path & "\sound"
GUIDelete($start_window)



;ЗАЧИТЫВАНИЕ НАСТРОЕК
Global $tele_bot_key = StringTrimLeft(FileReader($profile_path & "\other", "Бот"), 4)
Global $tele_chat_id = StringTrimLeft(FileReader($profile_path & "\other", "Чат"), 4)
Global $resolution_x = StringRegExpReplace(StringTrimLeft(FileReader($profile_path & "\geometry", "Разрешение"), 11), "#[0-9]{1,4}", "")
Global $resolution_y = StringRegExpReplace(StringTrimLeft(FileReader($profile_path & "\geometry", "Разрешение"), 11), "[0-9]{1,4}#", "")
Global $coordinate_x = StringRegExpReplace(StringTrimLeft(FileReader($profile_path & "\geometry", "Координаты"), 11), "#[0-9]{1,4}", "")
Global $coordinate_y = StringRegExpReplace(StringTrimLeft(FileReader($profile_path & "\geometry", "Координаты"), 11), "[0-9]{1,4}#", "")
Global $position_x = StringRegExpReplace(StringTrimLeft(FileReader($profile_path & "\geometry", "Позиция"), 8), "#[0-9]{1,4}", "")
Global $position_y = StringRegExpReplace(StringTrimLeft(FileReader($profile_path & "\geometry", "Позиция"), 8), "[0-9]{1,4}#", "")



;СТАРТ ИНТЕРВАЛОВ ВРЕМЕНИ
Global $continue_time = _DateDiff("s", $start_time, _NowCalc())
Global $sum_intervals = 0
$file = FileRead($profile_path & "\intervals")
Local $lines = StringSplit($file, @CRLF, 1)
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
SoundPlay($path_to_sound & "\" & $sound)
MsgBox(64 + 4096, "Таймер Задач", "Интервалы окончены :)", 10)





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
			Local $interval_window_exit_button = GUICtrlCreateButton("Выход", $position_x, $position_y + 190, 100, 30, $BS_CENTER)
				GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
				GUICtrlSetFont(-1, 14, 1000)
			Local $interval_window_task_button = GUICtrlCreateButton("Задачи", $position_x + 265, $position_y + 190, 100, 30, $BS_CENTER)
				GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
				GUICtrlSetFont(-1, 14, 1000)
			Local $interval_window_pause_button = GUICtrlCreateButton("⏯", $position_x + 107, $position_y + 190, 30, 30, $BS_CENTER)
				GUICtrlSetFont(-1, 16, 1000)
				GUICtrlSetTip(-1, "Остановить интервал", "", 2, 3)
			Local $interval_skip_button = GUICtrlCreateButton("⏭️", $position_x + 147, $position_y + 190, 30, 30, $BS_CENTER)
				GUICtrlSetFont(-1, 16, 1000)
				GUICtrlSetTip(-1, "Пропустить интервал", "", 2, 3)
			Local $interval_window_change_button = GUICtrlCreateButton("🔄", $position_x + 187, $position_y + 190, 30, 30, $BS_CENTER)
				GUICtrlSetFont(-1, 16, 1000)
				GUICtrlSetTip(-1, "Сменить фон", "", 2, 3)
			Local $interval_window_hide_button = GUICtrlCreateButton("_", $position_x + 227, $position_y + 190, 30, 30, $BS_CENTER)
				GUICtrlSetFont(-1, 16, 1000)
				GUICtrlSetTip(-1, "Свернуть", "", 2, 3)
			If StringTrimLeft(FileReader($s_profile_path & "\other", "Ресурсы"), 8) == "#0" Then GUICtrlSetState($interval_window_change_button, $GUI_DISABLE)

		GUISetState()

			SoundPlay("")
			SoundPlay($s_sound)
			BotMsg("✅ Интервал начался" & @CRLF & "   ➡️" & $s_name, $tele_bot_key, $tele_chat_id)
			Local $continue = $continue_time
			$continue_time = 0
			Local $go_time = _NowCalc(), $cnt = 0, $stm = 0, $gtm = 0
			Global $s_count = 0, $p, $p_time
			Dim $Array
			While _DateDiff("s", $go_time, _NowCalc()) + $continue - $p_count < $s_duration

				Switch GUIGetMsg()

					Case $interval_window_exit_button
						$file = FileOpen($path_to_script & "\pause", 2)
						FileWrite($file, $p_count)
						FileClose($file)
						Exit 0

					Case $interval_window_change_button
						GUICtrlSetImage($pic, $path_to_background & "\" & Random(1, $pic_count[0], 1) & ".jpg")

					Case $interval_window_pause_button
						If GUICtrlRead($interval_window_pause_button) == "⏯" Then

							GUICtrlSetState($interval_skip_button, $GUI_DISABLE)
							GUICtrlSetData($interval_window_pause_button, "▶️")
							GUICtrlSetData($interval_window_name_label, "ПАУЗА")
							GUICtrlSetColor($interval_window_name_label, 0xFF0000)
							$s_count = _NowCalc()
							$p_time = _NowCalc()
							$p = FileRead($path_to_script & "\pause")

						ElseIf GUICtrlRead($interval_window_pause_button) == "▶️" Then

							GUICtrlSetData($interval_window_pause_button, "⏯")
							GUICtrlSetData($interval_window_name_label, $s_name)
							GUICtrlSetColor($interval_window_name_label, 0x000000)
							$file = FileOpen($path_to_script & "\pause", 2)
							FileWrite($file, $p_count)
							FileClose($file)
							GUICtrlSetState($interval_skip_button, $GUI_ENABLE)

						EndIf

					Case $interval_skip_button
						$p_count = _DateDiff("s", $go_time, _NowCalc()) + $continue - $s_duration
						$file = FileOpen($path_to_script & "\pause", 2)
						FileWrite($file, $p_count)
						FileClose($file)

					Case $interval_window_hide_button
						GUISetState(@SW_MINIMIZE)

					Case $interval_window_task_button
						Tasks($interval_window, $s_profile_path)

					Case Else
						If $cnt == 20 Then


							If GUICtrlRead($interval_window_pause_button) == "▶️" Then

								$p_count = _DateDiff("s", $s_count, _NowCalc()) + $p
								GUICtrlSetData($interval_window_name_label, "ПАУЗА    " & _DateDiff("n", $p_time, _NowCalc()) & ":" & Mod(_DateDiff("s", $p_time, _NowCalc()), 60))

							Else

								$stm = _DateDiff("s", $start_time, _NowCalc()) - $p_count
								$gtm = _DateDiff("s", $go_time, _NowCalc()) + $continue - $p_count
								GUICtrlSetData($interval_window_common_progress, (100 / $sum_intervals) * ($stm / 60))
								GUICtrlSetData($interval_window_time_label, $sum_intervals - Int($gtm / 60) - $s_past & "   " & TimeCalc($remain, Int($p_count / 60), 0))
								GUICtrlSetData($interval_window_local_progress, (100 / $s_duration) * $gtm)
								GUICtrlSetData($interval_window_remain_label, Int($gtm / 60) & " из " & Int($s_duration / 60) & " мин.  " &  Int($gtm / 60) + $s_past)

							EndIf
							GUICtrlSetData($interval_window_t_label, _NowTime())
								For $k = 10 To 2 Step -2

									Local $task = TimeCalc(_NowTime(4), $k, 0)
									Local $st = FileReader($s_profile_path & "\tasks", $task)
									If  StringLen($st) > 1 Then

										BotMsg("⚠️➡️" & "Событие через " & $k & " минут(ы)!" & @CRLF & $st, $tele_bot_key, $tele_chat_id)
										SoundPlay("")
										SoundPlay($s_sound)
										MsgBox(48 + 262144, "Таймер Задач", "Событие через " & $k & " минут(ы)!" & @CRLF & $st, 3)
										Tasks($interval_window, $s_profile_path)
										ExitLoop

									EndIf

								Next
								$cnt = 0

						EndIf
						$cnt += 1
						sleep(25)

				EndSwitch

			WEnd
			$continue_time = _DateDiff("s", $go_time, _NowCalc()) + $continue - $s_duration
		GUIDelete($interval_window)

	Else

		$continue_time = $continue_time - $s_duration

	EndIf

EndFunc

Func Tasks($s_interval_window, $ss_profile_path)

	Local $task_window = GUICreate("Таймер Задач", 300, 550, -1, -1, $WS_DLGFRAME, $WS_EX_TOPMOST, $s_interval_window)
	
		Local $file = FileRead($ss_profile_path & "\tasks")
		Local $task_window_edit = GUICtrlCreateEdit($file, 10, 10, 280, 465, $ES_MULTILINE + $ES_WANTRETURN + $WS_VSCROLL)
			GUICtrlSetFont(-1, 14, 1000)
		Local $task_window_accept_button = GUICtrlCreateButton("Сохранить", 10, 485, 110, 30)
			GUICtrlSetFont(-1, 14, 1000)
		Local $task_window_exit_button = GUICtrlCreateButton("Отмена", 180, 485, 110, 30)
			GUICtrlSetFont(-1, 14, 1000)

	GUISetState()
	While true

		Switch GUIGetMsg()

			Case $task_window_accept_button
				$file = FileOpen($ss_profile_path & "\tasks", 2)
				FileWrite($file, GUICtrlRead($task_window_edit))
				FileClose($file)
				ExitLoop

			Case $task_window_exit_button
				ExitLoop

		EndSwitch

	WEnd
	GUIDelete($task_window)

EndFunc

Func Settings($s_start_window, $s_profile_path)

	Local $settings_window = GUICreate("Таймер Задач. Профиль: " & GUICtrlRead($profile_combo), 350, 330, -1, -1, $WS_DLGFRAME, $WS_EX_TOPMOST, $s_start_window)

		Local $settings_window_accept_button = GUICtrlCreateButton("Сохранить", 10, 260, 125, 40)
			GUICtrlSetFont(-1, 14)
		Local $settings_window_exit_button = GUICtrlCreateButton("Выход", 215, 260, 125, 40)
			GUICtrlSetFont(-1, 14)
		Local $settings_window_resources_button = GUICtrlCreateButton("📂", 155, 260, 40, 40)
			GUICtrlSetFont(-1, 14)

		Local $settings_tab = GUICtrlCreateTab(5, 5, 340, 250)
			Local $settings_tab_1 = GUICtrlCreateTabItem("Время")
				Local $file_time = FileRead($path_to_script & "\time")
				Local $settings_window_edit_time = GUICtrlCreateEdit($file_time, 10, 30, 330, 220, $ES_MULTILINE + $ES_WANTRETURN + $WS_VSCROLL)
					GUICtrlSetFont(-1, 14, 1000)

			Local $settings_tab_2 = GUICtrlCreateTabItem("Задачи")
				Local $file_tasks = FileRead($s_profile_path & "\tasks")
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
				Local $file = FileOpen($path_to_script & "\time", 2)
				FileWrite($file, GUICtrlRead($settings_window_edit_time))
				FileClose($file)
				$file = FileOpen($s_profile_path & "\tasks", 2)
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
						DirCreate($path_to_profiles & "\" & $Array[$i] & "\background")
						DirCreate($path_to_profiles & "\" & $Array[$i] & "\sound")
						If FileExists($path_to_profiles & "\" & $Array[$i] & "\tasks") == 0 Then

							FileWrite($path_to_profiles & "\" & $Array[$i] & "\tasks", "Настроить профиль" & @CRLF & "10:00 Начало работы")

						Else 

							FileWrite($path_to_profiles & "\" & $Array[$i] & "\tasks", "")

						EndIf
						If FileExists($path_to_profiles & "\" & $Array[$i] & "\other") == 0 Then

							FileWrite($path_to_profiles & "\" & $Array[$i] & "\other", "Бот " & @CRLF & "Чат " & @CRLF & "Ресурсы #1")

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
				ShellExecute($path_to_profiles & "\" & GUICtrlRead($profile_combo))

		EndSwitch

	WEnd
	GUIDelete($settings_window)

EndFunc

Func ProfileCreate($path)

	DirCreate($path & "\background")
	DirCreate($path & "\sound")
	FileWrite($path & "\geometry", "Разрешение 405#720" & @CRLF & "Координаты 20#235" & @CRLF & "Позиция 20#460")
	FileWrite($path & "\intervals", "Интервал I #5" & @CRLF & "Интервал II #10")
	FileWrite($path & "\other", "Бот " & @CRLF & "Чат " & @CRLF & "Ресурсы #1")
	FileWrite($path & "\tasks", "Настроить профиль" & @CRLF & "10:00 Начало работы")

EndFunc

Func Info($window)

	Local $info = "Для работы программы нужно создать свой профиль. Профилей может быть несколько, каждый со своими настройками. Для создания профиля перейти в Настройки->Профили. Написать имя профиля. Профиль в первой строке будет выбран по умолчанию при старте программы." & @CRLF & "Перезапустим настройки, выбрав профиль из выпадающего списка. Отредактируем параметры:" & @CRLF & "Прочие - Настройки телеграмм бота и ресурсов" & @CRLF & " - Бот пробел айди" & @CRLF & " - Чат пробел айди" & @CRLF & " - Ресурсы #1(об этом ниже)" & @CRLF & @CRLF & "Геометрия - задает вид окна, размер и положение надписей" & @CRLF & " - Здесь параметры задаются в пикселях в формате X#Y" & @CRLF & @CRLF & "Интервалы - интервалы времени по которым работает программа" & @CRLF & " - задается списком: Название #Время в минутах" & @CRLF & @CRLF & "Вкладки Время и Задачи можно не редактировать. Во Время записывается время старта программы, в Задачи можно написать свои задачи и напоминания. Если в задаче указать время, например 12:00, то за 10 минут до этого придет оповещение." & @CRLF & "Для старта программы нужно нажать Начнем, чтобы начать с текущего времени или можно Продолжить с ранее начатого момента" & @CRLF & @CRLF & "Программа поддерживает картинки и звуки. Стартовый фон, картинку Start.jpg положить в корень программы. Фон интервалов и звуки пронумеровать 1.jpg 1.mp3 и тд и положить в соответсвующие папки в своем профиле. Если в настройках Ресурсы #1, то картинки будут показываться в случайном порядке, если #0, то в упорядоченном."
	
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
	If $Hnum >= 24 Then

		$Hnum -= 24

	ElseIf $Hnum <= 0 Then

		$Hnum += 24

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
	ConsoleWrite(InetRead('https://api.telegram.org/' & $BotKey & '/sendMessage?chat_id=' & $ChatId & '&text=' & $sText, 0))

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