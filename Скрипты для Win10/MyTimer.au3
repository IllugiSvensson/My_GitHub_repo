#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ProgressConstants.au3>
#include <Array.au3>
#include <File.au3>

$id = GUICreate('Таймер Задач', 250, 390)					;Создаем основное окно таймера
GUICtrlCreatePic(@ScriptDir & "\Noelle.jpg", 0, 0, 250, 390);Фоновая картинка, но из-за неё плохо видно

GUICtrlCreateLabel("Работa", 20, 20, 75, 60)				;Создаем блоки деятельности
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)				;Прозрачный фон, если есть картинка
GUICtrlSetFont(-1, 10, 1000)
GUICtrlCreateLabel("Разминка", 20, 55, 75, 60)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetFont(-1, 10, 1000)
GUICtrlCreateLabel("Работа", 20, 90, 75, 60)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetFont(-1, 10, 1000)
GUICtrlCreateLabel("Обед", 20, 125, 75, 60)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetFont(-1, 10, 1000)
GUICtrlCreateLabel("Работа", 20, 160, 75, 60)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetFont(-1, 10, 1000)
GUICtrlCreateLabel("Турник", 20, 195, 75, 60)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetFont(-1, 10, 1000)
GUICtrlCreateLabel("Работа", 20, 230, 75, 60)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetFont(-1, 10, 1000)
GUICtrlCreateLabel("Разминка", 20, 265, 75, 60)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetFont(-1, 10, 1000)
GUICtrlCreateLabel("Сверхурочка", 20, 300, 90, 60)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlSetFont(-1, 10, 1000)
GUISetState(@SW_SHOW)										;Демонстрируем окно

MsgBox(32,"Таймер Задач", "Начнем работу?", 0, $id)			;Старт программы
;Проверка на ребут программы
Global $st[9]
Const $a[9] = [0, 0, 0, 0, 0, 0, 0, 0, 0]  
for $i = 0 to 8

	$st[$i] = FileReadLine("D:\Programms\MyTimer\time.txt", $i + 1)

Next
if $st[8] <> 0 Then MsgBox(32,"Таймер Задач", "Переработка " & $st[8] & " минут")

;Основной цикл программы
Work(20, 35, 210, 15, 110, 0, "/pause.jpg")		;Работа
Work(20, 70, 210, 15, 10, 1, "/work.jpg")		;Разминка
Work(20, 105, 210, 15, 110, 2, "/Dinner.jpg")	;Работа
Work(20, 140, 210, 15, 20, 3, "/work.jpg")		;Обед
Work(20, 175, 210, 15, 110, 4, "/Workout.jpg")	;Работа
Work(20, 210, 210, 15, 15, 5, "/work.jpg")		;Турник
Work(20, 245, 210, 15, 110, 6, "/pause.jpg")	;Работа
Work(20, 280, 210, 15, 10, 7, "/end.jpg")		;Разминка
$st = $a
Work(20, 315, 210, 15, 240, 8, "/another.jpg")	;Свехрурочная работа



Func Work ($left, $top, $width, $height, $dur, $d, $pic)		;Функция отсчета времени и отображения

	$t = $st[$d]	;Счетчик времени
	$PB = GUICtrlCreateProgress($left, $top, $width, $height, $PBS_SMOOTH)								  ;Создаем прогресс бар
	GUICtrlSetData($PB, (100 / $dur) * $t)
	GUICtrlCreateLabel(" из " & $dur & " минут", $left + 120, $top - 15, $width - 100, $height, $SS_LEFT) ;Создаем отсчет времени
	GUICtrlSetFont(-1, 10, 1000)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	$LB = GUICtrlCreateLabel($t, $left + 95, $top - 15, $width - 185, $height, $SS_LEFT)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetFont(-1, 10, 1000)

	if $t = $dur Then
	
		GUICtrlSetData($PB, 100)
		GUICtrlSetData($LB, $dur)
	
	Else
	
		While $t <> $dur

			Sleep(60000)			;Задержка 1 секунда
			$t = $t + 1			;Счетчик времени увеличен
			GUICtrlSetData($PB, (100 / $dur) * $t)	;Изменяем значения каждую секунду
			GUICtrlSetData($LB, $t)
			$st[$d] += 1
			_FileWriteFromArray("D:\Programms\MyTimer\time.txt", $st)

		WEnd

	SplashImageOn("Таймер Задач", @ScriptDir & $pic, -1, -1, -1, -1, 1)
	Sleep(3000)
	SplashOff()
	EndIf

EndFunc