public class Analyzer {

    Node N;
    String var;

    public Analyzer(Node N, String var) {
        this.N = N;
        this.var = var;
    }

    Node analyze() {
        Node out = null;
        out = N.derivative(var);
        return out;
    }

}
