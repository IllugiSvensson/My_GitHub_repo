#include <stdio.h>
#define IN 1
#define OUT 0

void func1(int c);
void func2(int c);
void func3();
void func4();
void func5();

int main()
{
    //Тип char не подходит, в него не "влезает" EOF
    int c;

//    func1(c);
//    func2(c);
//    func3();
//    func4();
    func5();

    printf("%d", EOF);
    return 0;
}

void func1(int c)
{
    //Берем один символ из текстового потока
    c = getchar();
    //Сравнение "не равно". EOF - признак конца файла
    while (c != EOF)
    {
        //Вставляем символ в текстовый поток
        putchar(c);
        c = getchar();
    }
}

void func2(int c)
{
    //В выражениях можно использовать присваивания (будет использовано rvalue)
    //Скобки нужны для расстановки приоритета вычислений
    while ((c = getchar()) != EOF)
    {
        putchar(c);
    }
}

void func3()
{
    long nc;
    nc = 0;

    while (getchar() != EOF)
        //Оператор инкримента (+1), есть еще декремент -- (-1)
        ++nc;
    printf("%ld\n", nc);

    //Вариант со счетным циклом и двойной длинной
    double nd;
    for (nd = 0; getchar() != EOF; ++nd)
    {
    }
    printf("%f\n", nd);
    //while и for могут не выполниться ни разу
}

void func4()
{
    int c, nl, nt = 0;
    nl = 0;
    putchar('\t');
    while ((c = getchar()) != EOF)
    {
        //Сравнение символа с концом строки
        if (c == '\n')
            ++nl;
        //'' представляют символ в целых значениях кодировки ASCII
        //"" представляют символ как строку символов
        if (c == '\t')
            ++nt;

        //Упражнение 1
        int a = 0;
        if (c != ' ')
        {
            if (a > 0) putchar(' ');
            putchar(c);
        }
        else
            a++;

        //Упражнение 2
        if (c == '\t')
        {
            putchar('\\');
            putchar('t');
        }
        else
            putchar(c);
    }
    printf("%d\n%d\n", nl, nt);
}

void func5()
{
    int c, nl, nw, nc, state;
    state = OUT;
    //Присваивание делается справа и эквивалентно nl = ( nw = (nc = 0));
    nl = nw = nc = 0;
    while ((c = getchar()) != EOF) {
        ++nc;
        if (c == '\n')
            ++nl;
        // || логическое ИЛИ (&& - И)
        if (c == ' ' || c == '\n'|| c == '\t')
            state = OUT;
        //else - альтернативное условие, если первое ложно
        else if ( state == OUT)
        {
            state = IN;
            ++nw;
        }

        //Упражнения
        if (c != ' ' || c != '\n' || c != '\t')
            putchar(c);
        else putchar('\n');
    }
    printf("%d %d %d\n", nl, nw, nc);
}
