import java.util.LinkedList;

public class ProgrammingLanguage {

    public static void main(String[] args) {
        GetUserInput G = new GetUserInput();

        while (true) {

            String expr = G.get();

            if (expr != "") {
                run(expr);
            }

        }

    }

    static void run(String in) {
        Lexer L = new Lexer(in);
        LinkedList<Token> Tokens = L.interpret();

        // System.out.println(Tokens);

        Parser P = new Parser(Tokens);
        Node N = P.parse();

        Interpreter I = new Interpreter(N);
        Number res = I.interpet();

        System.out.println(res);

    }
}