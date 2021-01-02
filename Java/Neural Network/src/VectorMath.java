import java.util.Random;

public class VectorMath {

    /////////////////////////////////////////////////////
    static void printVec(double[] vec) {
        System.out.print("");
        for (int k = 0; k < vec.length; k++) {
            System.out.print(vec[k]);
            if (k != vec.length - 1) {
                System.out.print(",");
            }
        }
        System.out.println();
    }

    /////////////////////////////////////////////////////
    static void printMat(double[][] mat) {
        System.out.println("");
        for (int k = 0; k < mat.length; k++) {
            printVec(mat[k]);
        }
        System.out.println();
    }

    /////////////////////////////////////////////////////
    static double[][] createGaussianMatrix(int x, int y) {
        double[][] mat = new double[x][y];
        Random r = new Random();
        for (int i = 0; i < mat.length; i++) {
            for (int j = 0; j < mat[i].length; j++) {
                mat[i][j] = r.nextGaussian() / 5;
            }

        }
        return mat;
    }

    static double[] createGaussianVector(int x) {
        double[] vec = new double[x];
        Random r = new Random();
        for (int i = 0; i < vec.length; i++) {
            vec[i] = r.nextGaussian();
        }
        return vec;
    }

    /////////////////////////////////////////////////////
    public static double[][] matmul(double[][] a, double[][] b) {

        double[][] C = new double[a.length][b.length];
        b = VectorMath.transpose(b);

        for (int i = 0; i < a.length; i++) { // aRow
            for (int k = 0; k < a[0].length; k++) { // aColumn
                for (int j = 0; j < b[0].length; j++) { // bColumn

                    C[i][j] += a[i][k] * b[k][j];
                }
            }
        }

        return C;
    }

    /////////////////////////////////////////////////////
    public static double[][] transpose(double[][] A) {

        double[][] C = new double[A[0].length][A.length];
        for (int i = 0; i < A.length; i++) {
            for (int k = 0; k < A[0].length; k++) {
                C[k][i] += A[i][k];
            }
        }
        return C;
    }

    /////////////////////////////////////////////////////
    public static double[][] addVec(double[][] A, double[] B) {

        double[][] C = new double[A.length][A[0].length];
        for (int i = 0; i < A.length; i++) {
            for (int j = 0; j < A[0].length; j++) {

                C[i][j] = A[i][j] + B[j];

            }
        }
        return C;
    }

    public static int maxIndex(float[] A) {

        int max = -1;
        float maxVal = -1;

        for (int i = 0; i < A.length; i++) {

            if (A[i] > maxVal) {
                maxVal = A[i];
                max = i;
            }

        }
        return max;
    }

    public static double[] subVec(double[] A, double[] B) {

        double[] C = new double[A.length];
        for (int i = 0; i < A.length; i++) {
            C[i] = A[i] - B[i];
        }
        return C;
    }

    /////////////////////////////////////////////////////
    public static double[][] Hadamard(double[][] A, double B[][]) {

        double[][] C = new double[A.length][A[0].length];
        for (int i = 0; i < A.length; i++) {
            for (int j = 0; j < A[0].length; j++) {
                C[i][j] = A[i][j] * B[i][j];
            }

        }
        return C;
    }

    public static double sigmoid(double a) {
        return (1 / (1 + Math.exp(-a)));
    }

    ///////////////////////////////////////////////
    public static double sigma(double a) {
        return sigmoid(a);
    }

    ///////////////////////////////////////////////
    public static double sigmaPrime(double a) {
        return sigmoid(a) * (1 - sigmoid(a));
    }

    /////////////////////////////////////////////////////
    public static double[][] sigma(double[][] A) {
        double[][] C = new double[A.length][A[0].length];
        for (int i = 0; i < A.length; i++) {
            for (int j = 0; j < A[0].length; j++) {
                C[i][j] = sigma(A[i][j]);
            }
        }
        return C;
    }

    /////////////////////////////////////////////////////
    public static double[][] sigmaPrime(double[][] A) {
        double[][] C = new double[A.length][A[0].length];
        for (int i = 0; i < A.length; i++) {
            for (int j = 0; j < A[0].length; j++) {
                C[i][j] = sigmaPrime(A[i][j]);
            }
        }
        return C;

    }

    ///////////////////////////////////////////////
    public static double relu(double a) {
        return Math.max(a, 0);
    }

    ///////////////////////////////////////////////
    public static double reluPrime(double a) {
        return a > 0 ? 1 : 0;
    }

    /////////////////////////////////////////////////////
    public static double[][] relu(double[][] A) {
        double[][] C = new double[A.length][A[0].length];
        for (int i = 0; i < A.length; i++) {
            for (int j = 0; j < A[0].length; j++) {
                C[i][j] = relu(A[i][j]);
            }
        }
        return C;
    }

    /////////////////////////////////////////////////////
    public static double[][] reluPrime(double[][] A) {
        double[][] C = new double[A.length][A[0].length];
        for (int i = 0; i < A.length; i++) {
            for (int j = 0; j < A[0].length; j++) {
                C[i][j] = reluPrime(A[i][j]);
            }
        }
        return C;

    }

}
