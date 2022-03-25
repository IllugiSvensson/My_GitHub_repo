#!/bin/bash



#Необходимые переменные
appfolder=`pwd | sed -e "s/.\{,8\}$//"`
icon="$appfolder/App/ChromePortable"
app="$appfolder/App/httpN"
desktop=`echo /home/$(hostname)/$(ls /home/$(hostname)/ | grep -Eo "^Desktop$|^Рабочий стол$")`
. $appfolder/App/httpN/system/httpN_Linux_lib	#Библиотека функций



#Пользовательские функции
function CreateAccount {						#Функция создания аккаунта

	test_input=`echo $input | egrep -o "[а-яА-Я]{1,}\s{1,}[а-яА-Я]{1,}\(\w+\)"`
	if [ "$input" != "$test_input" ]			#Читаем ввод и проверяем по шаблону
	then

		zenity --error --title=Ошибка --text="Ошибка в записи имени.\nВведите данные по шаблону" --ellipsize --timeout=5
		return 1

	else

		#Создаем записи для открытия URL
		touch ~/.local/share/applications/httpn.desktop
		cd ~/.local/share/applications/
		echo "[Desktop Entry]" > httpn.desktop
		echo "Type=Application" >> httpn.desktop
		echo "Name=httpN_Linux" >> httpn.desktop
		echo "Icon=$icon/GetStand.ico" >> httpn.desktop
		echo "Exec=$app/httpN_Linux %u" >> httpn.desktop
		echo "Terminal=false" >> httpn.desktop
		echo "StartupNotify=true" >> httpn.desktop
		echo "MimeType=x-scheme-handler/httpn" >> httpn.desktop
		xdg-mime default httpn.desktop x-scheme-handler/httpn
		[ `xdg-mime query default x-scheme-handler/httpn` == "httpn.desktop" ] || {

			message=`echo -e "🛑<b>Обработчик схемы не назначен</b>\n❌$input\n⏱$(_Now)"`
			BotMsg $sBotKey $nChatId 0 "$message"
			zenity --error --title=Ошибка --ellipsize --text="Обработчик схемы не назначен\nПопробуйте назначить вручную:\n\nСоздайте файл /usr/share/applications/httpn.desktop\n[Desktop Entry]\nType=Application\nName=httpN_Linux\nExec=$app/httpN_Linux %u\nTerminal=false\nMimeType=x-scheme-handler/httpn\n\nЗатем выполните:\nxdg-mime default httpn.desktop x-scheme-handler/httpn"
			return 1

		}

		if [ `echo ${#username}` == 0 ]
		then

			message=`echo -e "🛑<b>Имя компьютера не определено</b>\n❌$input\n⏱$(_Now)"`
			BotMsg $sBotKey $nChatId 0 "$message"
			echo "" >> $appfolder/App/httpN/system/log/system.txt
			echo $(Format 19 `"_Now"`) "| Имя компьютера не определено. Проверьте адрес пользователя: $input" >> $appfolder/App/httpN/system/log/system.txt
			zenity --error --title=Ошибка --text="Имя компьютера не определено.\nОбратитесь в Отдел Тестирования" --timeout=5
			return 1

		else

			echo "" >> $appfolder/App/httpN/system/USERS
			echo $username $input "default" >> $appfolder/App/httpN/system/USERS
			message=`echo -e "✅<b>Новый пользователь добавлен</b>\n👤$input🐧Linux\n⏱$(_Now)"`
			BotMsg $sBotKey $nChatId 0 "$message"
			echo "" >> $appfolder/App/httpN/system/log/system.txt
			echo $(Format 19 `"_Now"`) "| Добавлен новый пользователь Linux: $input" >> $appfolder/App/httpN/system/log/system.txt
			ln -s $appfolder/Diagrams/DiagramsOT.html $desktop/DiagramsOT
			zenity --info --title=GetStand --icon-name="$icon/GetStand.ico" --ellipsize --text="Аккаунт успешно создан!\nПриятного пользования :)\nПодписывайтесь на telegram канал\nЗдесь вся информация о стендах\n\nhttps://t.me/+e8d9JjwJMtY4NzYy" --ok-label=Продолжить
			xdg-open $desktop/DiagramsOT &

		fi

	fi

return 0
}





#Отрисовываем основное окно и диалог
while true
do

	#Отрисовываем основное окно ввода данных
	input=`zenity --entry --title="GetStand Linux version" --width=320 --height=210 --ok-label="Продолжить" --cancel-label="Выход" --text="\tПриветствую вас в системе GetStand!\n\nРегистрация:\nПожалуйста, введите свои данные\nв следующем формате: Иванов Иван(iva)" --entry-text="Фамилия Имя(hostname)"`
		if [ $? == 0 ]
		then

			zenity --question --title="GetStand" --text="Подключиться к системе GetStand?" --ellipsize --ok-label="Да" --cancel-label="Нет"
			[ $? == "0" ] && {

				CreateAccount					#Создание аккаунта и настройка
				[ $? == 1 ] && { continue; }
				break

			}

		else

			exit 0

		fi

done