import random

N, M = {9, 7}

def getTotalMines(PM, i, j):
    n = 0
    for k in range(-1, 2):
        for l in range(-1, 2):
            x = i + k
            y = j + l
            if x < 0 or x >= N or y < 0 or y >= N:
                continue
            if PM[x * N + y] < 0:
                n += 1
    return n

def createGame(PM):
    """Создание игрового поля: расположение мин
    и подсчет числа мин вокруг клеток без мин
    """
    rng = random.Random()

    n = M
    while n > 0:
        i = rng.randrange(N)
        j = rng.randrange(N)
        if PM[i * N + j] != 0:
            continue
        PM[i * N + j] = -1
        n -= 1

    for i in range(N):
        for j in range(N):
            if PM[i * N + j] == 0:
                PM[i * N + j] = getTotalMines(PM, i, j)

def show(map):
    """Функция отображения состояния текущего игрового поля
    """
    for i in range(N):
        for j in range(N):
            if map[i * N + j] == -2: sh = 'x'
            elif map[i * N + j] == -1: sh = '*'
            else: sh = map[i * N + j]
            print(str(sh).rjust(3), end="")
        print()

def goPlayer():
    """Функция для ввода пользователем координат
    закрытой клетки игрового поля
    """
    flLoopInput = True
    while flLoopInput:
        x, y = input("insert coord: ").split()
        if not x.isdigit() or not y.isdigit():
            print("Error")
            continue

        x = int(x) - 1
        y = int(y) - 1

        if x < 0 or x >= N or y < 0 or y >= N:
            print("Error")
            continue

        flLoopInput = False

    return (x, y)

def isFinish(PM, P):
    """Определение текущего состояния игры:
    """
    for i in range(N * N):
        if P[i] != -2 and PM[i] < 0: return -1
    for i in range(N * N):
        if P[i] == -2 and PM[i] >= 0: return 1

    return -2

def startGame():
    """Функция запуска игры: отображается игровое поле
    """
    P = [-2] * N * N
    PM = [0] * N * N

    createGame(PM)

    finishState = isFinish(PM, P)
    show(P)
    while finishState > 0:
        x, y = goPlayer()
        P[x * N + y] = PM[x * N + y]
        show(P)
        finishState = isFinish(PM, P)

    return finishState

res = startGame()
if res == -1: print("Lose")
else: print("Win!")
print("End of game")