#https://www.cyberforum.ru/python-science/thread2889560.html

# Author: Alm99-collab
# Date: 25/10/2021 2:00
# Description: MSUT STANKIN Μyagkov Alexandr IDM - 21 - 03
 
 
"""
Программа для численного решения волнового уравнения в одномерном случае,
при разлинчых начальных и граничных условий, с помощью явной разностной
схемы типа "крест".
 
Общий вид волнового уравнения:
u_tt = a**2*u_xx + f(x,t) (0,L) где u=0 на диапазоне x=0,L, for t in (0,T].
Начальные условия в общем случае: u=I(x), u_t=V(x).
В случае неоднородного уравнения задается функция f(x,t).
 
Синтакис основной функции решателя:
u, x, t = solver(I, V, f, a, L, dt, C, T, user_func) где:
I = I(x) - функция.
V = V(x) - функция.
f = f(x,t) - функция.
U_0, U_L, - условия на границе.
C - число Куранта (=a*dt/dx), зависящее от шага dx. Является криетрием
стабильности численных расчето, если соблюдено условие (<=1)
dt - шаг по времени.
dx - шаг по координате.
T - конечное время симуляции волнового процесса.
user_func - функция (u, x, t, n) для вызова пользовательских сценариев,
таких как анимация или вывод графика, запси данных в текстовый файл,
расчет ошибки (в случае если известно точное решение) и.т.д.
"""
 
import numpy as np
import math
import matplotlib.pyplot as plt
import os
import time
import glob
 
 
# функция решатель для данного дифференциального уравнения
def solver(I, V, f, a, U_0, U_L, L, dt, C, T,
           user_func = None):
    """
    Функция решения волнового уравнения u_tt = a**2*u_xx + f(x,t) (0,L),
    где u=0 на диапазоне x=0,L, for t in (0,T].
    Начальные условия в общем случае: u=I(x), u_t=V(x).
    В случае неоднородного уравнения задается функция f(x,t).
    ------------------------------------------------------------------------
    :param I:
    :param V:
    :param f:
    :param a:
    :param L:
    :param C:
    :param T:
    :param U_0:
    :param U_L:
    :param dt:
    :param user_func:
    :return:
    """
 
    nt = int(round(T / dt))
    t = np.linspace(0, nt * dt, nt + 1)  # Узлы сетки по времени
    dx = dt * a / float(C)
    nx = int(round(L / dx))
    x = np.linspace(0, L, nx + 1)  # Узлы сетки по координате
    C2 = C ** 2
    dt2 = dt * dt
 
    # Проверка того, что  массивы являются элементами t,x
    dx = x[1] - x[0]
    dt = t[1] - t[0]
 
    # Выбор и инициализация дополнительных параметров f, I, V, U_0, U_L если равны нулю
    # или не передаются
    if f is None or f == 0:
        f = lambda x, t: 0
    if I is None or I == 0:
        I = lambda x: 0
    if V is None or V == 0:
        V = lambda x: 0
    if U_0 is not None:
        if isinstance(U_0, (float, int)) and U_0 == 0:
            U_0 = lambda t: 0
        # иначе: U_0(t) является функцией
    if U_L is not None:
        if isinstance(U_L, (float, int)) and U_L == 0:
            U_L = lambda t: 0
        # иначе: U_L(t) является функцией
 
    # ---  Выделяем память под значения решений  ---
    u = np.zeros(nx + 1)  # Массив решений в узлах сетки на  временном шаге u(i,n+1)
    u_n = np.zeros(nx + 1)  # Массив решений в узлах сетки на  временном шаге u(i,n)
    u_nm1 = np.zeros(nx + 1)  # Массив решений в узлах сетки на  временном шаге u(i,n-1)
 
    # --- Проверка индексов для соблюдения размерностей массивов ---
    Ix = range(0, nx + 1)
    It = range(0, nt + 1)
 
    # --- Запись начальных условий ---
    for i in Ix:
        u_n[i] = I(x[i])
 
    if user_func is not None:
        user_func(u_n, x, t, 0)
 
    # --- Разностная формулма явной схемы "типа крест" на первом шаге ---
    for i in Ix[1:-1]:
        u[i] = u_n[i] + dt * V(x[i]) + 0.5 * C2 * (u_n[i - 1] - 2 * u_n[i] + u_n[i + 1]) + 0.5 * dt2 * f(x[i], t[0])
 
    i = Ix[0]
    if U_0 is None:
        # Запись граничных условий (x=0: i-1 -> i+1  u[i-1]=u[i+1]
        # где du/dn = 0, on x=L: i+1 -> i-1  u[i+1]=u[i-1])
        ip1 = i + 1
        im1 = ip1  # i-1 -> i+1
        u[i] = u_n[i] + dt * V(x[i]) + 0.5 * C2 * (u_n[im1] - 2 * u_n[i] + u_n[ip1]) + 0.5 * dt2 * f(x[i], t[0])
 
    else:
        u[0] = U_0(dt)
 
    i = Ix[-1]
    if U_L is None:
        im1 = i - 1
        ip1 = im1  # i+1 -> i-1
        u[i] = u_n[i] + dt * V(x[i]) + 0.5 * C2 * (u_n[im1] - 2 * u_n[i] + u_n[ip1]) + 0.5 * dt2 * f(x[i], t[0])
    else:
        u[i] = U_L(dt)
 
    if user_func is not None:
        user_func(u_n, x, t, 1)
 
    # Обновление данных и подготовка к новому шагу
    u_nm1, u_n, u = u_n, u, u_nm1
 
    # --- Симуляция (цикл прохода по времени) ---
    for n in It[1:-1]:
        # Обновление значений во внутренних узлах сетки
        for i in Ix[1:-1]:
            u[i] = - u_nm1[i] + 2 * u_n[i] + C2 * (u_n[i - 1] - 2 * u_n[i] + u_n[i + 1]) + dt2 * f(x[i], t[n])
 
        #  --- Запись граничных условий ---
        i = Ix[0]
        if U_0 is None:
            # Установка значений граничных условий
            # x=0: i-1 -> i+1  u[i-1]=u[i+1] где du/dn=0
            # x=L: i+1 -> i-1  u[i+1]=u[i-1] где du/dn=0
            ip1 = i + 1
            im1 = ip1
            u[i] = - u_nm1[i] + 2 * u_n[i] + C2 * (u_n[im1] - 2 * u_n[i] + u_n[ip1]) + dt2 * f(x[i], t[n])
        else:
            u[0] = U_0(t[n + 1])
 
        i = Ix[-1]
        if U_L is None:
            im1 = i - 1
            ip1 = im1
            u[i] = - u_nm1[i] + 2 * u_n[i] + C2 * (u_n[im1] - 2 * u_n[i] + u_n[ip1]) + dt2 * f(x[i], t[n])
        else:
            u[i] = U_L(t[n + 1])
 
        if user_func is not None:
            if user_func(u, x, t, n + 1):
                break
 
        # Обновление данных и подготовка к новому шагу
        u_nm1, u_n, u = u_n, u, u_nm1
 
    # Присвоение значений требуемому узлу после прохода по сетке
    u = u_n
 
    return u, x, t
 
 
# функция симуляции и анимации, сохранения данных в файл
def simulate(I, V, f, a, U_0, U_L, L, dt, C, T, umin, umax, animate = True):
 
    """
    Запуск решателя и анимации,сохранения данных в файл
    ----------------------------------------------------------------------------
    :param I:
    :param V:
    :param f:
    :param a:
    :param L:
    :param dt:
    :param C:
    :param T:
    :param umin:
    :param umax:
    :param U_0:
    :param U_L:
    :param animate:
    :param mode:      # выбор режима работы (анимация и визуализация или запись данных в файл)
    :return:
    """
 
    if callable(U_0):
        bc_left = 'u(0,t)=U_0(t)'
    elif U_0 is None:
        bc_left = 'du(0,t)/dx=0'
    else:
        bc_left = 'u(0,t)=0'
    if callable(U_L):
        bc_right = 'u(L,t)=U_L(t)'
    elif U_L is None:
        bc_right = 'du(L,t)/dx=0'
    else:
        bc_right = 'u(L,t)=0'
 
    class PlotMatplotlib:
        def __call__(self, u, x, t, n):
 
            """ user_func для визуализации """
 
            if n == 0:
                plt.ion()
                self.lines = plt.plot(x, u, 'r-')
                plt.xlabel('x')
                plt.ylabel('u')
                plt.axis([0, L, umin, umax])
                plt.legend(['t=%f' % t[n]], loc = 'lower left')
            else:
                self.lines[0].set_ydata(u)
                plt.legend(['t=%f' % t[n]], loc = 'lower left')
                plt.draw()
                plt.grid()
            time.sleep(1) if t[n] == 0 else time.sleep(0.5)
            plt.savefig('tmp_%04d.png' % n)  # для создания анимации из кадров
 
    plot_u = PlotMatplotlib()
 
    # Очистка фреймов для создания анимированного изображения
    for filename in glob.glob('frame_*.png'):
        os.remove(filename)
 
    fps = 4  # frames per second
    codec2ext = dict(flv = 'flv', libx264 = 'mp4', libvpx = 'webm',
                     libtheora = 'ogg')  # video formats
    filespec = 'tmp_%04d.png'
    movie_program = 'ffmpeg'  # or 'avconv'
    for codec in codec2ext:
        ext = codec2ext[codec]
        cmd = '%(movie_program)s -r %(fps)d -i %(filespec)s ' \
              '-vcodec %(codec)s movie.%(ext)s' % vars()
        os.system(cmd)
 
    user_func = plot_u if animate else None
    u, x, t = solver(I, V, f, a, U_0, U_L, L, dt, C, T, user_func)
 
    return u, x, t
 
 
# функция постановки задачи
def problem():
    I = lambda x: 0.2 * (1 - x) * math.sin(math.pi * x)
    V = lambda x: 0
    f = lambda x, t: 0
    U_0 = lambda t: 0
    U_L = 0
    L = 1
    a = 1
    C = 0.75
    nx = 12
    dt = C * (L / nx) / a
    T = 1
    umin = -0.25
    umax = 0.25
 
    u, x, t = simulate(I, V, f, a, U_0, U_L, L, dt, C, T, umin, umax, animate=True)
 
    return u, x, t
 
 
if __name__ == '__main__':
    u, x, t = problem()
    print(u,x,t)