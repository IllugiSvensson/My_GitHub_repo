#include <WindowsConstants.au3>
#include <GUIConstants.au3>
#include <ScrollBarConstants.au3>
#include <GuiEdit.au3>

;#include <StaticConstants.au3>
;#include <ButtonConstants.au3>
;#include <EditConstants.au3>
#include <Array.au3>
;#include <File.au3>



;НАСТРОЙКИ ПРОГРАММЫ
AutoItSetOption("MustDeclareVars", 1)
Opt("TrayMenuMode", 1 + 2)



Local $MainWindow = GUICreate("Оценка качества артефакта", 730, 750, -1, -1, $WS_DLGFRAME, $WS_EX_TOPMOST)

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

	Global $hp_input = GUICtrlCreateInput("0", 110, 50, 100, 40)
		GUICtrlSetFont(-1, 20, 1000)
		GUICtrlSetState(-1, $GUI_DISABLE)
	Global $hpp_input = GUICtrlCreateInput("0", 110, 90, 100, 40)
		GUICtrlSetFont(-1, 20, 1000)
		GUICtrlSetState(-1, $GUI_DISABLE)
	Global $atk_input = GUICtrlCreateInput("0", 110, 130, 100, 40)
		GUICtrlSetFont(-1, 20, 1000)
		GUICtrlSetState(-1, $GUI_DISABLE)
	Global $atkp_input = GUICtrlCreateInput("0", 110, 170, 100, 40)
		GUICtrlSetFont(-1, 20, 1000)
		GUICtrlSetState(-1, $GUI_DISABLE)
	Global $def_input = GUICtrlCreateInput("0", 110, 210, 100, 40)
		GUICtrlSetFont(-1, 20, 1000)
		GUICtrlSetState(-1, $GUI_DISABLE)
	Global $defp_input = GUICtrlCreateInput("0", 110, 250, 100, 40)
		GUICtrlSetFont(-1, 20, 1000)
		GUICtrlSetState(-1, $GUI_DISABLE)
	Global $em_input = GUICtrlCreateInput("0", 110, 290, 100, 40)
		GUICtrlSetFont(-1, 20, 1000)
		GUICtrlSetState(-1, $GUI_DISABLE)
	Global $re_input = GUICtrlCreateInput("0", 110, 330, 100, 40)
		GUICtrlSetFont(-1, 20, 1000)
		GUICtrlSetState(-1, $GUI_DISABLE)
	Global $cr_input = GUICtrlCreateInput("0", 110, 370, 100, 40)
		GUICtrlSetFont(-1, 20, 1000)
		GUICtrlSetState(-1, $GUI_DISABLE)
	Global $cd_input	= GUICtrlCreateInput("0", 110, 410, 100, 40)
		GUICtrlSetFont(-1, 20, 1000)
		GUICtrlSetState(-1, $GUI_DISABLE)
	Global $input_array[10] = [$hp_input, $hpp_input, $atk_input, $atkp_input, $def_input, $defp_input, $em_input, $re_input, $cr_input, $cd_input]

	GUICtrlCreateGroup("", 220, 44, 135, 48)
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
		Global $cd_radio_no = GUICtrlCreateRadio("", 230, $y + 11, 30, 30)
		Global $cd_radio_1 = GUICtrlCreateRadio("", 260, $y + 11, 30, 30)
		Global $cd_radio_2 = GUICtrlCreateRadio("", 290, $y + 11, 30, 30)
		Global $cd_radio_3 = GUICtrlCreateRadio("", 320, $y + 11, 30, 30)
		
GUICtrlCreateGroup("", -99, -99, 1, 1)
;			GUICtrlSetState($hp_radio_no, $GUI_CHECKED)
;			GUICtrlSetState($hpp_radio_no, $GUI_CHECKED)
			GUICtrlSetState($atk_radio_no, $GUI_CHECKED)
			GUICtrlSetState($atkp_radio_no, $GUI_CHECKED)
			GUICtrlSetState($def_radio_no, $GUI_CHECKED)
			GUICtrlSetState($defp_radio_no, $GUI_CHECKED)
			GUICtrlSetState($em_radio_no, $GUI_CHECKED)
			GUICtrlSetState($re_radio_no, $GUI_CHECKED)
			GUICtrlSetState($cr_radio_no, $GUI_CHECKED)
			GUICtrlSetState($cd_radio_no, $GUI_CHECKED)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$y = 284
	GUICtrlCreateGroup("", 220, $y, 135, 48)

	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$y = 324
	GUICtrlCreateGroup("", 220, $y, 135, 48)

	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$y = 364
	GUICtrlCreateGroup("", 220, $y, 135, 48)

	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$y = 404
	GUICtrlCreateGroup("", 220, $y, 135, 48)

	GUICtrlCreateGroup("", -99, -99, 1, 1)








	Local $log_list = GUICtrlCreateEdit("", 10, 460, 350, 220, $ES_MULTILINE + $ES_READONLY + $WS_VSCROLL)
		GUICtrlSetFont(-1, 12, 1000)
		GUICtrlSetData($log_list, "Оцениваем артефакты!" & @CRLF & "Смотрим на статы в артефакте, кликаем на галочки приоритетов: Х - стат не нужен, 1 - очень нужен и тд. В открытом поле вводим значение стата числом (для дроби через точку или запятую) и жмем Оценить" & @CRLF & "В поле справа можно писать свои заметки и сохранять их на рабочий стол")

	Local $textbox = GUICtrlCreateEdit("", 370, 10, 350, 670, $ES_MULTILINE + $WS_VSCROLL)
		GUICtrlSetFont(-1, 12, 1000)

	Local $save_button = GUICtrlCreateButton("Сохранить", 470, 685, 135, 35)
		GUICtrlSetFont(-1, 18, 1000)

	Local $check_button = GUICtrlCreateButton("Оценить", 10, 685, 116, 35)
		GUICtrlSetFont(-1, 18, 1000)
		GUICtrlSetState(-1, $GUI_DISABLE)

	Local $clear_button = GUICtrlCreateButton("Сброс", 126, 685, 116, 35)
		GUICtrlSetFont(-1, 18, 1000)

	Local $exit_button = GUICtrlCreateButton("Выход", 242, 685, 116, 35)
		GUICtrlSetFont(-1, 18, 1000)

Local $priority2 = 0.85, $priority3 = 0.7
GUISetState()
While true

	Switch GUIGetMsg()

		Case $hp_radio_no
			CheckRadio()
			GUICtrlSetState($hp_input, $GUI_DISABLE)
		Case $hp_radio_1
			CheckRadio()
			GUICtrlSetState($hp_input, $GUI_ENABLE)
			Local $hp_mult = 1
		Case $hp_radio_2
			CheckRadio()
			GUICtrlSetState($hp_input, $GUI_ENABLE)
			Local $hp_mult = $priority2
		Case $hp_radio_3
			CheckRadio()
			GUICtrlSetState($hp_input, $GUI_ENABLE)
			Local $hp_mult =$priority3
		Case $hpp_radio_no
			CheckRadio()
			GUICtrlSetState($hpp_input, $GUI_DISABLE)
		Case $hpp_radio_1
			CheckRadio()
			GUICtrlSetState($hpp_input, $GUI_ENABLE)
			Local $hpp_mult = 1
		Case $hpp_radio_2
			CheckRadio()
			GUICtrlSetState($hpp_input, $GUI_ENABLE)
			Local $hpp_mult = $priority2
		Case $hpp_radio_3
			CheckRadio()
			GUICtrlSetState($hpp_input, $GUI_ENABLE)
			Local $hpp_mult = $priority3
		Case $atk_radio_no
			CheckRadio()
			GUICtrlSetState($atk_input, $GUI_DISABLE)
		Case $atk_radio_1
			CheckRadio()
			GUICtrlSetState($atk_input, $GUI_ENABLE)
			Local $atk_mult = 1
		Case $atk_radio_2
			CheckRadio()
			GUICtrlSetState($atk_input, $GUI_ENABLE)
			Local $atk_mult = $priority2
		Case $atk_radio_3
			CheckRadio()
			GUICtrlSetState($atk_input, $GUI_ENABLE)
			Local $atk_mult = $priority3

		Case $atkp_radio_no
			CheckRadio()
			GUICtrlSetState($atkp_input, $GUI_DISABLE)
		Case $atkp_radio_1
			CheckRadio()
			GUICtrlSetState($atkp_input, $GUI_ENABLE)
			Local $atkp_mult = 1
		Case $atkp_radio_2
			CheckRadio()
			GUICtrlSetState($atkp_input, $GUI_ENABLE)
			Local $atkp_mult = $priority2
		Case $atkp_radio_3
			CheckRadio()
			GUICtrlSetState($atkp_input, $GUI_ENABLE)
			Local $atkp_mult = $priority3
		Case $def_radio_no
			CheckRadio()
			GUICtrlSetState($def_input, $GUI_DISABLE)
		Case $def_radio_1
			CheckRadio()
			GUICtrlSetState($def_input, $GUI_ENABLE)
			Local $def_mult = 1
		Case $def_radio_2
			CheckRadio()
			GUICtrlSetState($def_input, $GUI_ENABLE)
			Local $def_mult = $priority2
		Case $def_radio_3
			CheckRadio()
			GUICtrlSetState($def_input, $GUI_ENABLE)
			Local $def_mult = $priority3

		Case $defp_radio_no
			CheckRadio()
			GUICtrlSetState($defp_input, $GUI_DISABLE)
		Case $defp_radio_1
			CheckRadio()
			GUICtrlSetState($defp_input, $GUI_ENABLE)
			Local $defp_mult = 1
		Case $defp_radio_2
			CheckRadio()
			GUICtrlSetState($defp_input, $GUI_ENABLE)
			Local $defp_mult = $priority2
		Case $defp_radio_3
			CheckRadio()
			GUICtrlSetState($defp_input, $GUI_ENABLE)
			Local $defp_mult = $priority3
		Case $em_radio_no
			CheckRadio()
			GUICtrlSetState($em_input, $GUI_DISABLE)
		Case $em_radio_1
			CheckRadio()
			GUICtrlSetState($em_input, $GUI_ENABLE)
			Local $em_mult = 1
		Case $em_radio_2
			CheckRadio()
			GUICtrlSetState($em_input, $GUI_ENABLE)
			Local $em_mult = $priority2
		Case $em_radio_3
			CheckRadio()
			GUICtrlSetState($em_input, $GUI_ENABLE)
			Local $em_mult = $priority3
		Case $re_radio_no
			CheckRadio()
			GUICtrlSetState($re_input, $GUI_DISABLE)
		Case $re_radio_1
			CheckRadio()
			GUICtrlSetState($re_input, $GUI_ENABLE)
			Local $re_mult = 1
		Case $re_radio_2
			CheckRadio()
			GUICtrlSetState($re_input, $GUI_ENABLE)
			Local $re_mult = $priority2
		Case $re_radio_3
			CheckRadio()
			GUICtrlSetState($re_input, $GUI_ENABLE)
			Local $re_mult = $priority3
		Case $cr_radio_no
			CheckRadio()
			GUICtrlSetState($cr_input, $GUI_DISABLE)
		Case $cr_radio_1
			CheckRadio()
			GUICtrlSetState($cr_input, $GUI_ENABLE)
			Local $cr_mult = 1
		Case $cr_radio_2
			CheckRadio()
			GUICtrlSetState($cr_input, $GUI_ENABLE)
			Local $cr_mult = $priority2
		Case $cr_radio_3
			CheckRadio()
			GUICtrlSetState($cr_input, $GUI_ENABLE)
			Local $cr_mult = $priority3

		Case $cd_radio_no
			CheckRadio()
			GUICtrlSetState($cd_input, $GUI_DISABLE)
		Case $cd_radio_1
			CheckRadio()
			GUICtrlSetState($cd_input, $GUI_ENABLE)
			Local $cd_mult = 1
		Case $cd_radio_2
			CheckRadio()
			GUICtrlSetState($cd_input, $GUI_ENABLE)
			Local $cd_mult = $priority2
		Case $cd_radio_3
			CheckRadio()
			GUICtrlSetState($cd_input, $GUI_ENABLE)
			Local $cd_mult = $priority3

		Case $check_button
			Check()

		Case $clear_button
			GUICtrlSetData($hp_input, 0)
			GUICtrlSetData($hpp_input, 0)
			GUICtrlSetData($atk_input, 0)
			GUICtrlSetData($atkp_input, 0)
			GUICtrlSetData($def_input, 0)
			GUICtrlSetData($defp_input, 0)
			GUICtrlSetData($em_input, 0)
			GUICtrlSetData($re_input, 0)
			GUICtrlSetData($cr_input, 0)
			GUICtrlSetData($cd_input, 0)
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

		Case $save_button
			FileWrite(@DesktopDir & "\Artifact.log", GUICtrlRead($textbox))

		Case $exit_button
			Exit 0

	EndSwitch

WEnd



Func Check()

EndFunc

Func CheckRadio()

	Local $cnt_checked = 0
	For $i = 1 To 10

		Switch $i
			Case 1
				If GUICtrlRead($hp_radio_no) == 1 Then $cnt_checked += 1
			Case 2
				If GUICtrlRead($hpp_radio_no) == 1 Then $cnt_checked += 1
			Case 3
				If GUICtrlRead($atk_radio_no) == 1 Then $cnt_checked += 1
			Case 4
				If GUICtrlRead($atkp_radio_no) == 1 Then $cnt_checked += 1
			Case 5
				If GUICtrlRead($def_radio_no) == 1 Then $cnt_checked += 1
			Case 6
				If GUICtrlRead($defp_radio_no) == 1 Then $cnt_checked += 1
			Case 7
				If GUICtrlRead($em_radio_no) == 1 Then $cnt_checked += 1
			Case 8
				If GUICtrlRead($re_radio_no) == 1 Then $cnt_checked += 1
			Case 9
				If GUICtrlRead($cr_radio_no) == 1 Then $cnt_checked += 1
			Case 10
				If GUICtrlRead($cd_radio_no) == 1 Then $cnt_checked += 1

		EndSwitch

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

Func Validator($input, $label)

	Local $Array = StringRegExp(GUICtrlRead($input), "^([0-9]{1,4})$|^([0-9]{1,2}[\.|,][0-9]{1})$", 3)
	GUICtrlSetData($textbox, IsArray($Array))
	If IsArray($Array) <> 0 Then
		Local $text = GUICtrlRead($log_list)
		GUICtrlSetData($log_list, $text & @CRLF & @CRLF & "Ошибка ввода: " & $label)
		_GUICtrlEdit_Scroll($log_list, $SB_BOTTOM)
	EndIf

EndFunc
