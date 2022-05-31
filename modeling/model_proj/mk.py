import streamlit as st
import numpy as np
import matplotlib.pyplot as plt
import plotly.express as px

from matplotlib.patches import Polygon

np.random.seed(42)


def equation_0(x):
    """f(x) = sin(x)"""
    return np.sin(x)


def equation_1(x):
    """f(x) = 3 + 2x - 3x² + 2x³"""
    return 3 + 2 * x - 3 * x ** 2 + 2 * x ** 3


def equation_2(x):
    """f(x) = 1 / (3cos(x) + 2)"""
    return 1 / (3 * np.cos(x) + 2)


def equation_e(x):
    """f(x) = x * e^(-x)"""
    return x * np.e ** -x


def equation_3(x, y):
    """f(x, y) = 4 + 2y + 2x + xy + x³y"""
    return 4 + 2 * y + 2 * x + x * y + x ** 3 * y


def equation_3_2(xa, ya, a, b, c, d):
    x = (b - a) * xa + a
    y = (d - c) * ya + c
    return 4 + 2 * y + 2 * x + x * y + x ** 3 * y


def equation_4(x, y):
    """f(x, y) = y²/x²"""
    return y ** 2 / x ** 2


def equation_4_2(xa, ya, a, b, c, d):
    x = (b - a) * xa + a
    y = (d - c) * ya + c
    return y ** 2 / x ** 2


def equation_5(x, y):
    """f(x, y) = sqrt(x * x + y * y) + 3 * cos(sqrt(x * x + y * y)) + 5"""
    return np.sqrt(x * x + y * y) + 3 * np.cos(np.sqrt(x * x + y * y)) + 5


def equation_5_2(xa, ya, a, b, c, d):
    x = (b - a) * xa + a
    y = (d - c) * ya + c
    return np.sqrt(x * x + y * y) + 3 * np.cos(np.sqrt(x * x + y * y)) + 5


def estimate_ab(a, b, eps):
    if abs(a % np.pi) < eps:
        a = int(a / np.pi) * np.pi
    elif abs(a % np.e) < eps:
        a = int(a / np.e) * np.e
    if abs(b % np.pi) < eps:
        b = int(b / np.pi) * np.pi
    elif abs(b % np.e) < eps:
        b = int(b / np.e) * np.e
    return a, b


def generate_random(a, b, num_samples):
    return np.random.uniform(a, b, num_samples)


def calculate_average(list_random_nums, num_samples, func):
    sum_ = 0
    for i in range(0, num_samples):
        sum_ += func(list_random_nums[i])

    return sum_ / num_samples


def calculate(a, b, num_samples, func):
    list_random_uniform_nums = generate_random(a, b, num_samples)
    average = calculate_average(list_random_uniform_nums, num_samples, func)
    integral = (b - a) * average

    return integral


def calculate_integral(a, b, num_samples, num_iter, func):
    """Калькуляция однократного интеграла"""
    avg_sum = 0
    areas = []
    for i in range(0, num_iter):
        integral = calculate(a, b, num_samples, func)
        avg_sum += integral
        areas.append(integral)
    avg_integral = avg_sum / num_iter

    return areas, avg_integral


def plot_func(func, a, b, integral):
    st.write(f"Геометрическая интерпретация для $a={a}$, $b={b}$:")
    x = np.linspace(a, b)
    y = func(x)

    # график функции
    fig, ax = plt.subplots(figsize=(10, 6))
    ax.set_ylabel("f(x)")
    ax.set_xlabel("x")
    ax.grid(True)
    ax.axhline(y=0, color="k", linewidth=0.5)

    ax.plot(x, y, "r", linewidth=1)

    # заштрихованная область
    ix = np.linspace(a, b)
    iy = func(ix)
    verts = [(a, 0), *zip(ix, iy), (b, 0)]
    poly = Polygon(verts, facecolor="0.9", edgecolor="0.5")
    ax.add_patch(poly)
    ax.text(0.6 * (a + b), 0.3, r"$\int_a^b f(x)\mathrm{d}x = $" + f"{round(integral, 5)}",
            horizontalalignment="center", fontsize=20)

    st.pyplot(fig)

    st.write(f"Если взять случайную точку $x_i$ между $a={a}$ и $b={b}$. "
             r"Мы можем построить площадь прямоугольника, умножив $f(x_i)\cdot (b-a)$.")
    # графики для каждой точки
    x_rand = np.random.uniform(a, b, 9)
    fig, ax = plt.subplots(3, 3, figsize=(10, 6))
    for axs, x_i in zip(ax.reshape(-1), x_rand):
        axs.plot(x, y, 'r', linewidth=1)
        verts = [(a, 0), (a, func(x_i)), (b, func(x_i)), (b, 0)]
        poly = Polygon(verts, facecolor='0.9', edgecolor='0.5')
        axs.add_patch(poly)
        axs.plot(x_i, func(x_i), marker='o', color='b')
    st.pyplot(fig)  #


def plot_histogram(areas):
    fig = px.histogram(
        areas,
        opacity=0.85,
        marginal="box",
        title="Распределение рассчитанных интегралов(площадей)",
    )
    st.plotly_chart(fig, use_container_width=True)


def estimate_error(func_2, a, b, c, d, num_iter):
    fxy = 0
    for i in range(num_iter):
        x = np.random.rand()
        y = np.random.rand()
        fxy += func_2(x, y, a, b, c, d)
    return fxy


def calculate_integral_double(func_2, a, b, c, d, n):
    """Калькуляция двойного интеграла"""
    fxy = (estimate_error(func_2, a, b, c, d, n))

    res = ((b - a) * (d - c) / n) * fxy
    return res


def plot_func_3d(func):
    fig = plt.figure()
    ax = fig.add_subplot(111, projection='3d')
    x = y = np.arange(-3.0, 3.0, 0.05)
    X, Y = np.meshgrid(x, y)
    zs = np.array([func(x, y) for x, y in zip(np.ravel(X), np.ravel(Y))])
    Z = zs.reshape(X.shape)
    ax.plot_surface(X, Y, Z)
    ax.set_xlabel('X')
    ax.set_ylabel('Y')
    ax.set_zlabel('Z')
    st.write(fig)


def main():
    st.markdown("### НИРС")
    st.markdown("""**Тема:**
    Алгоритм и программная реализация метода Монте-Карло при вычислении однократных и двойных интегралов.""")
    st.markdown("""**Цель работы:** 
    Получение навыков программной реализации метода Монте-Карло при вычислении однократных и двойных интегралов.""")

    description = """
    Пусть интеграл (a, b, f (x)) представляет собой интеграл от a до b функции f (x) по x
    Пусть среднее (f (x), a, b) представляет собой среднее значение функции на отрезке a, b
    Используя вторую фундаментальную теорему исчисления среднее (f (x), a, b) = 1 (b-a) интеграл (a, b, f (x))
    преобразовывая функцию, указанную во второй фундаментальной теореме исчисления
    мы получаем (b-a) avg (f (x), a, b) = интеграл (a, b, f (x))
    
    Мы вычисляем среднее значение функции на интервале, используя несколько случайных выборок в данном интервале.
    Затем мы используем это вычисленное среднее значение, чтобы найти интеграл, используя приведенное выше уравнение.
    
    Функции:
    1. f(x) = 3 + 2x - 3x² + 2x³
    на отрезке [0, 1]

    2. f(x) = 1 / (3cos(x) + 2)

    3. f(x, y) = 4 + 2y + 2x + xy + x³y
    x -> от -1 до 1
    y -> от 0 до 3

    4. f(x, y) = y²/x²
    """

    show_schema = st.checkbox("Показать описание")
    if show_schema:
        st.code(description)

    calc_type = st.radio(
        "Выберите тип вычисления", (
            "1. Вычисление однократного интеграла",
            "2. Вычисление двойного интеграла",
        )
    )

    function = None
    function_2 = None

    if calc_type[:1] == "1":
        selected_fun = st.radio("Выберите функцию", (
            f"0. {equation_0.__doc__}",
            f"1. {equation_1.__doc__}",
            f"2. {equation_2.__doc__}",
            f"3. {equation_e.__doc__}",
        ))

        if selected_fun[:1] == "1":
            function = equation_1
        elif selected_fun[:1] == "2":
            function = equation_2
        elif selected_fun[:1] == "0":
            function = equation_0
        elif selected_fun[:1] == "3":
            function = equation_e

        st.markdown("---")
        c1, c2 = st.columns(2)
        c3, c4 = st.columns(2)

        a = c1.number_input("Введите нижний предел (a):", value=0.)
        b = c2.number_input("Введите верхний предел (b):", value=1.)
        eps = c3.number_input("Введите эпсилон (ε):", min_value=.00000000001, value=1.0 * (10 ** - 8), format="%.8f")
        num_samples = int(
            c4.number_input("Введите количество точек:", min_value=1, max_value=100000, value=1000, step=1))
        n = st.slider("Выберите количество итераций (n):", min_value=1, max_value=num_samples, value=100, step=1)

        st.markdown("---")

        a, b = estimate_ab(a, b, eps)

        all_areas, integral = calculate_integral(a, b, num_samples, n, function)

        st.write("Основная идея состоит в том, чтобы эмпирически оценить определенный интеграл функции.")
        st.write("Будем использовать функцию одной переменной:")
        st.latex(f"{function.__doc__}")

        st.markdown("---")
        st.markdown(f"Интеграл функции равен: **{integral}**")
        st.markdown("---")

        plot_func(function, a, b, integral)

        show_areas = st.checkbox("Показать все результаты вычислений")
        if show_areas:
            st.code(all_areas)

        plot_histogram(all_areas)

    elif calc_type[:1] == "2":
        selected_fun = st.radio("Выберите функцию", (
            f"1. {equation_3.__doc__}",
            f"2. {equation_4.__doc__}",
            f"3. {equation_5.__doc__}",
        ))

        if selected_fun[:1] == "1":
            function = equation_3
            function_2 = equation_3_2
        elif selected_fun[:1] == "2":
            function = equation_4
            function_2 = equation_4_2
        elif selected_fun[:1] == "3":
            function = equation_5
            function_2 = equation_5_2

        st.markdown("---")
        c1, c2 = st.columns(2)
        c3, c4 = st.columns(2)
        a1 = c1.number_input("Введите a1:", value=-1.)
        a2 = c3.number_input("Введите a2:", value=0.)
        b1 = c2.number_input("Введите b1:", value=1.)
        b2 = c4.number_input("Введите b2:", value=3.)
        n = st.slider("Выберите количество итераций (n):", min_value=1, max_value=100000, value=1000, step=1)

        st.write("Будем использовать функцию двух переменных:")
        st.latex(f"{function.__doc__}")

        integral_double = calculate_integral_double(function_2, a1, b1, a2, b2, n)

        st.markdown("---")
        st.markdown(f"Интеграл функции равен: **{integral_double}**")
        st.markdown("---")

        plot_func_3d(function)


if __name__ == "__main__":
    main()