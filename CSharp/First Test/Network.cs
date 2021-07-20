using System;

using MathNet.Numerics.LinearAlgebra;

namespace Neural_Network
{
    class Network
    {
        int[] dims;
        public Layer[] layers;

        double eta;

        public Network(int[] dims, ActivationFunction A, CostFunction CF, double eta)
        {
            this.dims = dims;
            this.eta = eta;


            layers = new Layer[dims.Length];

            for (int i = 0; i < dims.Length; i++)
            {
                layers[i] = new Layer(i, this, i > 0 ? dims[i - 1] : 0, dims[i], A, CF);
            }

        }

        public Matrix<double> forward(Matrix<double> input)
        {
            layers[0].a = input;

            var output = layers[0].a;

            for (int i = 1; i < dims.Length; i++)
            {
                output = layers[i].forward(output);
            }
            return output;

        }

        public double backward(Matrix<double> expected)
        {

            double cost = layers[layers.Length - 1].calcError(expected);

            for (int i = dims.Length - 2; i >= 1; i--)
            {
                layers[i].calcError();
            }

            for (int i = dims.Length - 1; i >= 1; i--)
            {
                layers[i].adjustParams(eta);
            }

            return cost;

        }
    }
}