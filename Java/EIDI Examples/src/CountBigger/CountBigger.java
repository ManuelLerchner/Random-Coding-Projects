package CountBigger;

public class CountBigger {

	static int count(int[] unsorted) {
		int result = 0;

		for (int i = 0; i < unsorted.length; i++) {
			int curr = unsorted[i];

			for (int j = i + 1; j < unsorted.length; j++) {
				if (curr > unsorted[j]) {
					result++;
				}
			}

		}
		return result;

	}

}
