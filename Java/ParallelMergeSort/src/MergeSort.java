public class MergeSort {


	static int[] sort(int[] arr) {
		if (arr.length <= 1) {
			return arr;
		}

		var k = arr.length / 2;
		int[] first = new int[k];
		int[] second = new int[arr.length - k];

		for (int i = 0; i < k; i++) {
			first[i] = arr[i];
		}
		for (int i = k; i < arr.length; i++) {
			second[i - k] = arr[i];
		}

		var firstSorted = sort(first);
		var secondSorted = sort(second);

		return merge(firstSorted, secondSorted);
	}

	public static int[] merge(int[] first, int[] second) {
		int[] out = new int[first.length + second.length];

		int iFirst = 0;
		int iSecond = 0;
		int i = 0;

		while (true) {
			if (iFirst >= first.length) {
				for (int k = iSecond; k < second.length; k++) {
					out[i] = second[iSecond];
					i++;
				}
				return out;
			}

			if (iSecond >= second.length) {
				for (int k = iFirst; k < first.length; k++) {
					out[i] = first[iFirst];
					i++;
				}
				return out;
			}

			if (first[iFirst] > second[iSecond]) {
				out[i] = second[iSecond];
				iSecond++;
			} else {
				out[i] = first[iFirst];
				iFirst++;
			}

			i++;

		}

	}


}
