using System;

using MathNet.Numerics.LinearAlgebra;
using MathNet.Numerics.LinearAlgebra.Double;

namespace Neural_Network
{

    class Program
    {
        static void Main(string[] args)
        {
            DataGenerator DG = new DataGenerator();

            ActivationFunction AF = new Sigmoid();
            CostFunction CF = new CrossEntropy();

            int[] dims = new int[] { 2, 4, 2, 1 };

            var NN = new Network(dims, AF, CF, 0.5);


            for (int i = 0; i < 1000; i++)
            {
                var Data = DG.randomXOR();
                var input = DenseMatrix.OfRowVectors(new Vector<double>[] { Data.Inp });
                var output = DenseMatrix.OfRowVectors(new Vector<double>[] { Data.Exp });


                var res = NN.forward(input);
                double cost = NN.backward(output);

                Console.Write("inp:  " + input.ToMatrixString());
                Console.Write("out:  " + res.ToMatrixString());
                Console.WriteLine("Cost: " + cost + "\n");
            }

        }
    }
}

