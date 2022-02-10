;Библиотека некоторых функций
;В частности генератор сообщений для телеграмма
#include <Array.au3>
#include <File.au3>
#include <Date.au3>
#include <Constants.au3>
#include <WindowsConstants.au3>
#include <GUIConstants.au3>


;Данные для телеграмм бота
$sBotKey = 'bot1844208783:AAHnDQhkV7kARiLCyus0vxV8jQdAYy4TZcY'	;Ваш api ключ
$nChatId = -1001460258261                                      	;Id получателя
Dim $ip[2] = ["192.168.31.", "192.168.30."]			;Список может будет пополняться

Func Validator($textstring, $pat)					;Функция проверки строки по шаблону

	$textstring = StringRegExp($textstring, $pat, 2)
	if IsArray($textstring) <> 1 Then

		Return 1

	Endif

EndFunc

Func _URIEncode($sData)								;Генератор сообщений для телеграм бота

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

Func BotMsg($_TXT, $sNotif, $sBotKey, $nChatId)				;Отправитель сообщений боту в телеграм

	$sText = _URIEncode($_TXT)		; Текст сообщения, не больше 4000 знаков
	ConsoleWrite(InetRead('https://api.telegram.org/' & $sBotKey & '/sendMessage?chat_id=' & $nChatId & '&parse_mode=html&disable_notification=' & $sNotif & '&text=' & $sText, 0))

EndFunc

Func GetMac($_MACsIP)								;Функция получения MAC по айпи(взял из гугла)

    Local $_MAC, $_MACSize
    Local $_MACi, $_MACs, $_MACr, $_MACiIP
    $_MAC = DllStructCreate("byte[6]")
    $_MACSize = DllStructCreate("int")
    DllStructSetData($_MACSize, 1, 6)
    $_MACr = DllCall ("Ws2_32.dll", "int", "inet_addr", "str", $_MACsIP)
    $_MACiIP = $_MACr[0]
    $_MACr = DllCall ("iphlpapi.dll", "int", "SendARP", "int", $_MACiIP, "int", 0, "ptr", DllStructGetPtr($_MAC), "ptr", DllStructGetPtr($_MACSize))
    $_MACs  = ""

		For $_MACi = 0 To 5

			If $_MACi Then $_MACs = $_MACs & ":"
			$_MACs = $_MACs & Hex(DllStructGetData($_MAC, 1, $_MACi + 1), 2)

		Next

    DllClose($_MAC)
    DllClose($_MACSize)
    Return $_MACs

EndFunc

Func ListDivider()									;Функция создания строки разделителя

	$a = "-"
	For $i = 0 To 61 Step 1

		$a &= "-"				;Создаем строку разделитель

	Next

Return $a
EndFunc

Func FileReader($pathToFile, $sSearchText)			;Функция поиска строки в файле

	$sText = FileRead($pathToFile) 							;Читаем список
	$aLines = StringSplit($sText, @CRLF, 1)					;Делаем массив строк
		For $i = 1 To $aLines[0] Step +1					;Перебираем строки

			If StringInStr($aLines[$i], $sSearchText) Then	;Если есть совпадение, выдаем строку

				return $aLines[$i]
				ExitLoop

			EndIf

		Next

EndFunc

Func ChangeLog()									;Функция отрисовки окошка для записи изменений

	$GUI = GUICreate("GetStand Manager", 256, 144, -1, -1, $WS_DLGFRAME)
	$Input = GUICtrlCreateInput("Изменения", 5, 15, 246, 40)
	GUICtrlSetFont($Input, 20)
	$BtnOk = GUICtrlCreateButton("Отчет", 53, 60, 150, 50)
	GUICtrlSetFont($BtnOk, 16)
	GUISetState()
		While True

			Switch GUIGetMsg()

				Case $BtnOk
				$text = GUICtrlRead($Input)
				ExitLoop

			EndSwitch

		WEnd
	GUIDelete($GUI)

Return $text
EndFunc