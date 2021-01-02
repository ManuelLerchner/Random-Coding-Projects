
public class Data {

    static double[] createXOR() {
        double r1 = Math.round(Math.random());
        double r2 = Math.round(Math.random());

        boolean a = r1 == 1;
        boolean b = r2 == 1;

        boolean c = a ^ b;

        int result = c ? 1 : 0;

        return new double[] { r1, r2, result };

    }

    static double[] createCIRCLE() {
        double x = Math.random() - 0.5;
        double y = Math.random() - 0.5;

        double dist = Math.abs(x) + Math.abs(y);
        double dist2 = Math.sqrt(Math.pow(x, 2) + Math.pow(y, 2));

        boolean onSquare = (dist < 0.3 && dist > 0.25);
        boolean onCircle = (dist2 < 0.35 && dist2 > 0.3);

        boolean onYCenter = Math.abs(x) < 0.025;
        boolean onXCenter = Math.abs(y) < 0.025;

        double result = onSquare || onCircle || onYCenter || onXCenter ? 1 : 0;

        if (Math.abs(x + y) < 0.025) {
            result = 1;
        }
        if (Math.abs(x - y) < 0.025) {
            result = 1;
        }

        return new double[] { x + 0.5, y + 0.5, result };

    }

    static float[] createSIN() {
        float x = (float) Math.random();
        float y = (float) Math.random();

        float result = (x + y) / 2;

        return new float[] { x, y, result };

    }

    static double[][] createMNIST(Card c) {
        int r = (int) (Math.random() * 60000);

        double[] inp = c.training_set[r].inputs;
        double[] out = c.training_set[r].outputs;

        return new double[][] { inp, out };

    }
}
