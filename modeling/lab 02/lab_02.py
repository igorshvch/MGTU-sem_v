import math

def machine_epsilon(func=float):
    '''
    Вспомогательная функция для вычисления машинного нуля
    '''
    machine_epsilon = func(1)
    while func(1)+func(machine_epsilon) != func(1):
        machine_epsilon_last = machine_epsilon
        machine_epsilon = func(machine_epsilon) / func(2)
    return machine_epsilon_last

def eval_Lm(x, n):
    '''
    Вычисление полинома Лежандра n-ой степени
    '''
    res = None
    if n > 1:
        Lm0 = 1 #значение полинома 0-й степени
        Lm1 = x #значение полинома 1-й степени
        lim_n = 2
        while True:
            res = (
                ((2*lim_n-1)*x*Lm1 - (lim_n-1)*Lm0)
                /lim_n
            )
            Lm0 = Lm1
            Lm1 = res
            if lim_n == n:
                break
            lim_n += 1
        return res
    else:
        return 1 if pow == 0 else x

def eval_Lm_derivative(x, n):
    '''
    Вычисление производной полинома Лежандра
    '''
    L_first = eval_Lm(x, n-1)
    L_second = eval_Lm(x, n)
    return (n/(1-x**2))*(L_first - x*L_second)

def eval_Lm_roots(n):
    '''
    Вычисление заданного количества корней полинома Лежандра
    '''
    ME = machine_epsilon()*10
    roots_res = []
    roots_init_approx = [
        math.cos(
            (math.pi*(4*i-1)) / (4*n+2)
        )
        for i in range(1, n+1)
    ]
    for x in roots_init_approx:
        Lm = 1
        while Lm > ME:
            Lm = eval_Lm(x, n)
            Lm_deriv = eval_Lm_derivative(x, n)
            x = x - Lm/Lm_deriv
        roots_res.append(x)
    return roots_res

