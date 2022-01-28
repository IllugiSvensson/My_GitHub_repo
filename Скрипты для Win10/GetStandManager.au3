#include <MsgSender_lib.au3>

;СОЗДАЕМ МЕНЮ МЕНЕДЖЕРА В ТРЕЕ
Opt("TrayMenuMode", 1 + 2)							;Отключаем стандартные пункты меню
;Создаем кнопки меню
$iList = TrayCreateItem("Пользователи в сети")		;Показать пользователей в сети
$iConfig = TrayCreateMenu("Конфигурации")			;Конфигурации подключений
	$iMac = TrayCreateItem("MAC-адреса", $iConfig)
	$iDNS = TrayCreateItem("DNS-адреса", $iConfig)
	$iHosts = TrayCreateItem("Хостнеймы", $iConfig)
	$iKit = TrayCreateItem("Kitty сессии", $iConfig)
	$iScp = TrayCreateItem("WinSCP сессии", $iConfig)
	$iVnc = TrayCreateItem("VNC сессии", $iConfig)
	TrayCreateItem("", $iConfig)					;Полоса разделитель
	$iConfigCreate = TrayCreateItem("Редактор конфигурации", $iConfig)
$iLog = TrayCreateMenu("Логи")						;Логи работы httpN
	$iRuns = TrayCreateItem("Логи подключений", $iLog)
	$iSystem = TrayCreateItem("Системные логи", $iLog)
	$iKitLog = TrayCreateItem("Логи Kitty", $iLog)
	$iScpLog = TrayCreateItem("Логи WinSCP", $iLog)
	$iVncLog = TrayCreateItem("Логи VNC", $iLog)
	TrayCreateItem("", $iLog)
	$iLogClear = TrayCreateItem("Очистить логи", $iLog)
$iScheme = TrayCreateMenu("Схема")					;GetStand схема в двух вариантах
	$iCom = TrayCreateItem("Оффлайн схема", $iScheme)
	$iEdit = TrayCreateItem("Редактор", $iScheme)
	$iExport = TrayCreateItem("Экспорт схемы", $iScheme)
$iCatalog = TrayCreateMenu("Каталоги")				;Основные рабочие каталоги
	$iGS = TrayCreateItem("Каталог GetStand", $iCatalog)
	$iHN = TrayCreateItem("Каталог httpN", $iCatalog)
$iUpdate = TrayCreateItem("Обновить httpN")			;Предупреждение об обновлении
TrayCreateItem("")
$iExit = TrayCreateItem("Выход")					;Выход из приложения



;Циклично наблюдаем за кнопками, выполняем действия при нажатии кнопок из трея
While True

	;БЛОК УПРАВЛЕНИЯ ПУНКТАМИ МЕНЮ ТРЕЯ
	Switch TrayGetMsg()		;Обрабатываем пункты меню

		Case $iList						;Открываем список пользователей онлайн
			ShowList()

		Case $iMac						;Открываем список маков
			ShellExecute("\\main\GetStand\App\notepad\notepad++.exe", "\\main\GetStand\App\httpN\system\MAC")

		Case $iDNS						;Открываем страничку ДНС
			ShellExecute("http://192.168.30.2/admin/dns_records.php")

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

	FileWrite("\\main\GetStand\App\httpN\system\temp\Sessions\ONLINE", "")		;Опрашиваем пользователей 2 секунды
	Sleep(2000)
	$FileList = _FileListToArray("\\main\GetStand\App\httpN\system\temp\PIDS")	;Формируем список пользователей
	If IsArray($FileList) = 0 Then

		FileDelete("\\main\GetStand\App\httpN\system\temp\Sessions\ONLINE")
		MsgBox(64, "GetStand Manager", "Пользователи не в сети", 5)

	Else

		For $i = 1 To $FileList[0] Step +1	;Перебираем пользователей

			$time = StringRegExp($FileList[$i], "\.\d+$", 2)	;Выделяем время
			$time[0] = StringTrimLeft($time[0], 1)
			$host = StringRegExp($FileList[$i], "\.\w+\.", 2)	;Выделяем хост
			$host[0] = StringTrimLeft(StringTrimRight($host[0], 1), 1)
			$name = StringTrimRight($FileList[$i], StringLen($time[0]) + StringLen($host[0]) + 2)	;Выделяяем имя
			$FileList[$i] = "👤" & $name & " 🖥" & $host[0] & @CRLF & "        ➡️ В сети ⏱" & $time[0] & " минут."

		Next

		$div = ListDivider()				;Строка разделитель
		FileDelete("\\main\GetStand\App\httpN\system\temp\Sessions\ONLINE")		;Удаляем файлы метки
		DirRemove("\\main\GetStand\App\httpN\system\temp\PIDS", 1)
		DirCreate("\\main\GetStand\App\httpN\system\temp\PIDS")
		_ArrayDelete($FileList, 0)
		$MsgList = _ArrayToString($FileList, @CRLF) 							;Вписываем в окно список пользователей
		BotMsg("✅Пользователи в сети:" & @CRLF & $div & @CRLF & $MsgList, $sBotKey, $nChatId)
		MsgBox(64, "GetStand Manager", "Пользователи в сети: " & $div & @CRLF & $MsgList, 5)

	EndIf

EndFunc

Func ConfigEditor()									;Функция создания окна для редактирования конфигурации

	;Создаем окно с кнопками
	$GUI = GUICreate("Редактор конфигурации", 384, 216, -1, -1, $WS_DLGFRAME)
		$Label = GUICtrlCreateLabel("Введите хостнейм компьютера чтобы создать или удалить конфигурацию для приложений.", 22, 10, 340, 40)
		GUICtrlSetFont($Label, 12)
		$Input = GUICtrlCreateInput('Введите Хостнейм', 66, 60, 252, 54)
		GUICtrlSetFont($Input, 20)
		$ButtonCreate = GUICtrlCreateButton("Создать", 42, 122, 100, 54)
		GUICtrlSetFont($ButtonCreate, 16)
		$ButtonDelete = GUICtrlCreateButton("Удалить", 142, 122, 100, 54)
		GUICtrlSetFont($ButtonDelete, 16)
		$ButtonCancel = GUICtrlCreateButton("Выход", 242, 122, 100, 54)
		GUICtrlSetFont($ButtonCancel, 16)
		GUISetState()
		;Сразу открываем страничку DNS
		ShellExecute("http://192.168.30.2/admin/dns_records.php")

	While True			;Запускаем цикл опроса окна

		Switch GUIGetMsg()

			Case $ButtonCreate					;Если нажали "Создать"
				$text = GUICtrlRead($Input)		;Считываем ввод
				If Validator($text, "\w+") <> 1 Then	;Проверяем строку

					;Конфигурация для маршрута
					FileWrite("\\main\GetStand\App\httpN\system\HOSTS", @CRLF & $text)	;Если нужно вписать маршрут
					ShellExecute("\\main\GetStand\App\notepad\notepad++.exe", "\\main\GetStand\App\httpN\system\HOSTS")

					;Конфигурация для VNC
					FileCopy("\\main\GetStand\App\vnc\config\Default.vnc", "\\main\GetStand\App\vnc\config\" & $text & ".vnc")
					FileWrite("\\main\GetStand\App\vnc\config\" & $text & ".vnc", @CRLF & "Host=" & $text & ".ot.net")

					;Конфигурация для WinSCP
					$File = "\\main\GetStand\App\winscp\WinSCP.ini"
					$Read = FileRead($File)
					StringRegExpReplace($Read, "ConfigDeleted", "ConfigDeleted")	;Проверим наличие совпадений
					if @extended <> 0 Then							;Если есть удаленная конфигурация, перезаписываем её

						$Replace = StringRegExpReplace($Read, "ConfigDeleted", $text)
						FileDelete($File)			;Перезаписываем файл с новыми данными
						FileWrite($File, $Replace)

					else											;Если нет, создаем новую

						FileWriteLine("\\main\GetStand\App\winscp\WinSCP.ini", "[Sessions\" & $text & "]" & @CRLF & "HostName=" & $text & ".ot.net" & @CRLF & "UserName=root")

					EndIf
					$WinPID = ShellExecute("\\main\GetStand\App\winscp\WinSCP.exe")

					;Конфигурация для Kitty
					FileCopy("\\main\GetStand\App\kitty\Sessions\Default", "\\main\GetStand\App\kitty\Sessions\" & $text)
					FileWrite("\\main\GetStand\App\kitty\Sessions\" & $text, @CRLF & "HostName\" & $text & ".ot.net\")
					$KittyPid = ShellExecute("\\main\GetStand\App\kitty\kitty.exe")	;Пароль нужно задать в окне вручную

					;Ожидаем завершения конфигурирования и выдаем сообщение
					ProcessWaitClose($KittyPid)
					ProcessWaitClose($WinPid)
					BotMsg("💾Создана конфигурация для хоста" & @CRLF & "🖥️" & $text & " ⏱" & _Now(), $sBotKey, $nChatId)
					FileWriteLine("\\main\GetStand\App\httpN\system\log\system.txt", StringFormat("%-19s", _Now()) & " | " & "Создана конфигурация для " & $text)
					MsgBox(64, "GetStand Manager", "Конфигурация сохранена", 3, $GUI)

				Else

					MsgBox(16, "GetStand Manager", "Недопустимый хостнейм", 3, $GUI)

				Endif

			Case $ButtonDelete					;Если нажали "Удалить"
				$text = GUICtrlRead($Input)
				If Validator($text, "\w+") <> 1 Then

					;Удаляем хост в списке маршрутов
					$File = "\\main\GetStand\App\httpN\system\HOSTS"
					$Read = FileRead($File)
					$Replace = StringRegExpReplace($Read, $text & ".*", "")
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

					BotMsg("⚠️Конфигурация для хоста удалена" & @CRLF & "🖥️" & $text & " ⏱" & _Now(), $sBotKey, $nChatId)
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
		BotMsg("⚠️Логи подключений удалены" & @CRLF & "⏱" & _Now(), $sBotKey, $nChatId)
		FileWriteLine("\\main\GetStand\App\httpN\system\log\system.txt", StringFormat("%-19s", _Now()) & " | " & "Логи подключений удалены")
		MsgBox(64, "GetStand Manager", "Логи удалены", 3)

	EndIf

EndFunc

Func SchemeExport()									;Функция экспортирования схемы на диск после редактирования

	If FileExists("D:\Download\DiagramsOt.html") Then

		$text = ChangeLog()
		BotMsg("🔥Схема GetStand обновлена!" & @CRLF & "📋" & $text & @CRLF & "⏱" & _Now(), $sBotKey, $nChatId)
		FileWriteLine("\\main\GetStand\App\httpN\system\log\system.txt", StringFormat("%-19s", _Now()) & " | " & "Обновление схемы завершено. Изменения: " & $text)
		FileMove("D:\Download\DiagramsOt.html", "\\main\GetStand\Diagrams\DiagramsOT.html", 1)	;Перемещаем схему с перезаписью

	Else

		MsgBox(16, "GetStand Manager", "Нет схемы для экспорта", 3)

	EndIf

EndFunc

Func Update()										;Функция выключения приложений и обновления httpN

	If MsgBox(36, "GetStand Manager", "Провести обновление httpN?") = 6 Then	;Если нажали да

		$text = ChangeLog()
		FileWrite("\\main\GetStand\App\httpN\system\temp\Sessions\UPDATE", "")	;Предупреждаем об обновлении
		BotMsg("⚠️Запущено обновление httpN" & @CRLF & "️🔄Автоотключение через минуту" & @CRLF & "⏱" & _Now(), $sBotKey, $nChatId)
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
		$AutoIt = "D:\Programms\AutoIt3\Aut2Exe\Aut2exe.exe /in D:\NitaGit\httpN\httpN_Windows.au3 /out \\main\GetStand\App\httpN\httpN_Windows.exe /icon \\main\GetStand\App\ChromePortable\GetStand.ICO /x86"
		Run(@ComSpec&' /c ' & $AutoIt, '', @SW_HIDE, $STDOUT_CHILD)				;Компилируем бинарь
		FileDelete("\\main\GetStand\App\httpN\system\temp\Sessions\UPDATE")		;Разрешаем дальнейшую работу
		FileDelete("\\main\GetStand\App\httpN\system\temp\Sessions\KILL")
		TraySetState(1)
		BotMsg("🔥Обновление завершено!" & @CRLF & "📋" & $text & @CRLF & "⏱" & _Now(), $sBotKey, $nChatId)
		FileWriteLine("\\main\GetStand\App\httpN\system\log\system.txt", StringFormat("%-19s", _Now()) & " | " & "Обновление завершено. Изменения: " & $text)
		MsgBox(64, "GetStand Manager", "Обновление прошло успешно!", 5)

	EndIf

EndFunc