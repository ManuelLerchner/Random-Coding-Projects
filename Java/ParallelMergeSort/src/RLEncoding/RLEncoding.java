package RLEncoding;

public class RLEncoding {

	static String rlEncode(String text) {
		String result = "";

		for (int i = 0; i < text.length(); i++) {
			var currChar = text.charAt(i);

			int count = 0;
			while (count + i < text.length() && text.charAt(i + count) == currChar) {
				count++;
			}

			result += "" + currChar + count;

			i += count - 1;
		}

		return result;
	}
}
