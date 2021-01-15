import java.util.Scanner;

class GetUserInput {

    Scanner in;

    public GetUserInput() {
        in = new Scanner(System.in);
    }

    String get() {

        System.out.print("\nEnter expression:\n>>>  ");

        return in.nextLine();

    }

}
