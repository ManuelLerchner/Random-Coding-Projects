import java.util.HashMap;

public class Context {

    public HashMap<String, Number> variables = new HashMap<String, Number>();

    Context() {

    }

    public void put(String var, Number N) {
        variables.put(var, N);
    }

    public Number get(String var) {
        return variables.get(var);
    }

}
