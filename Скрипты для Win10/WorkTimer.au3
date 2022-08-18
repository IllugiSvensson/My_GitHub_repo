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
Global $past = 0
Global $name = "Таймер"
Global $duration = 60



;СТАРТ ОКНО И ВЫХОД К ДРУГИМ ОКНАМ
Local $start_window = GUICreate("Таймер Задач", 500, 750, -1, -1, $WS_DLGFRAME)
	GUICtrlCreatePic($path_to_script & "\Start.jpg", 0, 0, 500, 750)
	GUICtrlSetState(-1, $GUI_DISABLE)

	Local $start_window_label = GUICtrlCreateLabel("Начнем работу?", 75, 225, 350, 50, $SS_CENTER)
		GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
		GUICtrlSetFont(-1, 25, 1000)
	Local $start_button = GUICtrlCreateButton("Начнем", 162, 285, 175, 50)
		GUICtrlSetFont(-1, 20, 1000)
	Local $continue_button = GUICtrlCreateButton("Продолжить", 162, 335, 175, 50)
		GUICtrlSetFont(-1, 20, 1000)
	Local $settings_button = GUICtrlCreateButton("Настройки", 162, 385, 175, 50)
		GUICtrlSetFont(-1, 20, 1000)
	Local $exit_button = GUICtrlCreateButton("Выход", 162, 435, 175, 50)
		GUICtrlSetFont(-1, 20, 1000)
	Local $profile_combo = GUICtrlCreateCombo("", 162, 680, 175, 50, $CBS_DROPDOWNLIST + $WS_VSCROLL)
		GUICtrlSetFont(-1, 20, 1000)
		Dim $Array
		_FileReadToArray($path_to_script & "\_profiles", $Array)
		For $i = 1 To $Array[0]

			GUICtrlSetData($profile_combo, $Array[$i], $Array[1])

		Next

GUISetState()
While true

	Switch GUIGetMsg()

		Case $start_button
			Local $file = FileOpen($path_to_script & "\time", 2)
			FileWrite($file, _NowCalc())
			FileClose($file)
			Global $start_time = _NowCalc()
			ExitLoop

		Case $continue_button
			Global $start_time = FileRead($path_to_script & "\time")
			ExitLoop

		Case $settings_button
			Settings($start_window, $profile_path & "\" & GUICtrlRead($profile_combo))

		Case $exit_button
			Exit 0

	EndSwitch

WEnd
$profile_path = $profile_path & "\" & GUICtrlRead($profile_combo)
$path_to_background = $profile_path & "\background"
$path_to_sound = $profile_path & "\sound"
GUIDelete($start_window)



;ЗАЧИТЫВАНИЕ НАСТРОЕК
Global $tele_bot_key = StringTrimLeft(FileReader($profile_path & "\other", "Бот"), 4)
Global $tele_chat_id = StringTrimLeft(FileReader($profile_path & "\other", "Чат"), 4)
Global $resolution_x = StringRegExpReplace(StringTrimLeft(FileReader($profile_path & "\geometry", "Разрешение"), 11), "#[0-9]{2,4}", "")
Global $resolution_y = StringRegExpReplace(StringTrimLeft(FileReader($profile_path & "\geometry", "Разрешение"), 11), "[0-9]{2,4}#", "")
Global $coordinate_x = StringRegExpReplace(StringTrimLeft(FileReader($profile_path & "\geometry", "Координаты"), 11), "#[0-9]{2,4}", "")
Global $coordinate_y = StringRegExpReplace(StringTrimLeft(FileReader($profile_path & "\geometry", "Координаты"), 11), "[0-9]{2,4}#", "")
Global $position_x = StringRegExpReplace(StringTrimLeft(FileReader($profile_path & "\geometry", "Позиция"), 8), "#[0-9]{2,4}", "")
Global $position_y = StringRegExpReplace(StringTrimLeft(FileReader($profile_path & "\geometry", "Позиция"), 8), "[0-9]{2,4}#", "")



;СТАРТ ИНТЕРВАЛОВ ВРЕМЕНИ
Global $continue_time = _DateDiff("n", $start_time, _NowCalc())
Global $sum_intervals = 0
Local $file = FileRead($profile_path & "\intervals")
Local $lines = StringSplit($file, @CRLF, 1)
	For $i = 1 To $lines[0]

		Local $number = StringRegExp($lines[$i], "#[0-9]{1,3}", 3)
		$number = StringTrimLeft($number[0], 1)
		$sum_intervals = $sum_intervals + $number

	Next
For $i = 1 To $lines[0]

	
	Local $number = StringRegExp($lines[$i], "#[0-9]{1,3}", 3)
	$duration = StringTrimLeft($number[0], 1)
	$name = StringReplace($lines[$i], $number[0], "")
	IntervalGUI($past, $name, $duration, $path_to_sound & "\" & $i & ".mp3", $profile_path)
	$past = $past + $duration

Next





Func IntervalGUI($s_past, $s_name, $s_duration, $s_sound, $s_profile_path)

	If $continue_time < $s_duration Then

		Local $continue = $continue_time
		$continue_time = 0
		Local $interval_window = GUICreate("Таймер Задач", $resolution_x, $resolution_y, $coordinate_x, $coordinate_y, $WS_DLGFRAME + $WS_MINIMIZEBOX)
			Local $pic_count = DirGetSize($path_to_background, 1)
			GUICtrlCreatePic($path_to_background & "\" & Random(1, $pic_count[1], 1) & ".jpg", 0, 0, $resolution_x, $resolution_y)
			GUICtrlSetState(-1, $GUI_DISABLE)

			Local $interval_window_time_label = GUICtrlCreateLabel(_NowTime(), $position_x, $position_y, 350, 55)
				GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
				GUICtrlSetFont(-1, 26, 1000)
			Local $interval_window_common_progress = GUICtrlCreateProgress($position_x, $position_y + 40, 365, 30, $PBS_SMOOTH)
			Local $interval_window_name_label = GUICtrlCreateLabel($s_name, $position_x, $position_y + 70, 350, 55)
				GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
				GUICtrlSetFont(-1, 32, 1000)
			Local $interval_window_remain_label = GUICtrlCreateLabel("0 из " & $s_duration & " минут", $position_x, $position_y + 145, 350, 40, $SS_LEFT)
				GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
				GUICtrlSetFont(-1, 26, 1000)
			Local $interval_window_local_progress = GUICtrlCreateProgress($position_x, $position_y + 115, 365, 30, $PBS_SMOOTH)
			Local $interval_window_exit_button = GUICtrlCreateButton("Выход", $position_x, $position_y + 190, 110, 30, $BS_CENTER)
				GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
				GUICtrlSetFont(-1, 14, 1000)
			Local $interval_window_task_button = GUICtrlCreateButton("Задачи", $position_x + 255, $position_y + 190, 110, 30, $BS_CENTER)
				GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
				GUICtrlSetFont(-1, 14, 1000)

		GUISetState()

			SoundPlay("")
			SoundPlay($s_sound)
			BotMsg("✅➡️" & $s_name, $tele_bot_key, $tele_chat_id)
			Local $go_time = _NowCalc()
			While true

				Switch GUIGetMsg()

					Case $interval_window_exit_button
						Exit 0

					Case $interval_window_task_button
						Tasks($interval_window, $s_profile_path)

					Case Else
						Local $stm = _DateDiff("n", $start_time, _NowCalc())
						Local $gtm = _DateDiff("n", $go_time, _NowCalc())
						GUICtrlSetData($interval_window_common_progress, (100 / $sum_intervals) * $stm)
						GUICtrlSetData($interval_window_time_label, _NowTime() & "   " & abs($sum_intervals - $gtm - $s_past - $continue) & "   " & TimeCalc(_NowTime(4), abs($sum_intervals - $gtm - $s_past - $continue), 0))
						GUICtrlSetData($interval_window_local_progress, (100 / $s_duration) * $gtm + $continue * (100 / $s_duration))
						GUICtrlSetData($interval_window_remain_label, $gtm + $continue & " из " & $s_duration & " минут")
						If StringInStr(FileRead($s_profile_path & "\tasks"), TimeCalc(_NowTime(4), 10, 0)) <> 0 Then

							BotMsg("⚠️➡️" & "Событие через 10 минут!", $tele_bot_key, $tele_chat_id)
							SoundPlay("")
							SoundPlay($s_sound)
							Tasks($interval_window)

						EndIf
						If $gtm + $continue >= $s_duration Then ExitLoop
						sleep(50)

				EndSwitch

			WEnd

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
				Switch GUICtrlRead($settings_tab)

					Case 0
						Local $file = FileOpen($path_to_script & "\time", 2)
						FileWrite($file, GUICtrlRead($settings_window_edit_time))
						FileClose($file)
						MsgBox(64, "Таймер Задач", "Сохранено", 3, $settings_window)

					Case 1
						Local $file = FileOpen($s_profile_path & "\tasks", 2)
						FileWrite($file, GUICtrlRead($settings_window_edit_tasks))
						FileClose($file)
						MsgBox(64, "Таймер Задач", "Сохранено", 3, $settings_window)

					Case 2
						Local $file = FileOpen($s_profile_path & "\intervals", 2)
						FileWrite($file, GUICtrlRead($settings_window_edit_intervals))
						FileClose($file)
						MsgBox(64, "Таймер Задач", "Сохранено", 3, $settings_window)

					Case 3
						Local $file = FileOpen($s_profile_path & "\geometry", 2)
						FileWrite($file, GUICtrlRead($settings_window_edit_geometry))
						FileClose($file)
						MsgBox(64, "Таймер Задач", "Сохранено", 3, $settings_window)

					Case 4
						Local $file = FileOpen($s_profile_path & "\other", 2)
						FileWrite($file, GUICtrlRead($settings_window_edit_other))
						FileClose($file)
						MsgBox(64, "Таймер Задач", "Сохранено", 3, $settings_window)

					Case 5
						Local $file = FileOpen($path_to_script & "\_profiles", 2)
						FileWrite($file, GUICtrlRead($settings_window_edit_profiles))
						FileClose($file)
						MsgBox(64, "Таймер Задач", "Сохранено", 3, $settings_window)
						GUICtrlSetData($profile_combo, "")
						Dim $Array
						_FileReadToArray($path_to_script & "\_profiles", $Array)
						For $i = 1 To $Array[0]

							GUICtrlSetData($profile_combo, $Array[$i], $Array[1])
							DirCreate($path_to_profiles & "\" & $Array[$i])
							DirCreate($path_to_profiles & "\" & $Array[$i] & "\background")
							DirCreate($path_to_profiles & "\" & $Array[$i] & "\sound")
							FileWrite($path_to_profiles & "\" & $Array[$i] & "\tasks", "")
							FileWrite($path_to_profiles & "\" & $Array[$i] & "\other", "")
							FileWrite($path_to_profiles & "\" & $Array[$i] & "\intervals", "")
							FileWrite($path_to_profiles & "\" & $Array[$i] & "\geometry", "")

						Next

				EndSwitch

			Case $settings_window_exit_button
				ExitLoop

		EndSwitch

	WEnd
	GUIDelete($settings_window)

EndFunc

Func TimeCalc($now, $num, $op)

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