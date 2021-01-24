import java.util.ArrayList;

class GenericStack {

    public static void main(String[] args) {

        Stack<String> S = new Stack<String>();

        S.push("1");
        S.push("2");
        S.push("3");
        S.push("hallo");

        System.out.println(S.toArrayList());

        ArrayList<String> l = new ArrayList<String>();
        l.add("5");
        l.add("6");
        l.add("lol");
        l.add("8");

        S.addAll(l);

        S.pop();

        System.out.println(S.toArrayList());

        for (String i : S) {
            System.out.println(i);
        }

        System.out.println(S.toArrayList());
    }

}