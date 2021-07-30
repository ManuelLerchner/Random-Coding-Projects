using System;

namespace Neural_Network
{
    interface ActivationFunction
    {
        double func(double x);
        double funcPrime(double x);
    }


    public class Relu : ActivationFunction
    {
        public double func(double x)
        {
            return Math.Max(x, 0);
        }

        public double funcPrime(double x)
        {
            return x > 0 ? 1 : 0;
        }
    }

    public class Sigmoid : ActivationFunction
    {
        public double func(double x)
        {
            return 1 / (1 + Math.Exp(-x));
        }

        public double funcPrime(double x)
        {
            return func(x) * (1 - func(x));
        }
    }
}