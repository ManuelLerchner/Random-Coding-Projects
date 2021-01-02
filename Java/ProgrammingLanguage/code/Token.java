import java.util.HashSet;
import java.util.Arrays;

public class Token {
    static final String PLUS = "PLUS";
    static final String MINUS = "MINUS";
    static final String MUL = "MUL";
    static final String DIV = "DIV";
    static final String LPAR = "LPAR";
    static final String RPAR = "RPAR";
    static final String NUMBER = "NUMBER";

    static final HashSet<String> NUMBERS = new HashSet<String>(
            Arrays.asList(new String[] { "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "9", "." }));

    double value;
    boolean valueSet;
    String type;

    public Token(String type, double value) {
        this.type = type;
        this.value = value;
        valueSet = true;
    }

    public Token(String type) {
        this.type = type;
    }

    public String toString() {
        return type + " " + (valueSet ? Double.toString(value) : "");
    }
}
