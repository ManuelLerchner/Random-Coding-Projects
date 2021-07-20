using System;

using MathNet.Numerics.LinearAlgebra;
using MathNet.Numerics.LinearAlgebra.Double;

namespace Neural_Network
{

    class Layer
    {
        int idx, numOutputs;

        Matrix<double> weights;
        Vector<double> bias;

        Network NN;
        ActivationFunction A;
        CostFunction CF;
        public Matrix<double> a, z, delta;


        public Layer(int idx, Network NN, int numInputs, int numOutputs, ActivationFunction A, CostFunction CF)
        {
            this.idx = idx;
            this.numOutputs = numOutputs;
            this.NN = NN;
            this.A = A;
            this.CF = CF;

            weights = Matrix<double>.Build.Random(numInputs, numOutputs);
            bias = Vector<double>.Build.Random(numOutputs);
        }

        public Matrix<double> forward(Matrix<double> input)
        {
            var m = input * weights;

            z = m.Clone();

            for (int i = 0; i < m.RowCount; i++)
            {
                var temp = m.Row(i) + bias;
                z.SetRow(i, temp);
            }

            a = z.Map(A.func);

            return a;

        }

        public double calcError(Matrix<double> expected)
        {
            var nabla_a_C = CF.evaluate(a, expected);

            var activationPrime = z.Map(A.funcPrime);

            var deltaL = nabla_a_C.PointwiseMultiply(activationPrime);

            delta = deltaL;

            return CF.calcCost(a, expected);

        }

        public void calcError()
        {
            var activationPrime = z.Map(A.funcPrime);

            var left = (NN.layers[idx + 1].weights * NN.layers[idx + 1].delta.Transpose()).Transpose();

            delta = left.PointwiseMultiply(activationPrime);
        }

        public void adjustParams(double eta)
        {
            Func<Vector<double>, double> average = (Vector<double> a) => a.Sum() / a.Count;

            var a = NN.layers[idx - 1].a;

            for (int j = 0; j < delta.ColumnCount; j++)
            {
                double delC_del_b_j = average(delta.Column(j));

                bias[j] -= eta * delC_del_b_j;

                for (int k = 0; k < a.ColumnCount; k++)
                {
                    var delC_del_w_j_k = average(a.Column(k)) * delC_del_b_j;


                    weights[k, j] -= eta * delC_del_w_j_k;
                }
            }

        }

    }
}
