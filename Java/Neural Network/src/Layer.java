public class Layer {

    Network NN;
    int nLayer;
    double[][] weights;
    double[][] a, z, delta;
    double[] b;


    Layer(Network NN, int nLayer) {
        this.NN = NN;
        this.nLayer = nLayer;
        this.weights = VectorMath.createGaussianMatrix(NN.NetworkSize[nLayer], nLayer > 0 ? NN.NetworkSize[nLayer - 1] : 0);
        this.b = VectorMath.createGaussianVector(NN.NetworkSize[nLayer]);
        this.a = new double[NN.NetworkSize[nLayer]][];
    }

    double[][] activationFunction(double[][] a) {
        switch (NN.func[nLayer]) {
            case "relu":
                return VectorMath.relu(a);
            case "sigmoid":
                return VectorMath.sigma(a);
            default:
                System.out.println("Layer: " + nLayer + " has an invalid Activation Function");
                return null;
        }
    }

    double[][] activationFunctionPrime(double[][] a) {
        switch (NN.func[nLayer]) {
            case "relu":
                return VectorMath.reluPrime(a);
            case "sigmoid":
                return VectorMath.sigmaPrime(a);
            default:
                System.out.println("Layer: " + nLayer + " has an invalid Activation Function");
                return null;
        }
    }


    void calcA() {
        double[][] T = VectorMath.matmul(NN.Layers[nLayer - 1].a, weights);
        T = VectorMath.addVec(T, b);
        z = T;
        a = activationFunction(T);
    }


    void calcErrorCROSSENTROPY(double[][] desired) {
        double[][] nabla_a_C = new double[desired.length][desired[0].length];
        for (int i = 0; i < desired.length; i++) {
            for (int j = 0; j < desired[0].length; j++) {
                nabla_a_C[i][j] = (a[i][j] - desired[i][j]) / (0.01+(a[i][j] - a[i][j] * a[i][j]));
            }
        }
        delta = VectorMath.Hadamard(nabla_a_C, activationFunctionPrime(z));
    }

    void calcError() {
        double[][] error = VectorMath.transpose(VectorMath.matmul(VectorMath.transpose(NN.Layers[nLayer + 1].weights), NN.Layers[nLayer + 1].delta));
        delta = VectorMath.Hadamard(error, activationFunctionPrime(z));
    }
}
