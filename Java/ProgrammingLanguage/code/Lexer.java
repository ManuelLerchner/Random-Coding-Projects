import java.util.LinkedList;

public class Lexer {
    String input;
    char currentChar;
    int index = -1;
    LinkedList<Token> Tokens = new LinkedList<Token>();

    Lexer(String input) {
        this.input = input;
        advance();
    }

    ////////////////////////////////////////////////////
    ////////////////////////////////////////////////////

    public LinkedList<Token> interpret() {

        while (currentChar != 0) {
            if (Token.NUMBERS.contains(String.valueOf(currentChar))) {
                Tokens.add(makeNumber());
            } else {
                Tokens.add(makeOperator());
            }
        }

        return Tokens;

    }

    ////////////////////////////////////////////////////
    ////////////////////////////////////////////////////

    void advance() {
        if (index < input.length() - 1) {
            index++;
        } else {
            currentChar = 0;
            return;
        }
        currentChar = input.charAt(index);
    }

    ////////////////////////////////////////////////////
    ////////////////////////////////////////////////////

    Token makeNumber() {
        String number = "";
        while (Token.NUMBERS.contains(String.valueOf(currentChar))) {
            number += currentChar;
            advance();
        }
        return new Token(Token.NUMBER, Double.valueOf(number));
    }

    ////////////////////////////////////////////////////
    ////////////////////////////////////////////////////

    Token makeOperator() {
        Token T;
        switch (currentChar) {
            case '+':
                T = new Token(Token.PLUS);
                break;
            case '-':
                T = new Token(Token.MINUS);
                break;
            case '*':
                T = new Token(Token.MUL);
                break;
            case '/':
                T = new Token(Token.DIV);
                break;
            case '(':
                T = new Token(Token.LPAR);
                break;
            case ')':
                T = new Token(Token.RPAR);
                break;
            default:
                T = null;
                break;
        }
        advance();
        return T;
    }

}
