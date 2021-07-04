import java.util.ArrayList;
import java.util.HashMap;

public class Interpreter {


    HashMap<String, Node> Memory = new HashMap<String, Node>();



    void putVariable(AsignmentNode N){
        Memory.put(N.name.name,N.expr);
    }

    String eval(String str){

        Lexer L=new Lexer();
        ArrayList<Token>Tokens=L.parse(str);

        //System.out.println(Tokens);

        Parser P= new Parser(Tokens);

        Node G=P.parse();
        Node E=null;

        boolean toAsign=false;
        NameNode NameAsign=null;

        if((""+G.getClass()).equals("class AsignmentNode")){
            toAsign=true;
            NameAsign=((AsignmentNode)G).name;
            E=((AsignmentNode)G).expr;
        }else{
            E=(ApplicationNode)G;
        }



        NameNode Name=(NameNode)((ApplicationNode)E).A;

        Node N=((ApplicationNode)E).B;

        Node Func=Memory.get(Name.name);

        Node O=Memory.get(N.pprint());


        
        String out=null;
        if(O!=null){
            out= ((FunctionNode)Func).evaluate(O.pprint());
        }else{
            out= ((FunctionNode)Func).evaluate(N.pprint());
        }


        if(toAsign){
            putVariable(new AsignmentNode(NameAsign,parse(this,out)));
        }

        return out;



        




    }

    static Node parse(Interpreter I,String str){
        //System.out.println(test); 

        Lexer L= new Lexer();
        ArrayList<Token> Tokens=L.parse(str);
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
    
}
