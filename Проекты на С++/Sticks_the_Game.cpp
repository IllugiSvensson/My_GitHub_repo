//Игра в палочки как в Форд-Боярд
//Проигрывает тот, кто берет последнюю палочку
//В начале игры нужно выбрать, сколько палочек будет в игре. От 10 до 30.
//Брать за ход можно от 1 до 3 палочек.

#include <iostream>
#include <cstdlib>
#include <ctime>

using namespace std;

int InputProcessing(int sticks, int lowlim, int uplim) {	//Функция обработки ввода
	
	int num;
	
	do {
		
		cout << "Введите количество палочек: ";
		cin >> num;
		
			if ((num < lowlim) || (num > uplim) || (num >= sticks)) {	//Оцениваем количество палочек
			
				cout << "Неподходящее число палочек" << endl;
				continue;	//Повторяем, пока не попадем в нужный диапазон
				
			} 
						
		break;		//Выходим из цикла и функции
		
	} while (true);
			
return num;
}

int main(int argc, char** args) {

	int number_of_sticks;
	int player_get_sticks;
	int opponent_get_sticks;
	
		srand(time(NULL));	//Задаем генератор случайных чисел
	
		cout << "Сколько палочек будет в игре? " << endl;
	
		number_of_sticks = InputProcessing(31, 10, 30);		//Задаем общее число палочек в игре
	
		cout << endl;
		cout << "Отлично, начнем игру!" << endl;
	
	while (true) {
		
		cout << "Палочек осталось: " << number_of_sticks << endl;
		
			if (number_of_sticks == 1) {		//Условия проигрыша игрока
				
				cout << "Вы проиграли" << endl;
				break;
					
			}
		
		cout << "Сколько палочек хотите взять?" << endl;
		player_get_sticks = InputProcessing(number_of_sticks, 1, 3);	//Игрок берет палочки(у)
		number_of_sticks = number_of_sticks - player_get_sticks;	//Общее число палочек уменьшается
		cout << endl;

			if (number_of_sticks == 1) {		//Условия проигрыша противника
				
				cout << "Противник проиграл" << endl;
				break;
					
			}
			
		opponent_get_sticks = rand() % 3 + 1;	//Противник берет случайное количество палочек
			
			switch (number_of_sticks) {	//Но при количестве 4 и менее берет столько, чтобы оставить одну
								
				case 4: 
					opponent_get_sticks = 3;
					break;
				case 3:
					opponent_get_sticks = 2;
					break;
				case 2: 
					opponent_get_sticks = 1;
					break;
				default:
					break;
						
			}
			
		cout << "Противник взял " << opponent_get_sticks <<
		((opponent_get_sticks == 1) ? " палочку" : " палочки") << endl;
		number_of_sticks = number_of_sticks - opponent_get_sticks;
		
	}

return 0;
}