package MergeSort;

public class MergeSortParallel implements Runnable {

	int[] arr;
	int[] res;

	public MergeSortParallel(int[] arr) {
		this.arr = arr;
	}

	public static int[] sort(int[] arr) {


		var sorter = new MergeSortParallel(arr);
		var thread = new Thread(sorter);
		thread.start();

		try {
			thread.join();
		} catch (InterruptedException ignored) {
		}

		return sorter.res;

	}


	@Override
	public void run() {
		if (arr.length <= 1) {
			res = arr;
			return;
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


		var firstSorter = new MergeSortParallel(first);
		var secondSorter = new MergeSortParallel(second);


		var threadA = new Thread(firstSorter);
		var threadB = new Thread(secondSorter);

		threadA.start();
		threadB.start();

		try {
			threadA.join();
			threadB.join();
		} catch (InterruptedException ignored) {

		}

		var firstSorted = firstSorter.res;
		var secondSorted = secondSorter.res;

		res = MergeSort.merge(firstSorted, secondSorted);
	}

}