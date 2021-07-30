public interface Node {

    String toString();
    String pprint();
    
}


class AsignmentNode implements Node{

    NameNode name;
    Node expr;

    AsignmentNode(NameNode name, Node expr){
        this.name = name;
        this.expr=expr;
    }


    public String toString(){
        return "Asignment NameNode: {"+name+" = " + expr+"}";
    }

    public String pprint(){
        return name.pprint()+"=" + expr.pprint();
    }

}

class ExpressionNode implements Node{

    Node N;

    ExpressionNode(NameNode Name){
        this.N = Name;
    }
    ExpressionNode(FunctionNode func){
        this.N = func;
    }
    ExpressionNode(ApplicationNode Application){
        this.N = Application;
    }

    public String toString(){
        return N.toString();
    }
    public String pprint(){
        return N.pprint();
    }

}


class NameNode implements Node{
    String name;
    NameNode(String name){
        this.name = name;

    }
    public String toString(){
        return "NameNode: "+name;
    }
    public String pprint(){
        return name;
    }
}

class FunctionNode implements Node{
    NameNode name;
    Node expr;
    FunctionNode(NameNode name,Node expr){
        this.name=name;
        this.expr=expr; 
    }
    public String toString(){
        return "[FunctionNode: λ("+name+").("+expr.toString()+")]";
    }
    public String pprint(){
        return "λ"+name.pprint()+"."+expr.pprint();
    }

    String evaluate(String str){

        String nm=name.name;

        String result=expr.pprint().replace(nm,str);


        return result;


    }
}


class ApplicationNode implements Node{
    Node A,B;
    ApplicationNode(Node A,Node B){
        this.A=A;
        this.B=B; 
    }
    public String toString(){
        return "ApplicationNode: ("+A.toString()+" "+B.toString()+")";
    }
        public String pprint(){
        return ""+A.pprint()+B.pprint();
    }

}