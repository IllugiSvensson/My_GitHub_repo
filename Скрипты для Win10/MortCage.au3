#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

;НАСТРОЙКИ ПРОГРАММЫ
AutoItSetOption("MustDeclareVars", 1)
Opt("TrayMenuMode", 1 + 2)

Local $MainWindow = GUICreate("Калькулятор кредита", 500, 450, -1, -1, $WS_DLGFRAME, $WS_EX_TOPMOST)

	GUICtrlCreateLabel("Общая сумма с последнего платежа", 10, 10, 400, 35)
		GUICtrlSetFont(-1, 16, 1000)
	Local $CurIn1 = GUICtrlCreateInput("", 10, 50, 120, 35)
		GUICtrlSetFont(-1, 16, 1000)
	Local $CurIn2 = GUICtrlCreateInput("", 140, 50, 120, 35)
		GUICtrlSetFont(-1, 16, 1000)
	Local $CurIn3 = GUICtrlCreateInput("", 270, 50, 120, 35)
		GUICtrlSetFont(-1, 16, 1000)
	
	GUICtrlCreateLabel("Общая сумма на платеж и распределение", 10, 100, 450, 35)
		GUICtrlSetFont(-1, 16, 1000)
	Local $PrIn = GUICtrlCreateInput("", 10, 140, 120, 35)
		GUICtrlSetFont(-1, 16, 1000)
	Local $iSl1 = GUICtrlCreateSlider(10, 180, 375, 40)
		GUICtrlSetFont(-1, 16, 1000)
		GUICtrlSetLimit(-1, 100)
	Local $iSl2 = GUICtrlCreateSlider(10, 225, 375, 40)
		GUICtrlSetFont(-1, 16, 1000)
		GUICtrlSetLimit(-1, 100)
	Local $iSl3 = GUICtrlCreateSlider(10, 270, 375, 40)
		GUICtrlSetFont(-1, 16, 1000)
		GUICtrlSetLimit(-1, 100)
	Local $iLb1 = GUICtrlCreateLabel(GUICtrlRead($iSl1), 385, 170, 105, 30)
		GUICtrlSetFont(-1, 16, 1000)
	Local $iLb2 = GUICtrlCreateLabel(GUICtrlRead($iSl2), 385, 210, 105, 30)
		GUICtrlSetFont(-1, 16, 1000)
	Local $iLb3 = GUICtrlCreateLabel(GUICtrlRead($iSl3), 385, 250, 105, 30)
		GUICtrlSetFont(-1, 16, 1000)

	Local $end = GUICtrlCreateLabel("Сумма переплаты: ", 10, 315, 400, 35)
		GUICtrlSetFont(-1, 16, 1000)

	Local $exit_button = GUICtrlCreateButton("Выход", 200, 355, 100, 35)
		GUICtrlSetFont(-1, 18, 1000)
	Local $a, $b, $c

GUISetState(@SW_SHOW)

While True

	Switch GUIGetMsg()
		Case $iSl1
			GUICtrlSetLimit($iSl1, 100 - GUICtrlRead($iSl2) - GUICtrlRead($iSl3))
			GUICtrlSetData($iLb1,GUICtrlRead($iSl1) & " " & (GUICtrlRead($PrIn) * GUICtrlRead($iSl1))/100)
			$a = CheckSum(GuiCtrlRead($CurIn1), 15.89, (GUICtrlRead($PrIn) * GUICtrlRead($iSl1))/100, 0.18) - GuiCtrlRead($CurIn1)
			$b = CheckSum(GuiCtrlRead($CurIn2), 106.9, (GUICtrlRead($PrIn) * GUICtrlRead($iSl2))/100, 2.43) - GuiCtrlRead($CurIn2)
			$c = CheckSum(GuiCtrlRead($CurIn3), 10.62, (GUICtrlRead($PrIn) * GUICtrlRead($iSl3))/100, 0.4) - GuiCtrlRead($CurIn3)
			GUICtrlSetData($end, "Сумма переплаты: " & round($a, 2) + round($b, 2) + round($c, 2))

		Case $iSl2
			GUICtrlSetLimit($iSl2, 100 - GUICtrlRead($iSl1) - GUICtrlRead($iSl3))
			GUICtrlSetData($iLb2,GUICtrlRead($iSl2) & " " & (GUICtrlRead($PrIn) * GUICtrlRead($iSl2))/100)
			$a = CheckSum(GuiCtrlRead($CurIn1), 15.89, (GUICtrlRead($PrIn) * GUICtrlRead($iSl1))/100, 0.18) - GuiCtrlRead($CurIn1)
			$b = CheckSum(GuiCtrlRead($CurIn2), 106.9, (GUICtrlRead($PrIn) * GUICtrlRead($iSl2))/100, 2.43) - GuiCtrlRead($CurIn2)
			$c = CheckSum(GuiCtrlRead($CurIn3), 10.62, (GUICtrlRead($PrIn) * GUICtrlRead($iSl3))/100, 0.4) - GuiCtrlRead($CurIn3)
			GUICtrlSetData($end, "Сумма переплаты: " & round($a, 2) + round($b, 2) + round($c, 2))			

		Case $iSl3
			GUICtrlSetLimit($iSl3, 100 - GUICtrlRead($iSl1) - GUICtrlRead($iSl2))
			GUICtrlSetData($iLb3,GUICtrlRead($iSl3) & " " & (GUICtrlRead($PrIn) * GUICtrlRead($iSl3))/100)
			$a = CheckSum(GuiCtrlRead($CurIn1), 15.89, (GUICtrlRead($PrIn) * GUICtrlRead($iSl1))/100, 0.18) - GuiCtrlRead($CurIn1)
			$b = CheckSum(GuiCtrlRead($CurIn2), 106.9, (GUICtrlRead($PrIn) * GUICtrlRead($iSl2))/100, 2.43) - GuiCtrlRead($CurIn2)
			$c = CheckSum(GuiCtrlRead($CurIn3), 10.62, (GUICtrlRead($PrIn) * GUICtrlRead($iSl3))/100, 0.4) - GuiCtrlRead($CurIn3)
			GUICtrlSetData($end, "Сумма переплаты: " & round($a, 2) + round($b, 2) + round($c, 2))
		Case $exit_button
			ExitLoop

	EndSwitch

WEnd
GUIDelete()




Func CheckSum($cur, $cd, $cp, $dif)

	Local $days = 0
	Local $sum = $cur
	While ($cur >= 0)

		$days += 1
		$cur += $cd
		$sum += $cd
		If (mod($days, 29) == 0) Then

			$cur -= $cp
			$cd -= $dif

		EndIf

	WEnd
Return $sum
EndFunc