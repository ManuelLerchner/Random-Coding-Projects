
public class Interpreter {

    Node root;
    Context context;

    public Interpreter(Node root) {
        this.root = root;
    }

    ////////////////////////////////////////////////////
    ////////////////////////////////////////////////////

    Number interpet(Context context) {
        return visit(root, context);
    }

    ////////////////////////////////////////////////////
    ////////////////////////////////////////////////////

    Number visit(Node N, Context context) {

        if (N.getClass() == BinOpNode.class) {
            return visitBinOpNode((BinOpNode) N, context);
        } else if (N.getClass() == NumberNode.class) {
            return visitNumberNode((NumberNode) N, context);
        } else if (N.getClass() == VarAssignNode.class) {
            return visitVarAssignNode((VarAssignNode) N, context);
        }

        return null;
    }

    ////////////////////////////////////////////////////
    ////////////////////////////////////////////////////

    Number visitNumberNode(NumberNode N, Context context) {
        if (N.isVariable) {
            return context.get(N.name);
        }
        return N.Num;
    }

    ////////////////////////////////////////////////////

    Number visitBinOpNode(BinOpNode N, Context context) {
        return N.eval(visit(N.Left, context), N.operation, visit(N.Right, context));
    }

    ////////////////////////////////////////////////////

    Number visitVarAssignNode(VarAssignNode N, Context context) {

        Number val = visit(N.expr, context);
        String name = N.name;

        context.put(name, val);

        return val;
    }

}
