import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;

public class Parser {
    ArrayList<Token> Tokens;

    Token currentToken;
    int index = -1;

    public Parser(ArrayList<Token> Tokens) {
        this.Tokens = Tokens;
        advance();
    }

    void advance() {
        index++;

        if (index < Tokens.size()) {
            currentToken = Tokens.get(index);
        }

    }

    Node parse() {
        return expression(currentToken);

    }

    Node expression(Token currentToken) {
        return repeat("term", new HashSet<String>(Arrays.asList(new String[] { Token.PLUS, Token.MINUS })));
    }

    Node term(Token currentToken) {
        return repeat("factor", new HashSet<String>(Arrays.asList(new String[] { Token.MUL, Token.DIV })));
    }

    Node factor(Token currentToken) {
        Node out = null;
        if (currentToken.type == Token.PLUS || currentToken.type == Token.MINUS) {
            advance();
            out = new UnaryOpNode(currentToken, factor(this.currentToken));
        } else {
            out = power(currentToken);
        }
        return out;
    }

    Node power(Token currentToken) {
        return repeat("atom", new HashSet<String>(Arrays.asList(new String[] { Token.POW })));
    }

    Node atom(Token currentToken) {

        Node N = null;

        if (currentToken.type == Token.NUMBER) {
            N = new NumberNode(currentToken.value);
            advance();
        } else if (currentToken.type == Token.LPAR) {
            advance();
            N = expression(currentToken);
            advance();
        } else if (currentToken.type == Token.VAR) {
            N = new VarNode(currentToken.name);
            advance();
        } else if (currentToken.type == Token.KEYWORD) {
            advance();
            N = function(currentToken);

           
            advance();
            Token op = this.currentToken;
            advance();
         

            Node remaining = expression(currentToken);

            if (remaining != null) {

                Node out = new BinOpNode(N, op, remaining);
                N = out;
            }


        }

        return N;

    }

    Node function(Token currentToken) {

        Token func = currentToken;
        advance();
        Node expr = expression(this.currentToken);
        return new FunctionNode(func, expr);
    }

    Node repeat(String Function, HashSet<String> allowedTokens) {
        Node Left = null;
        Node Right = null;

        switch (Function) {
            case "factor":
                Left = factor(currentToken);
                break;

            case "atom":
                Left = atom(currentToken);
                break;

            case "power":
                Left = power(currentToken);
                break;

            case "term":
                Left = term(currentToken);
                break;

            default:
                System.out.println("Function not found");
                break;
        }

        while (allowedTokens.contains(currentToken.type)) {

            Token operator = currentToken;
            advance();

            switch (Function) {
                case "factor":
                    Right = factor(currentToken);
                    break;
                case "atom":
                    Right = atom(currentToken);
                    break;
                case "power":
                    Right = power(currentToken);
                    break;

                case "term":
                    Right = term(currentToken);
                    break;
            }
            Left = new BinOpNode(Left, operator, Right);

        }

        return Left;
    }
}
