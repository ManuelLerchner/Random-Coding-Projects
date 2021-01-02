import java.util.Scanner;

class GetUserInput {

    Scanner in;

    public GetUserInput() {
        in = new Scanner(System.in);
    }

    String get() {

        System.out.println("\nEnter expression:");

        return in.nextLine();

    }

}
