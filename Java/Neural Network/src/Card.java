
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;


public class Card {

    Card[] training_set;
    Card[] testing_set;
    double[] inputs;
    double[] outputs;
    int output;

    Card() {
        inputs = new double[28*28];
        outputs = new double[10];
    }

    public void imageLoad(byte[] images, int offset) {
        for (int i = 0; i < 28*28; i++) {
            inputs[i] = images[i + offset] / 256f;

        }

    }

    public void labelLoad(byte[] labels, int offset) {
        output = labels[offset];
        for (int i = 0; i < 10; i++) {
            if (i == output) {
                outputs[i] = 1;
            } else {
                outputs[i] = 0;
            }
        }
    }

    void loadData() throws IOException {
        File testim = new File("src/data/train-images.idx3-ubyte");
        byte[] images = Files.readAllBytes(testim.toPath());


        File testla = new File("src/data/train-labels.idx1-ubyte");
        byte[] labels = Files.readAllBytes(testla.toPath());


        File trainim = new File("src/data/t10k-images.idx3-ubyte");
        byte[] trainimages = Files.readAllBytes(trainim.toPath());


        File trainla = new File("src/data/t10k-labels.idx1-ubyte");
        byte[] trainlabels = Files.readAllBytes(trainla.toPath());

        training_set = new Card[60000];
        for (int i = 0; i < 60000; i++) {
            training_set[i] = new Card();
            training_set[i].imageLoad(images, 16 + i * 28*28);
            training_set[i].labelLoad(labels, 8 + i);
        }
        testing_set = new Card[10000];
        for (int i = 0; i < 10000; i++) {
            testing_set[i] = new Card();
            testing_set[i].imageLoad(trainimages, 16 + i * 28*28);
            testing_set[i].labelLoad(trainlabels, 8 + i);
        }
    }
}


