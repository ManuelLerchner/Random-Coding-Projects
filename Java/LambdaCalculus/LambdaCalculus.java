import java.util.ArrayList;

public class LambdaCalculus{

    
    public static void main(String[] args) {

        // λ

        Interpreter I=new Interpreter();

        parse(I,"A=λx.x");
        parse(I,"B=λx.λy.y");

        System.out.println(); 

        eval(I,"C=(AB)");
        eval(I,"D=(C2)");

        System.out.println(); 

        eval(I,"E=(D3)");

    }

    static Node parse(Interpreter I,String str){
        //System.out.println(test); 

        Lexer L= new Lexer();
        ArrayList<Token> Tokens=L.parseInteractively(str);
        //System.out.println(Tokens);

        Parser P= new Parser(Tokens);
        Node E=P.parse();
        //System.out.println(E); 


        String result=E.pprint();

        if(!result.equals(str)){
            System.out.println("Failed: got "+ result +" by mistake");
            System.exit(0);
        };

        
        if((""+E.getClass()).equals("class AsignmentNode")){

            I.putVariable((AsignmentNode)E);
        }

        return E;


    }

    static void eval(Interpreter I,String str){
        
        Node E= parse(I,I.eval(str));

        //System.out.println(E);
    }
}