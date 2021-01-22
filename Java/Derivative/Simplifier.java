public class Simplifier {

    Node N;

    public Simplifier(Node N) {
        this.N = N;

    }

    Node simplify() {
        Node out = null;
        out=N.simplify();
        
        return out;
    }




}
