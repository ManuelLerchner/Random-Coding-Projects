public class Analyzer {

    Node N;
    String var;

    public Analyzer(Node N, String var) {
        this.N = N;
        this.var = var;
    }

    Node analyze() {
        Node out = null;

        if (N.getClass() == BinOpNode.class) {
            out = deriveBinOPNode((BinOpNode) N);
        } else if (N.getClass() == UnaryOpNode.class) {
            out = deriveUnaryOpNode((UnaryOpNode) N);
        } else if (N.getClass() == NumberNode.class) {
            out = deriveNumberNode((NumberNode) N);
        } else if (N.getClass() == FunctionNode.class) {
            out = deriveFunctionNode((FunctionNode) N);
        }
        return out;
    }

    Node deriveUnaryOpNode(UnaryOpNode N) {
        Node out = N.derivative(var);
        return out;
    }

    Node deriveBinOPNode(BinOpNode N) {
        Node out = N.derivative(var);
        return out;
    }

    Node deriveNumberNode(NumberNode N) {
        Node out = N.derivative(var);
        return out;
    }

    Node deriveFunctionNode(FunctionNode N) {
        Node out = N.derivative(var);
        return out;
    }

}
