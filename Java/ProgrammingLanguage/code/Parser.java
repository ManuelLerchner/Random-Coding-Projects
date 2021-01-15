import java.util.LinkedList;
import java.util.HashSet;
import java.util.Arrays;

public class Parser {
    LinkedList<Token> Tokens;
    Token currentToken;
    int index = -1;

    Parser(LinkedList<Token> Tokens) {
        this.Tokens = Tokens;
        advance();
    }

    ////////////////////////////////////////////////////
    ////////////////////////////////////////////////////

    Node parse() {
        return expression(currentToken);
    }

    ////////////////////////////////////////////////////
    ////////////////////////////////////////////////////

    void advance() {
        index++;
        if (index < Tokens.size()) {
            currentToken = Tokens.get(index);
        }

    }

    ////////////////////////////////////////////////////
    ////////////////////////////////////////////////////

    Node expression(Token Tok) {

        if (Tok.type.equals(Token.KEYWORD) && Tok.name.equals("var")) {

            advance();
            Token Identifier = currentToken;
            advance();

            if (!currentToken.type.equals(Token.EQ)) {
                return null;
            }
            advance();

            Node expr = expression(currentToken);

            return new VarAssignNode(Identifier.name, expr);

        } else {

            return repeat("factor", new HashSet<String>(Arrays.asList(new String[] { Token.PLUS, Token.MINUS })));
        }
    }

    ////////////////////////////////////////////////////
    ////////////////////////////////////////////////////

    Node factor(Token currentToken) {

        return repeat("atom", new HashSet<String>(Arrays.asList(new String[] { Token.MUL, Token.DIV })));
    }

    ////////////////////////////////////////////////////
    ////////////////////////////////////////////////////

    Node atom(Token currentToken) {
        Node N = null;

        if (new HashSet<String>(Arrays.asList(Token.NUMBER)).contains(currentToken.type)) {
            advance();
            N = new NumberNode(new Number(currentToken.value));
        } else if (currentToken.type == Token.LPAR) {
            advance();
            N = expression(currentToken);
            advance();
        } else if (currentToken.type == Token.IDENTIFIER) {
            N = new NumberNode(currentToken.name);
            advance();
        }
        return N;
    }

    ////////////////////////////////////////////////////
    ////////////////////////////////////////////////////

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
            }
            Left = new BinOpNode(Left, operator, Right);
        }

        return Left;
    }

}
