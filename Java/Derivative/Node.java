public interface Node {

    boolean isStatic(String var);

    Node derivative(String var);
}

class NumberNode implements Node {

    float value;

    NumberNode(float value) {
        this.value = value;
    }

    public String toString() {
        return "" + value;
    }

    public boolean isStatic(String var) {
        return true;
    }

    public Node derivative(String var) {
        Node out = new NumberNode(0);
        return out;
    }
}

class VarNode implements Node {

    String name;

    VarNode(String name) {
        this.name = name;
    }

    public String toString() {
        return "" + name;
    }

    public boolean isStatic(String var) {
        return !name.equals(var);
    }

    public Node derivative(String var) {

        if (isStatic(var)) {
            return new NumberNode(0);
        } else {
            return new NumberNode(1);
        }

    }
}

class FunctionNode implements Node {

    Token Tok;
    Node expr;

    FunctionNode(Token Tok, Node expr) {
        this.Tok = Tok;
        this.expr = expr;
    }

    public String toString() {
        return Tok.name + "[" + expr + "]";
    }

    public boolean isStatic(String var) {

        return expr.isStatic(var);
    }

    public Node derivative(String var) {

        if (Tok.name.equals("sqrt")) {
            Token sqrt = new Token(Token.KEYWORD, "sqrt");
            return new BinOpNode(expr.derivative(var), new Token(Token.DIV),
                    new BinOpNode(new NumberNode(2), new Token(Token.MUL), new FunctionNode(sqrt, expr)));
        }
        if (Tok.name.equals("ln")) {
            return new BinOpNode(expr.derivative(var), new Token(Token.DIV), expr);
        }
        if (Tok.name.equals("sin")) {
            Token cos = new Token(Token.KEYWORD, "cos");
            return new BinOpNode(expr.derivative(var), new Token(Token.MUL), new FunctionNode(cos, expr));
        }
        if (Tok.name.equals("cos")) {
            Token sin = new Token(Token.KEYWORD, "sin");
            return new BinOpNode(expr.derivative(var), new Token(Token.MUL),
                    new UnaryOpNode(new Token(Token.MINUS), new FunctionNode(sin, expr)));
        }
        if (Tok.name.equals("tan")) {
            Token cos = new Token(Token.KEYWORD, "cos");
            return new BinOpNode(expr.derivative(var), new Token(Token.DIV),
                    new BinOpNode(new FunctionNode(cos, expr), new Token(Token.POW), new NumberNode(2)));
        }

        return null;
    }
}

class BinOpNode implements Node {

    public Node Left;
    public Node Right;
    Token op;

    BinOpNode(Node Left, Token op, Node Right) {
        this.Left = Left;
        this.Right = Right;
        this.op = op;

    }

    public String toString() {
        return "(" + Left + " " + op + " " + Right + ")";
    }

    public boolean isStatic(String var) {
        return Left.isStatic(var) && Right.isStatic(var);
    }

    public Node derivative(String var) {

        if (op.type == Token.PLUS || op.type == Token.MINUS) {
            return sumRule(var, op);
        }

        if (op.type == Token.MUL) {
            if (Right.isStatic(var) && Left.isStatic(var)) {
                return new NumberNode(0);
            }
            if (Right.isStatic(var) ^ Left.isStatic(var)) {
                return factorRule(var);
            }
            if (!(Right.isStatic(var) && Left.isStatic(var))) {
                return productRule(var);
            }
        }

        if (op.type == Token.POW) {
            if (Right.isStatic(var) && Left.isStatic(var)) {
                return new NumberNode(0);
            }
            if (Right.isStatic(var)) {
                return powerRule();
            }
            if (Left.isStatic(var)) {
                return expRule(var);
            }
        }

        if (op.type == Token.DIV) {
            if (Right.isStatic(var) && Left.isStatic(var)) {
                return new NumberNode(0);
            }
            if (Right.isStatic(var)) {
                return new BinOpNode(new NumberNode(1), new Token(Token.DIV), Right);
            }

            return quotientRule(var);

        }

        return null;
    }

    Node powerRule() {
        Node Factor = Right;
        Node EXP = new BinOpNode(Right, new Token(Token.MINUS), new NumberNode(1));
        Node POW = new BinOpNode(Left, new Token(Token.POW), EXP);
        Node out = new BinOpNode(Factor, new Token(Token.MUL), POW);
        return out;
    }

    Node expRule(String var) {
        if (!Left.isStatic("e")) {
            Node Factor = Right.derivative(var);
            Node EXP = this;
            Node out = new BinOpNode(Factor, new Token(Token.MUL), EXP);
            return out;
        } else {
            Token ln = new Token(Token.KEYWORD, "ln");
            Node Factor = new BinOpNode(Right.derivative(var), new Token(Token.MUL), new FunctionNode(ln, Left));
            Node EXP = this;
            Node out = new BinOpNode(Factor, new Token(Token.MUL), EXP);
            return out;
        }
    }

    Node factorRule(String var) {
        if (Left.isStatic(var)) {
            return new BinOpNode(Left, new Token(Token.MUL), Right.derivative(var));
        } else {
            return new BinOpNode(Right, new Token(Token.MUL), Left.derivative(var));
        }
    }

    Node sumRule(String var, Token op) {
        Node S1 = Left.derivative(var);
        Node S2 = Right.derivative(var);
        return new BinOpNode(S1, op, S2);
    }

    Node productRule(String var) {

        Node DLeft = Left.derivative(var);
        Node DRight = Right.derivative(var);

        Node P1 = new BinOpNode(DLeft, new Token(Token.MUL), Right);
        Node P2 = new BinOpNode(DRight, new Token(Token.MUL), Left);

        return new BinOpNode(P1, new Token(Token.PLUS), P2);

    }

    Node quotientRule(String var) {
        Node DLeft = Left.derivative(var);
        Node DRight = Right.derivative(var);

        Node P1 = new BinOpNode(DLeft, new Token(Token.MUL), Right);
        Node P2 = new BinOpNode(DRight, new Token(Token.MUL), Left);
        Node Diff = new BinOpNode(P1, new Token(Token.MINUS), P2);
        return new BinOpNode(Diff, new Token(Token.DIV), new BinOpNode(Right, new Token(Token.POW), new NumberNode(2)));

    }
}

class UnaryOpNode implements Node {

    Token tok;

    Node expr;

    UnaryOpNode(Token tok, Node expr) {
        this.tok = tok;
        this.expr = expr;
    }

    public String toString() {
        return "" + tok + " " + expr;
    }

    public boolean isStatic(String var) {
        return expr.isStatic(var);
    }

    public Node derivative(String var) {

        return new UnaryOpNode(tok, expr.derivative(var));

    }
}