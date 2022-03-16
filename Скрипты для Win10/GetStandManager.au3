#include <httpN_Windows_lib.au3>



;СОЗДАЕМ МЕНЮ МЕНЕДЖЕРА В ТРЕЕ
Opt("TrayMenuMode", 1 + 2)									;Отключаем стандартные пункты меню
;Создаем кнопки меню
Local $iList = TrayCreateItem("Пользователи в сети")		;Показать пользователей в сети
Local $iConfig = TrayCreateMenu("Конфигурации")				;Конфигурации подключений
	Local $iUsers = TrayCreateItem("Пользователи", $iConfig)
	Local $iHosts = TrayCreateItem("Компьютеры", $iConfig)
	Local $iKit = TrayCreateItem("Kitty сессии", $iConfig)
	Local $iScp = TrayCreateItem("WinSCP сессии", $iConfig)
	Local $iVnc = TrayCreateItem("VNC сессии", $iConfig)
	TrayCreateItem("", $iConfig)							;Полоса разделитель
	Local $iConfigCreate = TrayCreateItem("Редактор конфигурации", $iConfig)
Local $iLog = TrayCreateMenu("Логи")						;Логи работы httpN
	Local $iRuns = TrayCreateItem("Логи подключений", $iLog)
	Local $iSystem = TrayCreateItem("Системные логи", $iLog)
	Local $iKitLog = TrayCreateItem("Логи Kitty", $iLog)
	Local $iScpLog = TrayCreateItem("Логи WinSCP", $iLog)
	Local $iVncLog = TrayCreateItem("Логи VNC", $iLog)
	TrayCreateItem("", $iLog)
	Local $iLogClear = TrayCreateItem("Очистить логи", $iLog)
Local $iScheme = TrayCreateMenu("Схема")					;GetStand схема в двух вариантах
	Local $iCom = TrayCreateItem("Оффлайн схема", $iScheme)
	Local $iEdit = TrayCreateItem("Редактор", $iScheme)
	TrayCreateItem("", $iScheme)
	Local $iExport = TrayCreateItem("Экспорт схемы", $iScheme)
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

		Case $iList						;Открываем список пользователей онлайн
			ShowList()

		Case $iUsers					;Открываем список пользователей
			ShellExecute("\\main\GetStand\App\notepad\notepad++.exe", "\\main\GetStand\App\httpN\system\USERS")

		Case $iHosts					;Открываем список хостнеймов
			ShellExecute("\\main\GetStand\App\notepad\notepad++.exe", "\\main\GetStand\App\httpN\system\HOSTS")

		Case $iKit						;Открываем сессии китти
			ShellExecute("\\main\GetStand\App\kitty\Sessions")

		Case $iScp						;Открываем сессии scp
			ShellExecute("\\main\GetStand\App\notepad\notepad++.exe", "\\main\GetStand\App\winscp\WinSCP.ini")

		Case $iVnc						;Открываем список мак адресов
			ShellExecute("\\main\GetStand\App\vnc\config")

		Case $iConfigCreate				;Открываем редактор конфигурации
			ConfigEditor()

		Case $iRuns						;Открываем лог подключений
			ShellExecute("\\main\GetStand\App\httpN\system\log\log.txt")

		Case $iSystem					;Открываем лог системы
			ShellExecute("\\main\GetStand\App\httpN\system\log\system.txt")

		Case $iKitLog					;Открываем логи по kitty
			ShellExecute("\\main\GetStand\App\kitty\Log")

		Case $iScpLog					;Открываем логи по winscp
			ShellExecute("\\main\GetStand\App\winscp\Log")

		Case $iVncLog					;Открываем логи по vnc
			ShellExecute("\\main\GetStand\App\vnc\Log")

		Case $iLogClear					;Предложение очистить все логи
			LogDeleter()

		Case $iCom						;Открываем схему оффлайн
			ShellExecute("\\main\GetStand\Diagrams\DiagramsOT.html")

		Case $iEdit						;Открываем редактор схемы
			ShellExecute("https://app.diagrams.net/?lang=ru&lightbox=0&highlight=1E90FF&layers=0&nav=1#G1oRpwSBE6dq6JEUCgGE6crQ1N3naf_PQp")

		Case $iExport					;Экспортируем на диск схему после редактирования
			SchemeExport()

		Case $iGS						;Открываем основной каталог
			ShellExecute("\\main\GetStand")

		Case $iHN 						;Открыть каталог httpN
			ShellExecute("\\main\GetStand\App\httpN\system")

		Case $iUpdate					;Закрываем приложения и обновляем бинарник
			Update()

		Case $iExit						;Закрываем программу
			ExitLoop

	EndSwitch

WEnd





;ПОЛЬЗОВАТЕЛЬСКИЕ ФУНКЦИИ
Func ShowList()										;Функция отображения списка пользователей

	FileWrite("\\main\GetStand\App\httpN\system\temp\Sessions\ONLINE", "")				;Опрашиваем пользователей 2 секунды
	Sleep(2000)
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
			$FileList[$i] = "👤" & $name & " 🖥" & $host[0] & @CRLF & "        ➡️ В сети ⏱" & $time[0] & " минут."

		Next

		FileDelete("\\main\GetStand\App\httpN\system\temp\Sessions\ONLINE")		;Удаляем файлы метки
		DirRemove("\\main\GetStand\App\httpN\system\temp\PIDS", 1)
		DirCreate("\\main\GetStand\App\httpN\system\temp\PIDS")
		_ArrayDelete($FileList, 0)
		BotMsg("✅<b>Пользователи в сети:</b>" & @CRLF & ListDivider() & @CRLF & _ArrayToString($FileList, @CRLF), 0, $sBotKey, $nChatId)
		MsgBox(64, "GetStand Manager", "Пользователи в сети: " & ListDivider() & @CRLF & _ArrayToString($FileList, @CRLF), 5)

	EndIf

EndFunc

Func ConfigEditor()									;Функция создания окна для редактирования конфигурации

	;Создаем окно с кнопками
	Local $GUI = GUICreate("Редактор конфигурации", 384, 384, -1, -1, $WS_DLGFRAME)
		Local $Label = GUICtrlCreateLabel("Введите данные компьютера чтобы создать, редактировать или удалить конфигурацию для приложений.", 22, 10, 340, 60)
		GUICtrlSetFont($Label, 12)
		Local $Input = GUICtrlCreateInput('Введите Хостнейм', 66, 80, 252, 40)
		GUICtrlSetFont($Input, 20)
		Local $Input1 = GUICtrlCreateInput('Введите адрес', 66, 120, 252, 40)
		GUICtrlSetFont($Input1, 20)
		Local $Input2 = GUICtrlCreateInput('Введите маршрут', 66, 160, 252, 40)
		GUICtrlSetFont($Input2, 20)
		Local $Input3 = GUICtrlCreateInput('Введите маску', 66, 200, 252, 40)
		GUICtrlSetFont($Input3, 20)
		Local $ButtonCreate = GUICtrlCreateButton("Создать", 42, 250, 100, 40)
		GUICtrlSetFont($ButtonCreate, 14)
		Local $ButtonDelete = GUICtrlCreateButton("Удалить", 142, 250, 100, 40)
		GUICtrlSetFont($ButtonDelete, 14)
		Local $ButtonCancel = GUICtrlCreateButton("Выход", 242, 250, 100, 40)
		GUICtrlSetFont($ButtonCancel, 14)
		GUISetState()

	While True			;Запускаем цикл опроса окна

		Switch GUIGetMsg()

			Case $ButtonCreate					;Если нажали "Создать"
				Local $text = GUICtrlRead($Input)		;Считываем ввод
				Local $text1 = GUICtrlRead($Input1)
				Local $text2 = GUICtrlRead($Input2)
				if StringLen($text2) <> 0 Then $text2 = "G" & $text2
				Local $text3 = GUICtrlRead($Input3)
				if StringLen($text3) <> 0 Then $text3 = "M" & $text3
				If Validator($text, "\w+") Or Validator($text1, "\w+") <> 1 Then	;Проверяем строку

					;Конфигурация для компьютера
					FileWrite("\\main\GetStand\App\httpN\system\HOSTS", @CRLF & $text & " A" & $text1 & " " & $text2 & " " & $text3)

					;Конфигурация для VNC
					FileCopy("\\main\GetStand\App\vnc\config\Default.vnc", "\\main\GetStand\App\vnc\config\" & $text & ".vnc")
					FileWrite("\\main\GetStand\App\vnc\config\" & $text & ".vnc", @CRLF & "Host=" & $text1)

					;Конфигурация для WinSCP
					Local $File = "\\main\GetStand\App\winscp\WinSCP.ini"
					Local $Read = FileRead($File)
					StringRegExpReplace($Read, "ConfigDeleted", "ConfigDeleted")	;Проверим наличие совпадений
					if @extended <> 0 Then							;Если есть удаленная конфигурация, перезаписываем её

						Local $Replace = StringRegExpReplace($Read, "ConfigDeleted", $text)
						FileDelete($File)			;Перезаписываем файл с новыми данными
						FileWrite($File, $Replace)

					else											;Если нет, создаем новую

						FileWriteLine("\\main\GetStand\App\winscp\WinSCP.ini", "[Sessions\" & $text & "]" & @CRLF & "HostName=" & $text1 & @CRLF & "UserName=root")

					EndIf
					Local $WinPID = ShellExecute("\\main\GetStand\App\winscp\WinSCP.exe")

					;Конфигурация для Kitty
					FileCopy("\\main\GetStand\App\kitty\Sessions\Default", "\\main\GetStand\App\kitty\Sessions\" & $text)
					FileWrite("\\main\GetStand\App\kitty\Sessions\" & $text, @CRLF & "HostName\" & $text1)
					Local $KittyPid = ShellExecute("\\main\GetStand\App\kitty\kitty.exe")	;Пароль нужно задать в окне вручную

					;Ожидаем завершения конфигурирования и выдаем сообщение
					ProcessWaitClose($KittyPid)
					ProcessWaitClose($WinPid)
					BotMsg("💾<b>Создана конфигурация для хоста</b>" & @CRLF & "🖥️" & $text & " ⏱" & _Now(), 0, $sBotKey, $nChatId)
					FileWriteLine("\\main\GetStand\App\httpN\system\log\system.txt", StringFormat("%-19s", _Now()) & " | " & "Создана конфигурация для " & $text)
					MsgBox(64, "GetStand Manager", "Конфигурация сохранена", 3, $GUI)

				Else

					MsgBox(16, "GetStand Manager", "Недопустимый хостнейм", 3, $GUI)

				Endif

			Case $ButtonDelete					;Если нажали "Удалить"
				Local $text = GUICtrlRead($Input)		;Считываем ввод
				If Validator($text, "\w+") <> 1 Then

					;Удаляем компьютер из списка
					Local $File = "\\main\GetStand\App\httpN\system\HOSTS"
					Local $Read = FileRead($File)
					Local $Replace = StringRegExpReplace($Read, $text & ".*", "")
					if @extended <> 0 Then

						FileDelete($File)			;Перезаписываем файл с новыми данными
						FileWrite($File, $Replace)

					EndIf

					;Удаляем конфигурации
					FileDelete("\\main\GetStand\App\vnc\config\" & $text & ".vnc")
					FileDelete("\\main\GetStand\App\kitty\Sessions\" & $text)

					;Для WinSCP нужно редактировать файл
					$File = "\\main\GetStand\App\winscp\WinSCP.ini"
					$Read = FileRead($File)
					$Replace = StringRegExpReplace($Read, $text, "ConfigDeleted")
					if @extended <> 0 Then

						FileDelete($File)			;Перезаписываем файл с новыми данными
						FileWrite($File, $Replace)

					EndIf

					BotMsg("⚠️<b>Конфигурация для хоста удалена</b>" & @CRLF & "🖥️" & $text & " ⏱" & _Now(), 0, $sBotKey, $nChatId)
					FileWriteLine("\\main\GetStand\App\httpN\system\log\system.txt", StringFormat("%-19s", _Now()) & " | " & "Конфигурация для " & $text & " удалена")
					MsgBox(64, "GetStand Manager", "Конфигурация удалена", 3, $GUI)

				Else

					MsgBox(16, "GetStand Manager", "Недопустимый хостнейм", 3, $GUI)

				Endif

			Case $ButtonCancel					;Если нажали "Выход"

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
		;Логи приложений
		FileDelete("\\main\GetStand\App\kitty\Log\*")
		FileDelete("\\main\GetStand\App\winscp\Log\*")
		FileDelete("\\main\GetStand\App\vnc\Log\*")
		BotMsg("⚠️<b>Логи подключений удалены</b>" & @CRLF & "⏱" & _Now(), 0, $sBotKey, $nChatId)
		FileWriteLine("\\main\GetStand\App\httpN\system\log\system.txt", StringFormat("%-19s", _Now()) & " | " & "Логи подключений удалены")
		MsgBox(64, "GetStand Manager", "Логи удалены", 3)

	EndIf

EndFunc

Func SchemeExport()									;Функция экспортирования схемы на диск после редактирования

	If FileExists("D:\Download\DiagramsOT.drawio.html") Then

		Local $text = ChangeLog()
		BotMsg("🔥<b>Схема GetStand обновлена!</b>" & @CRLF & "📋" & $text & @CRLF & "⏱" & _Now(), 0, $sBotKey, $nChatId)
		FileWriteLine("\\main\GetStand\App\httpN\system\log\system.txt", StringFormat("%-19s", _Now()) & " | " & "Обновление схемы завершено. Изменения: " & $text)
		FileMove("D:\Download\DiagramsOT.drawio.html", "\\main\GetStand\Diagrams\DiagramsOT.html", 1)	;Перемещаем схему с перезаписью

	Else

		MsgBox(16, "GetStand Manager", "Нет схемы для экспорта", 3)

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