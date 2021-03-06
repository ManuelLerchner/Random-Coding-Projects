public interface Node {

}

class NumberNode implements Node {

    Number Num;
    boolean isVariable;
    String name;

    public NumberNode(Number N) {
        this.Num = N;
    }

    public NumberNode(String name) {
        this.name = name;
        isVariable = true;
    }

    public String toString() {
        return "" + (isVariable == false ? Num : name);
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

class VarAssignNode implements Node {

    Node expr;
    String name;

    public VarAssignNode(String name, Node expr) {
        this.expr = expr;
        this.name = name;
    }

    public String toString() {
        return "" + expr;
    }
}
