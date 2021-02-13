import java.util.ArrayList;

class Derivative {

    public static void main(String[] args) {

        String test = "3*(x-2)^3";

        parse(test);

    }

    static void parse(String text) {

        Lexer L = new Lexer(text);
        L.interprete();
        // printTokens(L.Tokens);

        Parser P = new Parser(L.Tokens);
        Node res = P.parse();

        System.out.println("function");
        System.out.println(text);
        System.out.println(res);

        Simplifier SI = new Simplifier(res);
        res = SI.simplify();

        System.out.println(res + "\n");

        Analyzer A = new Analyzer(res, "x");
        Node deriv = A.analyze();

        System.out.println("deriv");
        System.out.println(deriv + "\n");

        Simplifier S = new Simplifier(deriv);

        Node simpified = S.simplify();

        S = new Simplifier(simpified);

        simpified = S.simplify();

        System.out.println("simplified");
        System.out.println(simpified);

        System.out.println(simpified.prettyPrint());

    }

    static void printTokens(ArrayList<Token> L) {
        for (Token T : L) {
            System.out.println(T);
        }
    }
}