#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

int randgen(int q); //13 задача.
int maxnumber(int a, int b, int c); //Задача 12

void solution1();   //Прототипы функций
void solution2();
void solution3();
void solution4();
void solution5();
void solution6();
void solution7();
void solution8();
void solution9();
void solution10();
void solution11();
void solution12();
void solution13();
void solution14();

int main() {

    int sel = 0;
    do {

        printf("Введите номер задачи или 0 для выхода: ");
        scanf("%i", &sel);

            switch (sel) {
                case 1:
                    solution1();
                    break;
                case 2:
                    solution2();
                    break;
                case 3:
                    solution3();
                    break;
                case 4:
                    solution4();
                    break;
                case 5:
                    solution5();
                    break;
                case 6:
                    solution6();
                    break;
                case 7:
                    solution7();
                    break;
                case 8:
                    solution8();
                    break;
                case 9:
                    solution9();
                    break;
                case 10:
                    solution10();
                    break;
                case 11:
                    solution11();
                    break;
                case 12:
                    solution12();
                    break;
                case 13:
                    solution13();
                    break;
                case 14:
                    solution14();
                    break;
                case 0:
                    printf("Выход\n");
                    break;
                default:
                    printf("Неверный выбор\n");
            }

    } while (sel != 0);

return 0;
}

void solution1() {

    printf("Задача 1\n");
        //1. Ввести вес и рост человека. Рассчитать и вывести индекс массы тела
        //по формуле I=m/(h*h); где m-масса тела в килограммах, h - рост в метрах.
        float h, m;

            printf("Введите рост человека в метрах: ");
            scanf("%f", &h);
            printf("Введите вес человека в килограммах: ");
            scanf("%f", &m);
            printf("Индекс массы тела: %3.2f\n\n", m / (h * h));

}

void solution2() {

    printf("Задача 2\n");
        //2. Найти максимальное из четырех чисел не используя массивы.
        int maxn, a, b, c, d;

            printf("Введите 4 числа: ");
            scanf("%d", &a);
            scanf("%d", &b);
            scanf("%d", &c);
            scanf("%d", &d);

                if((a > b) && (a > c) && (a > d)) maxn = a;
                else if ((b > a) && (b > c) && (b > d)) maxn = b;
                else if ((c > a) && (c > b) && (c > d)) maxn = c;
                else maxn = d;

            printf("Максимальное число: %d\n\n", maxn);

}

void solution3() {

    printf("Задача 3\n");
        //3. Написать программу обмена значениями двух целочисленных переменных:
        //a. с использованием третьей переменной;
        //b. *без использования третьей переменной.
        int a, b, c;

            printf("Введите два числа: ");
            scanf("%d", &a);
            scanf("%d", &b);
            printf("a = %d, b = %d\n", a, b);

                c = a;
                a = b;
                b = c;

            printf("a = %d, b = %d\n", a, b);

                a = a + b;
                b = a - b;
                a = a - b;

            printf("a = %d, b = %d\n\n", a, b);

}

void solution4() {

    printf("Задача 4\n");
        //4. Написать программу нахождения корней заданного квадратного уравнения.
        float a, b, c, x1, x2;
        double D = (b * b) - (4 * a * c);				//Расчет дискриминанта

            printf("Введите коэффициенты квадратного уравнения: ");
            scanf("%f", &a);
            scanf("%f", &b);
            scanf("%f", &c);

                if (a == 0) {					//Проверка на квадратное уравнение

                    x1 = -c / b;
                    printf("Неквадратное уравнение. Корень: x = %.2f \n\n", x1);

                } else if (D > 0) {				//Расчитываем корни

                    x1 = (-b + sqrt(D)) / (2 * a); 	//через дискриминант
                    x2 = (-b - sqrt(D)) / (2 * a);
                    printf("В уравнении есть два корня: x1 = %.2f, x2 = %.2f \n\n", x1, x2);

            } else if (D == 0) {

                x1 = -b / (2 * a);
                printf("В уравнении только один корень: x = %.2f \n\n", x1);

            } else {

                printf("В уравнении нет вещественных корней. \n\n");

            }

}

void solution5() {

    printf("Задача 5\n");
        //5. С клавиатуры вводится номер месяца. Требуется определить, к какому времени года он относится.
        int n;

            printf("Введите номер месяца: ");
            scanf("%d", &n);

                switch(n) {
                    case 3:
                    case 4:
                    case 5:
                        printf("Весна\n");
                        break;
                    case 6:
                    case 7:
                    case 8:
                        printf("Лето\n");
                        break;
                    case 9:
                    case 10:
                    case 11:
                        printf("Осень\n");
                        break;
                    case 12:
                    case 1:
                    case 2:
                        printf("Зима\n");
                        break;
                    default:
                        printf("Неверный ввод\n");
                        break;
                }

puts(" ");
}

void solution6() {

    printf("Задача 6\n");
        //6. Ввести возраст человека (от 1 до 150 лет) и вывести его вместе с последующим
        //словом «год», «года» или «лет».
        int n;

            printf("Введите возраст (от 1 до 100): ");
            scanf("%d" , &n);

                if ((n % 10 == 1) && (n != 11)) printf("%d год\n", n);
                else if ((n % 10 >= 2 ) && (n % 10 <= 4) && (n < 10 || n >= 20)) printf("%d года\n", n);
                else printf("%d лет\n",n);

puts(" ");
}

void solution7() {

    printf("Задача 7\n");
        //7. С клавиатуры вводятся числовые координаты двух полей шахматной
        //доски (x1,y1,x2,y2). Требуется определить, относятся ли к поля к одному цвету или нет.
        int x1, y1, x2, y2, n, k;
        int board[9][9] = {{0}, {0}};

            for(n = 0; n < 8; n += 2) { //Заполняем поля доски по строкам и столбцам

                for(k = 0; k < 8; k +=2) board[n][k] = 1;

            }

            for(n = 1; n < 8; n += 2) {

                for(k = 1; k < 8; k +=2) board[n][k] = 1;

            }

        printf("Введите координаты клетки 1: ");
        scanf("%d", &x1);
        scanf("%d", &y1);
        printf("Введите координаты клетки 2: ");
        scanf("%d", &x2);
        scanf("%d", &y2);
        printf("%s", (board[x1][y1] == board[x2][y2])? "Один цвет\n": "Цвета разные\n");

puts(" ");
}

void solution8() {

    printf("Задача 8\n");
        //8. Ввести a и b и вывести квадраты и кубы чисел от a до b.
        int a, b, k;

            printf("Введите a: ");
            scanf("%d", &a);
            printf("Введите b > a: ");
            scanf("%d", &b);

                for(k = a; k <= b; k++) {

                    printf("Квадрат числа %d: %.2lf\t Куб числа %d: %.2lf\n",
                    k, pow(k, 2), k, pow(k, 3));

                }

puts(" ");
}

void solution9() {

    printf("Задача 9\n");
        //9. Даны целые положительные числа N и K. Используя только операции сложения
        //и вычитания, найти частное от деления нацело N на K, а также остаток от этого деления.
        unsigned int N, K, n = 0;

            printf("Введите N: ");
            scanf("%d", &N);
            printf("Введите K: ");
            scanf("%d", &K);

                while(K < N) {

                    n++;
                    N -= K;

                }

        printf("Частное: %d \tОстаток: %d\n\n", n, N);

}

void solution10() {

    printf("Задача 10\n");
        //10. Дано целое число N (> 0). С помощью операций деления нацело и взятия
        //остатка от деления определить, имеются ли в записи числа N нечетные цифры.
        //Если имеются, то вывести True, если нет — вывести False.
        int numeral, n, k, s;

            printf("Введите число, больше нуля: ");
            scanf("%d", &n);

            numeral = n;
                for(k = 1; k < n; k *= 10) {    //смотрим по десяткам

                    if (numeral % 2 == 1) {     //проверяем нечетные числа

                        s = 0;
                        printf("True\n\n");
                        break;

                    } else s = -1;

                    numeral = n / (k * 10);

                }

            if(s == -1) printf("False\n\n");

}

void solution11() {

    printf("Задача 11\n");
        //11. С клавиатуры вводятся числа, пока не будет введен 0. Подсчитать среднее
        //арифметическое всех положительных четных чисел, оканчивающихся на 8.
        int n = 1, k = 0;
        float s = 0;

            while (n != 0) {

                printf("Введите число: ");
                scanf("%d", &n);

                if((n % 10 == 8) || (n == 8)) {

                    s = s + n;
                    k++;

                }

            }

        printf("\nСреднее: %5.2f\n\n", s / k);

}

void solution12() {

    printf("Задача 12\n");
        //12. Написать функцию нахождения максимального из трех чисел.
            int a, b ,c;

                printf("Введите число 1: ");
                scanf("%d", &a);
                printf("Введите число 2: ");
                scanf("%d", &b);
                printf("Введите число 3: ");
                scanf("%d", &c);
                printf("Максимальное число: %d \n\n", maxnumber(a, b, c));

}

void solution13() {

    printf("Задача 13\n");
        //13. Написать функцию, генерирующую случайное число от 1 до 100.
        //с использованием стандартной функции rand()
        //без использования стандартной функции rand()

            printf("Случайное число: %d \n\n", randgen(100));

}

void solution14() {

    printf("Задача 14\n");
    //14. Автоморфные числа. Натуральное число называется автоморфным,
    //если оно равно последним цифрам своего квадрата. Например, 25 \ :sup: 2 = 625.
    //Напишите программу, которая вводит натуральное число N и выводит на экран
    //все автоморфные числа, не превосходящие N.
    int numeral, n, amnum, k;

        printf("Введите любое целое положительное число: ");
        scanf("%d", &numeral);
        printf("Список аморфных чисел: \n");

        for(n = 1; n <= numeral; n++) {

            amnum = n * n;

            for(k = 10; k < n; k *= 10);    //Набираем k под проверку десяток, сотен и тд..
            amnum = amnum % k;

            if(amnum == n) printf("\t%d\n", n);

        }

puts(" ");
}

int maxnumber(int a, int b, int c) { //Задача 12

    int maxn;

        if((a > b) && (a > c)) maxn = a;
        else if ((b > a) && (b > c)) maxn = b;
        else maxn = c;

return maxn;
}

int randgen(int q) {	//Задача 13

    srand(time(NULL));

    //int random = 1 + rand() % q;  //Стандартная функция

    int random = time(NULL) % 100;	//Получаем секунды
    int i, sum;
                                //Что-то на подобии генератора псевдослучайной последовательности
        sum = random + 1;		//Присвоим число 1..10
        sum += random + 3;			//полученное число "сдвинем"

            if(sum >= 10) sum -= 10; //Зациклим в пределах 10

        for(i = 0; i < pow(random + 1, 2); i++) {

            sum = sum + (sum - 1);				//складываем текущее с предыдущим
                                                //значением.
            if(sum >= 100) sum -= 100;

        }

return random = abs(sum % 100);
}























