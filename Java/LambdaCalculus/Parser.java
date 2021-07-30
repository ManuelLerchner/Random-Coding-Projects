import java.util.ArrayList;

public class Parser {

    ArrayList<Token> Tokens;
    Token currentToken;
    int idx=-1;

    Parser(ArrayList<Token> Tokens){
        this.Tokens=Tokens;
        advanceToken();
    }

    void advanceToken(){
        idx++;
        if(idx<Tokens.size()){
            currentToken=Tokens.get(idx);
        }else{
            currentToken=null;
        }
    }

    Node parse(){
        return asignment();
    }
    

    Node asignment(){
            
        Node A=expression();

        advanceToken();
        if(currentToken!=null){
            if(currentToken.type=="EQ"){
                advanceToken();
                Node expr=expression();
                
                return new AsignmentNode((NameNode)A,expr);
            }
        }

        return A;
        

    }

    Node expression(){


        if(currentToken.type =="Lambda"){
            return function();
        }


        if(currentToken.type=="LPAR"){
            return application();
        }


        return new NameNode(currentToken.value);
    
        
    }

    FunctionNode function(){
        FunctionNode N=null;
        advanceToken();  //from Lambda

        if(currentToken.type=="Name"){
            NameNode Name=new NameNode(currentToken.value);
            advanceToken();
            advanceToken();
                
    
            Node expr=expression();
            advanceToken();
            N= new FunctionNode(Name,expr);
        }

        return N;

    }

    
    Node application(){
        advanceToken();

        ApplicationNode N=null;

        Node A=expression();
    
        advanceToken();

        Node B=expression();
        N=new ApplicationNode(A,B);

        advanceToken();


        return N;
    }


}
