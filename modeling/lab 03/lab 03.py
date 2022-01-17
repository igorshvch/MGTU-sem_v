from math import *

X = [1, 2, 3, 4, 5, 6]
Y = [0.571, 0.889, 1.091, 1.231, 1.333, 1.412]

def first_order_dif_formulas(list_y, node, step):
    '''
    Вычисляем производную с помощью формул односторонних разностей
    первого порядка точности
    '''
    if node < len(list_y) / 2:
        return (list_y[node+1]-list_y[node])/step
    else:
        return (list_y[node]-list_y[node-1])/step

def second_order_dif_formulas(list_y, node, step):
    '''
    Вычисляем производную с помощью центральной разностной
    формулы второго порядка точности, в первом и поселднем узлах
    используем специальные формулы для вычисляения
    '''
    if node == 0:
        return ((-3)*list_y[node]+4*list_y[node+1]-list_y[node+2])/(step*2)
    elif node == len(list_y)-1:
        return (3*list_y[node]-4*list_y[node-1]+list_y[node-2])/(step*2)
    else:
        return (list_y[node+1]-list_y[node-1])/(step*2)

def Runge_second_order_formulas(list_y, node, step):
    '''
    Вычисляем производную по формулам, полученным из второй
    формулы Рунге путем подстановки в нее односторонних разностныых
    формул
    '''
    if node < len(list_y) / 2:
        return ((-3)*list_y[node]+4*list_y[node+1]-list_y[node+2])/(step*2)
    else:
        return (3*list_y[node]-4*list_y[node-1]+list_y[node-2])/(step*2)

def extra_vars(list_y, list_x, node):
    '''
    Вычисляем производную с помощью выравнивающих переменных
    '''
    if node < len(list_y) / 2:
        return (
            (list_y[node]/list_x[node])
            *(list_x[node+1]/list_y[node+1])
            *((list_y[node]-list_y[node+1])/(list_x[node]-list_x[node+1]))
        )
    else:
        return (
            (list_x[node]/list_y[node])
            *(list_y[node-1]/list_x[node-1])
            *((list_y[node-1]-list_y[node])/(list_x[node-1]-list_x[node]))
        )

def second_order_second_dif_formulas(list_y, node, step):
    '''
    Вычисляем вторую производную по формулам второго
    порядка точности
    '''
    if node == 0:
        return (list_y[node+2]-2*list_y[node+1]+list_y[node])/pow(step,2)
    elif node == len(list_y)-1:
        return (list_y[node]-2*list_y[node-1]+list_y[node-2])/pow(step,2)
    else:
        return (list_y[node+1]-2*list_y[node]+list_y[node-1])/pow(step,2)

if __name__ == '__main__':
    step=1
    for i in range(len(Y)):
        a = first_order_dif_formulas(Y, i, step)
        b = second_order_dif_formulas(Y, i, step)
        c = Runge_second_order_formulas(Y, i, step)
        d = extra_vars(Y, X, i)
        e = second_order_second_dif_formulas(Y, i, step)
        print("x={:1d} y={:1.3f} | {:1.3f}, {:1.3f}, {:1.3f}, {:1.3f}, {:1.3f}".format(X[i], Y[i], a, b, c, d, e))