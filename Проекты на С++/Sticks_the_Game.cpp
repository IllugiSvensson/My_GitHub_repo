//Игра на взятие палочек Форд-Боярд
//Проигрывает тот, кто берет последнюю палочку;
//Нужно ввести количество палочек, которое будет в игре. От 10 до 30.
//Каждый из игроков может взять не более 3, но не менее 1 палочки за ход;

#include <iostream>
#include <cstdlib>
#include <ctime>

using namespace std;

int InputProcessing(int sticks, int lowlim, int uplim) {	//������� ��������� �����
	
	int num;
	
	do {
		
		cout << "Введите количество палочек: ";
		cin >> num;
		
			if ((num < lowlim) || (num > uplim) || (num >= sticks)) {	//��������� ���������� �������
			
				cout << "Неподходящее число палочек" << endl;
				continue;	//���������, ���� �� ������� � ������ ��������
				
			} 
						
		break;		//������� �� ����� � �������
		
	} while (true);
			
return num;
}

int main(int argc, char** args) {

	int number_of_sticks;
	int player_get_sticks;
	int opponent_get_sticks;
	
		srand(time(NULL));	//������ ��������� ��������� �����
	
		cout << "Сколько палочек будет в игре? " << endl;
	
		number_of_sticks = InputProcessing(31, 10, 30);		//������ ����� ����� ������� � ����
	
		cout << endl;
		cout << "Отлично, начнем игру!" << endl;
	
	while (true) {
		
		cout << "Палочек осталось: " << number_of_sticks << endl;
		
			if (number_of_sticks == 1) {		//������� ��������� ������
				
				cout << "Вы проиграли" << endl;
				break;
					
			}
		
		cout << "Сколько палочек хотите взять?" << endl;
		player_get_sticks = InputProcessing(number_of_sticks, 1, 3);	//����� ����� �������(�)
		number_of_sticks = number_of_sticks - player_get_sticks;	//����� ����� ������� �����������
		cout << endl;

			if (number_of_sticks == 1) {		//������� ��������� ����������
				
				cout << "Противник проиграл" << endl;
				break;
					
			}
			
		opponent_get_sticks = rand() % 3 + 1;	//��������� ����� ��������� ���������� �������
			
			switch (number_of_sticks) {	//�� ��� ���������� 4 � ����� ����� �������, ����� �������� ����
								
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
			
		cout <<"Противник взял " << opponent_get_sticks <<
		((opponent_get_sticks == 1) ? " палочку" : " палочки") << endl;
		number_of_sticks = number_of_sticks - opponent_get_sticks;
		
	}

return 0;
}