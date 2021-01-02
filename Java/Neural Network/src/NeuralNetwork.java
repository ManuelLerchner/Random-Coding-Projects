import javax.imageio.ImageIO;
import java.awt.*;
import java.io.File;
import java.io.IOException;
import java.awt.image.BufferedImage;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

public class NeuralNetwork {


    public static void main(String[] args) {


        String pattern = "MM.dd.yyyy  HH;mm;ss";
        DateFormat df = new SimpleDateFormat(pattern);
        Date today = Calendar.getInstance().getTime();
        String todayAsString = df.format(today);

        String Path = "/Users/Manuel/Documents/Coding Projects/Java/Neural Network/Images/" + todayAsString;
        Path path = Paths.get(Path);
        
        try {
            Files.createDirectories(path);
        } catch (IOException e) {
            e.printStackTrace();
        }

        System.out.println(Path);
        System.out.println("Directory is created!");


        //Setup Plot
        int size = 200;
        double[][] data = new double[size][size];
        //Plot p = new Plot(size, size);
        //p.sizeFactor = 1;

        //Setup NN
        int[] dim = new int[]{2, 40, 40, 40, 40, 32, 1};
        String[] func = new String[]{"relu", "relu", "relu", "relu", "relu", "relu", "sigmoid"};
        Network NN = new Network(dim, func);

        NN.learningRate = 0.01;
        NN.decay = 0.001;

        int iter = 0;
        while (true) {

            int batch = 16;
            double[][] X = new double[batch][];
            double[][] Y = new double[batch][];

            for (int i = 0; i < batch; i++) {
                double[] d = Data.createCIRCLE();
                X[i] = new double[]{d[0], d[1]};
                Y[i] = new double[]{d[2]};
            }


            NN.train(X, Y);

            //Update Frame
            int pause = 5000;
            if (iter % pause == 0) {
                try {
                    BufferedImage image = new BufferedImage(data[0].length, data.length, BufferedImage.TYPE_INT_RGB);

                    for (int k = 0; k < data[0].length; k++) {
                        for (int j = 0; j < data.length; j++) {
                            data[k][j] = NN.predict(new double[][]{{(double) k / data[0].length, (double) j / data.length}}, false)[0][0];
                            //p.data[k][j]=data[k][j]
                            int a = (int) (Math.round(255 * data[k][j]));
                            Color newColor = new Color(a, a, a);
                            image.setRGB(k, j, newColor.getRGB());
                        }
                    }

                    System.out.println(data[5][5]);
                    //dateTime
                    File output = new File("Images\\" + todayAsString + "\\image" + iter / pause + ".jpg");
                    ImageIO.write(image, "jpg", output);

                } catch (Exception e) {
                }
                //p.redraw();
                System.out.println("Progress: " + iter + " Iterations");
                NN.learningRate /= 1 + NN.decay;
            }

            iter++;

        }


    }

}


