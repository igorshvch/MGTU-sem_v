using System;
using System.Linq;
using System.Activities;
using System.Activities.Statements;

namespace IntegrGaussSimpson
{
    class Program
    {
        static double tauFrom = 0.05, tauTo = 10.05;
        static double tau = 5;
        static void Main(string[] args)
        {
            int N = 4; int M = 4;
            double a = 0;
            double b = 1.0 / 2.0 * Math.PI; 
            double c = 0; 
            double d = 1.0 / 2.0 * Math.PI;
            debug("a=" + a);
            debug("b=" + b);
            debug("c=" + c);
            debug("d=" + d);
            Console.WriteLine("Исследовать влияние количества выбираемых узлов сетки по каждому направлению на точность расчетов.");
            Console.WriteLine("N \t M \t integral");
            for (int i = 1; i < 10; i++)
            {
                for (int j = 1; j < 10; j++)
                {
                    M = i;
                    N = j;
                    Console.WriteLine(N + "\t" + M + "\t" + SimpsonGauss(N,M,a,b,c,d));
                }
            }
            N = M = 20;
            Console.WriteLine("Построить график зависимости   в диапазоне изменения  tau=0.05-10");
            Console.WriteLine("N = " + N + ", M = " + M);
            Console.WriteLine("tau\t integral");
            for (tau = tauFrom; tau <tauTo; tau += 0.050)
            {
                Console.WriteLine(Math.Round(tau,2) + "\t" + SimpsonGauss(N,M,a,b,c,d));
            };
            Console.ReadKey();
        }
        private static double SimpsonGauss(int N, int M, double a, double b, double c, double d)
        {
            double di = 0;
            for (double i = 0; i < N / 2 - 1; i++)
            {
                di += GaussLegendre(f,c,d,M,2*i)+ 4 * GaussLegendre(f,c,d,M,2 * i + 1) + GaussLegendre(f, c, d, M, 2 * i + 2);
            }
            double hx = (b - a) / N;
            di = hx / 3 * di;
            return di;
        }

            static void debug(string s)
        {
            //Console.WriteLine(s);
        }
        static double f(double x, double y)
        {
            double lr = 2.0 * Math.Cos(y) / (1.0 - Math.Pow(Math.Sin(y), 2) * Math.Pow(Math.Cos(x), 2));
            debug("lr(" + x + "," + y + ")=" + lr);
            double res = (4.0 / Math.PI) * (1.0 - Math.Exp(-tau * lr)) * Math.Cos(y) * Math.Sin(y);
            debug("f(" + x + "," + y + ")=" + res);
            return res;
        }
        

        public static double Legendre(double x, int deg)
        {
            // полином Лежандра степени n в точке X
            double P0 = 1.0;
            double P1 = x;
            double P2 = (3.0 * x * x - 1) / 2.0;
            int n = 1;
            if (deg < 0)
                throw new Exception("Степень полинома должна быть положительной");
            if (deg == 0)
                return P0;
            else if (deg == 1)
                return P1;
            else
            {
                return ((2*deg-1)*x*Legendre(x,deg-1)-(n-1)*Legendre(x,deg-2))/deg;
            }
        }
        public static void LegendreNodesWeights(int n, out double[] x, out double[] w)
        {
            // веса полиномов Лежандра
            double c, d, p1, p2, p3, dp;

            x = new double[n];
            w = new double[n];

            for (int i = 0; i < (n + 1) / 2; i++)
            {
                c = Math.Cos(Math.PI * (4 * i + 3) / (4 * n + 2));
                do
                {
                    p2 = 0;
                    p3 = 1;
                    for (int j = 0; j < n; j++)
                    {
                        p1 = p2;
                        p2 = p3;
                        p3 = ((2 * j + 1) * c * p2 - j * p1) / (j + 1);
                    }
                    dp = n * (c * p3 - p2) / (c * c - 1);
                    d = c;
                    c -= p3 / dp;
                }
                while (Math.Abs(c - d) > 1e-12);
                x[i] = c;
                x[n - 1 - i] = -c;
                w[i] = 2 * (1 - x[i] * x[i]) / (n + 1) / (n + 1) / Legendre(x[i], n + 1) / Legendre(x[i], n + 1);
                w[n - 1 - i] = w[i];
            }
        }

        public static double GaussLegendre(Function f, double a, double b, int n, double xi)
        {
            // Формула Гаусса
            double[] x, w;
            LegendreNodesWeights(n, out x, out w);
            double hx = (b - a) / n;
            double sum = 0.0;
            for (int i = 0; i < n; i++)
            {
                sum += 0.5 * (b - a) * w[i] * f(a + xi * hx, 0.5 * (a + b) + 0.5 * (b - a) * x[i]);
            }
            return sum;
        }

        public delegate double Function(double x, double y);
    }
}



