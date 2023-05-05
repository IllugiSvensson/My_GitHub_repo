#Урок 1 Введение
test = 10
print("Мне " + str(test) + " лет!") #test нужно привести к строке


#Урок 2 Простые операции
print(2 + 5)
print(2 - 1)
print(5 * 5)
print(25 / 5)
print(-5 * 5, - (-5 * 5), --5) #Инверсия
print(2 ** 5)   #Степень
print(20 // 6) #Деление нацело
print(20 % 6) #Остаток
#Типы данных инт и флоут обычно приводятся сами друг к другу


#Урок 3 Строки
#"" '' одинаково работают, можно вкладывать друг в друга
#\...экранирование, как обычно
print('Hello world!') #Обычный вывод
print('Hello \nworld!') #Вывод через перевод строки
#Другой вариант вывода (для больших текстов)
print('''Hello
world!''')
#Ввод данных
a = input('Первый: ')   #Возвращает строку
b = input('Второй: ')
#конкатенация и умножение
print('Сумма: ' + str(int(a) + int(b))) #Соединяем строку
print('Сумма: ' + (str(int(a) + int(b))) * 2) #Соединяем и умножаем


#Урок 4 Типы данных, переменные
#int(), float(), str() и тд - преобразователи типов
test = 10
test = test + 1
test += 1  #test++ не работает
#+=, -=, *=, %= и тд
#Удаление переменных
del a, b
#print(a + b) Будет ошибка


#Урок 5 Управляющие конструкции
test = True #False
print(10 == 11) #Сравнения != > < >= <=
print("Test" == "test") #У слов разный вес и положение букв, регистр
#Условия
pogoda = 'Winter'
time = 'Night'
if pogoda == 'Winter':
    print('Brr')
    if time == 'Night':
        print("Night")
    elif time == 'Day':
        print('Day')
    else:
        print("???")


#Урок 6 Множественные условия, приоритет
pogoda = 'Rain'
time = "night"
if pogoda == 'Rain' and (time == "night" or time == "midnight"):
    print("foo bar")
elif not time == "night":
    print("bar foo")
#Приоритеты: (), **, *, /, +, - ...


#Урок 7 Циклы
number = 0
while number <= 1000:
    if number == 10:
        break   #Сброс цикла

    number += 1
    if (number % 2) != 0:
        continue    #Сброс итерации цикла
    print(number)


#Урок 8 Списки
test = [1, 2, 3, 4, 5]
print(test[2])
test = [1, 2, 3, [4, 5, 6]]
print(test[3][1]) #Обращение к вложеному списку
print(str(test * 2)) #продублировать элементы списка
test = 'Привет'
print(test[3])  #Вывод буквы строки
test = [1, 2, 3, 4, 5, 6 ,7 ,8, 5]
if 4 in test:
    print('4')
if 9 not in test:
    print('not 9')

test.append(9) #Добавление элемента в конец
len(test) #Размер списка
test.remove(5) #Удаление первого найденного элемента
test.insert(3, 6)   #Добавление в позицию
max(test)
min(test)
test.count(5)   #Подсчет количества вхождений в список
test.reverse() #Переворот списка. Не создает копии и не возвращает значений


#Урок 9 Диапазоны
numbers = list(range(50, 100, 2))
for i in numbers:
    print(str(i) + '!')


#Урок 10 Функции
def multiply(number):
    print(number * 2)
multiply(5)

def max(x, y):
    if x > y:
        return x
    else:
        return y
print(max(4, 5))


#Урок 11 docstring
def howdy_ho():
    '''Description'''
    print('Howdy Ho!')
print(howdy_ho.__doc__)
#Функция - это переменная и её можно присваивать
my_var = howdy_ho
my_var()
#Так же функцию можно передать в другую функцию и вызвать её внутри


#Урок 12 Модули
import random
for i in range(10):
    print(random.randint(1, 100))
from random import randint as rint
#from random import * - импорт всего, без обращения к объекту
#PyPi - репозиторий модулей для питона
#pip - программа для установки модулей


#Урок 13 Использование модулей PyPi
#import pyowm
#owm = pyown.OWM('api key')
#observation = owm.weather_at_place('London')
#w = observation.get_weather()
#temperature = w.get_temperature('celsius').['temp']
#print(w + temperature)


#Урок 14 Исключения
#Ошибки
#ImportError, IndexError, NameError, SyntaxError, TypeError, ValueError
try:
    print(7 / 0)
except ZeroDivisionError:
    pass
finally:
    print("End of cathing")
print('End programm')
#Выбрасываем свои исключения
try:
    pogoda = 'Winter'
    if pogoda == "bad":
        raise TypeError('Тест')
except TypeError:
    print('Badd')

assert pogoda != 'nice'
#Если сработало, выбрасывается исключение AssertionError

#Урок 15 Работа с файлами
file = open('test.txt', 'r')
print(file.read())
print(len(file.read()))
file.close()

filename = input('input name: ')
text = input("input text: ")
file = open(filename, 'a+')
file.write(text)

print(file.read(2)) #Последовательно зачитывает по байтно
print(file.read(3))

filename1 = input('first: ')
filename2 = input('where?')
file1 = open(filename1, 'r')
file2 = open(filename2, 'w')
file2.write(file1.read())
file1.close()
file2.close()

file = open('test.txt', 'r')
strings = file.readline()
for string in strings:
    print(string)
file.close()

with open('test.txt', 'r') as f:    #Открывает и сам закрывает файл
    print(f.read(5))


#Урок 16 Типы данных словарь
#Функции без return возвращают тип None
test = {
    'key1' : 'value1',
    'key2' : 'value2'
}
print(test['key2']) #Если нет ключа, получаем исключение
print(test.get('key2')) #Если нет ключа, получаем None


#Урок 17 Кортежи
#Неизменяемый список, который работает быстрее списков
names = 'jack', 'james', 'john'
print(names)


#Урок 18 Срез списка
digits = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
digits2 = digits[2:4]   #[:3], [3:]
#[::2] - шаг следования
print(digits[-2])   #Индексирование с конца
print(digits[::-1]) #Реверсированный список
print(digits2)


#Урок 19 Форматирование строк
name = 'Jack'
age = 21
print('Hello, %s!\n You %d age' % (name, age))
print('Hello, {}!\n You {} age'.format(name, age))
print('{0}{1}{0}'.format('abra', 'cad')) #индексирование переменных abra cad abra
print('Hello, {name}!\n You {age} age'.format(name = name, age = age))
input_str = 'Jessy'
print('Hello {0:*^13}!'.format(input_str))
print(('{0:*^' + str(age) + '}').format(input_str))


#Урок 20 Разные функции
fruits = ['Lemon', 'Apples', 'Kiwi', 'Pineapple', 'Strawberry']
members = 'James,Jonny,Jessie,Jack,John'
print(' - '.join(fruits)) #Объединение строки с разделителем
print('Hello, apple'.replace('apple', 'straw'))
print(members.lower())
print(members.upper())
#startwith('A') Проверка с чего начинается и заканчивается слово
#endwith('ing')
print(members.split(","))
#min max sum abs
