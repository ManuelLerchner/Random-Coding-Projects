public class Diamond {

	public static void main(String[] args) {


		char input = 'D';

		int count = 0;

		int maxLengh = input - 'A';

		for (int i = 'A'; i < input; i++) {

			for (int j = 0; j < maxLengh - (i - 'A'); j++) {
				System.out.print(" ");
			}

			if (i > 'A') {
				System.out.print((char) i);
			}

			for (int j = 0; j < 2*(count-1)+1; j++) {
				System.out.print(".");
			}

			count++;

			System.out.println((char) i);
		}

		for (int i = input; i >= 'A'; i--) {

			for (int j = 0; j < maxLengh - (i - 'A'); j++) {
				System.out.print(" ");
			}

			if (i > 'A') {
				System.out.print((char) i);
			}

			for (int j = 0; j < 2*(count-1)+1; j++) {
				System.out.print(".");
			}

			count--;

			System.out.println((char) i);
		}

	}
}
