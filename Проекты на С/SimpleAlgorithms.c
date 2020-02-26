#include <stdio.h>
#include <math.h>
#define ARR_SIZE 100
#define T int //Пользовательский тип данных
T gcd(T a, T b) { //Быстрый алгоритм Эвклида

    T c;

    while (b) {

        c = a % b;
        a = b;
        b = c;

    }

return a;
}

int sumDigit(long a) {

    int result = 0;

        while (a > 0) {

            result = result + a % 10;   //сумма цифр числа
            //result = result * 10 + a % 10; //переворот числа
            //result = result * 10 + a % 2; a /= 2; //Перевод в другую ОС
            //Вариант с недостатком
            a = a / 10;

        }

return result;
}

double distance(double x1, double y1, double x2, double y2) {

    return sqrt(pow(x1 - x2, 2) + pow(y1 - y2, 2)); //Нахождение стороны.

}

struct Point {

    double x;
    double y;

};
typedef struct Point Point; //Структура точек

double Distance(Point A, Point B) {

    return sqrt(pow(A.x - B.x, 2) + pow(A.y - B.y, 2));

}

int bin[ARR_SIZE] = {0};
int size = 0;

void convertToBin(long n) {

    int i = 0;

        while (n > 0) {

            bin[i++] = n % 2;
            n /= 2;

        }

    size = i;

}

void binPrint() {

    int i;

        for(i = size - 1; i >= 0; i--) {

            printf("%d", bin[i]);

        }

    printf("\n");

}

int power(int a, int b) {

   int p = 1;

    while(b) {

        p = p * a;
        b--;

    }

return p;
}

int quickPow(int a, int b) {

    long n = 1;

        while (b) {

            if (b % 2) {

                b--;
                n *= a;

            } else {

                a *= a;
                b /= 2;

            }

        }

return n;
}

void arrayPrint(int length, int *a) {

    int i;

        for(i = 0; i < length; i++)

            printf("%4i", a[i]);

    printf("\n");

}

int findMax(int length, int *a) {

    //В качестве начального значения максимума берём первое число
    int result = a[0];
    int i;

        //Просматриваем остальные числа
        for (i = 1; i < length; i++)
            //Если среди них есть число больше max, то берём его в качестве max
            if (a[i] > result) result = a[i];

return result;
}

int main() {

    //Найти расстояние между точками
    double x1, x2, y1, y2; //координаты

        printf("Найти расстояние между точками \n");
        printf("Введите координаты \n");
        printf("x1: ");
        scanf("%lf", &x1);
        printf("y1: ");
        scanf("%lf", &y1);
        printf("x2: ");
        scanf("%lf", &x2);
        printf("y2: ");
        scanf("%lf", &y2);

    double dist = sqrt(pow(x1 - x2, 2) + pow(y1 - y2, 2));
    printf("Расстояние: %lf \n\n", dist);

    //Использование функций. Найти периметр треугольника
    double x3, y3; //Координаты последней вершины

        printf("Найти периметр треугольника \n");
        printf("Введите координаты последней вершины\n");
        printf("x3: ");
        scanf("%lf", &x3);
        printf("y3: ");
        scanf("%lf", &y3);

    double len1 = distance(x1, y1, x2, y2);
    double len2 = distance(x1, y1, x3, y3);
    double len3 = distance(x2, y2, x3, y3);
    printf("Периметр: %lf \n\n", len1 + len2 + len3);

    //Использование структур. Найти расстояние между точками
    Point p1, p2;

        printf("Структуры. Найти расстояние между точками \n");
        printf("Введите координаты \n");
        printf("x1:");
        scanf("%lf", &p1.x);
        printf("y1:");
        scanf("%lf", &p1.y);
        printf("x2:");
        scanf("%lf", &p2.x);
        printf("y2:");
        scanf("%lf", &p2.y);
        printf("Distance: %lf \n\n", Distance(p1, p2));

    //Определение наибольшего общего делителя. Алгоритм Эвклида
    int a, b;

        printf("Наибольший общий делитель \n");
        printf("a: ");
        scanf("%d", &a);
        printf("b: ");
        scanf("%d", &b);

    printf("Ускоренный алгоритм: %d \n", gcd(a, b));

        while (a != b) {

            if (a > b) {

                a = a - b;

            } else {

                b = b - a;

            }

        }

    printf("НОД: %d \n\n", a);

    //Определение простоты числа
    int number;
    int d = 0;
    int i = 2;

        printf("Простое число?\n");
        printf("Введите число: ");
        scanf("%d", &number);

    while (i < number / 2  + 1) {

        if (number % i == 0) {

            d++;
            break;

        }

        i++;

    }

    if (d == 0) {

        printf("Число простое \n\n");

    } else {

        printf("Число составное \n\n");

    }

    //Определение средней оценки.
    unsigned int counter;  // Количество оценок
    int grade , sum;       // Значение оценки и сумма
    double average;        // Средняя оценка

        sum = 0;
        counter = 1;

    printf("Расчет средней оценки\n");
    while (1) { //бесконечный цикл

        printf("Введите оценку: ");
        scanf("%d", &grade);

            if(grade == -1) break; //Пока не введем -1

        sum = sum + grade;
        counter++;

    }

    if(counter != 0) {

        average = (double) sum / (counter - 1);
        printf("Средняя оценка %lf\n\n", average);

    } else printf("Нет оценок\n\n");

    //Найти сумму цифр целого числа и её производные
    int n;

        printf("Сумма цифр числа: ");
        scanf("%d", &n);
        printf("Равна: %d \n\n", sumDigit(n));

    //Перевод числа в другую СС
    int N = 13;
    convertToBin(N);
    printf("Число %i в двоичной системе: ", N); binPrint();

    N = 8;
    convertToBin(N);
    printf("Число %i в двоичной системе: ", N); binPrint();

    //Возведение числа в степень
    printf("\nВозведение числа а в степень b \n");
    printf("a: ");
    scanf("%d", &a);
    printf("b: ");
    scanf("%d", &b);
    printf("\nВозведение числа %d в %d равно %d", a, b, power(a, b));
    printf("\nУскоренное возведение числа %d в %d равно %d \n\n",
           a, b, quickPow(a, b));

    //Генератор псевдослучайных чисел.
    int x, m;
    m = 100; // Вершина последовательности
    b = 3;
    a = 2;
    x = 1;
    int modulus = 100;

        for (i = 0; i < modulus; i++) {

            x = (a * x + b) % m; //Ядро генератора
            printf("%d ", x);

        }
    puts(" ");

    //Работа с файлами. Нахождение максимального числа массива
    int array[ARR_SIZE];
    int size = 0;
    FILE *in;
    in = fopen("/home/sad/Загрузки/file", "r");

        if (in == NULL) {

            puts("Can't open file \n\n");
            return 1;

        }
            int data;

            // Пока количество подсчитанных данных больше нуля
            while(fscanf(in, "%d", &data) > 0) {

                array[size] = data;
                size++;
            }

     fclose(in);

    printf("\nПрочитано %d записей\n", size);
    // Массив является указателем (хранит адрес), поэтому & не ставится
    arrayPrint(size, array);
    printf("Max = %d \n", findMax(size, array));

return 0;
}














