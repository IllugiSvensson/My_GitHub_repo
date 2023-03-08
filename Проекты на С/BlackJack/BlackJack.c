#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <locale.h>
#include <unistd.h>
#include <string.h>

typedef struct Menu {		//Структура хранит переменные, которые
							//используются для проверки ввода и переключения
	char menu_choice[0];	//пунктов игрового меню
	int menu_switch;
	
} mnc;

void mainmenu();				//Список прототипов функций
void clearscreen();				//Данная программа не модульная
void wrongchoice();				//и состоит из набора функций
void quit();					//описанных в одном main файле
void rules(mnc *rls);
void back2menu(mnc *bck2mn);
void newgame(mnc *nwgm);
void choosebets(int *money, int *bet, mnc *chsbts);
void confirm();
char getcard(int *getrandom);
int sumcards(char *hand, int quantity);
void dealing(char *gamer, int quantity, int *getrandom);
void getstatus(char *player, int quantity);
void drawning(mnc *drwng, char *player, char *dealer, int *rndm, int *money, int *bet);
void dealerturn(int p_sum, char *dealer, int *rndm, int *money, int *bet);
void conflictBJ(mnc *cnflct, int *money, int *bet, char *dealer);
void showresults(mnc *shwrslts);
void writeresult(mnc *wrtrslt, int *money);
void writefile(mnc *wrtfl, int *money);
void getresultline(char *line, int *money, int position);

int main(int argc, char *argv[]) {	//Главная функция

	setlocale(LC_ALL, "Rus");		//Устанавливаем отображение кириллицы
	
	mainmenu();						//Запускаем функцию главного меню

return 0;
}


void mainmenu() {		//Функция главного меню 

	clearscreen();		//Очищаем консоль перед началом игры

		printf("\n	Приветствую вас в игре BlackJack! \n");
		printf("		Главное меню\n");
		printf("		1. Новая игра\n");
		printf("		2. Правила игры\n");
		printf("		3. Результаты\n");
		printf("		4. Выйти из игры\n");

	mnc MnMn;							//Объявляем структуру для проверки пользовательского ввода

		do {							//Запрашиваем ввод, если он отличается от десятичного числа
										//предупреждаем об этом и запрашиваем ввод повторно
			MnMn.menu_switch = 0;

				printf("\n	Введите число для продолжения: ");
				scanf("%s", MnMn.menu_choice);				//Вводим число в формате строки

					switch (atoi(MnMn.menu_choice)) {		//Преобразуем строку в число
						
						case 1:
							newgame(&MnMn);			//Начинаем новую игру
							break;
						case 2:
							rules(&MnMn);			//Показываем правила игры
							break;
						case 3:
							showresults(&MnMn);		//Показать записи с результатами
							back2menu(&MnMn);
							break;
						case 4:
							quit();					//Полный выход из игры в консоль
							break;
						default:
							MnMn.menu_switch = 1;
							wrongchoice();			//Предупреждение о неверном вводе
							break;					//(символе, а не числе)
							
					}

		} while (MnMn.menu_switch);

}

void clearscreen() {		//Функция очистки консоли от записей

	system("cls");			//Для Linux нужно заменить на "clear"

}

void wrongchoice() {		//Функция предупреждения о неправильном вводе
							//Дает подсказку, что следует вводить для продолжения
	printf("	Введите допустимые цифры! Например 1, 2, 3 и т.д... \n");

}

void quit(){			//Функция выхода из игры

	clearscreen();		//Перед выходом очищает за собой консоль
	
		printf("\n Выход..\n\n");
		
	sleep(1);				//Задержка вывода

exit(0);					//Полностью выходит из приложения
}

void rules(mnc *rls) {		//Функция, описывающая правила игры

	clearscreen();			//Очищаем консоль перед выводом правил

		printf("\n 			 Правила игры: \n");
		printf("   Перед раздачей карт Игроку необходимо сделать ставку, не превышающую \n");
		printf(" его текущий капитал. Стартовый капитал каждой новой игры - 100$.  \n");
		printf(" После принятия ставки Игрок и Дилер получают по две карты, причем Игрок \n");
		printf(" может видеть одну карту в руке Дилера.\n\n");

		printf("   После раздачи Игрок может взять еще несколько карт, а затем должен отдать \n");
		printf(" ход Дилеру. Задача Игрока - обыграть Дилера, набрав очков больше, чем у  \n");
		printf(" него, но не более 21-го очка. Победа принесет Игроку удвоенную ставку.\n\n");

		printf("   Если Игрок и Дилер наберут одинаковое количество очков, то оба останутся \n");
		printf(" при своих ставках. Когда Игрок наберет меньше очков, чем у Дилера или больше, \n");
		printf(" чем 21 очко, то он проигрывает свою ставку. Если на раздаче Игрок соберает \n");
		printf(" BkackJack (21 очко), то он получает 1.5 своей ставки, только если открытая\n");
		printf(" карта Дилера не 10, V, Q, K, A. Иначе Игрок может забрать свою ставку, либо \n");
		printf(" отдать ход Дилеру. Если Дилер не собирает BlackJack, то Игрок выигрывает 1.5 \n");
		printf(" своей ставки, либо теряет свою ставку.\n\n");

		printf("			 Номиналы карт: \n");
		printf("   Стоимость карт с цифрами равна их числовому значению. Карты с лицами дают\n");
		printf(" по десять очков. Туз дает одно очко или одинадцать, смотря какое значение \n");
		printf(" выгоднее Игроку в данный момент.\n");
		printf("   Данная версия игры упрощенная, некоторые правила не реализованы.\n ");

	back2menu(rls);				//Функция возврата в главное меню игры

}

void back2menu(mnc *bck2mn) {	//Функция возврата в главное меню

	do {						//Проверяем пользовательский ввод

		bck2mn->menu_switch = 0;
			
			printf("\n	1. Назад в главное меню: ");
			printf("\n	Введите число для продолжения: ");
			scanf("%s", bck2mn->menu_choice);
				
				if (atoi(bck2mn->menu_choice) == 1) {		//Преобразуем строку в число

					mainmenu(&bck2mn);						//Возвращаемся в главное меню

				} else {

					bck2mn->menu_switch = 1;
					wrongchoice();							//Запрашиваем ввод повтроно
					
				}

	} while (bck2mn->menu_switch);

}

void newgame(mnc *nwgm){		//Функция новой игры. Принимает ставки и раздает карты

	clearscreen();				//Очищаем консоль

	int money = 100;		//Начальный капитал игрока
	int bet = 0;			//Ставка игрока
	int getrandom = 1;		//Число для генерации случайных карт
	int p_sum = 0;			//Сумма очков игрокаж
	int quantity;			//Количество выдаваемых карт
	char *player = NULL;	//Рука Игрока
	char *dealer = NULL;	//Рука Дилера

		printf("\n 			Ваш стартовый капитал - 100$\n");
		printf("	Сделайте ставку и постарайтесь выиграть как можно больше!\n\n");

	while (money > 0 || money >= 1000000) {			//Играем, пока Игрок не проиграет все деньги или 
													//выиграет миллион
		choosebets(&money, &bet, nwgm);				//Запрашиваем ставку игрока
		
		clearscreen();								//Начинаем игру после принятия ставки

			player = (char*)calloc(8, sizeof(char));	 	//Инициализируем каждый круг
			dealer = (char*)calloc(8, sizeof(char));	 	//Руку игроков

				printf("\n	Раздача карт началась! Ваша ставка %d$\n", bet);
				sleep(1);

			for (quantity = 0; quantity < 2; quantity++) {		//Начальная раздача двух карт

				dealing(dealer, quantity, &getrandom);			//Раздаем карты Дилеру
				dealing(player, quantity, &getrandom);			//Раздаем карты Игроку

			}

				printf("\n	Карта в руке Дилера: %c\n", *dealer);
				printf("	Карты в вашей руке: ");

			getstatus(player, quantity);					//Показать состояние руки игроков
			p_sum = sumcards(player, quantity);				//Посчитать сумму очков в руке Игрока

				printf("\n	Набрано очков: %d\n", p_sum);	//Очки игрока после раздачи

			if (p_sum == 21 && (*dealer == 'T'				//Ситуация с двумя блекджеками
			|| *dealer == 'V' || *dealer == 'Q'				//Либо забираем ставку, либо играем
			|| *dealer == 'K' || *dealer == 'A')) {			//за 1.5 ставки

				conflictBJ(nwgm, &money, &bet, dealer);

			} else if (p_sum == 21) {					//Ситуация с БДЖ на раздаче

				money = money + (int)(1.5 * bet);		//Получаем 1.5 ставки
				printf("\n	Вы победили! BlackJack на раздаче!\n");
				printf("	Ваш текущий капитал составляет %d$\n", money);

			} else {								//Если БДЖ на раздаче нет, набираем карты
													//Или отдаем ход Дилеру и сравниваем очки
				drawning(nwgm, player, dealer, &getrandom, &money, &bet);

			}
			
			sleep(1);				//Небольшие паузы, чтобы игрок мог прочесть текст

			while (money > 0) {		//Пока у игрока есть деньги, предлагаем сыграть снова

				printf("\n	1. Сыграть снова\n ");
				printf("	2. Закончить игру\n");
				printf("	Введите число для продолжения: ");
				scanf("%s", nwgm->menu_choice);

					if (atoi(nwgm->menu_choice) == 1) {		//Проверка ввода
															//Если игрок согласен, раздаем карты
						clearscreen();						//заходим на новый круг
						printf("\n\n	Ваш текущий капитал составляет %d$\n", money);
						break;
					
					} else if (atoi(nwgm->menu_choice) == 2) {

						writeresult(nwgm, &money);			//Если нет, предлагаем сделать запись результата
						break;					

					} else {

						wrongchoice();

					}

			}

			if (money <= 0) {						//Возвращаемся в меню, если деньги закончились

				printf("\n	Игра окончена. Вы проиграли все свои деньги");
				back2menu(nwgm);

			} else if (money >= 1000000) {			//Выводим на запись результата
													//Если выиграли миллион
				printf("\n	Поздравляем! Вы выиграли миллион!\n");
				printf("	Дилер больше не будет играть с вами");
				sleep(5);
				writeresult(nwgm, &money);
			}
			
			free(player);							//Очищаем руку Игрока и Дилера
			free(dealer);
			
	}

}

void choosebets(int *money, int *bet, mnc *chsbts) { 		//Функция принятия ставок

	do {													//Запрашиваем у Игрока ставку
		
		chsbts->menu_switch = 0;
		
		printf("	Введите вашу ставку: ");
		scanf("%s", chsbts->menu_choice);

			if (atoi(chsbts->menu_choice) == 0) {			//Проверяем корректность ввода

				printf("	Введите десятичное число больше нуля! \n\n");

			} else if (atoi(chsbts->menu_choice) > *money) {	//Проверяем величину ставки

				printf("	Недостаточно денег для ставки! \n\n");

			} else {											//Просим подтверждение введенной ставки

				printf("\n	Вы уверены? \n");
				confirm();
				*bet = atoi(chsbts->menu_choice);
				scanf("%s", chsbts->menu_choice);				//Так же проверяем корректность ввода

					if (atoi(chsbts->menu_choice) == 1) {

						*money = *money - *bet;					//На время игры вычитаем ставку из капитала
						chsbts->menu_switch = 0;
						
					} else if (atoi(chsbts->menu_choice) == 2) {
						
						puts(" ");
						continue;

					} else {						//Запрашиваем ставку по новой, если нужно

						chsbts->menu_switch = 1;
						wrongchoice();
						puts(" ");
						
					}
					
			}

	} while (chsbts->menu_switch);

}

void confirm() {					//Функция запроса на подтверждение выбора

	printf("	1. Да \n");
	printf("	2. Нет \n");
	printf("	Введите число для продолжения: ");

}

char getcard(int *getrandom) {		//Функция генерации случайных карт

	srand(time(NULL));				//Ядро генератора

		int num = 13;
		int a = 0; //,b=0;
		int n;						//Набор игровых карт. Т означает десятку
		char cards[13] = {'2', '3', '4', '5', '6', '7', '8', '9', 'T', 'V', 'Q', 'K', 'A'};
		//Расширить набор карт до 52 двумерным массивом, например так:
		//char cards[52][4] = { {'2', '3', '4', '5', '6', '7', '8', '9', 'T', 'V', 'Q', 'K', 'A'},
		//					 	{'2', '3', '4', '5', '6', '7', '8', '9', 'T', 'V', 'Q', 'K', 'A'},
		//					 	{'2', '3', '4', '5', '6', '7', '8', '9', 'T', 'V', 'Q', 'K', 'A'},
		//					 	{'2', '3', '4', '5', '6', '7', '8', '9', 'T', 'V', 'Q', 'K', 'A'} };

			for (n = 0; n < *getrandom; n++) {		//Генерируем числа из заданного диапазона

				a = 0 + rand() %num;
				//b = 0 + rand() %4;

			}

return cards[a];//[b]							Возвращаем случайную карту
}

int sumcards(char *hand, int quantity) {	//Функция, считающая очки в руке

	int i;
	int score = 0;
//Изменить порядок пересчета карт. Тузы считать в последнюю очередь и после пересчета других карт решать
//Делать туз единичкой или 10. Сейчас предыдущее значение туза не сбрасывается, если он 11 и мы набрали больше 21
		for (i = 0; i < quantity; i++) {	//Оцениваем количество карт в руке

			if (*(hand + i) == ('T') || *(hand + i) == ('V')	//Проверяем каждую карту
			|| *(hand + i) == ('Q') || *(hand + i) == ('K')) {	//и считаем очки

				score = score + 10;

			} else if (*(hand + i) == ('2') || *(hand + i) == ('3')
					|| *(hand + i) == ('4') || *(hand + i) == ('5')
					|| *(hand + i) == ('6') || *(hand + i) == ('7')
					|| *(hand + i) == ('8') || *(hand + i) == ('9')) {

				score = score + *(hand + i) - '0';				//преобразуем строки в числа

			}

		}

		for (i = 0; i < quantity; i++) {						//Для туза отдельная проверка

			if (*(hand + i) == 'A') {							//Повторно проверяем каждую карту

				if (score > 10) {								//Оцениваем набранные очки и прибавляем

					score = score + 1;

				} else	{										//1 или 11, смотря какой исход выгоднее

					score = score + 11;
				
				}

			}

		}

return score;
}

void dealing(char *gamer, int quantity, int *getrandom) {	//Функция раздачи карт

	//gamer = (char*)realloc(gamer, (quantity + 1));		//Добавляем блок памяти под новую карту
	*(gamer + quantity) = getcard(getrandom);				//Раздаем карту
	*getrandom = *getrandom + 1;							//Перебираем случайные числа

}

void getstatus(char *gamer, int quantity) {					//Функция показывает состояние карт в руке

	int i;

		for (i = 0; i < quantity; i++) {					//Циклом показываем по одной карте

			printf("%c ", *(gamer + i));

		}

}

void drawning(mnc *drwng, char *player, char *dealer, int *rndm, int *money, int *bet) {
													//Функция набора карт и сравнения результатов
	int np = 0;
	int p_sum = sumcards(player, np + 2); 			//Подсчитаем очки игрока
	
		do {
			
			drwng->menu_switch = 1;
			printf("\n	Взять еще карту?\n");		//Предложение взять еще карту 
			confirm();								//с проверкой ввода
			scanf("%s", drwng->menu_choice);

				if (atoi(drwng->menu_choice) == 1) {	
						
					dealing(player, np + 2, rndm);			//Берем одну карту 
					printf("\n	Карты в вашей руке: ");		//Считаем полученные очки
					getstatus(player, np + 3);				//Предлагаем брать карты пока не откажемся
					np++;									//Либо не наберем больше 21
					p_sum = sumcards(player, np + 3);
					printf("\n	Набрано очков: %d\n", p_sum);
					
				} else if (atoi(drwng->menu_choice) == 2) {		//Если очков достаточно, отдаем 
																//ход Дилеру. Он набирает карты.
					clearscreen();								//Очищаем экран
					
					printf("\n	Карты в вашей руке: ");			//Текущая информация об игроке
					getstatus(player, np + 3);
					printf("\n	Набрано очков: %d\n", sumcards(player, np + 3));
					printf("	Ваша ставка: %d$\n", *bet);
					printf("	Текущий капитал: %d$\n\n", *money);
					sleep(1);
					printf("	Теперь Дилер набирает карты.. \n\n");
					sleep(2);
					dealerturn(p_sum, dealer, rndm, money, bet);	//Передаем ход Дилеру
					drwng->menu_switch = 0;
					
				} else {
					
					wrongchoice();

				}
				
				if (p_sum > 21) {									//Проверяем ситуации, когда у игрока перебор
																	//Либо он собрал BJ
					printf("	У вас перебор, вы проиграли свою ставку\n");
					break;
					
				} else if (p_sum == 21) {
					
					printf("	У вас достаточно очков!\n\n");		//Когда собрал BJ, передаем ход
					printf("	Теперь Дилер набирает карты.. \n\n");
					sleep(1);
					dealerturn(p_sum, dealer, rndm, money, bet);
					drwng->menu_switch = 0;

				}

		} while (drwng->menu_switch);

}

void dealerturn(int p_sum, char *dealer, int *rndm, int *money, int *bet) {	 	//Функция хода Дилера
	
	int n = 0;
	int d_sum;
	
		do { 

			d_sum = sumcards(dealer, n + 2);				//Сначала считаем карты Дилера

				if (d_sum < 17) {							//Дилер Обязан брать карты и прекращает
															//набор, пока не наберет 17 очков и более
					dealing(dealer, n + 2, rndm);	
					n++;
									
				} else {
					
					break;
					
				}
					
		} while (d_sum <= 17);							//Когда Дилер набрал карты смотрим ситуации

		if (d_sum > 21) {								//Если перебор у Дилера
							
			printf("	Карты в руке Дилера: ");			//Показываем карты Дилера и очки
			getstatus(dealer, n + 2);						//Поздравляем с победой 
			printf("\n	Набрано очков: %d\n", d_sum);		//и увеличиваем капитал
			printf("\n	У Дилера перебор!\n");
			printf("	Вы выиграли и заработали: %d$\n", 2 * (*bet));
			*money = *money + 2 * (*bet);
							
		} else if (d_sum == p_sum) {
							
			printf("	Карты в руке Дилера: ");				//Если ничья, то возвращаем
			getstatus(dealer, n + 2);							//ставку Игроку
			printf("\n	Набрано очков: %d\n", d_sum);
			printf("	Ничья! Вы вернули свою ставку\n");			
			*money = *money + *bet;
						
		} else if (d_sum > p_sum) {
							
			printf("	Карты в руке Дилера: ");				//Если у Дилера очков больше
			getstatus(dealer, n + 2);							//то не возвращаем ставку
			printf("\n	Набрано очков: %d\n", d_sum);			//Игроку
			printf("	Победил Дилер! Вы потеряли свою ставку\n");				
						
		} else {
							
			printf("	Карты в руке Дилера: ");				//Если у Игрока очков больше
			getstatus(dealer, n + 2);							//возвращаем удвоенную ставку
			printf("\n	Набрано очков: %d\n", d_sum);
			printf("	Вы выиграли и заработали: %d$\n", 2 * (*bet));
			*money = *money + 2 * (*bet);

		}

}

void conflictBJ(mnc *cnflct, int *money, int *bet, char *dealer) {		//Функция конфликтной ситуации 

	int d_sum;

	printf("\n	Спорная ситуация!  У Дилера возможен BlackJack!\n");

		do {

			cnflct->menu_switch = 0;								//Предлагаем забрать ставку или 
			printf("	1. Забрать свою ставку \n");				//Постараться выиграть больше
			printf(" 	2. Отдать ход Дилеру\n");
			printf("	Введите число для продолжения: ");
			scanf("%s", cnflct->menu_choice);

				if (atoi(cnflct->menu_choice) == 1) {				//Если забираем, капитал не изменяется

					printf("\n	Вы вернули свою ставку\n");
					*money = *money + *bet;
					break;
					
				} else if (atoi(cnflct->menu_choice) == 2) {		//Отдаем ход Дилеру

					printf("\n\n	Дилер открывает последнюю карту..\n");
					sleep(1);
					printf("	Карты в руке Дилера: ");
					getstatus(dealer, 2);							//Открываем вторую карту Дилера
					d_sum = sumcards(dealer, 2);

						if (d_sum == 21) {							//Если у Дилера BlackJack он выигрывает
															
							printf("\n	У Дилера был BlackJack, вы проиграли\n");

						} else {

							printf("\n	У Дилера не было BlackJack'а, вы заработали %d$ \n",
											(int)(2 * (*bet)));
							*money = *money + (int)(2 * (*bet));	

						}
						
					break;
						
				} else {

					wrongchoice();						//Проверка на ввод
					cnflct->menu_switch = 1;

				}

		} while (cnflct->menu_switch);

}

void showresults(mnc *shwrslts) {				//Функция показа результатов

	clearscreen();								//Очищаем экран

		FILE *file;
		char table[7][23];						//Создаем таблицу и указатель на файл
		int n = 0;

			file = fopen("results.txt", "a+");		//Создаем файл или открываем существующий

				while(!feof(file)) {				//Читаем файл и записываем в таблицу данные

					fgets(*(table + n), 24, file);	//Если файла не было, то ничего не записываем
					n++;

				}

			printf("\n	Результаты игроков:\n");

		if (table[0][0] != '1') {							//Если записей нет, то создаем таблицу

			strcpy(table[0], "1. 1000000 - Developer");		//Таблица-пример
			strcpy(table[1], "2.         -          ");
			strcpy(table[2], "3.         -          ");
			strcpy(table[3], "4.         -          ");
			strcpy(table[4], "5.         -          ");
			strcpy(table[5], "6.         -          ");
			strcpy(table[6], "7.         -          ");

				freopen("results.txt", "w", file);			//Открываем файл для записи

			for (n = 0; n < 7; n++) {						//Записываем таблицу в чистый файл

				fprintf(file, "%s\n", *(table + n));		//Выводим на экран
				printf("	%s\n", *(table + n));

			}

		} else {										//Если в файле есть записи, то выводим их на экран

			freopen("results.txt", "r", file);			//открываем файл для чтения
			n = 0;

				while(!feof(file)) {

					fgets(*(table + n), 24, file);
					printf("	%s", *(table + n));		//Выводим данные из файла на экран
					n++;

				}

		}

	fclose(file);										//Закрываем файл

}

void writeresult(mnc *wrtrslt, int *money) {			//Функция записи результатов

	clearscreen();

		do {

			wrtrslt->menu_switch = 0;						//Запрашиваем ввод
			printf("\n	Желаете записать свой результат?\n");
			confirm();
			scanf("%s", wrtrslt->menu_choice);

				if (atoi(wrtrslt->menu_choice) == 1) {

					writefile(wrtrslt, money);				//Записываем результат
					break;

				} else if (atoi(wrtrslt->menu_choice) == 2) {

					mainmenu();								//Иначе выходим в главное меню

				} else {

					wrongchoice();
					wrtrslt->menu_switch = 1;

				}

		} while (wrtrslt->menu_switch);
		
	mainmenu(); 								//После записи выходим в меню

}

void writefile(mnc *wrtfl, int *money) {		//Функция редактирования таблицы

	clearscreen();								//Очищаем консоль

	showresults(wrtfl);							//Покажем существующую таблицу или создадим новую
	
	char *line = calloc(23, sizeof(char));		//Рабочая строка
	int position = 1;

		printf("\n\n	Вы можете записать свой результат в любую из строк\n");
		printf("	(Занятые строки будут перезаписаны)\n");

			do {								//Проверяем пользовательский ввод

				wrtfl->menu_switch = 0;

				printf("\n	Укажите номер строки: ");
				scanf("%s", wrtfl->menu_choice);

					switch (atoi(wrtfl->menu_choice)) {		//Выбираем нужную строку
															//и записываем туда имя
						case 1:
							position = 1;
							getresultline(line, money, position);
							break;		
						case 2:
							position = 2;
							getresultline(line, money, position);
							break;
						case 3:
							position = 3;
							getresultline(line, money, position);
							break;
						case 4:
							position = 4;
							getresultline(line, money, position);
							break;
						case 5:
							position = 5;
							getresultline(line, money, position);
							break;
						case 6:
							position = 6;
							getresultline(line, money, position);
							break;
						case 7:
							position = 7;
							getresultline(line, money, position);
							break;
						default:
							wrongchoice();
							wrtfl->menu_switch = 1;			//Иначе запрашивае ввод повторно
							break;
							
					}	
						
			} while (wrtfl->menu_switch == 1);
			
	FILE *file;
	char table[7][23] = {0};
	int n = 0;

		file = fopen("results.txt", "r");				//Открываем файл для чтения
			
			while(n < 7) {								//Показываем существующую таблицу

				fgets(*(table + n), 24, file);
				n++;

			}		

			for (n = 0; n < strlen(line); n++) {		//Записываем строку в таблицу
				
				table[position - 1][n] = line[n];

			}

		freopen("results.txt", "w", file);				//Открываем файл для записи

		fprintf(file,"%s",table);						//Записываем новую таблицу

	fclose(file);										//Закрываем файл

	clearscreen();
		
		printf("\n Запись..\n");
			
	sleep(1);
		
}

void getresultline(char *line, int *money, int position) {		//Функция склеивания строки 

	char *name = calloc(9, sizeof(char));						//Обозначаем будущую строку
	char *name_lim = calloc(9, sizeof(char));
	char mn[8];
	char ps[0];
	int n = 0;
	
		printf("\n	Введите свое имя (не более 9 знаков): ");
		scanf("%s", name);										//Запрашиваем любое имя
		
			strncpy(name_lim, name, 9);							//Ограничиваем количество знаков до 9
			sprintf(ps, "%d", position);			
			strcat(line, ps);									//последовательно склеиваем части таблицы
			strcat(line, ". ");
			sprintf(mn, "%d", *money);

				for (n = strlen(mn); n < 7; n++) {		//Дописываем пробелы, если число
														//мешьне заявленного блока
					strcat(mn, " ");
					
				}
				
			strcat(line, mn);
			strcat(line, " - ");
			
				for (n = strlen(name_lim); n < 9; n++) {
					
					strcat(name_lim, " ");
					
				}
				
			strcat(line, name_lim);						//Выдаем строку в требуемом формате


}
