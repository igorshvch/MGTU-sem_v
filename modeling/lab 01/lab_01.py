__version__ = "0.0.1"

arr_x = [0, 0.15, 0.3, 0.45, 0.6, 0.75, 0.9, 1.05]
arr_y = [1, 0.838771, 0.655336, 0.450447, 0.225336, -0.01831, -0.27839, -0.55243]

def sort_coord_table(arr_x, arr_y, print_info=True):
    table = [(x, y) for (x, y) in zip(arr_x, arr_y)]
    table = sorted(table, key=lambda pair: pair[0])

    arr_x_sorted = [pair[0] for pair in table]
    arr_y_sorted = [pair[1] for pair in table]

    #секция печати
    if print_info:
        print()
        print("Отсортированная таблица координат")
        print("X:", end=" ")
        [print("{:9.6f}".format(i), end=" ") for i in arr_x_sorted]
        print()
        print("Y:", end=" ")
        [print("{:9.6f}".format(i), end=" ") for i in arr_y_sorted]
        print()
    #

    return arr_x_sorted, arr_y_sorted

def binary_search(arr, x):
    '''
    Функция бинарного поиска по сортированному массиву
    '''
    lo = 0
    hi = len(arr)
    while lo < hi:
        mid = (lo+hi)//2
        if x < arr[mid]:
            hi = mid
        else:
            lo = mid+1
    return lo if lo>0 else 0

def get_nodes(arr_x, arr_y, start_pos, n, print_info=True):
    '''
    Функция поиска подходящих узлов
    '''
    half_range = (n+1)//2
    start_pos = start_pos - half_range
    end_pos = start_pos + n+1
    left_border = start_pos if start_pos > 0 else 0
    right_border = end_pos if end_pos < len(arr_x) else len(arr_x)

    if left_border!=right_border:
        arr_x_nodes = arr_x[left_border:right_border]
        arr_y_nodes = arr_y[left_border:right_border]
    else:
        arr_x_nodes = [arr_x[left_border]]
        arr_y_nodes = [arr_y[left_border]]

    
    #Секция печати
    if print_info:
        print()
        print("Индекс ближайшего узла в массиве:", start_pos)
        print("Индексы границ:",[left_border, right_border])
        print()
        print("Узловые значения, используемые для вычисления:")
        print("X:", end=" ")
        [print("{:9.6f}".format(i), end=" ") for i in arr_x_nodes]
        print()
        print("Y:", end=" ")
        [print("{:9.6f}".format(i), end=" ") for i in arr_y_nodes]
        print()
        print()
    #

    return arr_x_nodes, arr_y_nodes

def calc_dd_coefs(arr_x, arr_y, print_info=True):
    '''
    Функция вычисления значения разделенных разностей
    '''
    n = len(arr_y)
    coefs_table = [[0 for i in range(n)] for i in range(n)]
    # the first column is y
    for i in range(n):
        coefs_table[i][0] = arr_y[i]
    
    for j in range(1,n):
        for i in range(n-j):
            coefs_table[i][j] = \
                (coefs_table[i+1][j-1] - coefs_table[i][j-1]) / (arr_x[i+j]-arr_x[i])
    
    #Секция печати
    if print_info:
        print("Таблица коэффициентов (разделенные разности)")
        for i in range(len(coefs_table)):
            for j in range(len(coefs_table[0])):
                print("{:9.6f}".format(coefs_table[i][j]), end=" ")
            print()
        print()
    #

    return [coefs_table[0][i] for i in range(len(coefs_table))]

def calc_newton_polynomial(coefs_vector, arr_x, x_dot):
    '''
    Функиця вычисления значения полинома для заданной точки на оси Х
    '''
    n = len(arr_x)-1
    p = coefs_vector[n]

    for k in range(1,n+1):
        p = coefs_vector[n-k] + (x_dot - arr_x[n-k])*p

    return p

def main(x_dot, n):
    
    #Секция печати
    print()
    print("Таблица значений функции")
    print("X:", end=" ")
    [print("{:9.6f}".format(i), end=" ") for i in arr_x]
    print()
    print("Y:", end=" ")
    [print("{:9.6f}".format(i), end=" ") for i in arr_y]
    print()
    #
    
    #Вычисление полинома заданной функции
    arr_x_sorted, arr_y_sorted = sort_coord_table(arr_x, arr_y)
    start_pos = binary_search(arr_x_sorted, x_dot)
    arr_x_new, arr_y_new = get_nodes(arr_x_sorted, arr_y_sorted, start_pos, n)
    coefs_vector = calc_dd_coefs(arr_x_new, arr_y_new)
    y_dot = calc_newton_polynomial(coefs_vector, arr_x_new, x_dot)

    print("========================")
    print("Вычисление корня функции")
    print("========================")

    #Вычисление значения корня функции
    arr_x_sorted, arr_y_sorted = sort_coord_table(arr_y, arr_x)
    start_pos = binary_search(arr_x_sorted, 0)
    arr_x_new, arr_y_new = get_nodes(arr_x_sorted, arr_y_sorted, start_pos, n)
    coefs_vector = calc_dd_coefs(arr_x_new, arr_y_new)
    func_root = calc_newton_polynomial(coefs_vector, arr_x_new, 0)

    return y_dot, func_root

if __name__ == "__main__":
    print()
    while True:
        x_dot = float(input("Введите точку на оси X в интервале [0, 1.05]:/n>>> "))
        if x_dot > arr_x[-1] or x_dot < arr_x[0]:
            print("Введенное значение находится за пределами заданного интервала")
            stop = input("Продолжить [y/n]?/n>>> ")
            if stop == "n":
                break
            else:
                continue
        n = int(input("Введите степень полинома в интервале [0, 4]:/n>>> "))
        if n > 4 or n < 0:
            print("Введенное значение находится за пределами заданного интервала")
            stop = input("Продолжить [y/n]?/n>>> ")
            if stop == "n":
                break
            else:
                continue
        print()
        print("========================================================================")
        y_dot_poly, func_root = main(x_dot, n)
        print("========================================================================")
        print("Значение полинома {}й степени в точке {} на оси Х:".format(n, x_dot), y_dot_poly)
        print("Значение корня функции, полученное путем обратной интерполяции:", func_root)
        print("========================================================================")
        print()
