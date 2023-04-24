#include <File.au3>



If FileExists(@WorkingDir & "\Input.txt") == 0 Then

	FileWrite(@WorkingDir & "\Input.txt", "Проценты   Мин еж.платеж   Остаток на момент последнего платежа" & @CRLF)
	FileWrite(@WorkingDir & "\Input.txt", "1.175      1018.33         19777.73")

EndIf


Local $List
ShellExecuteWait(@WorkingDir & "\Input.txt")
_FileReadToArray(@WorkingDir & "\Input.txt", $List)

Local $PERC1 = StringRegExp($List[2], "\w{1,}\.\w{1,}", 3)[0]
Local $mEP1 = StringRegExp($List[2], "\w{1,}\.\w{1,}|\w{1,}", 3)[1]
Local $current1 = StringRegExp($List[2], "\w{1,}\.\w{1,}|\w{1,}", 3)[2]

If $current1 <= ($current1 + ($current1 * $PERC1 - $current1)/12 - $mEP1) Then
	MsgBox(64, "Ошибка", "Процент больше платежа!")
	Exit
EndIf
CheckSum($mEP1, 0, 0, $mEP1 + 1, 1)





Func CheckSum($pl1, $pl2, $pl3, $spl, $flag)

    Local $month = 0
    Local $rem1 = $current1
    Local $overprice = 0
    Local $pl_1 = $pl1
    If ($flag == 1) Then FileWrite(@WorkingDir & "\Credit.txt", $month & "   " & Round($rem1, 2) & @CRLF)
    While (($rem1) >= 0)
        $month += 1
        $overprice += ((($rem1 * $PERC1) - $rem1))/12
        $rem1 = CheckPl($rem1, $pl_1, $PERC1)
        If ($flag == 1) Then FileWrite(@WorkingDir & "\Credit.txt", $month & "   " & Round($rem1, 2) & @CRLF)
    WEnd
    If ($flag == 1) Then FileWrite(@WorkingDir & "\Credit.txt", "Переплата: " & Round($overprice, 2) & @CRLF)

Return $overprice
EndFunc

Func CheckPl($current, $epl, $percent)
    If $current <= 0 Then return 0
    return $current + ($current * $percent - $current)/12 - $epl
EndFunc

