import java.util.ArrayList;

public class Lexer {



    public ArrayList<Token> parseInteractively(String str){
        System.out.println(">>"+str);
        return parse(str);
    }

    public ArrayList<Token> parse(String str){
    
        ArrayList<Token> tokens = new ArrayList<Token>();

        for (int i = 0; i <str.length(); i++){
            char c =str.charAt(i);


            if(c=='λ'){
                tokens.add(new Token("Lambda",""));
                continue;
            }
            if(c=='.'){
                tokens.add(new Token("Dot",""));
                continue;
            }

            if(c=='('){
                tokens.add(new Token("LPAR",""));
                continue;
            }
            if(c==')'){
                tokens.add(new Token("RPAR",""));
                continue;
            }
            if(c=='='){
                tokens.add(new Token("EQ",""));
                continue;
            }

            tokens.add(new Token("Name",Character.toString(c)));
    
        }

        return tokens;

    }
    
}

class Token{
    String type="";
    String value="";

    Token(String type, String value){
        this.type = type;
        this.value = value;
    }

    public String toString(){
        return type + (value!=""?(": " + value):"");
    }
}
