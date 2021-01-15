import java.util.ArrayList;

public class Lexer {

    char currentChar;
    String text;
    int index;

    ArrayList<Token> Tokens = new ArrayList<Token>();

    public Lexer(String text) {
        this.text = text;
        advance();
    }

    void advance() {

        if (index < text.length()) {
            currentChar = text.charAt(index);
            index++;
        } else {
            currentChar = 0;
        }
    }

    void interprete() {

        while (currentChar != 0) {

            if (Token.numbers.contains("" + currentChar)) {
                Tokens.add(makeNumber());
            } else if (Token.operators.contains("" + currentChar)) {
                Tokens.add(makeOperator());
                advance();
            } else {
                Tokens.add(makeKeyword());
            }

        }
    }

    Token makeNumber() {
        String res = "";
        while (Token.numbers.contains("" + currentChar)) {
            res += currentChar;
            advance();
        }
        return new Token(Token.NUMBER, Float.valueOf(res));
    }

    Token makeOperator() {
        switch (currentChar) {
            case '+':
                return new Token(Token.PLUS);
            case '-':
                return new Token(Token.MINUS);
            case '*':
                return new Token(Token.MUL);
            case '/':
                return new Token(Token.DIV);
            case '^':
                return new Token(Token.POW);
            case '(':
                return new Token(Token.LPAR);
            case ')':
                return new Token(Token.RPAR);
        }

        return null;

    }

    Token makeKeyword() {
        String res = "";
        while (Token.letters.contains("" + currentChar)) {
            res += currentChar;
            advance();
        }

        if (Token.keywords.contains(res)) {
            return new Token(Token.KEYWORD, res);
        }

        return new Token(Token.VAR, res);
    }

}
