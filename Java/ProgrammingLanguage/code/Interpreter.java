public class Interpreter {

    Node root;

    public Interpreter(Node root) {
        this.root = root;
    }

    ////////////////////////////////////////////////////
    ////////////////////////////////////////////////////

    Number interpet() {
        return visit(root);
    }

    ////////////////////////////////////////////////////
    ////////////////////////////////////////////////////

    Number visit(Node N) {
        if (N.getClass() == BinOpNode.class) {
            return visitBinOpNode((BinOpNode) N);
        } else if (N.getClass() == NumberNode.class) {
            return visitNumberNode((NumberNode) N);
        }

        return null;
    }

    ////////////////////////////////////////////////////
    ////////////////////////////////////////////////////

    Number visitNumberNode(NumberNode N) {
        return N.Num;
    }

    ////////////////////////////////////////////////////

    Number visitBinOpNode(BinOpNode N) {
        return N.eval(visit(N.Left), N.operation, visit(N.Right));
    }

}
