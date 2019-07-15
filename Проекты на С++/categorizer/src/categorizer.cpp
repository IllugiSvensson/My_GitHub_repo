//Для загрузки изображений в программу есть
//скрипт в каталоге My_GitHub_repo/Скрипты на Bash/PGMloader.sh

#include <iostream>
#include <fstream>

using namespace std;

void CheckPosition(ifstream& in, char ending) {		//Оцениваем позицию указателя в бинарном файле

    char RHS;

        do {    //Пройдемся по числам, пока не наткнемся разделитель

            in.read(&RHS, 1);

        } while (RHS != ending);

}

int GetResolution(int EndPos, int StartPos, ifstream& in, int decdig[256]) {	//Вычислим разрешение изображения

    int i = 0;
    int c = 1;
    int Res = 0;
    char RHS;

        for(i = EndPos; i >= StartPos; i--, c *= 10) {		

            in.seekg(i);               //Смещаем указатель, считываем символ
            in.read(&RHS, 1);          //с конца и двигаемся назад (позиционно по разрядам)
            Res += decdig[RHS] * c;    //Складываем единицы, десятки и тд

        }

return Res;
}

int main(int argc, char** args) {

    unsigned int Histogram[256];
    int DecDigits[256];
    char filename[256];
    char CheckType[2];
    char ReadHexSymb;
	char norm;
    unsigned int StartPosition;
    unsigned int EndPosition;
    int Width = 0;
    int Height = 0;
	int normalized;
    int j;
    int c;

        if(argc == 1) {     //Проверяем наличие подключенных файлов

            cout << "Укажите входной файл(ы)!" << endl;
            return 1;

        }
        
			cout << "Желаете нормировать гистограммы? [y/n]: ";
			cin >> norm;

    ifstream in;

        for(int i = 1; i < argc; i++) {     //Обрабатываем каждый файл отдельно

            in.open(args[i], ios::in | ios::binary); //Открываем подключенные файлы

                if(!in.is_open()) {         //Проверяем на ошибки при открытии файлов

                    cout << "Файл: " << args[i] << " открыть не удалось." << endl;
                    continue;

                } else {

                    cout << "Файл: " << args[i] << " успешно открыт." << endl;

                }

            in.read(CheckType, 2);

                if((CheckType[0] != 0x50) || (CheckType[1] != 0x35)) { //Проверяем на правильность типа формата

                    continue;

                } else {

                    cout << "Подключен файл формата PGM в бинарном представлении." << endl;

                }

    //Формат заголовка: XX.XXXX XXXX.XXX. Пример P5.512 512.255
    //В HEX представлении: 50 35 0A 35 31 32 20 35 31 32 0A 32 35 35

            in.seekg(static_cast<unsigned int>(in.tellg()) + 1);  //Сместим указатель в позицию после 0A
            StartPosition = static_cast<unsigned int>(in.tellg()); //Зафиксируем начальную позицию

                CheckPosition(in, 0x20);	//Пройдемся по числам

            EndPosition = static_cast<unsigned int>(in.tellg()) - 2; //Зафиксируем конечную позицию

                for(int a = '0', j = 0; a <= '9'; a++, j++) {   //Создаем массив десятичных чисел

                    DecDigits[a] = j;

                }

                Width = GetResolution(EndPosition, StartPosition, in, DecDigits); //Считаем ширину изображения

            StartPosition = EndPosition + 2;    //Устанавливаем новую стартовую позицию
            c = 1;                              //Сброс до единиц

                CheckPosition(in, 0x0A);	//Пройдемся по числам вновь

            EndPosition = static_cast<unsigned int>(in.tellg()) - 2; //Фиксируем конечную позицию

                Height = GetResolution(EndPosition, StartPosition, in, DecDigits); //Считаем высоту изображения

                    cout << "\t" << "Ширина: " << Width << endl;
                    cout << "\t" << "Высота: " << Height << endl;

                for(int k = 0; k < 256; ++k) {      //Очищаем массив для записи

                    Histogram[k] = 0;

                }

            in.seekg(EndPosition + 6);  //Смещаем указатель на новую позицию

                for(int k = 0; k < (Width * Height); ++k) {     //Сворачиваем изображение в строку

                    if(in.eof()) {                          //Обходим каждый элементы строки до конца

                        break;

                    } else {
						
                        in.read(&ReadHexSymb, 1);          //Накапливаем единицы в ячейках массива
                        Histogram[static_cast<unsigned char>(ReadHexSymb)] += 1;

                    }
                }

        in.close();		//Закрываем изображение

            sprintf(filename, "Histogram_%s.txt", args[i]);       //Именуем выходные файлы по имени входного файла
            ofstream out(filename);
			
		normalized = Histogram[0];
			
			if (norm == 'y') {			//Нормируем гистограммы
								
				for(j = 0; j < 256; ++j) {		//Ищем пиковое значение гистограммы
					
					if(Histogram[j] > normalized) {
						
						normalized = Histogram[j];	
						
					}
					
				}

				normalized /= 1000;			//Масштабируем значение
			
			} else {
				
				cout << "Нормирование отклонено" << endl;
				normalized = 1;
			
			}

                out << "\tФайл: " << args[i] << endl;
                out << "Ширина: " << Width << "\t" << "Высота: " << Height << endl;

            for(j = 0; j < 256; j++) {      //Записываем гистограмму в файл

                out << "[" << j << "] ";

                    for(int k = 0; k < (Histogram[j] / normalized); k++) {	//Масштабируем гистограмму и записываем в файл

                        out << "|";

                    }

                out << endl;

            }

                out << "Конец файла " << args[i] << endl << endl;

            out.close();

            cout << "Гистограмма для файла " << args[i] << " получена " << endl;

        }

return 0;
}