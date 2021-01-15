import java.util.ArrayList;

class Derivative {

    public static void main(String[] args) {

        String test = "sin(x^2)";

        parse(test);

    }

    static void parse(String text) {
        Lexer L = new Lexer(text);
        L.interprete();
        //printTokens(L.Tokens);

        Parser P = new Parser(L.Tokens);
        Node res = P.parse();

        Analyzer A = new Analyzer(res, "x");
        Node deriv = A.analyze();

        System.out.println("function");
        System.out.println(res + "\n");
        System.out.println("deriv");
        System.out.println(deriv);

    }

    static void printTokens(ArrayList<Token> L) {
        for (Token T : L) {
            System.out.println(T);
        }
    }
}