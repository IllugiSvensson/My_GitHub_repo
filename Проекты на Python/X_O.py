import random


def show(map):
    """Функция отображения состояния текущего игрового поля
    """
    for i in range(1, 10):
        if map[i] == 0: sh = '*'
        elif map[i] == 1: sh = 'x'
        elif map[i] == 2: sh = 'o'
        print(str(sh).rjust(3), end="")
        if i % 3 == 0: print()
    print()

def goPlayer(map):
    """Функция для ввода пользователем координат
    свободной клетки игрового поля
    """
    flLoopInput = True
    while flLoopInput:
        x = input("insert number: ")
        if not x.isdigit():
            print("Error")
            continue
        x = int(x)
        if x < 1 or x > 9:
            print("Error")
            continue
        if map[x] != 0:
            print("not vacant")
            continue
        flLoopInput = False

    return x

def goOpp(map):
    """Функция хода оппонента"""
    while True:
        rnd = random.randint(1, 9)
        if map[rnd] == 0:
            y = rnd
            break
    return y

def isFinish(map, n):
    """Определение текущего состояния игры:
    """
    if map[1] == n and map[2] == n and map[3] == n: return n
    elif map[4] == n and map[5] == n and map[6] == n: return n
    elif map[7] == n and map[8] == n and map[9] == n: return n
    elif map[1] == n and map[4] == n and map[7] == n: return n
    elif map[2] == n and map[5] == n and map[8] == n: return n
    elif map[3] == n and map[6] == n and map[9] == n: return n
    elif map[1] == n and map[5] == n and map[9] == n: return n
    elif map[3] == n and map[5] == n and map[7] == n: return n
    else: return 0

def startGame():
    """Функция запуска игры: отображается игровое поле
    """
    map = {}
    for i in range(1, 10):
        map[i] = 0
    show(map)

    while True:
        map[goPlayer(map)] = 1
        if isFinish(map, 1) == 1:
            show(map)
            return 1

        map[goOpp(map)] = 2
        show(map)
        if isFinish(map, 2) == 2: return 2

res = startGame()
if res == 2: print("Lose")
else: print("Win!")
print("End of game")
