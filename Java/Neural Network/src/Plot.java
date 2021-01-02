import java.awt.*;


public class Plot extends Component {
    /**
     *
     */
    private static final long serialVersionUID = 1L;
    double[][] data;
    int sizeFactor = 1;
    javax.swing.JFrame frame;

    Plot(int n, int m) {
        this.data = new double[n][m];
        init();
    }


    void init() {
        int frameWidth = sizeFactor * data.length;
        int frameHeight = sizeFactor * data.length + 23;

        frame = new javax.swing.JFrame();
        frame.setSize(frameWidth, frameHeight);
        frame.setLocationRelativeTo(null);
        frame.setVisible(true);
        frame.getContentPane().add(this);
    }

    void drawPixel(Graphics g, int x, int y, int s) {
        for (int i = 0; i < s; i++) {
            for (int j = 0; j < s; j++) {
                g.drawLine(i + x, j + y, i + x, j + y);
            }
        }
    }

    void redraw() {
        frame.repaint();
    }

    public void paint(Graphics g) {
        for (int i = 0; i < data[0].length; i++) {
            for (int j = 0; j < data.length; j++) {
                int val = (int)Math.round(255 * data[i][j]);
                float[] rgb = Color.RGBtoHSB(val, val, val, null);
                g.setColor(Color.getHSBColor(rgb[0], rgb[1], rgb[2]));
                drawPixel(g, i * sizeFactor, j * sizeFactor, sizeFactor);
            }

        }


    }
}
