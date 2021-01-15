import java.util.LinkedList;

public class ProgrammingLanguage {

    public static void main(String[] args) {
        GetUserInput G = new GetUserInput();
        Context globalContext = new Context();

        // run("var agfg = 5", globalContext);

        // run("agfg+3", globalContext);

        while (true) {

            String expr = G.get();

            if (expr != "") {
                run(expr, globalContext);
            }

        }

    }

    static void run(String in, Context context) {
        Lexer L = new Lexer(in);
        LinkedList<Token> Tokens = L.interpret();

        // System.out.println(Tokens);

        Parser P = new Parser(Tokens);
        Node N = P.parse();

        // System.out.println(N);

        Interpreter I = new Interpreter(N);
        Number res = I.interpet(context);

        System.out.println(res);

    }
}