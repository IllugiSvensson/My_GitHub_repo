#include <WindowsConstants.au3>
#include <GUIConstants.au3>
#include <ScrollBarConstants.au3>
#include <GuiEdit.au3>



;НАСТРОЙКИ ПРОГРАММЫ
AutoItSetOption("MustDeclareVars", 1)
Opt("TrayMenuMode", 1 + 2)
Local $priority2 = 0.85, $priority3 = 0.7
Global $Stats[10] = [1794, 34.8, 114, 34.8, 138, 43.8, 138, 39, 23.4, 46.8]



Local $MainWindow = GUICreate("Оценка качества артефакта", 730, 530, -1, -1, $WS_DLGFRAME, $WS_EX_TOPMOST)

	GUICtrlCreateLabel("Приоритет            Х   1   2   3", 10, 10, 480, 40)
		GUICtrlSetFont(-1, 20, 1000)

	Local $hp_label = GUICtrlCreateLabel("ХП", 10, 50, 100, 40)
		GUICtrlSetFont(-1, 20, 1000)
	Local $hpp_label = GUICtrlCreateLabel("ХП%", 10, 90, 100, 40)
		GUICtrlSetFont(-1, 20, 1000)
	Local $atk_label = GUICtrlCreateLabel("ATK", 10, 130, 100, 40)
		GUICtrlSetFont(-1, 20, 1000)
	Local $atkp_label = GUICtrlCreateLabel("ATK%", 10, 170, 100, 40)
		GUICtrlSetFont(-1, 20, 1000)
	Local $def_label = GUICtrlCreateLabel("ЗАЩ", 10, 210, 100, 40)
		GUICtrlSetFont(-1, 20, 1000)
	Local $defp_label = GUICtrlCreateLabel("ЗАЩ%", 10, 250, 100, 40)
		GUICtrlSetFont(-1, 20, 1000)
	Local $em_label = GUICtrlCreateLabel("МС", 10, 290, 100, 40)
		GUICtrlSetFont(-1, 20, 1000)
	Local $re_label = GUICtrlCreateLabel("ВЭ", 10, 330, 100, 40)
		GUICtrlSetFont(-1, 20, 1000)
	Local $cr_label = GUICtrlCreateLabel("КШ", 10, 370, 100, 40)
		GUICtrlSetFont(-1, 20, 1000)
	Local $cd_label	= GUICtrlCreateLabel("КУ", 10, 410, 100, 40)
		GUICtrlSetFont(-1, 20, 1000)
	Local $label_array[10] = [$hp_label, $hpp_label, $atk_label, $atkp_label, $def_label, $defp_label, $em_label, $re_label, $cr_label, $cd_label]

	Global $hp_input = GUICtrlCreateInput("", 110, 50, 100, 40)
		GUICtrlSetFont(-1, 20, 1000)
		GUICtrlSetState(-1, $GUI_DISABLE)
	Global $hpp_input = GUICtrlCreateInput("", 110, 90, 100, 40)
		GUICtrlSetFont(-1, 20, 1000)
		GUICtrlSetState(-1, $GUI_DISABLE)
	Global $atk_input = GUICtrlCreateInput("", 110, 130, 100, 40)
		GUICtrlSetFont(-1, 20, 1000)
		GUICtrlSetState(-1, $GUI_DISABLE)
	Global $atkp_input = GUICtrlCreateInput("", 110, 170, 100, 40)
		GUICtrlSetFont(-1, 20, 1000)
		GUICtrlSetState(-1, $GUI_DISABLE)
	Global $def_input = GUICtrlCreateInput("", 110, 210, 100, 40)
		GUICtrlSetFont(-1, 20, 1000)
		GUICtrlSetState(-1, $GUI_DISABLE)
	Global $defp_input = GUICtrlCreateInput("", 110, 250, 100, 40)
		GUICtrlSetFont(-1, 20, 1000)
		GUICtrlSetState(-1, $GUI_DISABLE)
	Global $em_input = GUICtrlCreateInput("", 110, 290, 100, 40)
		GUICtrlSetFont(-1, 20, 1000)
		GUICtrlSetState(-1, $GUI_DISABLE)
	Global $re_input = GUICtrlCreateInput("", 110, 330, 100, 40)
		GUICtrlSetFont(-1, 20, 1000)
		GUICtrlSetState(-1, $GUI_DISABLE)
	Global $cr_input = GUICtrlCreateInput("", 110, 370, 100, 40)
		GUICtrlSetFont(-1, 20, 1000)
		GUICtrlSetState(-1, $GUI_DISABLE)
	Global $cd_input	= GUICtrlCreateInput("", 110, 410, 100, 40)
		GUICtrlSetFont(-1, 20, 1000)
		GUICtrlSetState(-1, $GUI_DISABLE)
	Global $input_array[10] = [$hp_input, $hpp_input, $atk_input, $atkp_input, $def_input, $defp_input, $em_input, $re_input, $cr_input, $cd_input]

	Global $hp_slider = GUICtrlCreateSlider(220, 55, 140, 30)
		GUICtrlSetLimit(-1, 3, 0)
		GUICtrlSetData($hp_slider, 0)
	Global $hpp_slider = GUICtrlCreateSlider(220, 95, 140, 30)
		GUICtrlSetLimit(-1, 3, 0)
		GUICtrlSetData($hpp_slider, 0)
	Global $atk_slider = GUICtrlCreateSlider(220, 135, 140, 30)
		GUICtrlSetLimit(-1, 3, 0)
		GUICtrlSetData($atk_slider, 0)
	Global $atkp_slider = GUICtrlCreateSlider(220, 175, 140, 30)
		GUICtrlSetLimit(-1, 3, 0)
		GUICtrlSetData($atkp_slider, 0)
	Global $def_slider = GUICtrlCreateSlider(220, 215, 140, 30)
		GUICtrlSetLimit(-1, 3, 0)
		GUICtrlSetData($def_slider, 0)
	Global $defp_slider = GUICtrlCreateSlider(220, 255, 140, 30)
		GUICtrlSetLimit(-1, 3, 0)
		GUICtrlSetData($defp_slider, 0)
	Global $em_slider = GUICtrlCreateSlider(220, 295, 140, 30)
		GUICtrlSetLimit(-1, 3, 0)
		GUICtrlSetData($em_slider, 0)
	Global $re_slider = GUICtrlCreateSlider(220, 335, 140, 30)
		GUICtrlSetLimit(-1, 3, 0)
		GUICtrlSetData($re_slider, 0)
	Global $cr_slider = GUICtrlCreateSlider(220, 375, 140, 30)
		GUICtrlSetLimit(-1, 3, 0)
		GUICtrlSetData($cr_slider, 0)
	Global $cd_slider = GUICtrlCreateSlider(220, 415, 140, 30)
		GUICtrlSetLimit(-1, 3, 0)
		GUICtrlSetData($cd_slider, 0)
	Global $slider_array[10] = [$hp_slider, $hpp_slider, $atk_slider, $atkp_slider, $def_slider, $defp_slider, $em_slider, $re_slider, $cr_slider, $cd_slider]

	Local $log_list = GUICtrlCreateEdit("", 370, 10, 350, 405, $ES_MULTILINE + $WS_VSCROLL + $ES_WANTRETURN)
		GUICtrlSetFont(-1, 12, 1000)
		GUICtrlSetData($log_list, "Оцениваем артефакты!" & @CRLF & "Смотрим на статы в артефакте, кликаем на галочки приоритетов: Х - стат не нужен, 1 - очень нужен и тд. В открытом поле вводим значение стата числом (для дроби через точку) и жмем 'Оценить'. Для удобства игру лучше открыть в оконном режиме" & @CRLF & @CRLF)

	Local $output_label = GUICtrlCreateLabel("", 370, 415, 350, 35, $SS_CENTER, $SS_CENTERIMAGE)
		GUICtrlSetFont(-1, 17, 1000)

	Local $check_button = GUICtrlCreateButton("Оценить", 10, 460, 116, 35)
		GUICtrlSetFont(-1, 18, 1000)
		GUICtrlSetState(-1, $GUI_DISABLE)
	Local $clear_button = GUICtrlCreateButton("Сброс", 126, 460, 116, 35)
		GUICtrlSetFont(-1, 18, 1000)
	Local $exit_button = GUICtrlCreateButton("Выход", 242, 460, 116, 35)
		GUICtrlSetFont(-1, 18, 1000)
	Local $log_button = GUICtrlCreateButton("Очистить", 400, 460, 135, 35)
		GUICtrlSetFont(-1, 18, 1000)
	Local $save_button = GUICtrlCreateButton("Сохранить", 555, 460, 135, 35)
		GUICtrlSetFont(-1, 18, 1000)

	Global $hp_mult, $hpp_mult, $atk_mult, $atkp_mult, $def_mult, $defp_mult, $em_mult, $re_mult, $cr_mult, $cd_mult

GUICtrlSetState($exit_button, $GUI_FOCUS)
GUISetState()
	While true

		Switch GUIGetMsg()

			Case $hp_slider
				$hp_mult = CheckSlider($hp_slider, $hp_input)

			Case $hpp_slider
				$hpp_mult = CheckSlider($hpp_slider, $hpp_input)

			Case $atk_slider
				$atk_mult = CheckSlider($atk_slider, $atk_input)

			Case $atkp_slider
				$atkp_mult = CheckSlider($atkp_slider, $atkp_input)

			Case $def_slider
				$def_mult = CheckSlider($def_slider, $def_input)

			Case $defp_slider
				$defp_mult = CheckSlider($defp_slider, $defp_input)

			Case $em_slider
				$em_mult = CheckSlider($em_slider, $em_input)

			Case $re_slider
				$re_mult = CheckSlider($re_slider, $re_input)

			Case $cr_slider
				$cr_mult = CheckSlider($cr_slider, $cr_input)

			Case $cd_slider
				$cd_mult = CheckSlider($cd_slider, $cd_input)

			Case $check_button
				Check()

			Case $clear_button
				For $i = 0 To 9
					GUICtrlSetData($input_array[$i], "")
					GUICtrlSetState($input_array[$i], $GUI_DISABLE)
					GUICtrlSetData($slider_array[$i], 0)
					GUICtrlSetState($slider_array[$i], $GUI_ENABLE)
				Next
				GUICtrlSetState($check_button, $GUI_DISABLE)
				GUICtrlSetBkColor($output_label, $GUI_BKCOLOR_TRANSPARENT)
				GUICtrlSetData($output_label, "")

			Case $exit_button
				Exit 0

			Case $log_button
				GUICtrlSetData($log_list, "")

			Case $save_button
				FileWrite(@DesktopDir & "\ArtifactQualityChecker.log", GUICtrlRead($log_list))

		EndSwitch

	WEnd



Func Check()

	Local $flag = 0
	For $i = 0 To 9

		If GUICtrlRead($slider_array[$i]) <> 0 Then

			If StringRegExp(GUICtrlRead($input_array[$i]), "^([0-9]{1,4})$|^([0-9]{1,2}\.[0-9]{1})$", 0) == 0 Then
				GUICtrlSetData($log_list, GUICtrlRead($log_list) & @CRLF & "Неправильный символ в: " & GUICtrlRead($label_array[$i]) & @CRLF)
				_GUICtrlEdit_Scroll($log_list, $SB_BOTTOM)
				$flag = 0
				ExitLoop
			ElseIf $Stats[$i] < GUICtrlRead($input_array[$i]) Then
				GUICtrlSetData($log_list, GUICtrlRead($log_list) & @CRLF & "Превышение значения в: " & GUICtrlRead($label_array[$i]) & @CRLF)
				_GUICtrlEdit_Scroll($log_list, $SB_BOTTOM)
				$flag = 0
				ExitLoop
			Else
				$flag = 1
			EndIf

		EndIf

	Next

	Local $summary = 0, $current = 0
	Local $mult_array[10] = [$hp_mult, $hpp_mult, $atk_mult, $atkp_mult, $def_mult, $defp_mult, $em_mult, $re_mult, $cr_mult, $cd_mult]
	If $flag == 1 Then

		For $i = 0 To 9

			If GUICtrlRead($slider_array[$i]) <> 0 Then

				$current = GUICtrlRead($input_array[$i]) * (100 / $Stats[$i]) * $mult_array[$i]
				$summary += $current
				GUICtrlSetData($log_list, GUICtrlRead($log_list) & @CRLF & GUICtrlRead($label_array[$i]) & ": " & GUICtrlRead($input_array[$i]) & " - " & Round($current / 1.5, 2) & "%")

			EndIf

		Next
		If Round($summary / 1.5, 2) > 100 Then
			GUICtrlSetData($log_list, GUICtrlRead($log_list) & @CRLF & "Итого: Ошибка в величине статов" & @CRLF)
		Else
			GUICtrlSetData($log_list, GUICtrlRead($log_list) & @CRLF & "Итого: " & Round($summary / 1.5, 2) & @CRLF)
		EndIf
		_GUICtrlEdit_Scroll($log_list, $SB_BOTTOM)
		Quality(Round($summary / 1.5))

	EndIf

EndFunc

Func CheckSlider($slider, $input)

	Local $cnt_checked = 0
	For $i = 0 To 9

		If GUICtrlRead($slider_array[$i]) == 0 Then $cnt_checked += 1

	Next

	If $cnt_checked < 6 Then
		GUICtrlSetState($slider, $GUI_DISABLE)
		GUICtrlSetData($slider, 0)
			For $i = 0 To 9
				If GUICtrlRead($slider_array[$i]) == 0 Then GUICtrlSetState($slider_array[$i], $GUI_DISABLE)
			Next
	Else
		GUICtrlSetState($check_button, $GUI_ENABLE)
		GUICtrlSetState($input, $GUI_ENABLE)
		GUICtrlSetState($slider, $GUI_ENABLE)
			For $i = 0 To 9
				If GUICtrlRead($slider_array[$i]) == 0 Then GUICtrlSetState($slider_array[$i], $GUI_ENABLE)
			Next
	EndIf

	If GUICtrlRead($slider) == 0 Then
		GUICtrlSetState($input, $GUI_DISABLE)
	ElseIf GUICtrlRead($slider) == 1 Then
		Return 1
	ElseIf GUICtrlRead($slider) == 2 Then
		Return $priority2
	ElseIf GUICtrlRead($slider) == 3 Then
		Return $priority3
	EndIf

EndFunc

Func Quality($value)

	If $value > 100 Then
		GUICtrlSetData($output_label, "Ошибка в величине статов!")
		GUICtrlSetBkColor ($output_label, 0xFF0000)
	ElseIf $value >= 90 Then
		GUICtrlSetData($output_label, "Качество: " & $value & "% Превосходное!")
		GUICtrlSetBkColor ($output_label, 0x00FF00)
	ElseIf $value >= 70 Then
		GUICtrlSetData($output_label, "Качество: " & $value & "% Отличное!")
		GUICtrlSetBkColor ($output_label, 0x80FF00)
	ElseIf $value >= 50 Then
		GUICtrlSetData($output_label, "Качество: " & $value & "% Среднее")
		GUICtrlSetBkColor ($output_label, 0xFFFF00)
	ElseIf $value >= 30 Then
		GUICtrlSetData($output_label, "Качество: " & $value & "% Плохое")
		GUICtrlSetBkColor ($output_label, 0xFF8000)
	Else
		GUICtrlSetData($output_label, "Качество: " & $value & "% Ужасное")
		GUICtrlSetBkColor ($output_label, 0xFF0000)
	EndIf

EndFunc