Func GetMac($_MACsIP)							;Функция получения MAC по айпи(взял из гугла)

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

Func FileReader($pathToFile, $sSearchText)		;Функция поиска строки в файле

	$sText = FileRead($pathToFile) 							;Читаем список
	$aLines = StringSplit($sText, @CRLF, 1)					;Делаем массив строк
		For $i = 1 To $aLines[0] Step +1					;Перебираем строки

			If StringInStr($aLines[$i], $sSearchText) Then	;Если есть совпадение, выдаем строку

				return $aLines[$i]
				ExitLoop

			EndIf

		Next

EndFunc