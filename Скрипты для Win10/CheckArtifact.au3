#include <WindowsConstants.au3>
#include <ScrollBarConstants.au3>
#include <GUIConstants.au3>
#include <GuiEdit.au3>
#include <Array.au3>



;НАСТРОЙКИ ПРОГРАММЫ
AutoItSetOption("MustDeclareVars", 1)
Opt("TrayMenuMode", 1 + 2)
Local $Stats[10] = [1794, 34.8, 114, 34.8, 138, 43.8, 138, 39, 23.4, 46.8]
Local $hp_mult, $hpp_mult, $atk_mult, $atkp_mult, $def_mult, $defp_mult, $em_mult, $re_mult, $cr_mult, $cd_mult
Local $Hp[4] = [209, 239, 269, 299], $Hp_combo = GenerateCombo($Hp)
Local $HppAtkp[4] = [4.1, 4.7, 5.3, 5.8], $HppAtkp_combo = GenerateCombo($HppAtkp)
Local $Atk[4] = [14, 16, 18, 19], $Atk_combo = GenerateCombo($Atk)
Local $DefEm[4] = [16, 19, 21, 23], $DefEm_combo = GenerateCombo($DefEm)
Local $Defp[4] = [5.1, 5.8, 6.6, 7.3], $Defp_combo = GenerateCombo($Defp)
Local $Re[4] = [4.5, 5.2, 5.8, 6.5], $Re_combo = GenerateCombo($Re)
Local $Cr[4] = [2.7, 3.1, 3.5, 3.9], $Cr_combo = GenerateCombo($Cr)
Local $Cd[4] = [5.4, 6.2, 7.0, 7.8], $Cd_combo = GenerateCombo($Cd)
Local $input[10] = [" ", " ", " ", " ", " ", " ", " ", " ", " ", " "]
Local $insldr[12] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
Local $priority2 = 0.8, $priority3 = 0.6
Local $tabcnt = 0, $insldr_tmp[12]



Local $MainWindow = GUICreate("Оценка качества артефакта", 730, 550, -1, -1, $WS_DLGFRAME, $WS_EX_TOPMOST)

	Local $TAB = GUICtrlCreateTab(3, 3, 726, 519, $TCS_BUTTONS)
		GUICtrlSetFont(-1, 12, 1000)
	GUICtrlCreateTabItem("Главная")
	GUICtrlCreateLabel("Создать вкладку персонажа:", 10, 150, 345, 40)
		GUICtrlSetFont(-1, 18, 1000)
	Local $new_input = GUICtrlCreateInput(" ", 10, 190, 345, 40, $ES_CENTER)
		GUICtrlSetFont(-1, 20, 1000)
		GUICtrlSetTip(-1, "Введите имя вкладки", "", 1, 1)
	Local $new_button = GUICtrlCreateButton("Создать", 20, 240, 325, 40)
		GUICtrlSetFont(-1, 20, 1000)
		GUICtrlSetTip(-1, "Создать вкладку персонажа" & @CRLF & "для оценки артефактов", "", 1, 1)
	Local $exit_button = GUICtrlCreateButton("Выход", 20, 470, 325, 40)
		GUICtrlSetFont(-1, 20, 1000)
		GUICtrlSetTip(-1, "Выйти из программы", "", 1, 1)
	Local $list = GUICtrlCreateEdit("", 370, 32, 350, 478, $ES_MULTILINE + $WS_VSCROLL + $ES_WANTRETURN + $ES_READONLY)
		GUICtrlSetFont(-1, 11, 1000)
		GUICtrlSetData($list, "Оцениваем артефакты!" & @CRLF & "Для удобства открываем игру в оконном режиме." & @CRLF & @CRLF & "Создаем вкладку персонажа для сравнения оценок с другими персонажами." & @CRLF & @CRLF & "Берем артефакт 20го или 16го уровня и смотрим на доп статы. Выставляем приоритеты и величину статов на артефакте. Кликаем 'Оценка20' или 'Оценка16'(с предсказанием) и получаем качественную оценку выбранного артефакта." & @CRLF & @CRLF & "Приоритет - субъективная оценка стата по степени нужности: 1 - очень нужен, 3 - не очень нужен. Ненужные статы оставляем в 'Х'." & @CRLF & @CRLF & "Выставить на оценку можно до четырёх статов. Значения вводятся цифрами без знака '%' и через точку (для дробных значений) или выбираются из списка." & @CRLF & @CRLF & "Маленькие кнопки позволяют записать и учесть отдельные артефакты и подсчитать общую оценку экипировки, а так же скопировать параметры в другие вкладки.")
	GUICtrlCreateTabItem("")

	GUISetState()
	While True

		Switch GUIGetMsg()

			Case $new_button
				$tabcnt += 1
				GUICtrlCreateTabItem($tabcnt & "." & GUICtrlRead($new_input))
				CreateTabElements()
				GUICtrlCreateTabItem("")

			Case $exit_button
				Exit 0

			Case GUICtrlRead($TAB, 1) + 22
				$hp_mult = CheckSlider(GUICtrlRead($TAB, 1) + 22, GUICtrlRead($TAB, 1) + 12)

			Case GUICtrlRead($TAB, 1) + 23
				$hpp_mult = CheckSlider(GUICtrlRead($TAB, 1) + 23, GUICtrlRead($TAB, 1) + 13)

			Case GUICtrlRead($TAB, 1) + 24
				$atk_mult = CheckSlider(GUICtrlRead($TAB, 1) + 24, GUICtrlRead($TAB, 1) + 14)

			Case GUICtrlRead($TAB, 1) + 25
				$atkp_mult = CheckSlider(GUICtrlRead($TAB, 1) + 25, GUICtrlRead($TAB, 1) + 15)

			Case GUICtrlRead($TAB, 1) + 26
				$def_mult = CheckSlider(GUICtrlRead($TAB, 1) + 26, GUICtrlRead($TAB, 1) + 16)

			Case GUICtrlRead($TAB, 1) + 27
				$defp_mult = CheckSlider(GUICtrlRead($TAB, 1) + 27, GUICtrlRead($TAB, 1) + 17)

			Case GUICtrlRead($TAB, 1) + 28
				$em_mult = CheckSlider(GUICtrlRead($TAB, 1) + 28, GUICtrlRead($TAB, 1) + 18)

			Case GUICtrlRead($TAB, 1) + 29
				$re_mult = CheckSlider(GUICtrlRead($TAB, 1) + 29, GUICtrlRead($TAB, 1) + 19)

			Case GUICtrlRead($TAB, 1) + 30
				$cr_mult = CheckSlider(GUICtrlRead($TAB, 1) + 30, GUICtrlRead($TAB, 1) + 20)

			Case GUICtrlRead($TAB, 1) + 31
				$cd_mult = CheckSlider(GUICtrlRead($TAB, 1) + 31, GUICtrlRead($TAB, 1) + 21)

			Case GUICtrlRead($TAB, 1) + 37
				$input = SaveInput()
				$insldr = Check(0)
				If $insldr[0] = 0 Then BlockColor(0)
				GUICtrlSetState(GUICtrlRead($TAB, 1) + 37, $GUI_DISABLE)
				GUICtrlSetState(GUICtrlRead($TAB, 1) + 38, $GUI_DISABLE)

			Case GUICtrlRead($TAB, 1) + 38
				$input = SaveInput()
				$insldr = Check(1)
				If $insldr[0] = 0 Then BlockColor(0)
				GUICtrlSetState(GUICtrlRead($TAB, 1) + 37, $GUI_DISABLE)
				GUICtrlSetState(GUICtrlRead($TAB, 1) + 38, $GUI_DISABLE)

			Case GUICtrlRead($TAB, 1) + 39
				$insldr_tmp = $insldr
				Result(1, $insldr_tmp[11])

			Case GUICtrlRead($TAB, 1) + 40
				If (GUICtrlRead($TAB, 1) + 40) == "✅" Then GUICtrlSetData(GUICtrlRead($TAB, 1) + 40, 0)
				GUICtrlSetState(GUICtrlRead($TAB, 1) + 39, $GUI_DISABLE)
				GUICtrlSetState(GUICtrlRead($TAB, 1) + 40, $GUI_DISABLE)
				GUICtrlSetState(GUICtrlRead($TAB, 1) + 41, $GUI_ENABLE)
				GUICtrlSetData(GUICtrlRead($TAB, 1) + 33, GUICtrlRead(GUICtrlRead($TAB, 1) + 33) & "Оценка: " & $insldr_tmp[11] & " ")
				For $i = 0 To 9
					If $insldr_tmp[$i + 1] <> 0 Then
						GUICtrlSetData(GUICtrlRead($TAB, 1) + 33, GUICtrlRead(GUICtrlRead($TAB, 1) + 33) & @CRLF & GUICtrlRead(GUICtrlRead($TAB, 1) + 2 + $i) & ": " & $input[$i])
						_GUICtrlEdit_Scroll(GUICtrlRead($TAB, 1) + 33, $SB_BOTTOM)
					EndIf
				Next
				Result(0, $insldr_tmp[11])
				GUICtrlSetData(GUICtrlRead($TAB, 1) + 33, GUICtrlRead(GUICtrlRead($TAB, 1) + 33) & @CRLF & @CRLF)

			Case GUICtrlRead($TAB, 1) + 41
				GUICtrlSetData(GUICtrlRead($TAB, 1) + 34, GUICtrlRead(GUICtrlRead($TAB, 1) + 34) & @CRLF & "Учет сброшен!" & @CRLF)
				_GUICtrlEdit_Scroll(GUICtrlRead($TAB, 1) + 34, $SB_BOTTOM)
				GUICtrlSetState(GUICtrlRead($TAB, 1) + 41, $GUI_DISABLE)
				GUICtrlSetStyle(GUICtrlRead($TAB, 1) + 39, 0)
				GUICtrlSetState(GUICtrlRead($TAB, 1) + 39, $GUI_DISABLE)
				GUICtrlSetData(GUICtrlRead($TAB, 1) + 39, "💾")
				GUICtrlSetData(GUICtrlRead($TAB, 1) + 40, "✅")
				GUICtrlSetState(GUICtrlRead($TAB, 1) + 40, $GUI_DISABLE)
				GUICtrlSetData(GUICtrlRead($TAB, 1) + 35, "0")
				GUICtrlSetData(GUICtrlRead($TAB, 1) + 33, "")

			Case GUICtrlRead($TAB, 1) + 42
				For $i = 0 To 9

					GUICtrlSetData(GUICtrlRead($TAB, 1) + 12 + $i, $input[$i], $input[$i])

				Next

			Case GUICtrlRead($TAB, 1) + 43
				For $i = 0 To 9
					GUICtrlSetData(GUICtrlRead($TAB, 1) + 12 + $i, " ")
					GUICtrlSetState(GUICtrlRead($TAB, 1) + 12 + $i, $GUI_DISABLE)
					GUICtrlSetData(GUICtrlRead($TAB, 1) + 22 + $i, 0)
					GUICtrlSetState(GUICtrlRead($TAB, 1) + 22 + $i, $GUI_ENABLE)
				Next
				GUICtrlSetState(GUICtrlRead($TAB, 1) + 37, $GUI_DISABLE)
				GUICtrlSetData(GUICtrlRead($TAB, 1) + 37, "Оценка20")
				GUICtrlSetState(GUICtrlRead($TAB, 1) + 38, $GUI_DISABLE)
				GUICtrlSetData(GUICtrlRead($TAB, 1) + 38, "Оценка16")
				GUICtrlSetBkColor(GUICtrlRead($TAB, 1) + 36, $GUI_BKCOLOR_TRANSPARENT)
				GUICtrlSetData(GUICtrlRead($TAB, 1) + 36, "")
				GUICtrlSetData(GUICtrlRead($TAB, 1) + 34, "")

			Case GUICtrlRead($TAB, 1) + 44
				GUICtrlSetData(GUICtrlRead($TAB, 1) + 32, "")
				GUICtrlSetData(GUICtrlRead($TAB, 1) + 33, "")

			Case GUICtrlRead($TAB, 1) + 45
				For $i = GUICtrlRead($TAB, 1) To GUICtrlRead($TAB, 1) + 45

					GUICtrlDelete($i)

				Next

		EndSwitch

	WEnd



Func GenerateCombo($Stat)

	Local $prev = 0, $current = Ubound($Stat), $count = 0
	For $i = 1 To 5

		ReDim $Stat[$current + 4 * (Ubound($Stat) - $prev)]
		For $j = $prev To $current - 1

			For $k = 0 To 3

				$Stat[4 + $count] = $Stat[$k] + $Stat[$j]
				$count += 1

			Next

		Next
		$prev = $current
		$current = Ubound($Stat)

	Next

	_ArraySort($Stat)
	$Stat = _ArrayUnique($Stat)
	Local $Combo = ""
	For $i = 1 To $Stat[0]

		$Combo &= $Stat[$i] & "|"

	Next
	Return $Combo

EndFunc

Func CreateTabElements()

	GUICtrlCreateLabel("Приоритет            Х   1   2   3", 10, 30, 350, 40)
		GUICtrlSetFont(-1, 20, 1000)
		GUICtrlSetTip(-1, "Степень нужности стата:"  & @CRLF &  "X - не учитывать" & @CRLF & "1 - обязательный (учет 100%)" & @CRLF & "2 - нужный (учет 80%)"  & @CRLF & "3 - пригодится (учет 60%)", "", 1, 1)
	Local $hp_label = GUICtrlCreateLabel("ХП", 10, 70, 100, 40)
		GUICtrlSetFont(-1, 20, 1000)
	Local $hpp_label = GUICtrlCreateLabel("ХП%", 10, 110, 100, 40)
		GUICtrlSetFont(-1, 20, 1000)
	Local $atk_label = GUICtrlCreateLabel("ATK", 10, 150, 100, 40)
		GUICtrlSetFont(-1, 20, 1000)
	Local $atkp_label = GUICtrlCreateLabel("ATK%", 10, 190, 100, 40)
		GUICtrlSetFont(-1, 20, 1000)
	Local $def_label = GUICtrlCreateLabel("ЗАЩ", 10, 230, 100, 40)
		GUICtrlSetFont(-1, 20, 1000)
	Local $defp_label = GUICtrlCreateLabel("ЗАЩ%", 10, 270, 100, 40)
		GUICtrlSetFont(-1, 20, 1000)
	Local $em_label = GUICtrlCreateLabel("МС", 10, 310, 100, 40)
		GUICtrlSetFont(-1, 20, 1000)
	Local $re_label = GUICtrlCreateLabel("ВЭ", 10, 350, 100, 40)
		GUICtrlSetFont(-1, 20, 1000)
	Local $cr_label = GUICtrlCreateLabel("КШ", 10, 390, 100, 40)
		GUICtrlSetFont(-1, 20, 1000)
	Local $cd_label	= GUICtrlCreateLabel("КУ", 10, 430, 100, 40)
		GUICtrlSetFont(-1, 20, 1000)

	Local $hp_input = GUICtrlCreateCombo(" ", 110, 70, 100, 385, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_NOINTEGRALHEIGHT))
		GUICtrlSetFont(-1, 20, 1000)
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlSetData($hp_input, $Hp_combo, " ")
	Local $hpp_input = GUICtrlCreateCombo(" ", 110, 110, 100, 385, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_NOINTEGRALHEIGHT))
		GUICtrlSetFont(-1, 20, 1000)
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlSetData($hpp_input, $HppAtkp_combo, " ")
	Local $atk_input = GUICtrlCreateCombo(" ", 110, 150, 100, 385, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_NOINTEGRALHEIGHT))
		GUICtrlSetFont(-1, 20, 1000)
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlSetData($atk_input, $Atk_combo, " ")
	Local $atkp_input = GUICtrlCreateCombo(" ", 110, 190, 100, 385, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_NOINTEGRALHEIGHT))
		GUICtrlSetFont(-1, 20, 1000)
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlSetData($atkp_input, $HppAtkp_combo, " ")
	Local $def_input = GUICtrlCreateCombo(" ", 110, 230, 100, 385, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_NOINTEGRALHEIGHT))
		GUICtrlSetFont(-1, 20, 1000)
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlSetData($def_input, $DefEm_combo, " ")
	Local $defp_input = GUICtrlCreateCombo(" ", 110, 270, 100, 385, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_NOINTEGRALHEIGHT))
		GUICtrlSetFont(-1, 20, 1000)
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlSetData($defp_input, $Defp_combo, " ")
	Local $em_input = GUICtrlCreateCombo(" ", 110, 310, 100, 385, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_NOINTEGRALHEIGHT))
		GUICtrlSetFont(-1, 20, 1000)
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlSetData($em_input, $DefEm_combo, " ")
	Local $re_input = GUICtrlCreateCombo(" ", 110, 350, 100, 385, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_NOINTEGRALHEIGHT))
		GUICtrlSetFont(-1, 20, 1000)
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlSetData($re_input, $Re_combo, " ")
	Local $cr_input = GUICtrlCreateCombo(" ", 110, 390, 100, 385, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_NOINTEGRALHEIGHT))
		GUICtrlSetFont(-1, 20, 1000)
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlSetData($cr_input, $Cr_combo, " ")
	Local $cd_input	= GUICtrlCreateCombo(" ", 110, 430, 100, 385, BitOR($GUI_SS_DEFAULT_COMBO, $CBS_NOINTEGRALHEIGHT))
		GUICtrlSetFont(-1, 20, 1000)
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlSetData($cd_input, $Cd_combo, " ")

	Local $hp_slider = GUICtrlCreateSlider(220, 75, 140, 30)
		GUICtrlSetLimit(-1, 3, 0)
		GUICtrlSetData($hp_slider, 0)
	Local $hpp_slider = GUICtrlCreateSlider(220, 115, 140, 30)
		GUICtrlSetLimit(-1, 3, 0)
		GUICtrlSetData($hpp_slider, 0)
	Local $atk_slider = GUICtrlCreateSlider(220, 155, 140, 30)
		GUICtrlSetLimit(-1, 3, 0)
		GUICtrlSetData($atk_slider, 0)
	Local $atkp_slider = GUICtrlCreateSlider(220, 195, 140, 30)
		GUICtrlSetLimit(-1, 3, 0)
		GUICtrlSetData($atkp_slider, 0)
	Local $def_slider = GUICtrlCreateSlider(220, 235, 140, 30)
		GUICtrlSetLimit(-1, 3, 0)
		GUICtrlSetData($def_slider, 0)
	Local $defp_slider = GUICtrlCreateSlider(220, 275, 140, 30)
		GUICtrlSetLimit(-1, 3, 0)
		GUICtrlSetData($defp_slider, 0)
	Local $em_slider = GUICtrlCreateSlider(220, 315, 140, 30)
		GUICtrlSetLimit(-1, 3, 0)
		GUICtrlSetData($em_slider, 0)
	Local $re_slider = GUICtrlCreateSlider(220, 355, 140, 30)
		GUICtrlSetLimit(-1, 3, 0)
		GUICtrlSetData($re_slider, 0)
	Local $cr_slider = GUICtrlCreateSlider(220, 395, 140, 30)
		GUICtrlSetLimit(-1, 3, 0)
		GUICtrlSetData($cr_slider, 0)
	Local $cd_slider = GUICtrlCreateSlider(220, 435, 140, 30)
		GUICtrlSetLimit(-1, 3, 0)
		GUICtrlSetData($cd_slider, 0)

	Local $priority_label = GUICtrlCreateInput("Характеристики", 370, 32, 350, 28, $ES_CENTER)
		GUICtrlSetFont(-1, 14, 1000)
		GUICtrlSetTip(-1, "Ввести нужные статы персонажа для удобства", "", 1, 1)
	Local $saved_list = GUICtrlCreateEdit("", 370, 60, 350, 105, $ES_MULTILINE + $WS_VSCROLL + $ES_WANTRETURN)
		GUICtrlSetFont(-1, 12, 1000)
		GUICtrlSetTip(-1, "Поле сохраненных оценок", "", 1, 1)
	Local $log_list = GUICtrlCreateEdit("", 370, 165, 350, 278, $ES_MULTILINE + $WS_VSCROLL + $ES_WANTRETURN)
		GUICtrlSetFont(-1, 12, 1000)
		GUICtrlSetTip(-1, "Рабочее поле расчета оценок", "", 1, 1)
	Local $sum_label = GUICtrlCreateLabel("", 370, 442, 45, 28, $SS_CENTER, $SS_CENTERIMAGE)
		GUICtrlSetFont(-1, 16, 1000)
		GUICtrlSetData(-1, "0")
		GUICtrlSetTip(-1, "Общая сумма оценок", "", 1, 1)
	Local $output_label = GUICtrlCreateLabel("", 415, 442, 305, 28, $SS_CENTER, $SS_CENTERIMAGE)
		GUICtrlSetFont(-1, 16, 1000)
		GUICtrlSetTip(-1, "Поле вывода оценок", "", 1, 1)
	Local $check_button = GUICtrlCreateButton("Оценка20", 5, 480, 123, 35)
		GUICtrlSetFont(-1, 18, 1000)
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlSetTip(-1, "Оценить артефакт 20го уровня", "", 1, 1)
	Local $predict_button = GUICtrlCreateButton("Оценка16", 128, 480, 123, 35)
		GUICtrlSetFont(-1, 18, 1000)
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlSetTip(-1, "Оценить артефакт 16го уровня с предсказанием" & @CRLF & "Будет предсказана самая наилучшая оценка" & @CRLF & "если прокачать артефакт до 20го уровня", "", 1, 1)
	Local $tmp_button = GUICtrlCreateButton("💾", 251, 480, 35, 35)
		GUICtrlSetFont(-1, 18, 1000)
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlSetTip(-1, "Записать оценку артефакта для учета", "", 1, 1)
	Local $result_button = GUICtrlCreateButton("✅", 286, 480, 35, 35)
		GUICtrlSetFont(-1, 18, 1000)
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlSetTip(-1, "Учесть артефакт для оценки экипировки" & @CRLF & "Учитывается последовательно 5 артефактов", "", 1, 1)
	Local $clean_result = GUICtrlCreateButton("❌", 321, 480, 35, 35)
		GUICtrlSetFont(-1, 18, 1000)
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlSetTip(-1, "Сбросить оценку экипировки", "", 1, 1)
	Local $insert_button = GUICtrlCreateButton("✏️", 356, 480, 35, 35)
		GUICtrlSetFont(-1, 18, 1000)
		GUICtrlSetTip(-1, "Вставить последние учтенные параметры", "", 1, 1)
	Local $clear_button = GUICtrlCreateButton("Сброс", 391, 480, 88, 35)
		GUICtrlSetFont(-1, 18, 1000)
		GUICtrlSetTip(-1, "Сбросить введенные данные и слайдеры", "", 1, 1)
	Local $log_button = GUICtrlCreateButton("Очистить", 479, 480, 123, 35)
		GUICtrlSetFont(-1, 18, 1000)
		GUICtrlSetTip(-1, "Удалить записи лога безвозвратно", "", 1, 1)
	Local $exit_button = GUICtrlCreateButton("Закрыть", 602, 480, 123, 35)
		GUICtrlSetFont(-1, 18, 1000)
		GUICtrlSetTip(-1, "Закрыть вкладку", "", 1, 1)

EndFunc

Func CheckSlider($slider, $input)

	Local $cnt_checked = 0
	For $i = 0 To 9

		If GUICtrlRead(GUICtrlRead($TAB, 1) + 22 + $i) == 0 Then $cnt_checked += 1

	Next

	If $cnt_checked < 6 Then

		GUICtrlSetState($slider, $GUI_DISABLE)
		GUICtrlSetData($slider, 0)
		For $i = 0 To 9

			If GUICtrlRead(GUICtrlRead($TAB, 1) + 22 + $i) == 0 Then GUICtrlSetState(GUICtrlRead(GUICtrlRead($TAB, 1) + 22 + $i), $GUI_DISABLE)

		Next

	Else

		GUICtrlSetState(GUICtrlRead($TAB, 1) + 37, $GUI_ENABLE)
		GUICtrlSetState(GUICtrlRead($TAB, 1) + 38, $GUI_ENABLE)
		GUICtrlSetState($input, $GUI_ENABLE)
		GUICtrlSetState($slider, $GUI_ENABLE)
		For $i = 0 To 9

			If GUICtrlRead(GUICtrlRead($TAB, 1) + 22 + $i) == 0 Then GUICtrlSetState(GUICtrlRead($TAB, 1) + 22 + $i, $GUI_ENABLE)

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

Func Check($flg)

	Local $flag = 0
	Local $chk[12] = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	For $i = 0 To 9

		If GUICtrlRead(GUICtrlRead($TAB, 1) + 22 + $i) <> 0 Then

			If StringRegExp(GUICtrlRead(GUICtrlRead($TAB, 1) + 12 + $i), "^([0-9]{1,4})$|^([0-9]{1,2}\.[0-9]{1})$", 0) == 0 Then

				GUICtrlSetData(GUICtrlRead($TAB, 1) + 34, GUICtrlRead(GUICtrlRead($TAB, 1) + 34) & @CRLF & "Неправильный символ: " & GUICtrlRead(GUICtrlRead($TAB, 1) + 2 + $i) & @CRLF)
				_GUICtrlEdit_Scroll(GUICtrlRead($TAB, 1) + 34, $SB_BOTTOM)
				GUICtrlSetData(GUICtrlRead($TAB, 1) + 22 + $i, 0)
				GUICtrlSetState(GUICtrlRead($TAB, 1) + 12 + $i, $GUI_DISABLE)
				$flag = 0
				$chk[0] = 1
				Return $chk

			ElseIf $Stats[$i] < GUICtrlRead(GUICtrlRead($TAB, 1) + 12 + $i) Then

				GUICtrlSetData(GUICtrlRead($TAB, 1) + 34, GUICtrlRead(GUICtrlRead($TAB, 1) + 34) & @CRLF & "Превышение значения: " & GUICtrlRead(GUICtrlRead($TAB, 1) + 2 + $i) & @CRLF)
				_GUICtrlEdit_Scroll(GUICtrlRead($TAB, 1) + 34, $SB_BOTTOM)
				GUICtrlSetData(GUICtrlRead($TAB, 1) + 22 + $i, 0)
				GUICtrlSetState(GUICtrlRead($TAB, 1) + 12 + $i, $GUI_DISABLE)
				$flag = 0
				$chk[0] = 1
				Return $chk

			Else

				$flag = 1

			EndIf

		EndIf

	Next

	Local $summary = 0, $current = 0, $cnt = 0, $res = 1, $str
	Local $mult_array[10] = [$hp_mult, $hpp_mult, $atk_mult, $atkp_mult, $def_mult, $defp_mult, $em_mult, $re_mult, $cr_mult, $cd_mult]
	If $flag == 1 Then

		For $i = 0 To 9

			If GUICtrlRead(GUICtrlRead($TAB, 1) + 22 + $i) <> 0 Then

				$str &= $i & ' '
				$cnt += 1

			EndIf

		Next

		If $cnt == 4 Then $res = 1.5
		If $cnt == 3 Then $res = 1.3334
		If $cnt == 2 Then $res = 1.1667
		$str = StringSplit($str, ' ', 2)
		_ArrayDelete($str, UBound($str) - 1)
		If $flg == 1 Then

			For $i In $str

				If GUICtrlRead(GUICtrlRead($TAB, 1) + 22 + $i) <> 0 Then

					$current = GUICtrlRead(GUICtrlRead($TAB, 1) + 12 + $i) * (100 / $Stats[$i]) * $mult_array[$i]
					$summary += $current
					GUICtrlSetData(GUICtrlRead($TAB, 1) + 34, GUICtrlRead(GUICtrlRead($TAB, 1) + 34) & @CRLF & GUICtrlRead(GUICtrlRead($TAB, 1) + 2 + $i) & ": " & GUICtrlRead(GUICtrlRead($TAB, 1) + 12 + $i) & " - " & Round($current / $res, 2) & "%")

				EndIf

			Next
			GUICtrlSetData(GUICtrlRead($TAB, 1) + 34, GUICtrlRead(GUICtrlRead($TAB, 1) + 34) & @CRLF & "    Текущая оценка: " & Round($summary / $res, 2))
			Quality(Round($summary / $res))
			Local $max = 0, $predict, $prd = $summary
			$summary = 0
			For $j In $str

				For $i In $str

					If GUICtrlRead(GUICtrlRead($TAB, 1) + 22 + $i) <> 0 Then

						If $j == $i Then $predict = $Stats[$i] / 6
						$current = (GUICtrlRead(GUICtrlRead($TAB, 1) + 12 + $i) + $predict) * (100 / $Stats[$i]) * $mult_array[$i]
						$summary += $current
						GUICtrlSetData(GUICtrlRead($TAB, 1) + 34, GUICtrlRead(GUICtrlRead($TAB, 1) + 34) & @CRLF & GUICtrlRead(GUICtrlRead($TAB, 1) + 2 + $i) & ": " & (GUICtrlRead(GUICtrlRead($TAB, 1) + 12 + $i) + $predict) & " - " & Round($current / $res, 2) & "%")
						$predict = 0

					EndIf

				Next
				If $summary > $max Then $max = $summary
				$summary = 0
				If Round($max / $res, 2) < 100 Then
					GUICtrlSetData(GUICtrlRead($TAB, 1) + 34, GUICtrlRead(GUICtrlRead($TAB, 1) + 34) & @CRLF & "    Возможная оценка: " & Round($max / $res, 2))
				Else
					GUICtrlSetData(GUICtrlRead($TAB, 1) + 34, "Ошибка в стате для предсказания")
				EndIf

			Next
			$summary = $prd

		Else

			For $i In $str

				If GUICtrlRead(GUICtrlRead($TAB, 1) + 22 + $i) <> 0 Then

					$current = GUICtrlRead(GUICtrlRead($TAB, 1) + 12 + $i) * (100 / $Stats[$i]) * $mult_array[$i]
					$summary += $current
					GUICtrlSetData(GUICtrlRead($TAB, 1) + 34, GUICtrlRead(GUICtrlRead($TAB, 1) + 34) & @CRLF & GUICtrlRead(GUICtrlRead($TAB, 1) + 2 + $i) & ": " & GUICtrlRead(GUICtrlRead($TAB, 1) + 12 + $i) & " - " & Round($current / $res, 2) & "%")

				EndIf

			Next
			GUICtrlSetData(GUICtrlRead($TAB, 1) + 34, GUICtrlRead(GUICtrlRead($TAB, 1) + 34) & @CRLF & "    Текущая оценка: " & Round($summary / $res, 2))
			Quality(Round($summary / $res))

		EndIf

		If Round($summary / $res, 2) > 100 Then

			GUICtrlSetData(GUICtrlRead($TAB, 1) + 34, GUICtrlRead(GUICtrlRead($TAB, 1) + 34) & @CRLF & "Итого: Ошибка в величине статов" & @CRLF)

		Else

			GUICtrlSetData(GUICtrlRead($TAB, 1) + 34, GUICtrlRead(GUICtrlRead($TAB, 1) + 34) & @CRLF & "Итого: " & Round($summary / $res, 2) & @CRLF)

		EndIf
		_GUICtrlEdit_Scroll(GUICtrlRead($TAB, 1) + 34, $SB_BOTTOM)
		GUICtrlSetData(GUICtrlRead($TAB, 1) + 37, Round($summary / $res))
		GUICtrlSetData(GUICtrlRead($TAB, 1) + 38, Round($summary / $res))
		GUICtrlSetState(GUICtrlRead($TAB, 1) + 39, $GUI_ENABLE)
		GUICtrlSetBkColor(GUICtrlRead($TAB, 1) + 39, 0xFFFF00)

	EndIf
	For $i = 0 To 9

		$chk[$i + 1] = GUICtrlRead(GUICtrlRead($TAB, 1) + 22 + $i)
		GUICtrlSetData(GUICtrlRead($TAB, 1) + 22 + $i, 0)
		GUICtrlSetState(GUICtrlRead($TAB, 1) + 12 + $i, $GUI_DISABLE)

	Next
	$chk[11] = Round($summary / $res, 2)
	Return $chk

EndFunc

Func Quality($value)

	If $value > 100 Then
		GUICtrlSetData(GUICtrlRead($TAB, 1) + 36, "Ошибка в величине статов!")
		GUICtrlSetBkColor (GUICtrlRead($TAB, 1) + 36, 0xFF0000)
	ElseIf $value >= 90 Then
		GUICtrlSetData(GUICtrlRead($TAB, 1) + 36, "Качество: " & $value & "% Идеальное!")
		GUICtrlSetBkColor (GUICtrlRead($TAB, 1) + 36, 0x00FF00)
	ElseIf $value >= 70 Then
		GUICtrlSetData(GUICtrlRead($TAB, 1) + 36, "Качество: " & $value & "% Отличное!")
		GUICtrlSetBkColor (GUICtrlRead($TAB, 1) + 36, 0x80FF00)
	ElseIf $value >= 50 Then
		GUICtrlSetData(GUICtrlRead($TAB, 1) + 36, "Качество: " & $value & "% Среднее")
		GUICtrlSetBkColor (GUICtrlRead($TAB, 1) + 36, 0xFFFF00)
	ElseIf $value >= 30 Then
		GUICtrlSetData(GUICtrlRead($TAB, 1) + 36, "Качество: " & $value & "% Плохое")
		GUICtrlSetBkColor (GUICtrlRead($TAB, 1) + 36, 0xFF8000)
	Else
		GUICtrlSetData(GUICtrlRead($TAB, 1) + 36, "Качество: " & $value & "% Ужасное")
		GUICtrlSetBkColor (GUICtrlRead($TAB, 1) + 36, 0xFF0000)
	EndIf

EndFunc

Func SaveInput()

	Local $tmp[10]
	For $i = 0 To 9

		$tmp[$i] = GUICtrlRead(GUICtrlRead($TAB, 1) + 12 + $i)

	Next
	Return $tmp

EndFunc

Func Result($flg, $insl)

	Local $checked_art = Round($insl), $tmp
	If $flg == 0 Then
 
		If (GUICtrlRead(GUICtrlRead($TAB, 1) + 40) < 5 Or GUICtrlRead(GUICtrlRead($TAB, 1) + 40) <> "✅") And $checked_art <> 0 Then

			GUICtrlSetData(GUICtrlRead($TAB, 1) + 40, GUICtrlRead(GUICtrlRead($TAB, 1) + 40) + 1)
			$checked_art = $checked_art + $tmp
			GUICtrlSetData(GUICtrlRead($TAB, 1) + 37, "Оценка20")
			GUICtrlSetData(GUICtrlRead($TAB, 1) + 38, "Оценка16")
			GUICtrlSetData(GUICtrlRead($TAB, 1) + 34, GUICtrlRead(GUICtrlRead($TAB, 1) + 34) & "Артефакт учтён, количество: " & GUICtrlRead(GUICtrlRead($TAB, 1) + 40) & @CRLF & "Сумма: " & GUICtrlRead(GUICtrlRead($TAB, 1) + 35) + $checked_art & @CRLF)
			_GUICtrlEdit_Scroll(GUICtrlRead($TAB, 1) + 34, $SB_BOTTOM)
			GUICtrlSetData(GUICtrlRead($TAB, 1) + 35, GUICtrlRead(GUICtrlRead($TAB, 1) + 35) + $checked_art)
				If GUICtrlRead(GUICtrlRead($TAB, 1) + 40) == 5 Then

					GUICtrlSetData(GUICtrlRead($TAB, 1) + 33, GUICtrlRead(GUICtrlRead($TAB, 1) + 33) & @CRLF & "Итоговая оценка: " & GUICtrlRead(GUICtrlRead($TAB, 1) + 35) / 5)
					Quality(GUICtrlRead(GUICtrlRead($TAB, 1) + 35) / 5)
					GUICtrlSetData(GUICtrlRead($TAB, 1) + 34, GUICtrlRead(GUICtrlRead($TAB, 1) + 34) & "Учет Завершен!" & @CRLF)
					_GUICtrlEdit_Scroll(GUICtrlRead($TAB, 1) + 34, $SB_BOTTOM)
					GUICtrlSetState(GUICtrlRead($TAB, 1) + 41, $GUI_DISABLE)
					GUICtrlSetStyle(GUICtrlRead($TAB, 1) + 39, 0)
					GUICtrlSetState(GUICtrlRead($TAB, 1) + 39, $GUI_DISABLE)
					GUICtrlSetState(GUICtrlRead($TAB, 1) + 40, $GUI_DISABLE)
					GUICtrlSetData(GUICtrlRead($TAB, 1) + 39, "💾")
					GUICtrlSetData(GUICtrlRead($TAB, 1) + 40, "✅")
					GUICtrlSetData(GUICtrlRead($TAB, 1) + 35, "0")

				EndIf

		Else

			GUICtrlSetData(GUICtrlRead($TAB, 1) + 34, GUICtrlRead(GUICtrlRead($TAB, 1) + 34) & @CRLF & "Оцените артефакт!" & @CRLF)
			_GUICtrlEdit_Scroll(GUICtrlRead($TAB, 1) + 34, $SB_BOTTOM)

		EndIf

	ElseIf $flg == 1 Then

		If $checked_art <> 0 Then

			$tmp = $checked_art
			GUICtrlSetData(GUICtrlRead($TAB, 1) + 34, GUICtrlRead(GUICtrlRead($TAB, 1) + 34) & "Артефакт Записан: " & $tmp & @CRLF)
			_GUICtrlEdit_Scroll(GUICtrlRead($TAB, 1) + 34, $SB_BOTTOM)
			GUICtrlSetBkColor(GUICtrlRead($TAB, 1) + 39, 0x80FF00)
			GUICtrlSetData(GUICtrlRead($TAB, 1) + 39, $tmp)
			GUICtrlSetState(GUICtrlRead($TAB, 1) + 40, $GUI_ENABLE)
			GUICtrlSetState(GUICtrlRead($TAB, 1) + 39, $GUI_DISABLE)

		Else

			GUICtrlSetData(GUICtrlRead($TAB, 1) + 34, GUICtrlRead(GUICtrlRead($TAB, 1) + 34) & @CRLF & "Оцените артефакт!" & @CRLF)
			_GUICtrlEdit_Scroll(GUICtrlRead($TAB, 1) + 34, $SB_BOTTOM)

		EndIf

	EndIf

EndFunc

Func BlockColor($flg)

	If $flg == 0 Then
		For $i = 10 To 1390 Step 46
			If GUICtrlRead($TAB, 1) + 42 == $i + 42 Then
				GUICtrlSetData(GUICtrlRead($TAB, 1) + 42, "✒")
			Else
				GUICtrlSetStyle($i + 42, 0)
				GUICtrlSetData($i + 42, "✏️")
			EndIf
		Next
	Else
		If GUICtrlRead(GUICtrlRead($TAB, 1) + 42) == "✒" Then
			For $i = 10 To 1390 Step 46
				GUICtrlSetStyle($i + 42, 0)
				GUICtrlSetData($i + 42, "✏️")
			Next
		EndIf
	EndIf

EndFunc