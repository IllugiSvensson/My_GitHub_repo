#include <httpN_Windows_lib.au3>



;СОЗДАЕМ МЕНЮ МЕНЕДЖЕРА В ТРЕЕ
Opt("TrayMenuMode", 1 + 2)									;Отключаем стандартные пункты меню
;Создаем кнопки меню
Local $iMessage = TrayCreateItem("Сообщение пользователям")	;Отправить сообщение всем пользователям
Local $iList = TrayCreateItem("Пользователи в сети")		;Показать пользователей в сети
Local $iConfig = TrayCreateMenu("Конфигурации")				;Конфигурации подключений
	Local $iUsers = TrayCreateItem("Пользователи", $iConfig)
	Local $iHosts = TrayCreateItem("Компьютеры", $iConfig)
	Local $iVnc = TrayCreateItem("VNC сессии", $iConfig)
	TrayCreateItem("", $iConfig)							;Полоса разделитель
	Local $iConfigCreate = TrayCreateItem("Редактор конфигурации", $iConfig)
Local $iLog = TrayCreateMenu("Логи")						;Логи работы httpN
	Local $iRuns = TrayCreateItem("Логи подключений", $iLog)
	Local $iSystem = TrayCreateItem("Системные логи", $iLog)
	TrayCreateItem("", $iLog)
	Local $iLogClear = TrayCreateItem("Очистить логи", $iLog)
Local $iScheme = TrayCreateMenu("Схема")					;GetStand схема в двух вариантах
	Local $iCom = TrayCreateItem("Оффлайн схема", $iScheme)
	Local $iEdit = TrayCreateItem("Редактор", $iScheme)
Local $iCatalog = TrayCreateMenu("Каталоги")				;Основные рабочие каталоги
	Local $iGS = TrayCreateItem("Каталог GetStand", $iCatalog)
	Local $iHN = TrayCreateItem("Каталог httpN", $iCatalog)
Local $iUpdate = TrayCreateItem("Обновить httpN")			;Предупреждение об обновлении
TrayCreateItem("")
Local $iExit = TrayCreateItem("Выход")						;Выход из приложения



;Циклично наблюдаем за кнопками, выполняем действия при нажатии кнопок из трея
While True

	;БЛОК УПРАВЛЕНИЯ ПУНКТАМИ МЕНЮ ТРЕЯ
	Switch TrayGetMsg()		;Обрабатываем пункты меню

		Case $iMessage					;Открываем форму для ввода сообщений
			Message(3)

		Case $iList						;Открываем список пользователей онлайн
			ShowList()

		Case $iUsers					;Открываем список пользователей
			ShellExecute("\\main\GetStand\App\notepad\notepad++.exe", "\\main\GetStand\App\httpN\system\USERS")

		Case $iHosts					;Открываем список хостнеймов
			ShellExecute("\\main\GetStand\App\notepad\notepad++.exe", "\\main\GetStand\App\httpN\system\HOSTS")

		Case $iVnc						;Открываем список vnc
			ShellExecute("\\main\GetStand\App\vnc\config")

		Case $iConfigCreate				;Открываем редактор конфигурации
			ConfigEditor()

		Case $iRuns						;Открываем лог подключений
			ShellExecute("\\main\GetStand\App\httpN\system\log\log.txt")

		Case $iSystem					;Открываем лог системы
			ShellExecute("\\main\GetStand\App\httpN\system\log\system.txt")

		Case $iLogClear					;Предложение очистить все логи
			LogDeleter()

		Case $iCom						;Открываем схему оффлайн
			ShellExecute("\\main\GetStand\Diagrams\DiagramsOT.html")

		Case $iEdit						;Открываем редактор схемы
			ShellExecute("https://cloud.nboot.ru/nextcloud/apps/drawio/36850")

		Case $iGS						;Открываем основной каталог
			ShellExecute("\\main\GetStand")

		Case $iHN 						;Открыть каталог httpN
			ShellExecute("\\main\GetStand\App\httpN\system")

		Case $iUpdate					;Закрываем приложения и обновляем бинарник
			Update()

		Case $iExit						;Закрываем программу
			ExitLoop

	EndSwitch
	If FileExists("D:\Download\drawio.html") Then
		ConfigEditor()
		SchemeExport()
	EndIf

WEnd





;ПОЛЬЗОВАТЕЛЬСКИЕ ФУНКЦИИ
Func Message($type)									;Функция отправки сообщений всем пользователям

	Local $entry = EntryWindow($type, 0)
	Local $text = FileRead("\\main\GetStand\App\httpN\system\USERS")		;Читаем список
	$text = StringRegExp($text, "[а-яА-Я]{1,}\s{1,}[а-яА-Я]{1,}\(\w+\)", 3) ;Формируем имена
		If StringInStr($entry, "@all") Then		;Если метка "Всем"

			$entry = StringTrimLeft($entry, 5)
			For $i = 0 To UBound($text) - 1

				FileWriteLine("\\main\GetStand\App\httpN\system\temp\Changes\" & $text[$i], _NowDate() & " " & $entry)

			Next
			MsgBox(64, "GetStand", "Сообщение отправлено пользователям", 3)

		ElseIf StringInStr($entry, "@") Then

			Local $locUser = StringRegExp($entry, "(@\w+){1}(\@\w+){0,}", 3)	;Список получателей
			For $i = 0 To UBound($locUser) - 1									;Фильтруем строку ввода

				$entry = StringTrimLeft($entry, StringLen($locUser[$i]) + 1)

			Next
			For $i = 0 To UBound($text) - 1

				For $j = 0 To UBound($locUser) - 1

					If StringInStr($text[$i], StringTrimLeft($locUser[$j], 1)) <> 0 Then	;Если получатель есть в общем списке

						FileWriteLine("\\main\GetStand\App\httpN\system\temp\Changes\" & $text[$i], _NowDate() & " " & $entry)

					EndIf

				Next

			Next
			MsgBox(64, "GetStand", "Сообщение отправлено пользователям", 3)

		EndIf

EndFunc

Func ListDivider()									;Функция создания строки разделителя

	Local $a = "-"
	For $i = 0 To 61 Step 1

		$a &= "-"		;Создаем строку разделитель

	Next

Return $a
EndFunc

Func ShowList()										;Функция отображения списка пользователей

	FileWrite("\\main\GetStand\App\httpN\system\temp\Sessions\ONLINE", "")				;Опрашиваем пользователей 2 секунды
	Sleep(2500)
	Local $FileList = _FileListToArray("\\main\GetStand\App\httpN\system\temp\PIDS")	;Формируем список пользователей
	If IsArray($FileList) = 0 Then

		FileDelete("\\main\GetStand\App\httpN\system\temp\Sessions\ONLINE")
		MsgBox(64, "GetStand Manager", "Пользователи не в сети", 5)

	Else

		For $i = 1 To $FileList[0] Step +1			;Перебираем пользователей

			Local $time = StringRegExp($FileList[$i], "\.\d+$", 2)	;Выделяем время
			$time[0] = StringTrimLeft($time[0], 1)
			Local $host = StringRegExp($FileList[$i], "\.\w+\.", 2)	;Выделяем хост
			$host[0] = StringTrimLeft(StringTrimRight($host[0], 1), 1)
			Local $name = StringTrimRight($FileList[$i], StringLen($time[0]) + StringLen($host[0]) + 2)	;Выделяяем имя
			$FileList[$i] = "👤" & $name & " 🖥" & $host[0] & @CRLF & "        ➡️ В сети ⏱" & $time[0] & " минут"

		Next

		FileDelete("\\main\GetStand\App\httpN\system\temp\Sessions\ONLINE")		;Удаляем файлы метки
		DirRemove("\\main\GetStand\App\httpN\system\temp\PIDS", 1)
		DirCreate("\\main\GetStand\App\httpN\system\temp\PIDS")
		_ArrayDelete($FileList, 0)
		BotMsg("✅<b>Пользователи в сети:</b>" & @CRLF & ListDivider() & @CRLF & _ArrayToString($FileList, @CRLF), 0)
		MsgBox(64, "GetStand Manager", "Пользователи в сети: " & ListDivider() & @CRLF & _ArrayToString($FileList, @CRLF), 10)

	EndIf

EndFunc

Func HOSTConfig($mode, $hostname, $address, $port, $pass, $e_host, $e_add, $e_port, $e_pass, $stend)	;Функция редактирования хостов

	Dim $Array
	_FileReadToArray("\\main\GetStand\App\httpN\system\HOSTS", $Array)
	Switch $mode

		Case 0		;Записали новый адрес
			For $i = 0 To $Array[$i]

				If StringInStr($Array[$i], $stend) Then

					Local $code = _Encoding_Base64Encode($pass & $hostname & "A" & $address & "S" & $port)
					_FileWriteToLine("\\main\GetStand\App\httpN\system\HOSTS", $i + 1, StringStripWS($hostname & " A" & $address & " S" & $port & " #" & $code, 2), 0)
					ExitLoop

				EndIf

			Next

		Case 1		;Изменили существующий адрес
			For $i = 0 To $Array[0]

				If StringInStr($Array[$i], $hostname) Then

					Local $a = StringRegExp($Array[$i], "\w+", 2)
					If $a[0] <> $hostname Then ContinueLoop
					Local $sText = $Array[$i]
					If $e_host <> -1 Then $sText = StringReplace($sText, $hostname, $e_host)
					If $e_add <> -1 Then $sText = StringReplace($sText, $address, $e_add)
					If $e_port <> -1 Then $sText = StringReplace($sText, " S" & $port & " ", " S" & $e_port & " ")
					$sText = StringRegExpReplace($sText, "[#]\S+", "")
					If $e_pass <> -1 Then
						$sText = $sText & " #" & _Encoding_Base64Encode($e_pass & StringStripWS($sText, 8))
					Else
						$sText = $sText & " #" & _Encoding_Base64Encode($pass & StringStripWS($sText, 8))
					EndIf
					_FileWriteToLine("\\main\GetStand\App\httpN\system\HOSTS", $i, StringStripWS($sText, 2), 1)
					ExitLoop

				EndIf

			Next

		Case 2		;Удалили существующий адрес
			For $i = 0 To $Array[0]

				If StringInStr($Array[$i], $hostname) Then

					Local $a = StringRegExp($Array[$i], "\w+", 2)
					If $a[0] <> $hostname Then ContinueLoop
					_FileWriteToLine("\\main\GetStand\App\httpN\system\HOSTS", $i, "", 1)
					For $j = $i To $Array[0] - 1

						_FileWriteToLine("\\main\GetStand\App\httpN\system\HOSTS", $j, $Array[$j + 1], 1)

					Next
					_FileWriteToLine("\\main\GetStand\App\httpN\system\HOSTS", _FileCountLines("\\main\GetStand\App\httpN\system\HOSTS"), '', 1)
					ExitLoop

				EndIf

			Next

	EndSwitch

EndFunc

Func VNCConfig($mode, $hostname, $address, $port, $e_host, $e_add, $e_port)	;Функция изменения конфигов vnc

	Dim $Array
	_FileReadToArray("\\main\GetStand\App\vnc\config\" & $hostname & ".vnc", $Array)
	Switch $mode

		Case 0		;Создали новый конфиг
			If $port <> 22 Then
				Local $let = ":" & $port
			Else
				Local $let = ""
			EndIf
			FileCopy("\\main\GetStand\App\vnc\config\Pattern.vnc", "\\main\GetStand\App\vnc\config\" & $hostname & ".vnc")
			FileWrite("\\main\GetStand\App\vnc\config\" & $hostname & ".vnc", @CRLF & "Host=" & $address & $let)

		Case 1		;Изменили существующий конфиг
			For $i = 0 To $Array[0]

				If StringInStr($Array[$i], "Host=") Then

					Local $sText = $Array[$i]
					If $e_add <> -1 Then $sText = StringReplace($sText, $address, $e_add)
					If $e_port <> -1 Then

						Local $b = StringReplace($sText, "Host=" & $e_add, "")
						If StringLen($b) = 0 Then $sText = $sText & ":" & $e_port
						If StringLen($b) <> 0 Then $sText = StringReplace($sText, $b, $b & ":" & $e_port)

					EndIf
					If $e_port = 22 Then $sText = StringRegExpReplace($sText, "\:[0-9]{2,5}", "")
					_FileWriteToLine("\\main\GetStand\App\vnc\config\" & $hostname & ".vnc", $i, $sText, 1)
					ExitLoop

				EndIf

			Next
			If $e_host <> -1 Then FileMove("\\main\GetStand\App\vnc\config\" & $hostname & ".vnc", "\\main\GetStand\App\vnc\config\" & $e_host & ".vnc")

		Case 2		;Удалили существующий конфиг
			FileDelete("\\main\GetStand\App\vnc\config\" & $hostname & ".vnc")

	EndSwitch

EndFunc

Func InputValidator($str1, $str2, $str3, $str4)		;Функция проверки пользовательского ввода

	Local $val1 = Validator($str1, "\w+|\-1")
	Local $val2 = Validator($str2, "(([0-9]{1,3}\.){3}[0-9]{1,3})|\-1")
	Local $val3 = Validator($str3, "[0-9]{2,5}|\-1")
	Local $val4 = Validator($str4, "\S+|\-1")
	If ($val1 + $val2 + $val3 + $val4) <> 4 Then

		MsgBox(16, "Ошибка", "Ошибка в одном из полей", 3)
		Return 1

	EndIf

Return 0
EndFunc

Func FindConfig($hst)								;Функция поиска данных конфига

	Local $path = "\\main\GetStand\App\"
	Dim $CFG[3] = [ -1, -1, -1 ]					;Массив параметров
	If StringInStr(FileRead($path & "\httpN\system\HOSTS"), $hst) AND FileExists($path & "vnc\config\" & $hst & ".vnc") Then

		Local $conf = FileRead($path & "httpN\system\HOSTS")			;Читаем список
		Local $aLines = StringSplit($conf, @CRLF, 0)					;Делаем массив строк
		For $i = 1 To $aLines[0] Step +1								;Перебираем строки

			If StringInStr($aLines[$i], $hst) Then						;Если есть совпадение, выдаем строку

				Local $a = StringRegExp($aLines[$i], "\w+", 2)
				If $a[0] <> $hst Then ContinueLoop
				Local $x = StringRegExp($aLines[$i], "[A]((\w+\.){3}\w+)", 2)	;Получаем шаблон адреса
				Local $y = StringRegExp($aLines[$i], "[S][0-9]{2,5}", 2)		;Получаем шаблон порта
				Local $z = StringRegExp($aLines[$i], "[#]\S+", 2)				;Получаем шаблон пароля
				$CFG[2] = StringTrimLeft($z[0], 1)
				$CFG[1] = StringTrimLeft($y[0], 1)
				$CFG[0] = StringTrimLeft($x[0], 1)
				$CFG[2] = _Encoding_Base64Decode($CFG[2])
				$CFG[2] = StringReplace($CFG[2], $hst, "")
				$CFG[2] = StringReplace($CFG[2], $x[0], "")
				$CFG[2] = StringReplace($CFG[2], $y[0], "")
				ExitLoop

			EndIf

		Next
		GUICtrlSetState($E_Input2, $GUI_ENABLE)
		GUICtrlSetState($E_Input3, $GUI_ENABLE)
		GUICtrlSetState($E_Input4, $GUI_ENABLE)
		GUICtrlSetState($E_Input5, $GUI_ENABLE)
		Return $CFG

	Else

		MsgBox(16, "Ошибка", "Конфиг не найден", 3)
		ShellExecute("\\main\GetStand\App\notepad\notepad++.exe", "\\main\GetStand\App\httpN\system\HOSTS")
		ShellExecute("\\main\GetStand\App\vnc\config")
		GUICtrlSetState($E_Input2, $GUI_DISABLE)
		GUICtrlSetState($E_Input3, $GUI_DISABLE)
		GUICtrlSetState($E_Input4, $GUI_DISABLE)
		GUICtrlSetState($E_Input5, $GUI_DISABLE)
		Return $CFG

	EndIf

EndFunc

Func ConfigEditor()									;Функция создания окна для редактирования конфигурации

	Local $GUI = GUICreate("Редактор конфигурации", 330, 330, -1, -1, $WS_DLGFRAME)	;Основные элементы
	Local $TAB = GUICtrlCreateTab(5, 5, 320, 240)
	Local $OKbtn = GUICtrlCreateButton("Продолжить", 25, 255, 125, 40)
	Local $CNCLbtn = GUICtrlCreateButton("Выход", 175, 255, 125, 40)
	Local $path = "\\main\GetStand\App\"

		Local $Tab1 = GUICtrlCreateTabItem("Создать")								;Внутренние элементы
			Local $C_Input1 = GUICtrlCreateInput('Хостнейм', 20, 80, 285, 30)
			GUICtrlSetFont($C_Input1, 14)
			Local $C_Input2 = GUICtrlCreateInput("Адрес", 20, 120, 285, 30)
			GUICtrlSetFont($C_Input2, 14)
			Local $C_Input3 = GUICtrlCreateInput('Порт', 20, 160, 285, 30)
			GUICtrlSetFont($C_Input3, 14)
			Local $C_Input4 = GUICtrlCreateInput('Пароль', 20, 200, 285, 30)
			GUICtrlSetFont($C_Input4, 14)
			Local $C_Box = GUICtrlCreateCombo('', 20, 40, 285, 30, $CBS_DROPDOWNLIST)
			GUICtrlSetFont($C_Box, 14)
			Dim $Array
			_FileReadToArray("\\main\GetStand\App\httpN\system\HOSTS", $Array)
			For $i = 0 To $Array[0]

				If StringInStr($Array[$i], ":") Then GUICtrlSetData($C_Box, StringTrimRight($Array[$i], 1), "Прочие")

			Next
			GUICtrlSetState(-1, $GUI_SHOW)

		Local $Tab2 = GUICtrlCreateTabItem("Редактировать")
			Local $E_Input1 = GUICtrlCreateInput('Хостнейм', 20, 40, 140, 30)
			GUICtrlSetFont($E_Input1, 14)
			Local $E_Button1 = GUICtrlCreateButton("Получить", 20, 80, 140, 30)
			GUICtrlSetFont($E_Button1, 14)
			Local $E_Label1 = GUICtrlCreateLabel('Адрес', 20, 120, 140, 30, $WS_BORDER)
			GUICtrlSetFont($E_Label1, 14)
			GUICtrlSetState($E_Label1, $GUI_DISABLE)
			Local $E_Label2 = GUICtrlCreateLabel('Порт', 20, 160, 140, 30, $WS_BORDER)
			GUICtrlSetFont($E_Label2, 14)
			GUICtrlSetState($E_Label2, $GUI_DISABLE)
			Local $E_Label3 = GUICtrlCreateLabel('Пароль', 20, 200, 140, 30, $WS_BORDER)
			GUICtrlSetFont($E_Label3, 14)
			GUICtrlSetState($E_Label3, $GUI_DISABLE)
			Local $E_Label4 = GUICtrlCreateLabel('Поставить -1, чтобы не редактитовать поле', 170, 40, 140, 30)
			GUICtrlSetFont($E_Label4, 9)
			Global $E_Input2= GUICtrlCreateInput("Хостнейм", 170, 80, 140, 30)
			GUICtrlSetFont($E_Input2, 14)
			GUICtrlSetState($E_Input2, $GUI_DISABLE)
			Global $E_Input3 = GUICtrlCreateInput('Адрес', 170, 120, 140, 30)
			GUICtrlSetFont($E_Input3, 14)
			GUICtrlSetState($E_Input3, $GUI_DISABLE)
			Global $E_Input4 = GUICtrlCreateInput('Порт', 170, 160, 140, 30)
			GUICtrlSetFont($E_Input4, 14)
			GUICtrlSetState($E_Input4, $GUI_DISABLE)
			Global $E_Input5 = GUICtrlCreateInput('Пароль', 170, 200, 140, 30)
			GUICtrlSetFont($E_Input5, 14)
			GUICtrlSetState($E_Input5, $GUI_DISABLE)

		Local $Tab3 = GUICtrlCreateTabItem("Удалить")
			Local $D_Input1 = GUICtrlCreateInput("Хостнейм", 20, 100, 285, 30)
			GUICtrlSetFont($D_Input1, 14)

	GUICtrlCreateTabItem("") 	;определяет конец вкладок
	GUISetState()

	While True

		Switch GUIGetMsg()

			Case $OKbtn				;Нажали ОК. В зависимости от вкладки, выполняем разные действия
				Switch GUICtrlRead($TAB)

					Case 0			;Проверяем ввод элементов и вызываем функции обработки
						If InputValidator(GUICtrlRead($C_Input1), GUICtrlRead($C_Input2), GUICtrlRead($C_Input3), GUICtrlRead($C_Input4)) Then ContinueLoop
						If StringInStr(FileRead("\\main\GetStand\App\httpN\system\HOSTS"), GUICtrlRead($C_Input1) & " ") Then

							MsgBox(64, "GetStand Manager", "Конфигурация существует", 3, $GUI)
							ContinueLoop

						EndIf
						HOSTConfig(0, GUICtrlRead($C_Input1), GUICtrlRead($C_Input2), GUICtrlRead($C_Input3), GUICtrlRead($C_Input4), -1, -1, -1, -1, GUICtrlRead($C_Box))
						VNCConfig(0, GUICtrlRead($C_Input1), GUICtrlRead($C_Input2), GUICtrlRead($C_Input3), -1, -1, -1)
						BotMsg("💾<b>Создана конфигурация для хоста</b>" & @CRLF & "🖥️" & GUICtrlRead($C_Input1) & " ⏱" & _Now(), 0)
						FileWriteLine("\\main\GetStand\App\httpN\system\log\system.txt", StringFormat("%-19s", _Now()) & " | " & "Создана конфигурация для " & GUICtrlRead($C_Input1))
						MsgBox(64, "GetStand Manager", "Конфигурация сохранена", 3, $GUI)

					Case 1
						If InputValidator(GUICtrlRead($E_Input2), GUICtrlRead($E_Input3), GUICtrlRead($E_Input4), GUICtrlRead($E_Input5)) Then ContinueLoop
						HOSTConfig(1, GUICtrlRead($E_Input1), GUICtrlRead($E_Label1), GUICtrlRead($E_Label2), GUICtrlRead($E_Label3), GUICtrlRead($E_Input2), GUICtrlRead($E_Input3), GUICtrlRead($E_Input4), GUICtrlRead($E_Input5), -1)
						VNCConfig(1, GUICtrlRead($E_Input1), GUICtrlRead($E_Label1), GUICtrlRead($E_Label2), GUICtrlRead($E_Input2), GUICtrlRead($E_Input3), GUICtrlRead($E_Input4))
						GUICtrlSetState($E_Input2, $GUI_DISABLE)
						GUICtrlSetState($E_Input3, $GUI_DISABLE)
						GUICtrlSetState($E_Input4, $GUI_DISABLE)
						GUICtrlSetState($E_Input5, $GUI_DISABLE)
						BotMsg("💾<b>Изменена конфигурация хоста</b>" & @CRLF & "🖥️" & GUICtrlRead($E_Input1) & " ⏱" & _Now(), 0)
						FileWriteLine("\\main\GetStand\App\httpN\system\log\system.txt", StringFormat("%-19s", _Now()) & " | " & "Изменена конфигурация для " & GUICtrlRead($E_Input1))
						MsgBox(64, "GetStand Manager", "Конфигурация изменена", 3, $GUI)

					Case 2
						If InputValidator(GUICtrlRead($D_Input1), -1, -1, -1) Then ContinueLoop
						If StringInStr(FileRead("\\main\GetStand\App\httpN\system\HOSTS"), GUICtrlRead($D_Input1) & " ") = 0 Then

							MsgBox(64, "GetStand Manager", "Конфигурация не существует", 3, $GUI)
							ContinueLoop

						EndIf
						HOSTConfig(2, GUICtrlRead($D_Input1), -1, -1, -1, -1, -1, -1, -1, -1)
						VNCConfig(2, GUICtrlRead($D_Input1), -1, -1, -1, -1, -1)
						BotMsg("⚠️<b>Конфигурация для хоста удалена</b>" & @CRLF & "🖥️" & GUICtrlRead($D_Input1) & " ⏱" & _Now(), 0)
						FileWriteLine("\\main\GetStand\App\httpN\system\log\system.txt", StringFormat("%-19s", _Now()) & " | " & "Конфигурация для " & GUICtrlRead($D_Input1) & " удалена")
						MsgBox(64, "GetStand Manager", "Конфигурация удалена", 3, $GUI)

				EndSwitch

			Case $E_Button1			;Проверяем наличие конфига
				Dim $FC = FindConfig(GUICtrlRead($E_Input1))
				GUICtrlSetData($E_Label1, $FC[0])
				GUICtrlSetData($E_Label2, $FC[1])
				GUICtrlSetData($E_Label3, $FC[2])

			Case $CNCLbtn			;Выходим
				ExitLoop

		EndSwitch

	WEnd
	GUIDelete()

EndFunc

Func LogDeleter()									;Функция для удаления логов

	if MsgBox(36, "GetStand Manager", "Очистить все логи?" & @CRLF & "(Действие необратимо)") = 6 Then

		;Логи подключений
		FileDelete("\\main\GetStand\App\httpN\system\log\*")
		FileWrite("\\main\GetStand\App\httpN\system\log\log.txt", "")
		;Системные логи
		FileWrite("\\main\GetStand\App\httpN\system\log\system.txt", "")
		BotMsg("⚠️<b>Логи подключений удалены</b>" & @CRLF & "⏱" & _Now(), 0)
		FileWriteLine("\\main\GetStand\App\httpN\system\log\system.txt", StringFormat("%-19s", _Now()) & " | " & "Логи подключений удалены")
		MsgBox(64, "GetStand Manager", "Логи удалены", 3)

	EndIf

EndFunc

Func SchemeExport()									;Функция экспортирования схемы на диск после редактирования

	Local $entry = EntryWindow(4, 0)
	If StringLen($entry) > 1 Then

		Local $text = FileRead("\\main\GetStand\App\httpN\system\USERS")		;Читаем список
		$text = StringRegExp($text, "[а-яА-Я]{1,}\s{1,}[а-яА-Я]{1,}\(\w+\)", 3) ;Формируем имена
		BotMsg("🔥<b>Схема GetStand обновлена!</b>" & @CRLF & "📋" & $entry & @CRLF & "⏱" & _Now(), 0)
		FileWriteLine("\\main\GetStand\App\httpN\system\log\system.txt", StringFormat("%-19s", _Now()) & " | " & "Обновление схемы завершено. Изменения: " & $entry)
		FileMove("D:\Download\drawio.html", "\\main\GetStand\Diagrams\DiagramsOT.html", 1)	;Перемещаем схему с перезаписью
			For $i = 0 To UBound($text) - 1

				FileWriteLine("\\main\GetStand\App\httpN\system\temp\Changes\" & $text[$i], _NowDate() & " Изменения схемы: " & $entry)

			Next
			MsgBox(64, "GetStand", "Отчет отправлен пользователям", 3)

	Else

		FileDelete("D:\Download\drawio.html")

	EndIf

EndFunc

Func Update()										;Функция выключения приложений и обновления httpN

	If MsgBox(36, "GetStand Manager", "Провести обновление httpN?") = 6 Then	;Если нажали да

		Local $text = ChangeLog()
		FileWrite("\\main\GetStand\App\httpN\system\temp\Sessions\UPDATE", "")	;Предупреждаем об обновлении
		BotMsg("⚠️<b>Запущено обновление httpN</b>" & @CRLF & "️🔄Автоотключение через минуту" & @CRLF & "⏱" & _Now(), 0, $sBotKey, $nChatId)
		FileWriteLine("\\main\GetStand\App\httpN\system\log\system.txt", StringFormat("%-19s", _Now()) & " | " & "Запущено обновление httpN")
		TraySetState(2)															;Скрываем иконку
		ProgressOn("GetStand Manager", "Обновление httpN", "", -1, -1, 3) 		;Ведем отсчет обновления
			For $i = 1 To 100 Step 1.67											;Ожидаем минуту

				ProgressSet($i)
				Sleep(1000)

			Next
		ProgressOff()
		FileWrite("\\main\GetStand\App\httpN\system\temp\Sessions\KILL", "")	;Создаем файл, который точно убьет все процессы
		Sleep(1200)																;Убиваем процессы
		Local $AutoIt = "D:\Programms\AutoIt3\Aut2Exe\Aut2exe.exe /in D:\NitaGit\httpN\httpN_Windows.au3 /out \\main\GetStand\App\httpN\httpN_Windows.exe /icon \\main\GetStand\App\ChromePortable\GetStand.ICO /x86"
		Run(@ComSpec&' /c ' & $AutoIt, '', @SW_HIDE, $STDOUT_CHILD)				;Компилируем бинарь
		FileDelete("\\main\GetStand\App\httpN\system\temp\Sessions\UPDATE")		;Разрешаем дальнейшую работу
		FileDelete("\\main\GetStand\App\httpN\system\temp\Sessions\KILL")
		TraySetState(1)
		BotMsg("🔥<b>Обновление завершено!</b>" & @CRLF & "📋" & $text & @CRLF & "⏱" & _Now(), 0, $sBotKey, $nChatId)
		FileWriteLine("\\main\GetStand\App\httpN\system\log\system.txt", StringFormat("%-19s", _Now()) & " | " & "Обновление завершено. Изменения: " & $text)
		MsgBox(64, "GetStand Manager", "Обновление прошло успешно!", 5)

	EndIf

EndFunc