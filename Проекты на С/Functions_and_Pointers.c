#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <time.h>
#include <locale.h>

#define ARRAY 15  //Размер массива для генератора случайных чисел

//Задача на указатели.
//Используя заголовочный файл <math.h>, описать функцию, 
//int calculateSquareEquality(float a, float b, float c, float* x1, float* x2); 
//Которая будет решать квадратное уравнение вида a * x ^ 2 + b * x + c = 0 
//и записывать корни этого уравнения в переменные, адреса которых переданы в 
//качестве указателей х1 и х2. Функция должна вернуть -1, если уравнение не 
//имеет корней, 0, если у уравнения есть один корень, и 1, если у уравнения два корня.

int cSE(float a, float b, float c, float *x1, float *x2) {
	
	double D;
	D = (b * b) - (4 * a * c);				//Расчет дискриминанта
	
		if (a == 0){					//Проверка на квадратное уравнение
			*x1 = -c / b;
			return 0;
		} else if (D > 0){				//Расчитываем корни
			*x1 = (-b + sqrt(D)) / (2 * a); 	//через дискриминант
			*x2 = (-b - sqrt(D)) / (2 * a);
			return 1;
		} else if (D == 0){
			*x1 = -b / (2 * a);
			return 0;
		} else
			return -1;		
}

//Задача на массивы.
//Инициализировать массив из целых чисел, описать функцию, принимающую на вход этот массив.
//Функция должна вернуть ноль, если в массиве нет нечётных чисел, в противном случае удвоить
//все нечётные числа в массиве и вернуть единицу. После выполнения функции, если массив был
//изменён, вывести все числа из массива на экран.

int odd(int *arr, int Len) {

	int i;
	int changed = 0;

	for (i = 0; i < Len; i++) {
		if (arr[i] % 2 != 0) {		//Проверяем элементы массива
			arr[i] *= 2;		//на нечетность
			changed = 1;
		}
	}
	return changed;
}

//Спец задания.
//Как известно, переменная типа integer занимает в памяти 4 байта, а переменная типа short два
//байта. Опишите функцию, которая принимает массив из тридцатидвухразрядных чисел (типа int),
//и выводит его на экран шестнадцатиразрядными числами (типа short).

void int2short(unsigned int *a, int length) {

	int i;
	unsigned short *sh = a;			//Приводим тип

	for (i = 0; i < length * 2; i++)	//Распределяем число по разрядам
		printf("%d ", *(sh + i));
}

//Проверить работоспособность генератора случайных чисел.

void randomGen () {

	srand(time(NULL));	//используем системное время для генерации

	int i, n, a;
	int freq[ARRAY]={0};	//Инициализируем массив нулями

	printf("Введите число генераций: ");
	scanf("%d", &n);

		for(i = 0; i < n ; i++){
				a = rand() % ARRAY;	//Элементы массива случайны
				freq[a]++;		//в диапазоне от нуля до ARRAY
		}
		
		for(i = 0; i < ARRAY; i++) {
			printf("Число %d сгенерированно %6d (%5.2f%%) раз\n", 
				i, freq[i], ((float)freq[i] / n * 100));
		}
}

//Сформировать таблицу Пифагора и вывести на экран.

void multiTable() {

	int table[10][10];
	int row, column;

    	for(row = 0; row < 10; row++) {				//Заполняем таблицу
    		for(column = 0; column < 10; column++)
    			table[row][column] = (row + 1) * (column + 1);
    	}

    	for(row = 0; row < 10; row++) {				//Выводим таблицу
    		printf("\n");
    		for(column = 0; column < 10; column++)
    			printf("%4d", table[row][column]);
    	}
}

int main(int argc, char const *argv[]) {
	setlocale(LC_ALL,"Rus");

	float a, b, c;
	float x1, x2;
	int result;

	printf("Посчитаем корни квадратного уравнения!\n");
	printf("Введите коэффициент a: ");
	scanf("%f", &a);
	printf("Введите коэффициент b: ");
	scanf("%f", &b);
	printf("Введите коэффициент c: ");
	scanf("%f", &c);

		result = cSE(a, b, c, &x1, &x2);

			if(result == 1) {
				printf("В уравнении есть два корня: x1 = %.2f, x2 = %.2f \n", x1, x2);	
			} else if(result == 0){
				printf("В уравнении только один корень: x = %.2f \n", x1);	
			} else 
				printf("В уравнении нет вещественных корней. \n");

	int size, i;
	int ARR[size];

	printf("\nУдвоим нечетные числа в массиве.");
	printf("\nВведите число элементов массива: ");
	scanf("%d", &size);

		for (i = 0; i < size; i++) {
			printf("Введите %d элемент массива: ", i+1);
			scanf("%d", ARR + i);
		}

		if(odd(ARR, size))				//Если массив изменился, то выводим
			for(i = 0; i <size; i++)		//его на экран 
				printf("%d ", *(ARR + i));	

	printf("\n\nПреобразуем тип int в short.");
	printf("\nВведите число элементов массива: ");
	scanf("%d", &size);

	unsigned int arr[size];

		for (i = 0; i < size; i++) {
			printf("Введите %d элемент массива: ", i+1);
			scanf("%d", arr + i);
		}
		
	int2short(arr, size);	 

	printf("\n\nПроверим генератор случайных чисел\n");

		randomGen();

	printf("\nВыведем таблицу Пифагора: ");

		multiTable();

return 0;
}
