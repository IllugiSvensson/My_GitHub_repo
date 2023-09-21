#include <WindowsConstants.au3>
#include <GUIConstants.au3>
#include <ScrollBarConstants.au3>
#include <GuiEdit.au3>
#include <Array.au3>



;НАСТРОЙКИ ПРОГРАММЫ
AutoItSetOption("MustDeclareVars", 1)
Opt("TrayMenuMode", 1 + 2)
Local $priority2 = 0.8, $priority3 = 0.6
Global $Stats[10] = [1794, 34.8, 114, 34.8, 138, 43.8, 138, 39, 23.4, 46.8]
Global $hp_mult, $hpp_mult, $atk_mult, $atkp_mult, $def_mult, $defp_mult, $em_mult, $re_mult, $cr_mult, $cd_mult
Global $Hp[7] = [209, 224, 239, 254, 269, 284, 299]
Global $HppAtkp[7] = [4.1, 4.4, 4.7, 5.0, 5.3, 5.5, 5.8]
Global $Atk[7] = [14, 15, 16, 17, 18, 18, 19]
Global $DefEm[7] = [16, 17, 19, 20, 21, 22, 23]
Global $Defp[7] = [5.1, 5.5, 5.8, 6.2, 6.6, 6.9, 7.3]
Global $Re[7] = [4.5, 4.8, 5.2, 5.5, 5.8, 6.1, 6.5]
Global $Cr[7] = [2.7, 2.9, 3.1, 3.3, 3.5, 3.7, 3.9]
Global $Cd[7] = [5.4, 5.8, 6.2, 6.6, 7.0, 7.4, 7.8]
Global $count_art = 0, $checked_art = 0, $check = 0
Global $tmp = 0



Local $MainWindow = GUICreate("Оценка качества артефакта", 730, 530, -1, -1, $WS_DLGFRAME, $WS_EX_TOPMOST)

	GUICtrlCreateLabel("Приоритет            Х   1   2   3", 10, 10, 350, 40)
		GUICtrlSetFont(-1, 20, 1000)
		GUICtrlSetTip(-1, "Степень нужности стата:"  & @CRLF &  "X - не учитывать" & @CRLF & "1 - обязательный (учет 100%)" & @CRLF & "2 - нужный (учет 80%)"  & @CRLF & "3 - пригодится (учет 60%)", "", 1, 1)

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

	Global $hp_input = GUICtrlCreateCombo(" ", 110, 50, 100, 385, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_NOINTEGRALHEIGHT))
		GUICtrlSetFont(-1, 20, 1000)
		GUICtrlSetState(-1, $GUI_DISABLE)
		GenerateCombo($Hp, $hp_input)
	Global $hpp_input = GUICtrlCreateCombo(" ", 110, 90, 100, 385, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_NOINTEGRALHEIGHT))
		GUICtrlSetFont(-1, 20, 1000)
		GUICtrlSetState(-1, $GUI_DISABLE)
		GenerateCombo($HppAtkp, $hpp_input)
	Global $atk_input = GUICtrlCreateCombo(" ", 110, 130, 100, 385, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_NOINTEGRALHEIGHT))
		GUICtrlSetFont(-1, 20, 1000)
		GUICtrlSetState(-1, $GUI_DISABLE)
		GenerateCombo($Atk, $atk_input)
	Global $atkp_input = GUICtrlCreateCombo(" ", 110, 170, 100, 385, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_NOINTEGRALHEIGHT))
		GUICtrlSetFont(-1, 20, 1000)
		GUICtrlSetState(-1, $GUI_DISABLE)
		GenerateCombo($HppAtkp, $atkp_input)
	Global $def_input = GUICtrlCreateCombo(" ", 110, 210, 100, 385, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_NOINTEGRALHEIGHT))
		GUICtrlSetFont(-1, 20, 1000)
		GUICtrlSetState(-1, $GUI_DISABLE)
		GenerateCombo($DefEm, $def_input)
	Global $defp_input = GUICtrlCreateCombo(" ", 110, 250, 100, 385, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_NOINTEGRALHEIGHT))
		GUICtrlSetFont(-1, 20, 1000)
		GUICtrlSetState(-1, $GUI_DISABLE)
		GenerateCombo($Defp, $defp_input)
	Global $em_input = GUICtrlCreateCombo(" ", 110, 290, 100, 385, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_NOINTEGRALHEIGHT))
		GUICtrlSetFont(-1, 20, 1000)
		GUICtrlSetState(-1, $GUI_DISABLE)
		GenerateCombo($DefEm, $em_input)
	Global $re_input = GUICtrlCreateCombo(" ", 110, 330, 100, 385, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_NOINTEGRALHEIGHT))
		GUICtrlSetFont(-1, 20, 1000)
		GUICtrlSetState(-1, $GUI_DISABLE)
		GenerateCombo($Re, $re_input)
	Global $cr_input = GUICtrlCreateCombo(" ", 110, 370, 100, 385, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_NOINTEGRALHEIGHT))
		GUICtrlSetFont(-1, 20, 1000)
		GUICtrlSetState(-1, $GUI_DISABLE)
		GenerateCombo($Cr, $cr_input)
	Global $cd_input	= GUICtrlCreateCombo(" ", 110, 410, 100, 385, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_NOINTEGRALHEIGHT))
		GUICtrlSetFont(-1, 20, 1000)
		GUICtrlSetState(-1, $GUI_DISABLE)
		GenerateCombo($Cd, $cd_input)
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
		GUICtrlSetFont(-1, 11, 1000)
		GUICtrlSetData($log_list, "Оцениваем артефакты!" & @CRLF & "Для удобства открываем игру в оконном режиме." & @CRLF & @CRLF & "Берем артефакт 20го или 16го уровня и смотрим на доп статы. Выставляем приоритеты и величину статов на артефакте. Кликаем 'Оценка20' или 'Оценка16'(с предсказанием) и получаем качественную оценку выбранного артефакта." & @CRLF & @CRLF & "Приоритет - субъективная оценка стата по степени нужности: 1 - очень нужен, 3 - не очень нужен. Ненужные статы оставляем в 'Х'." & @CRLF & @CRLF & "Выставить на оценку можно до четырёх статов. Значения вводятся цифрами без знака '%' и через точку (для дробных значений) или выбираются из списка." & @CRLF & @CRLF & "Маленькие кнопки позволяют записать и учесть отдельные артефакты и подсчитать общую оценку экипировки.")
	Local $output_label = GUICtrlCreateLabel("", 370, 415, 350, 35, $SS_CENTER, $SS_CENTERIMAGE)
		GUICtrlSetFont(-1, 17, 1000)

	Local $check_button = GUICtrlCreateButton("Оценка20", 5, 460, 123, 35)
		GUICtrlSetFont(-1, 18, 1000)
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlSetTip(-1, "Оценить артефакт 20го уровня", "", 1, 1)
	Local $predict_button = GUICtrlCreateButton("Оценка16", 128, 460, 123, 35)
		GUICtrlSetFont(-1, 18, 1000)
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlSetTip(-1, "Оценить артефакт 16го уровня с предсказанием" & @CRLF & "Будет предсказана самая наилучшая оценка" & @CRLF & "если прокачать артефакт до 20го уровня", "", 1, 1)
	Local $tmp_button = GUICtrlCreateButton("💾", 251, 460, 35, 35)
		GUICtrlSetFont(-1, 18, 1000)
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlSetTip(-1, "Записать оценку артефакта для учета", "", 1, 1)
	Global $result_button = GUICtrlCreateButton("✅", 286, 460, 35, 35)
		GUICtrlSetFont(-1, 18, 1000)
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlSetTip(-1, "Учесть артефакт для оценки экипировки" & @CRLF & "Учитывается последовательно 5 артефактов", "", 1, 1)
	Global $clean_result = GUICtrlCreateButton("❌", 321, 460, 35, 35)
		GUICtrlSetFont(-1, 18, 1000)
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlSetTip(-1, "Сбросить оценку экипировки", "", 1, 1)
	Local $clear_button = GUICtrlCreateButton("Сброс", 356, 460, 123, 35)
		GUICtrlSetFont(-1, 18, 1000)
		GUICtrlSetTip(-1, "Сбросить введенные данные и слайдеры", "", 1, 1)
	Local $log_button = GUICtrlCreateButton("Очистить", 479, 460, 123, 35)
		GUICtrlSetFont(-1, 18, 1000)
		GUICtrlSetTip(-1, "Удалить записи лога безвозвратно", "", 1, 1)
	Local $exit_button = GUICtrlCreateButton("Выход", 602, 460, 123, 35)
		GUICtrlSetFont(-1, 18, 1000)
		GUICtrlSetTip(-1, "Выйти из программы", "", 1, 1)

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
				Check(0)
				GUICtrlSetState($check_button, $GUI_DISABLE)
				GUICtrlSetState($predict_button, $GUI_DISABLE)

			Case $predict_button
				Check(0)
				GUICtrlSetState($check_button, $GUI_DISABLE)
				GUICtrlSetState($predict_button, $GUI_DISABLE)

			Case $tmp_button
				Result(1)

			Case $result_button
				Result(0)

			Case $clean_result
				$count_art = 0
				$checked_art = 0
				$check = 0
				GUICtrlSetData($log_list, GUICtrlRead($log_list) & @CRLF & "Учет сброшен!" & @CRLF)
				_GUICtrlEdit_Scroll($log_list, $SB_BOTTOM)

			Case $clear_button
				For $i = 0 To 9
					GUICtrlSetData($input_array[$i], " ")
					GUICtrlSetState($input_array[$i], $GUI_DISABLE)
					GUICtrlSetData($slider_array[$i], 0)
					GUICtrlSetState($slider_array[$i], $GUI_ENABLE)
				Next
				GUICtrlSetState($check_button, $GUI_DISABLE)
				GUICtrlSetState($predict_button, $GUI_DISABLE)
				GUICtrlSetBkColor($output_label, $GUI_BKCOLOR_TRANSPARENT)
				GUICtrlSetData($output_label, "")

			Case $log_button
				GUICtrlSetData($log_list, "")

			Case $exit_button
				Exit 0

		EndSwitch

	WEnd

Func GenerateCombo($Stat, $Combo)

	Local $List, $temp
	For $i = 0 To 6

		For $j = 1 To 6

			$List &= $Stat[$i] * $j & ' '

		Next

	Next

	$List = StringSplit($List, ' ', 2)
	For $i = 0 To 41

		For $j = 0 To 40

			If Int($List[$j]) > Int($List[$j + 1]) Then

				$temp = $List[$j]
				$List[$j] = $List[$j + 1]
				$List[$j + 1] = $temp

			EndIf

		Next

	Next

	_ArrayDelete($List, 5)
	_ArrayDelete($List, 3)
	_ArrayDelete($List, 1)
	For $i = 0 To 38

		GUICtrlSetData($Combo, $List[$i], " ")

	Next

EndFunc

Func Check($flg)

	Local $flag = 0
	For $i = 0 To 9

		If GUICtrlRead($slider_array[$i]) <> 0 Then

			If StringRegExp(GUICtrlRead($input_array[$i]), "^([0-9]{1,4})$|^([0-9]{1,2}\.[0-9]{1})$", 0) == 0 Then
				GUICtrlSetData($log_list, GUICtrlRead($log_list) & @CRLF & "Неправильный символ: " & GUICtrlRead($label_array[$i]) & @CRLF)
				_GUICtrlEdit_Scroll($log_list, $SB_BOTTOM)
				$flag = 0
				ExitLoop
			ElseIf $Stats[$i] < GUICtrlRead($input_array[$i]) Then
				GUICtrlSetData($log_list, GUICtrlRead($log_list) & @CRLF & "Превышение значения: " & GUICtrlRead($label_array[$i]) & @CRLF)
				_GUICtrlEdit_Scroll($log_list, $SB_BOTTOM)
				$flag = 0
				ExitLoop
			Else
				$flag = 1
			EndIf

		EndIf

	Next

	Local $summary = 0, $current = 0, $cnt = 0
	Local $res = 1
	Local $mult_array[10] = [$hp_mult, $hpp_mult, $atk_mult, $atkp_mult, $def_mult, $defp_mult, $em_mult, $re_mult, $cr_mult, $cd_mult]
	If $flag == 1 Then

		For $i = 0 To 9

			If GUICtrlRead($slider_array[$i]) <> 0 Then

				$current = GUICtrlRead($input_array[$i]) * (100 / $Stats[$i]) * $mult_array[$i]
				$summary += $current
				$cnt += 1
				GUICtrlSetData($log_list, GUICtrlRead($log_list) & @CRLF & GUICtrlRead($label_array[$i]) & ": " & GUICtrlRead($input_array[$i]) & " - " & Round($current / $res, 2) & "%")

			EndIf

		Next
		If $cnt == 4 Then $res = 1.5
		If $cnt == 3 Then $res = 1.3334
		If $cnt == 2 Then $res = 1.1667
		If Round($summary / $res, 2) > 100 Then
			GUICtrlSetData($log_list, GUICtrlRead($log_list) & @CRLF & "Итого: Ошибка в величине статов" & @CRLF)
		Else
			GUICtrlSetData($log_list, GUICtrlRead($log_list) & @CRLF & "Итого: " & Round($summary / $res, 2) & @CRLF)
		EndIf
		_GUICtrlEdit_Scroll($log_list, $SB_BOTTOM)
		Quality(Round($summary / $res))
		$checked_art = Round($summary / $res)

	EndIf
	For $i = 0 To 9

		GUICtrlSetData($slider_array[$i], 0)
		GUICtrlSetState($input_array[$i], $GUI_DISABLE)

	Next

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
		GUICtrlSetState($predict_button, $GUI_ENABLE)
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

Func Result($flg)

	If $flg == 0 Then

		If $count_art < 5 And $checked_art <> 0 Then

			$count_art += 1
			$check = $check + $checked_art
			$checked_art = 0
			GUICtrlSetData($log_list, GUICtrlRead($log_list) & @CRLF & "Артефакт учтён, количество: " & $count_art & @CRLF & "Сумма: " & $check & @CRLF)
			_GUICtrlEdit_Scroll($log_list, $SB_BOTTOM)
			GUICtrlSetBkColor($tmp_button, $GUI_BKCOLOR_TRANSPARENT)
				If $count_art == 5 Then

					Quality($check / 5)
					$check = 0
					$count_art = 0

				EndIf

		Else

			GUICtrlSetData($log_list, GUICtrlRead($log_list) & @CRLF & "Оцените артефакт!" & @CRLF)
			_GUICtrlEdit_Scroll($log_list, $SB_BOTTOM)

		EndIf

	ElseIf $flg == 1 Then

		If $checked_art <> 0 Then

			$tmp = $checked_art
			GUICtrlSetData($log_list, GUICtrlRead($log_list) & @CRLF & "Артефакт Записан: " & $tmp & @CRLF)
			_GUICtrlEdit_Scroll($log_list, $SB_BOTTOM)
			GUICtrlSetBkColor($tmp_button, 0x80FF00)

		Else

			GUICtrlSetData($log_list, GUICtrlRead($log_list) & @CRLF & "Оцените артефакт!" & @CRLF)
			_GUICtrlEdit_Scroll($log_list, $SB_BOTTOM)

		EndIf

	EndIf

EndFunc