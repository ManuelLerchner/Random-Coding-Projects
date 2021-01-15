import java.util.ArrayList;
import java.util.Arrays;

public class Token {

    static final String MUL = "MUL";
    static final String DIV = "DIV";
    static final String PLUS = "PLUS";
    static final String MINUS = "MINUS";
    static final String POW = "POW";
    static final String LPAR = "LPAR";
    static final String RPAR = "RPAR";

    static final String KEYWORD = "KEYWORD";
    static final String VAR = "VAR";
    static final String NUMBER = "NUMBER";

    static final String numbers = "01234567890.";
    static final String letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    static final String operators = "+-*/()^";

    static final ArrayList<String> keywords = new ArrayList<String>(Arrays.asList("sin", "cos", "tan", "sqrt", "ln"));

    String type;
    String name;

    float value;

    boolean valueSet;
    boolean nameSet;

    Token(String type, float value) {
        this.type = type;
        this.value = value;
        valueSet = true;
    }

    Token(String type, String name) {
        this.type = type;
        this.name = name;
        nameSet = true;
    }

    Token(String type) {
        this.type = type;
    }

    public String toString() {
        return type + (valueSet ? ": " + value : (nameSet ? ": " + name : ""));
    }
}
