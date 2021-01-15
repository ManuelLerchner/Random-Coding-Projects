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
            while (currentChar == ' ') {
                advance();
            }
            if (Token.NUMBERS.contains(String.valueOf(currentChar))) {
                Tokens.add(makeNumber());
            } else if (Token.LETTERS.contains(String.valueOf(currentChar))) {
                Tokens.add(makeWord());
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
            case '=':
                T = new Token(Token.EQ);
                break;
            default:
                T = null;
                break;
        }
        advance();
        return T;
    }

    Token makeWord() {
        Token T = null;
        String word = "";
        while (Token.LETTERS.contains(String.valueOf(currentChar))) {
            word += currentChar;
            advance();
        }

        if (Token.KEYWORDS.contains(word)) {
            T = new Token(Token.KEYWORD);
            T.name = word;
            return T;
        }

        T = new Token(Token.IDENTIFIER);
        T.name = word;
        return T;

    }

}
