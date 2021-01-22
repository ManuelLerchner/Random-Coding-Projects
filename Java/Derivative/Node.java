import java.math.BigDecimal;

public interface Node {

    boolean isStatic(String var);

    Node derivative(String var);

    Node simplify();

    String prettyPrint();
}

class NumberNode implements Node {

    float value;

    NumberNode(float value) {
        this.value = value;
    }

    public String toString() {
        return "" + value;
    }

    public String prettyPrint() {
        BigDecimal stripedVal = new BigDecimal(value).stripTrailingZeros();
        return "" + stripedVal;
    }

    public boolean isStatic(String var) {
        return true;
    }

    public Node derivative(String var) {
        Node out = new NumberNode(0);
        return out;
    }

    public Node simplify() {
        Node out = new NumberNode(value);
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

    public String prettyPrint() {
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

    public Node simplify() {
        Node out = new VarNode(name);
        return out;
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

    public String prettyPrint() {
        return Tok.name + expr.prettyPrint();
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

    public Node simplify() {
        Node out = new FunctionNode(Tok, expr.simplify());
        return out;
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

    public String prettyPrint() {

        if (op.type == Token.MUL) {
            if (Right.getClass() == NumberNode.class || Right.getClass() == UnaryOpNode.class) {
                return Right.prettyPrint() + op.prettyPrint() + Left.prettyPrint();
            }
            return "(" + Left.prettyPrint() + op.prettyPrint() + Right.prettyPrint() + ")";
        }
        return "(" + Left.prettyPrint() + op.prettyPrint() + Right.prettyPrint() + ")";
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
                return powerRule(var);
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
                return new BinOpNode(Left.derivative(var), new Token(Token.DIV), Right);
            }

            return quotientRule(var);

        }

        return null;
    }

    Node powerRule(String var) {
        Node Factor = Right;
        Node innerDer = Left.derivative(var);
        Node EXP = new BinOpNode(Right, new Token(Token.MINUS), new NumberNode(1));
        Node POW = new BinOpNode(Left, new Token(Token.POW), EXP);
        Node out = new BinOpNode(Factor, new Token(Token.MUL), POW);
        out = new BinOpNode(out, new Token(Token.MUL), innerDer);
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

    public Node simplify() {

        if (Left.getClass() == NumberNode.class && Right.getClass() == BinOpNode.class) {
            // return simplifyOverBrackets((NumberNode) Left, op, (BinOpNode) Right);
        }

        Node LS = Left.simplify();
        Node RS = Right.simplify();

        Node Simplified = calculate(LS, op, RS);
        return (Simplified != null) ? Simplified : new BinOpNode(LS, op, RS);
    }

    Node calculate(Node A, Token op, Node B) {

        if (A.getClass() == NumberNode.class && B.getClass() == NumberNode.class) {
            float val = 0;
            NumberNode AN = (NumberNode) A;
            NumberNode BN = (NumberNode) B;
            switch (op.type) {

                case Token.PLUS:
                    val = AN.value + BN.value;
                    break;
                case Token.MINUS:
                    val = AN.value - BN.value;
                    break;
                case Token.MUL:
                    val = AN.value * BN.value;
                    break;
                case Token.DIV:
                    val = AN.value / BN.value;
                    break;
            }
            return new NumberNode(val);
        }

        if (A.getClass() == NumberNode.class) {

            NumberNode AN = (NumberNode) A;

            if (op.type == Token.MUL) {
                if (AN.value == 0) {
                    return new NumberNode(0);
                }
                if (AN.value == 1) {
                    return B;
                }
                if (AN.value == -1) {
                    return new UnaryOpNode(new Token(Token.MINUS), B);
                }
            }

            if (op.type == Token.DIV) {
                if (AN.value == 0) {
                    return new NumberNode(0);
                }
            }

            if (op.type == Token.PLUS) {
                if (AN.value == 0) {
                    return B;
                }
            }

            if (op.type == Token.MINUS) {
                if (AN.value == 0) {
                    return new UnaryOpNode(new Token(Token.MINUS), B);
                }
            }

            if (op.type == Token.POW) {
                if (AN.value == 1) {
                    return new NumberNode(1);
                }

                if (AN.value == 0) {
                    return new NumberNode(0);
                }
            }

        }

        if (B.getClass() == NumberNode.class) {

            NumberNode BN = (NumberNode) B;

            if (op.type == Token.MUL) {
                if (BN.value == 0) {
                    return new NumberNode(0);
                }
                if (BN.value == 1) {
                    return A;
                }
                if (BN.value == -1) {
                    return new UnaryOpNode(new Token(Token.MINUS), A);
                }
            }

            if (op.type == Token.DIV) {
                if (BN.value == 1) {
                    return A;
                }
            }

            if (op.type == Token.PLUS) {
                if (BN.value == 0) {
                    return A;
                }
            }

            if (op.type == Token.MINUS) {
                if (BN.value == 0) {
                    return A;
                }
            }

            if (op.type == Token.POW) {
                if (BN.value == 1) {
                    return A;
                }

                if (BN.value == 0) {
                    return new NumberNode(1);
                }
            }

        }

        if (A.getClass() == VarNode.class && B.getClass() == VarNode.class) {
            VarNode AN = (VarNode) A;
            VarNode BN = (VarNode) B;
            if (AN.name.equals(BN.name)) {

                if (op.type == Token.MINUS) {
                    return new NumberNode(0);
                }

                if (op.type == Token.DIV) {
                    return new NumberNode(1);
                }

            }

        }

        if (A.getClass() == NumberNode.class && B.getClass() == BinOpNode.class) {
            NumberNode AN = (NumberNode) A;
            BinOpNode BN = (BinOpNode) B;
            if (op.type == Token.MUL) {

                if (BN.op.type == Token.MUL || BN.op.type == Token.DIV) {

                    if (BN.Left.simplify().getClass() == NumberNode.class) {

                        Node factor = calculate(AN, op, BN.Left);

                        if (factor.getClass() == NumberNode.class) {
                            return new BinOpNode(factor, BN.op, BN.Right);
                        }

                    }

                }

            }

            if (op.type == Token.PLUS) {

                if (BN.op.type == Token.PLUS || BN.op.type == Token.MINUS) {

                    if (BN.Left.simplify().getClass() == NumberNode.class) {

                        Node factor = calculate(AN, op, BN.Left);

                        if (factor.getClass() == NumberNode.class) {
                            return new BinOpNode(factor, BN.op, BN.Right);
                        }

                    }

                }

            }

            if (op.type == Token.MINUS) {

                if (BN.op.type == Token.PLUS || BN.op.type == Token.MINUS) {

                    if (BN.Left.simplify().getClass() == NumberNode.class) {

                        Node factor = calculate(AN, op, BN.Left);

                        if (factor.getClass() == NumberNode.class) {
                            return new BinOpNode(factor, op, BN.Right);
                        }

                    }

                }

            }

        }

        if (A.getClass() == BinOpNode.class && B.getClass() == BinOpNode.class) {
            BinOpNode AN = (BinOpNode) A;
            BinOpNode BN = (BinOpNode) B;

            VarNode VarA = null;
            VarNode VarB = null;
            Node restA = null;
            Node restB = null;
            if (AN.Left.getClass() == VarNode.class) {
                VarA = (VarNode) AN.Left;
                restA = AN.Right;
            }
            if (AN.Right.getClass() == VarNode.class) {
                VarA = (VarNode) AN.Right;
                restA = AN.Left;
            }

            if (BN.Left.getClass() == VarNode.class) {
                VarB = (VarNode) BN.Left;
                restB = BN.Right;
            }
            if (BN.Right.getClass() == VarNode.class) {
                VarB = (VarNode) BN.Right;
                restB = BN.Left;
            }

            if (AN.op.type == Token.MUL && BN.op.type == Token.MUL) {
                if (VarA != null && VarB != null) {
                    if (VarA.name.equals(VarB.name)) {
                        Node P2 = new BinOpNode(restA, op, restB);
                        Node P1 = VarA;
                        return new BinOpNode(P1, new Token(Token.MUL), P2);
                    }
                }
            }

        }

        if (A.getClass() == BinOpNode.class) {
            BinOpNode AN = (BinOpNode) A;
            if (AN.op.type == Token.DIV) {

                BinOpNode TOP = new BinOpNode(AN.Left, new Token(Token.MUL), B);
                Node BOT = AN.Right;

                return new BinOpNode(TOP, new Token(Token.DIV), BOT);
            }
        }

        return null;

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

    public String prettyPrint() {
        return "" + tok.prettyPrint() + expr.prettyPrint();
    }

    public boolean isStatic(String var) {
        return expr.isStatic(var);
    }

    public Node derivative(String var) {

        return new UnaryOpNode(tok, expr.derivative(var));

    }

    public Node simplify() {

        return new UnaryOpNode(tok, expr.simplify());
    }
}