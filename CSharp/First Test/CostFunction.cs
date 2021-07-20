using System;

using MathNet.Numerics.LinearAlgebra;

namespace Neural_Network
{
    interface CostFunction
    {
        Matrix<double> evaluate(Matrix<double> a, Matrix<double> exp);
        double calcCost(Matrix<double> a, Matrix<double> exp);

    }


    public class Quadratic : CostFunction
    {
        public Matrix<double> evaluate(Matrix<double> a, Matrix<double> exp)
        {
            return a - exp;
        }

        public double calcCost(Matrix<double> a, Matrix<double> exp)
        {
            return 1 / 2.0 * (a - exp).L2Norm();
        }
    }

    public class CrossEntropy : CostFunction
    {

        double epsilon = 0.000001;

        public Matrix<double> evaluate(Matrix<double> a, Matrix<double> exp)
        {
            return (a - exp).PointwiseDivide(a * (1 - a) + epsilon);
        }

        public double calcCost(Matrix<double> a, Matrix<double> exp)
        {

            return (-a * (exp + epsilon).PointwiseLog()).ColumnSums().Sum();
        }
    }
}