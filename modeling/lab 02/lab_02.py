from math import *

def machine_epsilon(func=float):
    '''
    Вспомогательная функция для вычисления машинного нуля
    '''
    machine_epsilon = func(1)
    while func(1)+func(machine_epsilon) != func(1):
        machine_epsilon_last = machine_epsilon
        machine_epsilon = func(machine_epsilon) / func(2)
    return machine_epsilon_last

ME = machine_epsilon()*10

def eval_func(t):
    '''
    Интегрируемая функция
    '''
    def inner_func_LR(theta, phi):
        return (2*cos(theta)) / (1-(sin(theta)**2)*(cos(phi)**2))
    def inner_func_main(t, LR_func, theta, phi):
        return (1-exp((-t)*LR_func(theta, phi))) * cos(theta)*sin(theta)
    return lambda theta, phi: inner_func_main(t, inner_func_LR, theta, phi)

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
    roots_res = []
    roots_init_approx = [
        cos(
            (pi*(4*i-1)) / (4*n+2)
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

'========================================================================='
'========================================================================='
'========================================================================='

def eval_At_sum(k):
    '''
    Вычисление суммы произведений Ai*ti
    '''
    return 2/(k+1) if k%2==0 else 0

def build_At_matrix_with_coef_sum(n, Lm_roots):
    '''
    Строим СЛАУ
    '''
    M = []
    for k in range(n):
        row = []
        for ti in Lm_roots:
            row.append(ti**k)
        row.append(eval_At_sum(k))
        M.append(row)
    return M

def eval_Ai_coefs(M):
    '''
    Решаем СЛАУ, находим коэффициенты Ai
    '''
    n = len(M)
    X = [0 for i in range(n)]
    for i in range(n):
        for j in range(i+1, n):
            ratio = M[j][i]/M[i][i]
            for k in range(n+1):
                M[j][k] = M[j][k] - ratio*M[i][k]
    X[n-1] = M[n-1][n]/M[n-1][n-1]
    for i in range(n-2, -1, -1):
        X[i] = M[i][n]
        for j in range(i+1, n):
            X[i] = X[i] - M[i][j]*X[j]
        X[i] = X[i]/M[i][i]
    return X

def eval_Gauss_integration(func, a, b, N_nodes):
    '''
    Проводим численное интегрирование по формуле Гаусса
    '''
    T = eval_Lm_roots(N_nodes)
    A = eval_Ai_coefs(build_At_matrix_with_coef_sum(N_nodes, T))
    sum_Aiti = sum([Ai*func((a+b)/2+((b-a)/2)*ti) for (Ai, ti) in zip(A, T)])
    res = ((b-a)/2)*sum_Aiti
    return res

def eval_Simpson_multiple_integration(func, a, b, N_nodes):
    '''
    Вычисляем кратный интеграл по формуле Симпсона
    '''
    res = 0
    h = (b - a) / N_nodes
    x = a
    half_int = h/2
    while x < b:
        next_x = x + h
        res += func(x) + 4 * func(x + half_int) + func(next_x)
        x = next_x
    return h / 6 * res

def composite_integrate(func, a, b, c, d, N, M):
    res_Gauss = lambda x: eval_Gauss_integration(lambda y: func(x, y), c, d, M)
    return eval_Simpson_multiple_integration(res_Gauss, a, b, N)

def integrate(t, N_Simpson, M_Gauss):
    ef = eval_func(t)
    return 4 / pi * composite_integrate(
        ef,
        0, pi/2,
        0, pi/2,
        N_Simpson, M_Gauss)

if __name__ == '__main__':
    print(integrate(0.808, 4, 5))
    print(integrate(2, 10, 11))
    t = 0.05
    N = 10
    M = 10
    for i in range(20):
        print("t=", t, integrate(t, N, M))
        t += 0.5
    print("t=", 10, integrate(10, N, M))