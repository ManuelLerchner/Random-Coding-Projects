
public class Network {

    double learningRate = 0.1;
    double decay = 0;
    int[] NetworkSize;
    String[] func;
    Layer[] Layers;


    Network(int[] NetworkSize, String[] func) {
        this.NetworkSize = NetworkSize;
        this.func=func;
        this.Layers = new Layer[NetworkSize.length];
        for (int i = 0; i < NetworkSize.length; i++) {
            Layers[i] = new Layer(this, i);
        }
    }

    void forwards(double[][] input) {
        Layers[0].a = input;
        for (int i = 1; i < Layers.length; i++) {
            Layers[i].calcA();
        }
    }


    void backwards(double[][] desired) {
        //Layers[Layers.length - 1].calcErrorSQUARE(desired);
        Layers[Layers.length - 1].calcErrorCROSSENTROPY(desired);
        for (int i = Layers.length - 2; i >= 1; i--) {
            Layers[i].calcError();
        }
    }

    void adjustParameters() {


        int batchSize = Layers[0].a.length;
        for (int l = 1; l < NetworkSize.length; l++) {
            for (int j = 0; j < NetworkSize[l]; j++) {
                for (int k = 0; k < NetworkSize[l - 1]; k++) {

                    double Gradient_w = 0;
                    for (int batch = 0; batch < batchSize; batch++) {
                        Gradient_w += Layers[l - 1].a[batch][k] * Layers[l].delta[batch][j];
                    }
                    Gradient_w /= batchSize;

                    Layers[l].weights[j][k] -= Gradient_w * learningRate;
                }

                double Gradient_b = 0;
                for (int batch = 0; batch < batchSize; batch++) {
                    Gradient_b = Layers[l].delta[batch][j];
                }
                Gradient_b /= batchSize;
                Layers[l].b[j] -= Gradient_b * learningRate;
            }
        }
    }


    void train(double[][] input, double[][] desired) {
        forwards(input);
        backwards(desired);
        adjustParameters();

    }

    double[][] predict(double[][] input, boolean print) {
        forwards(input);
        if (print) {
            System.out.print("\nPrediction for Input: ");
            VectorMath.printMat(input);
            VectorMath.printMat(Layers[Layers.length - 1].a);
        }
        return Layers[Layers.length - 1].a;
    }

}


