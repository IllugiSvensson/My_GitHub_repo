# Урок 2
# Переменная - это ссылка на объект со значением и типом
z = x = y = 0
print(id(z), id(x), id(y))
x, y, z = 1, 2, 3
print(id(x), id(y), id(z))
print(type(y))

# Урок 3
print(1, 2, 3, sep="-", end="__end__\n")
print("Name %s, age %d" % ("Name", 17))

# Урок 4
a = 2; b = -5.8; c = 2.3
print((a + b) * c)

#Урок 5
age = 18
accessAllowed = True if age >= 18 else False #Либо

accessAllowed = age >= 18
print(accessAllowed)

#Урок 6
S = 0; i = -10
while i < 100:
    if i == 0: break
    S += 1 / i
    i += 1
else:       #Не выполняется, если сработал брейк
    print('End')

#Урок 7
print("abs" in "absasdasd")
print("abs" == "ABS")
print(ord("B"))
#ДЗ
cnt = 0
ab = ''
for i in "abrakadabra":
    if i == "a":
        cnt += 1
    ab += i
    if "ab" in ab:
        ab = ab[:len(ab) - 2]
print(cnt)
print(ab)
a = input("Insert string: ")
if a == a[::-1]: print("is polyndrome")
else: print("not polyndrome")
s = "abrakadabra"
cnt = 0
for i in range(len(s)):
    if s[i:i + 2] == "ra":
        cnt += 1
print(cnt)
text = input("text: ")
print(text)

#Урок 8
msg = s
msg.count("ra", 4, 11)
msg.find("br", 2)
msg.rfind("ab")
msg.replace("a", "o", 2)
msg.isalpha()
msg.isdigit()
msg.rjust(5, "-") #ljust
msg.split(" ") #join
msg.strip() #lstrip, rstrip
#ДЗ
number = "89811230505"
if len(number) == 11 and number.isdigit():
    print("Correct")
msg = "2+3+6.7 + 82 + 5.7 +1"
print(msg.replace("+", "-").replace(" ", ""))
for i in 0, -100, 5.6, -3:
    print(str(i).rjust(6))

#Урок 9
lst = [ "Msk", "Spb", "Tvr", 'Kzn', "Ekb"]
for city in lst:
    print(city)
A = [0] * 100 #список из ста нулей
t = [ "str", 5, 5.7, True, [ 1, 2, 3]]
t = t + [ 4, 5 ]
#ДЗ
t = [-1, 0, 5, 3, 2]
t = sorted(t, reverse=True)
b = []
for i in range(len(t)):
    t[i] = t[i] * 7.2
    b = b + [t[i]] * 2
print(t)
print(b)
m1 = [[1, 2], [3, 4], [5, 6]]
m2 = [[1, 0], [0, 1], [1, 1]]
A = []
for i in range(len(m1)):
    for j in range(len(m1[0])):
        m1[i][j] = m1[i][j] + m2[i][j]
print(m1)

#Урок 10
del m1[2][1]
print(m1)
for i in range(len(t)):
    A.append(t[i] ** 2)
print(A)
A = [ '+7456', '+7456', '6123', '4323', '+72314']
B = []
for i in A:
    if '+7' not in i:
        B.append(i)
A = B
print(A)
LIST = [1, 2, 3, 4, 5, 6]
shift = 1
for i in range(1, shift + 1):
    LIST.append(LIST.pop(0))
print(LIST)
for i in range(1, shift + 2):
    LIST.insert(0, LIST.pop(len(LIST) - 1))
print(LIST)

#Урок 11
#list comprehension
A = [x ** 2 for x in range(10) if x%2 == 0]
print(A)

#Урок 12
A = [ 1 , 3 , 5, 6 ,4, 2, 6, 8, 5 , 2, 8, 4, 2, 1, 0]
B = {}
for i in A:
    if i % 2 == 0:
        B[i] = i ** 2
print(B)
A = "int=целое число, dict=словарь, list=список, bool=булевый тип"
A = A.split(", ")
B = {}
for i in A:
    x = i.split("=")
    B[x[0]] = x[1]
print(B)

#Урок 13
p = ('+7114', '+7432', '+7413', '+54983', '+39482', '+7591874')
for i in range(len(p)):
    if p[i][:2] == '+7':
        print(p[i])
count = 'Count: 5, 4, 3, 4, 2, 4, 5, 4'
t = ()
for i in count:
    if i.isdigit(): t += tuple(i)
print(t)
t = ((1, 2, 3), (3, 4, 5), (6, 7, 8))
for el in t:
    for n in el:
        if el.index(n) < len(el)-1:
            print(n, end = '-' )
        else:
            print(n)

#Урок 14
TYPE_FUNC = True
if TYPE_FUNC:
    def sayHello():
        print("Hello")
else:
    def sayHello():
        print("not Hello")
def getSqrt(a = 1, b = 1):
    return 0.5 * a * b
print(getSqrt())
def RecCalc(a = 1, b = 1, TYPE = True):
    if TYPE == True: return a * b
    else: return 0.5 * a * b
print(RecCalc(1, 2, False))
print(RecCalc(2, 3, True))
t = [1, 2, 3, 4, 5, 6]
def getMax(lst):
    return max(lst)
print(getMax(t))
def multList(lst):
    m = 1
    for i in lst:
        m *= i
    return m
print(multList(t))

#Урок 15
#игра в сапера в другом файле

#Урок 16
x, y = (1, 2)
#Упаковка данных
x , *y = (1, 2, 3 ,4)
a = [-5, 6]
#Распаковка
for x in range(*a):
    print(x)
def myFunc(*args): #аргументы - список
    print(args)
def myFunc(**args): #аргументы - словарь. Именованные аргументы
    print(args)
def myFunc(*lst, **args):
    print(lst)
    print(args)
r = lambda a, b: a + b
r(1, 2)
def rec(n):
    if n == 1: return 1
    return n * rec(n - 1)
print(rec(5))
def amo(*lst):
    return sum(lst)
print(amo(1, 2, 3, 4, 5))
lst = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
def srtlambd(lst, func):
    newlst = []
    for i in lst:
        if func(i):
            newlst += str(i)
    return sorted(newlst)
print(srtlambd(lst, lambda n: True if n % 3 == 0 else False))

#Урок 17
import time
def getNOD(a, b):
    while a != b:
        if a > b:
            a -= b
        else:
            b -= a
    return a
def testNOD():
    a = 2; b = 10000000
    st = time.time()
    res = getNOD(a, b)
    et = time.time()
    dt = et - st
    if res == 2 and dt < 1:
        print('ok')
    else:
        print('not ok')
testNOD()
def fastEvc(a, b):
    if a < b:
        a, b = b, a
    if b > 0:
        a = fastEvc(b, a % b)
    return a
print(fastEvc(24, 15))
def MinMax(lst, func):
    return func(lst)
print(MinMax(lst, lambda lst: min(lst)))

#Урок 18
a = 10
def myFunc(b):
    global a
    a = 11

#Урок 19
setA = {1 ,2 ,3 ,4}
setB = {2, 4, 6, 8}
setC = setA & setB #setC = setA.intersection(setB)
#setA.intersection_update(setB)
setA |= setB #setA.union(setB)
#setA - setB
#setA ^ setB
#Множества можно сравнивать
print(setC)
text = input("text: ")
text = text.split(sep=' ')
print(set(text))

#Урок 20
a = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
it = iter(a)
print(next(it))
def f():
    for x in range(10):
        yield x #Замораживает последнее значение

#Урок 21
def sq(x):
    return x ** 2 #Работает только с одним аргументом, но возвращать может несколько
b = list(map(sq, a))
def odd(x):
    return x%2
b = list(filter(odd, a))
print(list(zip(a, b)))
d = {'h': 'х', 'e': 'е', 'l': 'л', 'o': 'о', 'w': 'в', 'r': 'р', 'd': 'д', ' ': ' ', '!': '!'}
s = ''
for i in 'hello world!':
    s += d[i]
print(s)
t = '''Куда ты скачешь гордый конь,
и где опустишь ты копыта?
о мощный властелин судьбы!
не так ли ты над самой бездной,
на высоте, уздой железной
Россию поднял на дыбы?'''
it = iter(t.split(' '))
cnt = 1
s = []
def f(x):
    return x
for i in list(map(f, it)):
    if cnt % 2 == 0: s.append(i)
    cnt += 1
print(s)
s = []
N = int(input("number: "))
for i in range(1, round(N / 2)):
    if N % i == 0: s.append(i)
print(s)

#Урок 22
def funcSort(x):
    if x%2 == 0:
        return x
    else: return x + 100
print(sorted(a, key=lambda x: x%2))
a = [1, 2, -5, 0, 5, 10]
print(sorted(a))
print(a)
digs = (-10, 0, 7, -2, 3, 6, -8)
print(sorted(digs))
d = {'+7': 23123123, '+4': 123511313, '+5': 12351512313, '+12': 126541212}
for i in sorted(list(d.keys()), key=lambda x: int(x[1::])):
    print(d[i])

#Урок 23
try:
    x = 1 / 2
except ValueError as v:
    res = v
else:
    print("all clear!")
finally:
    print("finally")
lst = input("insert numbers: ")
try:
    c = list(map(lambda x: int(x), lst.split(', ')))
except ValueError:
    print("error convertation")
finally:
    print(type(c))
def am(lst):
    try:
        print(sum(lst) / len(lst))
    except ValueError:
        print("error")
am(c)

#Урок 24
try:
    file = open("myfile.txt", encoding="utf-8")
    print(file.read(2))
    file.seek(0)
    print(file.read(2))
    pos = file.tell()
    print(pos)
except FileNotFoundError:
    print("no file")
    file.close()
#with open("myfile.txt", "r") as file:
# s = file.readlines()   - Закрывает файл сам, даже после ошибок
import pickle
#books = [ ("asd"), ("aqwe")]
#with open("myfile.txt", "rb") as file:
    #pickle.dump(books, file)
    #print(pickle.load(file))
p = ""
with open("file", 'r') as file:
    for i in range(100):
        p += file.read(1)
        file.read(1)
with open('myfile.txt', 'w') as file:
    file.write(p)
q = input("insert text: ")
q = q.replace(" ", "\n")
with open("myfile.txt", "w") as file:
    file.write(q)
d = { "house": "дом", "car": "машина", "tree": "дерево", "road": "дорога", "river": "река"}
with open("binary", "wb") as file:
    pickle.dump(list(d.items()), file)
with open("binary", "rb") as file:
    try:
        while i != 'EOFError':
            print(pickle.load(file))
    except EOFError:
        print("end of file")

#Урок 25
name = "zxc"
age = 17
msg = "asd {fio} asd {old}".format(fio=name, old=age)
print(msg)
msg = f"asd {name.upper()} asd {age * 2}"
print(msg)
s = input("insert fio: ").split()
print(f"""Ваши персональные данные:
Фамилия: {s[0]}
Имя: {s[1]}
Отчество: {s[2]}""")
with open("people", "r") as file:
    for line in file:
        s = line.split(", ")
        if int(s[2]) < 30:
            print(f"Уважаемый(ая) {s[0]}! Приглашаем вас изучить питон: {s[1]}")

#Урок 26
import math
from importlib import reload
reload(math)
import func as fnc
print(fnc.sqrt(5, 4))
print(fnc.area(5, 4))
while True:
    c = int(input("insert command: "))
    if c == 1:
        print(fnc.translate(input("word: ")))
    elif c == 2:
        fnc.addword(input("word: "))
        fnc.showwords()
    elif c == 3:
        fnc.delword(input("word: "))
        fnc.showwords()
    else:
        break

#Урок 27
#Пакет - каталог с модулями
#__init__.py - Конфиг пакета
#exp.py - файлы из пакета
#func.py
#from . import func - точка указывает на текущий пакет

#Урок 28
#Декоратор принимает другую функцию и расширяет её
import time
def testTime(fn):
    def wrapper(*args):
        st = time.time()
        fn(*args)
        dt = time.time() - st
        print(f"Time: {dt} sec")
    return wrapper
test1 = testTime(getNOD)
test1(10000, 2)
#@testTime - Принудительный вызов декоратора
N = 1000000
@testTime
def listappend(N):
    lst = []
    for i in range(0, N, 2):
        lst.append(i)
    return lst
@testTime
def listcomprehension(N):
    return [x for x in range(0, N, 2)]
listappend(N)
listcomprehension(N)

#Урок 30
#enumerate() упрощает работу с итерируемыми элементами
a = [1, 4, 2, -5, 0, 11]
for i, e in enumerate(a):
     a[i] += 1
print(a)
A = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
for i, e in enumerate(A):
    A[i][i] = 0
print(A)
def enumerate1(d):
    if str(type(d)) == "<class 'dict'>":
        ind = 0
        for val in d.items():
            res = (ind,) + val
            ind += 1
            yield res
    else:
        for i in enumerate(d):
            yield i
for a in enumerate1(d):
     print(a)
for a in enumerate1(A):
    print(a)