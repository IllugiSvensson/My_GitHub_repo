#include <WindowsConstants.au3>
#include <GUIConstants.au3>
#include <ScrollBarConstants.au3>
#include <GuiEdit.au3>

;#include <StaticConstants.au3>
;#include <ButtonConstants.au3>
;#include <EditConstants.au3>
;#include <Array.au3>
;#include <File.au3>



;НАСТРОЙКИ ПРОГРАММЫ
AutoItSetOption("MustDeclareVars", 1)
Opt("TrayMenuMode", 1 + 2)
Local $priority2 = 0.85, $priority3 = 0.7
Global $Stats[10] = [1794, 34.8, 114, 34.8, 138, 43.8, 138, 39, 23.4, 46.8]



Local $MainWindow = GUICreate("Оценка качества артефакта", 730, 530, -1, -1, $WS_DLGFRAME, $WS_EX_TOPMOST)

	GUICtrlCreateLabel("Приоритет            Х  1  2  3", 10, 10, 480, 40)
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

	GUIStartGroup()
		Global $hp_radio_no = GUICtrlCreateRadio("", 230, 55, 30, 30)
		Global $hp_radio_1 = GUICtrlCreateRadio("", 260, 55, 30, 30)
		Global $hp_radio_2 = GUICtrlCreateRadio("", 290, 55, 30, 30)
		Global $hp_radio_3 = GUICtrlCreateRadio("", 320, 55, 30, 30)
	GUIStartGroup()
		Global $hpp_radio_no = GUICtrlCreateRadio("", 230, 95, 30, 30)
		Global $hpp_radio_1 = GUICtrlCreateRadio("", 260, 95, 30, 30)
		Global $hpp_radio_2 = GUICtrlCreateRadio("", 290, 95, 30, 30)
		Global $hpp_radio_3 = GUICtrlCreateRadio("", 320, 95, 30, 30)
	GUIStartGroup()
		Global $atk_radio_no = GUICtrlCreateRadio("", 230, 135, 30, 30)
		Global $atk_radio_1 = GUICtrlCreateRadio("", 260, 135, 30, 30)
		Global $atk_radio_2 = GUICtrlCreateRadio("", 290, 135, 30, 30)
		Global $atk_radio_3 = GUICtrlCreateRadio("", 320, 135, 30, 30)
	GUIStartGroup()
		Global $atkp_radio_no = GUICtrlCreateRadio("", 230, 175, 30, 30)
		Global $atkp_radio_1 = GUICtrlCreateRadio("", 260, 175, 30, 30)
		Global $atkp_radio_2 = GUICtrlCreateRadio("", 290, 175, 30, 30)
		Global $atkp_radio_3 = GUICtrlCreateRadio("", 320, 175, 30, 30)
	GUIStartGroup()
		Global $def_radio_no = GUICtrlCreateRadio("", 230, 215, 30, 30)
		Global $def_radio_1 = GUICtrlCreateRadio("", 260, 215, 30, 30)
		Global $def_radio_2 = GUICtrlCreateRadio("", 290, 215, 30, 30)
		Global $def_radio_3 = GUICtrlCreateRadio("", 320, 215, 30, 30)
	GUIStartGroup()
		Global $defp_radio_no = GUICtrlCreateRadio("", 230, 255, 30, 30)
		Global $defp_radio_1 = GUICtrlCreateRadio("", 260, 255, 30, 30)
		Global $defp_radio_2 = GUICtrlCreateRadio("", 290, 255, 30, 30)
		Global $defp_radio_3 = GUICtrlCreateRadio("", 320, 255, 30, 30)
	GUIStartGroup()
		Global $em_radio_no = GUICtrlCreateRadio("", 230, 295, 30, 30)
		Global $em_radio_1 = GUICtrlCreateRadio("", 260, 295, 30, 30)
		Global $em_radio_2 = GUICtrlCreateRadio("", 290, 295, 30, 30)
		Global $em_radio_3 = GUICtrlCreateRadio("", 320, 295, 30, 30)	
	GUIStartGroup()
		Global $re_radio_no = GUICtrlCreateRadio("", 230, 335, 30, 30)
		Global $re_radio_1 = GUICtrlCreateRadio("", 260, 335, 30, 30)
		Global $re_radio_2 = GUICtrlCreateRadio("", 290, 335, 30, 30)
		Global $re_radio_3 = GUICtrlCreateRadio("", 320, 335, 30, 30)	
	GUIStartGroup()
		Global $cr_radio_no = GUICtrlCreateRadio("", 230, 375, 30, 30)
		Global $cr_radio_1 = GUICtrlCreateRadio("", 260, 375, 30, 30)
		Global $cr_radio_2 = GUICtrlCreateRadio("", 290, 375, 30, 30)
		Global $cr_radio_3 = GUICtrlCreateRadio("", 320, 375, 30, 30)	
	GUIStartGroup()
		Global $cd_radio_no = GUICtrlCreateRadio("", 230, 415, 30, 30)
		Global $cd_radio_1 = GUICtrlCreateRadio("", 260, 415, 30, 30)
		Global $cd_radio_2 = GUICtrlCreateRadio("", 290, 415, 30, 30)
		Global $cd_radio_3 = GUICtrlCreateRadio("", 320, 415, 30, 30)	

	Global $radio_array[10] = [$hp_radio_no, $hpp_radio_no, $atk_radio_no, $atkp_radio_no, $def_radio_no, $defp_radio_no, $em_radio_no, $re_radio_no, $cr_radio_no, $cd_radio_no]
		GUICtrlSetState($hp_radio_no, $GUI_CHECKED)
		GUICtrlSetState($hpp_radio_no, $GUI_CHECKED)
		GUICtrlSetState($atk_radio_no, $GUI_CHECKED)
		GUICtrlSetState($atkp_radio_no, $GUI_CHECKED)
		GUICtrlSetState($def_radio_no, $GUI_CHECKED)
		GUICtrlSetState($defp_radio_no, $GUI_CHECKED)
		GUICtrlSetState($em_radio_no, $GUI_CHECKED)
		GUICtrlSetState($re_radio_no, $GUI_CHECKED)
		GUICtrlSetState($cr_radio_no, $GUI_CHECKED)
		GUICtrlSetState($cd_radio_no, $GUI_CHECKED)

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

GUISetState()
	While true

		Switch GUIGetMsg()

			Case $hp_radio_no
				CheckRadio()
				GUICtrlSetState($hp_input, $GUI_DISABLE)
			Case $hp_radio_1
				CheckRadio()
				GUICtrlSetState($hp_input, $GUI_ENABLE)
				$hp_mult = 1
			Case $hp_radio_2
				CheckRadio()
				GUICtrlSetState($hp_input, $GUI_ENABLE)
				$hp_mult = $priority2
			Case $hp_radio_3
				CheckRadio()
				GUICtrlSetState($hp_input, $GUI_ENABLE)
				$hp_mult =$priority3

			Case $hpp_radio_no
				CheckRadio()
				GUICtrlSetState($hpp_input, $GUI_DISABLE)
			Case $hpp_radio_1
				CheckRadio()
				GUICtrlSetState($hpp_input, $GUI_ENABLE)
				$hpp_mult = 1
			Case $hpp_radio_2
				CheckRadio()
				GUICtrlSetState($hpp_input, $GUI_ENABLE)
				$hpp_mult = $priority2
			Case $hpp_radio_3
				CheckRadio()
				GUICtrlSetState($hpp_input, $GUI_ENABLE)
				$hpp_mult = $priority3

			Case $atk_radio_no
				CheckRadio()
				GUICtrlSetState($atk_input, $GUI_DISABLE)
			Case $atk_radio_1
				CheckRadio()
				GUICtrlSetState($atk_input, $GUI_ENABLE)
				$atk_mult = 1
			Case $atk_radio_2
				CheckRadio()
				GUICtrlSetState($atk_input, $GUI_ENABLE)
				$atk_mult = $priority2
			Case $atk_radio_3
				CheckRadio()
				GUICtrlSetState($atk_input, $GUI_ENABLE)
				$atk_mult = $priority3

			Case $atkp_radio_no
				CheckRadio()
				GUICtrlSetState($atkp_input, $GUI_DISABLE)
			Case $atkp_radio_1
				CheckRadio()
				GUICtrlSetState($atkp_input, $GUI_ENABLE)
				$atkp_mult = 1
			Case $atkp_radio_2
				CheckRadio()
				GUICtrlSetState($atkp_input, $GUI_ENABLE)
				$atkp_mult = $priority2
			Case $atkp_radio_3
				CheckRadio()
				GUICtrlSetState($atkp_input, $GUI_ENABLE)
				$atkp_mult = $priority3

			Case $def_radio_no
				CheckRadio()
				GUICtrlSetState($def_input, $GUI_DISABLE)
			Case $def_radio_1
				CheckRadio()
				GUICtrlSetState($def_input, $GUI_ENABLE)
				$def_mult = 1
			Case $def_radio_2
				CheckRadio()
				GUICtrlSetState($def_input, $GUI_ENABLE)
				$def_mult = $priority2
			Case $def_radio_3
				CheckRadio()
				GUICtrlSetState($def_input, $GUI_ENABLE)
				$def_mult = $priority3

			Case $defp_radio_no
				CheckRadio()
				GUICtrlSetState($defp_input, $GUI_DISABLE)
			Case $defp_radio_1
				CheckRadio()
				GUICtrlSetState($defp_input, $GUI_ENABLE)
				$defp_mult = 1
			Case $defp_radio_2
				CheckRadio()
				GUICtrlSetState($defp_input, $GUI_ENABLE)
				$defp_mult = $priority2
			Case $defp_radio_3
				CheckRadio()
				GUICtrlSetState($defp_input, $GUI_ENABLE)
				$defp_mult = $priority3

			Case $em_radio_no
				CheckRadio()
				GUICtrlSetState($em_input, $GUI_DISABLE)
			Case $em_radio_1
				CheckRadio()
				GUICtrlSetState($em_input, $GUI_ENABLE)
				$em_mult = 1
			Case $em_radio_2
				CheckRadio()
				GUICtrlSetState($em_input, $GUI_ENABLE)
				$em_mult = $priority2
			Case $em_radio_3
				CheckRadio()
				GUICtrlSetState($em_input, $GUI_ENABLE)
				$em_mult = $priority3

			Case $re_radio_no
				CheckRadio()
				GUICtrlSetState($re_input, $GUI_DISABLE)
			Case $re_radio_1
				CheckRadio()
				GUICtrlSetState($re_input, $GUI_ENABLE)
				$re_mult = 1
			Case $re_radio_2
				CheckRadio()
				GUICtrlSetState($re_input, $GUI_ENABLE)
				$re_mult = $priority2
			Case $re_radio_3
				CheckRadio()
				GUICtrlSetState($re_input, $GUI_ENABLE)
				$re_mult = $priority3

			Case $cr_radio_no
				CheckRadio()
				GUICtrlSetState($cr_input, $GUI_DISABLE)
			Case $cr_radio_1
				CheckRadio()
				GUICtrlSetState($cr_input, $GUI_ENABLE)
				$cr_mult = 1
			Case $cr_radio_2
				CheckRadio()
				GUICtrlSetState($cr_input, $GUI_ENABLE)
				$cr_mult = $priority2
			Case $cr_radio_3
				CheckRadio()
				GUICtrlSetState($cr_input, $GUI_ENABLE)
				$cr_mult = $priority3

			Case $cd_radio_no
				CheckRadio()
				GUICtrlSetState($cd_input, $GUI_DISABLE)
			Case $cd_radio_1
				CheckRadio()
				GUICtrlSetState($cd_input, $GUI_ENABLE)
				$cd_mult = 1
			Case $cd_radio_2
				CheckRadio()
				GUICtrlSetState($cd_input, $GUI_ENABLE)
				$cd_mult = $priority2
			Case $cd_radio_3
				CheckRadio()
				GUICtrlSetState($cd_input, $GUI_ENABLE)
				$cd_mult = $priority3

			Case $check_button
				Check()

			Case $clear_button
				GUICtrlSetData($hp_input, "")
				GUICtrlSetData($hpp_input, "")
				GUICtrlSetData($atk_input, "")
				GUICtrlSetData($atkp_input, "")
				GUICtrlSetData($def_input, "")
				GUICtrlSetData($defp_input, "")
				GUICtrlSetData($em_input, "")
				GUICtrlSetData($re_input, "")
				GUICtrlSetData($cr_input, "")
				GUICtrlSetData($cd_input, "")
				GUICtrlSetState($hp_radio_no, $GUI_CHECKED)
				GUICtrlSetState($hpp_radio_no, $GUI_CHECKED)
				GUICtrlSetState($atk_radio_no, $GUI_CHECKED)
				GUICtrlSetState($atkp_radio_no, $GUI_CHECKED)
				GUICtrlSetState($def_radio_no, $GUI_CHECKED)
				GUICtrlSetState($defp_radio_no, $GUI_CHECKED)
				GUICtrlSetState($em_radio_no, $GUI_CHECKED)
				GUICtrlSetState($re_radio_no, $GUI_CHECKED)
				GUICtrlSetState($cr_radio_no, $GUI_CHECKED)
				GUICtrlSetState($cd_radio_no, $GUI_CHECKED)
				GUICtrlSetState($hp_input, $GUI_DISABLE)
				GUICtrlSetState($hpp_input, $GUI_DISABLE)
				GUICtrlSetState($atk_input, $GUI_DISABLE)
				GUICtrlSetState($atkp_input, $GUI_DISABLE)
				GUICtrlSetState($def_input, $GUI_DISABLE)
				GUICtrlSetState($defp_input, $GUI_DISABLE)
				GUICtrlSetState($em_input, $GUI_DISABLE)
				GUICtrlSetState($re_input, $GUI_DISABLE)
				GUICtrlSetState($cr_input, $GUI_DISABLE)
				GUICtrlSetState($cd_input, $GUI_DISABLE)
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

		If GUICtrlRead($radio_array[$i]) == 4 Then

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

			If GUICtrlRead($radio_array[$i]) == 4 Then

				$current = GUICtrlRead($input_array[$i]) * (100 / $Stats[$i]) * $mult_array[$i]
				$summary += $current
				GUICtrlSetData($log_list, GUICtrlRead($log_list) & @CRLF & GUICtrlRead($label_array[$i]) & ": " & Round($current / 1.5, 2))

			EndIf

		Next
		GUICtrlSetData($log_list, GUICtrlRead($log_list) & @CRLF & "Итого: " & Round($summary / 1.5, 2) & @CRLF)
		_GUICtrlEdit_Scroll($log_list, $SB_BOTTOM)
		Quality(Round($summary / 1.5))

	EndIf

EndFunc

Func CheckRadio()

	Local $cnt_checked = 0
	For $i = 0 To 9

		If GUICtrlRead($radio_array[$i]) == 1 Then $cnt_checked += 1 

	Next
	If $cnt_checked < 6 Then
		GUICtrlSetState($check_button, $GUI_DISABLE)
		Local $text = GUICtrlRead($log_list)
		GUICtrlSetData($log_list, $text & @CRLF & @CRLF & "Недопустимое количество статов. Не более 4х")
		_GUICtrlEdit_Scroll($log_list, $SB_BOTTOM)
	ElseIf $cnt_checked > 9 Then
		GUICtrlSetState($check_button, $GUI_DISABLE)
	Else
		GUICtrlSetState($check_button, $GUI_ENABLE)
	EndIf

EndFunc

Func Quality($value)

	If $value >= 90 Then
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