public class SumArray {

	static int sum(int[] arr) {
		return sumRecursive(arr, 0);
	}

	static int sumEndRec(int[] arr) {
		return sumEndRecursive(arr, 0, 0);
	}

	private static int sumRecursive(int[] arr, int i) {
		if (i >= arr.length) {
			return 0;
		}

		return arr[i] + sumRecursive(arr, i + 1);
	}

	private static int sumEndRecursive(int[] arr, int i, int acc) {
		if (i >= arr.length) {
			return acc;
		}

		return sumEndRecursive(arr, i + 1, acc + arr[i]);
	}
}
