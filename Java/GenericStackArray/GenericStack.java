
public class GenericStack {

    public static void main(String[] aStrings) {

        Stack<String> S = new Stack<String>();

        S.push("1");
        S.push("2");
        S.push("3");
        S.push("4");
        S.push("5");

        for (String s : S) {
            System.out.println(s);
        }

        System.out.println("---------");

        S.pop();
        S.pop();
        S.pop();
        S.pop();
        S.push("z");
        S.pop();

        for (String s : S) {
            System.out.println(s);
        }

        System.out.println("---------");

        S.push("a");

        for (String s : S) {
            System.out.println(s);
        }

    }
}