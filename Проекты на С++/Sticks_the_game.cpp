//РРіСЂР° РЅР° РІР·СЏС‚РёРµ РїР°Р»РѕС‡РµРє Р¤РѕСЂРґ-Р‘РѕСЏСЂРґ
//РџСЂРѕРёРіСЂС‹РІР°РµС‚ С‚РѕС‚, РєС‚Рѕ Р±РµСЂРµС‚ РїРѕСЃР»РµРґРЅСЋСЋ РїР°Р»РѕС‡РєСѓ;
//РќСѓР¶РЅРѕ РІРІРµСЃС‚Рё РєРѕР»РёС‡РµСЃС‚РІРѕ РїР°Р»РѕС‡РµРє, РєРѕС‚РѕСЂРѕРµ Р±СѓРґРµС‚ РІ РёРіСЂРµ. РћС‚ 10 РґРѕ 30.
//РљР°Р¶РґС‹Р№ РёР· РёРіСЂРѕРєРѕРІ РјРѕР¶РµС‚ РІР·СЏС‚СЊ РЅРµ Р±РѕР»РµРµ 3, РЅРѕ РЅРµ РјРµРЅРµРµ 1 РїР°Р»РѕС‡РєРё Р·Р° С…РѕРґ;

#include <iostream>
#include <cstdlib>
#include <ctime>

using namespace std;

int InputProcessing(int sticks, int lowlim, int uplim) {	//Функция обработки ввода
	
	int num;
	
	do {
		
		cout << "Р’РІРµРґРёС‚Рµ РєРѕР»РёС‡РµСЃС‚РІРѕ РїР°Р»РѕС‡РµРє: ";
		cin >> num;
		
			if ((num < lowlim) || (num > uplim) || (num >= sticks)) {	//Оцениваем количество палочек
			
				cout << "РќРµРїРѕРґС…РѕРґСЏС‰РµРµ С‡РёСЃР»Рѕ РїР°Р»РѕС‡РµРє" << endl;
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
	
		cout << "РЎРєРѕР»СЊРєРѕ РїР°Р»РѕС‡РµРє Р±СѓРґРµС‚ РІ РёРіСЂРµ? " << endl;
	
		number_of_sticks = InputProcessing(31, 10, 30);		//Задаем общее число палочек в игре
	
		cout << endl;
		cout << "РћС‚Р»РёС‡РЅРѕ, РЅР°С‡РЅРµРј РёРіСЂСѓ!" << endl;
	
	while (true) {
		
		cout << "РџР°Р»РѕС‡РµРє РѕСЃС‚Р°Р»РѕСЃСЊ: " << number_of_sticks << endl;
		
			if (number_of_sticks == 1) {		//Условия проигрыша игрока
				
				cout << "Р’С‹ РїСЂРѕРёРіСЂР°Р»Рё" << endl;
				break;
					
			}
		
		cout << "РЎРєРѕР»СЊРєРѕ РїР°Р»РѕС‡РµРє С…РѕС‚РёС‚Рµ РІР·СЏС‚СЊ?" << endl;
		player_get_sticks = InputProcessing(number_of_sticks, 1, 3);	//Игрок берет палочки(у)
		number_of_sticks = number_of_sticks - player_get_sticks;	//Общее число палочек уменьшается
		cout << endl;

			if (number_of_sticks == 1) {		//Условия проигрыша противника
				
				cout << "РџСЂРѕС‚РёРІРЅРёРє РїСЂРѕРёРіСЂР°Р»" << endl;
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
			
		cout <<"РџСЂРѕС‚РёРІРЅРёРє РІР·СЏР» " << opponent_get_sticks <<
		((opponent_get_sticks == 1) ? " РїР°Р»РѕС‡РєСѓ" : " РїР°Р»РѕС‡РєРё") << endl;
		number_of_sticks = number_of_sticks - opponent_get_sticks;
		
	}

return 0;
}