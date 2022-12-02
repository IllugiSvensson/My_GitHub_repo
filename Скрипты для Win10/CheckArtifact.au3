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



Local $MainWindow = GUICreate("Проверка качества артефакта", 730, 750, -1, -1, $WS_DLGFRAME, $WS_EX_TOPMOST)

	Local $priority_label = GUICtrlCreateLabel("Приоритет            Х  1  2  3", 10, 10, 480, 40)
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

	Local $hp_input = GUICtrlCreateInput("0", 110, 50, 100, 40)
		GUICtrlSetFont(-1, 20, 1000)
		GUICtrlSetState(-1, $GUI_DISABLE)
	Local $hpp_input = GUICtrlCreateInput("0", 110, 90, 100, 40)
		GUICtrlSetFont(-1, 20, 1000)
		GUICtrlSetState(-1, $GUI_DISABLE)
	Local $atk_input = GUICtrlCreateInput("0", 110, 130, 100, 40)
		GUICtrlSetFont(-1, 20, 1000)
		GUICtrlSetState(-1, $GUI_DISABLE)
	Local $atkp_input = GUICtrlCreateInput("0", 110, 170, 100, 40)
		GUICtrlSetFont(-1, 20, 1000)
		GUICtrlSetState(-1, $GUI_DISABLE)
	Local $def_input = GUICtrlCreateInput("0", 110, 210, 100, 40)
		GUICtrlSetFont(-1, 20, 1000)
		GUICtrlSetState(-1, $GUI_DISABLE)
	Local $defp_input = GUICtrlCreateInput("0", 110, 250, 100, 40)
		GUICtrlSetFont(-1, 20, 1000)
		GUICtrlSetState(-1, $GUI_DISABLE)
	Local $em_input = GUICtrlCreateInput("0", 110, 290, 100, 40)
		GUICtrlSetFont(-1, 20, 1000)
		GUICtrlSetState(-1, $GUI_DISABLE)
	Local $re_input = GUICtrlCreateInput("0", 110, 330, 100, 40)
		GUICtrlSetFont(-1, 20, 1000)
		GUICtrlSetState(-1, $GUI_DISABLE)
	Local $cr_input = GUICtrlCreateInput("0", 110, 370, 100, 40)
		GUICtrlSetFont(-1, 20, 1000)
		GUICtrlSetState(-1, $GUI_DISABLE)
	Local $cd_input	= GUICtrlCreateInput("0", 110, 410, 100, 40)
		GUICtrlSetFont(-1, 20, 1000)
		GUICtrlSetState(-1, $GUI_DISABLE)

	Local $y = 44
	GUICtrlCreateGroup("", 220, $y, 135, 48)
	Local $hp_radio_no = GUICtrlCreateRadio("", 230, $y + 11, 30, 30)
		GUICtrlSetState($hp_radio_no, $GUI_CHECKED)
	Local $hp_radio_1 = GUICtrlCreateRadio("", 260, $y + 11, 30, 30)
	Local $hp_radio_2 = GUICtrlCreateRadio("", 290, $y + 11, 30, 30)
	Local $hp_radio_3 = GUICtrlCreateRadio("", 320, $y + 11, 30, 30)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$y = 84
	GUICtrlCreateGroup("", 220, $y, 135, 48)
	Local $hpp_radio_no = GUICtrlCreateRadio("", 230, $y + 11, 30, 30)
		GUICtrlSetState($hpp_radio_no, $GUI_CHECKED)
	Local $hpp_radio_1 = GUICtrlCreateRadio("", 260, $y + 11, 30, 30)
	Local $hpp_radio_2 = GUICtrlCreateRadio("", 290, $y + 11, 30, 30)
	Local $hpp_radio_3 = GUICtrlCreateRadio("", 320, $y + 11, 30, 30)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$y = 124
	GUICtrlCreateGroup("", 220, $y, 135, 48)
	Local $atk_radio_no = GUICtrlCreateRadio("", 230, $y + 11, 30, 30)
		GUICtrlSetState($atk_radio_no, $GUI_CHECKED)
	Local $atk_radio_1 = GUICtrlCreateRadio("", 260, $y + 11, 30, 30)
	Local $atk_radio_2 = GUICtrlCreateRadio("", 290, $y + 11, 30, 30)
	Local $atk_radio_3 = GUICtrlCreateRadio("", 320, $y + 11, 30, 30)
	GUICtrlCreateGroup("", -99, -99, 1, 1)	
	$y = 164
	GUICtrlCreateGroup("", 220, $y, 135, 48)
	Local $atkp_radio_no = GUICtrlCreateRadio("", 230, $y + 11, 30, 30)
		GUICtrlSetState($atkp_radio_no, $GUI_CHECKED)
	Local $atkp_radio_1 = GUICtrlCreateRadio("", 260, $y + 11, 30, 30)
	Local $atkp_radio_2 = GUICtrlCreateRadio("", 290, $y + 11, 30, 30)
	Local $atkp_radio_3 = GUICtrlCreateRadio("", 320, $y + 11, 30, 30)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$y = 204
	GUICtrlCreateGroup("", 220, $y, 135, 48)
	Local $def_radio_no = GUICtrlCreateRadio("", 230, $y + 11, 30, 30)
		GUICtrlSetState($def_radio_no, $GUI_CHECKED)
	Local $def_radio_1 = GUICtrlCreateRadio("", 260, $y + 11, 30, 30)
	Local $def_radio_2 = GUICtrlCreateRadio("", 290, $y + 11, 30, 30)
	Local $def_radio_3 = GUICtrlCreateRadio("", 320, $y + 11, 30, 30)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$y = 244
	GUICtrlCreateGroup("", 220, $y, 135, 48)
	Local $defp_radio_no = GUICtrlCreateRadio("", 230, $y + 11, 30, 30)
		GUICtrlSetState($defp_radio_no, $GUI_CHECKED)
	Local $defp_radio_1 = GUICtrlCreateRadio("", 260, $y + 11, 30, 30)
	Local $defp_radio_2 = GUICtrlCreateRadio("", 290, $y + 11, 30, 30)
	Local $defp_radio_3 = GUICtrlCreateRadio("", 320, $y + 11, 30, 30)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$y = 284
	GUICtrlCreateGroup("", 220, $y, 135, 48)
	Local $em_radio_no = GUICtrlCreateRadio("", 230, $y + 11, 30, 30)
		GUICtrlSetState($em_radio_no, $GUI_CHECKED)
	Local $em_radio_1 = GUICtrlCreateRadio("", 260, $y + 11, 30, 30)
	Local $em_radio_2 = GUICtrlCreateRadio("", 290, $y + 11, 30, 30)
	Local $em_radio_3 = GUICtrlCreateRadio("", 320, $y + 11, 30, 30)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$y = 324
	GUICtrlCreateGroup("", 220, $y, 135, 48)
	Local $re_radio_no = GUICtrlCreateRadio("", 230, $y + 11, 30, 30)
		GUICtrlSetState($re_radio_no, $GUI_CHECKED)
	Local $re_radio_1 = GUICtrlCreateRadio("", 260, $y + 11, 30, 30)
	Local $re_radio_2 = GUICtrlCreateRadio("", 290, $y + 11, 30, 30)
	Local $re_radio_3 = GUICtrlCreateRadio("", 320, $y + 11, 30, 30)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$y = 364
	GUICtrlCreateGroup("", 220, $y, 135, 48)
	Local $cr_radio_no = GUICtrlCreateRadio("", 230, $y + 11, 30, 30)
		GUICtrlSetState($cr_radio_no, $GUI_CHECKED)
	Local $cr_radio_1 = GUICtrlCreateRadio("", 260, $y + 11, 30, 30)
	Local $cr_radio_2 = GUICtrlCreateRadio("", 290, $y + 11, 30, 30)
	Local $cr_radio_3 = GUICtrlCreateRadio("", 320, $y + 11, 30, 30)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$y = 404
	GUICtrlCreateGroup("", 220, $y, 135, 48)
	Local $cd_radio_no = GUICtrlCreateRadio("", 230, $y + 11, 30, 30)
		GUICtrlSetState($cd_radio_no, $GUI_CHECKED)
	Local $cd_radio_1 = GUICtrlCreateRadio("", 260, $y + 11, 30, 30)
	Local $cd_radio_2 = GUICtrlCreateRadio("", 290, $y + 11, 30, 30)
	Local $cd_radio_3 = GUICtrlCreateRadio("", 320, $y + 11, 30, 30)
	GUICtrlCreateGroup("", -99, -99, 1, 1)

	Local $log_list = GUICtrlCreateEdit("", 10, 460, 350, 220, $ES_MULTILINE + $ES_READONLY)
	GUICtrlSetFont(-1, 12, 1000)
	GUICtrlSetData($log_list, "Оцениваем артефакты!" & @CRLF & "Смотрим на статы в артефакте, кликаем на галочки приоритетов: Х - стат не нужен, 1 - очень нужен и тд. В открытом поле вводим значение стата числом (для дроби через запятую) и жмем Оценить" & @CRLF & "В поле справа можно писать свои заметки и сохранять их на рабочий стол")

	Local $textbox = GUICtrlCreateEdit("", 370, 10, 350, 670, $ES_MULTILINE)
	GUICtrlSetFont(-1, 12, 1000)

	Local $save_button = GUICtrlCreateButton("Сохранить", 470, 685, 135, 35)
		GUICtrlSetFont(-1, 18, 1000)

	Local $check_button = GUICtrlCreateButton("Оценить", 10, 685, 116, 35)
		GUICtrlSetFont(-1, 18, 1000)

	Local $clear_button = GUICtrlCreateButton("Сброс", 126, 685, 116, 35)
		GUICtrlSetFont(-1, 18, 1000)

	Local $exit_button = GUICtrlCreateButton("Выход", 242, 685, 116, 35)
		GUICtrlSetFont(-1, 18, 1000)


GUISetState()
While true

	Switch GUIGetMsg()

		Case $check_button
			;some function

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

		Case $save_button
			FileWrite(@DesktopDir & "\Artifact.log", GUICtrlRead($textbox))

		Case $exit_button
			Exit 0

	EndSwitch

WEnd

Func Collect

