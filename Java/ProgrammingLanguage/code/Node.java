public interface Node {

}

class NumberNode implements Node {

    Number Num;

    public NumberNode(Number N) {
        this.Num = N;
    }

    public String toString() {
        return "" + Num;
    }
}

class BinOpNode implements Node {

    Node Left, Right;
    Token operation;

    public BinOpNode(Node Left, Token operation, Node Right) {
        this.Left = Left;
        this.Right = Right;
        this.operation = operation;
    }

    public String toString() {
        return "(" + Left + " " + operation + " " + Right + ")";
    }

    public Number eval(Number A, Token operation, Number B) {

        switch (operation.type) {
            case Token.PLUS:
                return new Number(A.val + B.val);
            case Token.MINUS:
                return new Number(A.val - B.val);
            case Token.DIV:
                return new Number(A.val / B.val);
            case Token.MUL:
                return new Number(A.val * B.val);
            default:
                return null;
        }

    }
}