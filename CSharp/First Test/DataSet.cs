using System;

using MathNet.Numerics.LinearAlgebra;
using MathNet.Numerics.LinearAlgebra.Double;

namespace Neural_Network
{

    struct Data
    {
        public Vector<double> Inp { get; }
        public Vector<double> Exp { get; }

        public Data(Vector<double> inp, Vector<double> exp)
        {
            Inp = inp;
            Exp = exp;
        }
    }

    class DataGenerator
    {
        Random rnd;

        public DataGenerator()
        {
            this.rnd = new Random();
        }

        public Data randomXOR()
        {
            var a = rnd.NextDouble() < 0.5;
            var b = rnd.NextDouble() < 0.5;

            var c = a ^ b;

            Vector<double> inp = DenseVector.OfArray(new double[] { a ? 1 : 0, b ? 1 : 0 });
            Vector<double> output = DenseVector.OfArray(new double[] { c ? 1 : 0 });

            return new Data(inp, output);
        }

    }
}