package MergeSort;

import MergeSort.MergeSort;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import java.util.Arrays;

import static org.junit.jupiter.api.Assertions.assertEquals;


class MergeSortTest {


	@Nested
	class Normal {


		@Test
		void sort() {

			int[] arr = {54, 26, 93, 17, 77, 31, 44, 55, 20};

			var res = MergeSort.sort(arr);


			System.out.println(Arrays.toString(res));
			assertEquals(Arrays.toString(res), "[17, 20, 26, 31, 44, 54, 55, 77, 93]");
		}

		@Test
		void smallSort() {

			int[] arr = {2, 1};

			var res = MergeSort.sort(arr);


			System.out.println(Arrays.toString(res));
			assertEquals("[1, 2]", Arrays.toString(res));
		}



	}

	@Nested
	class Parallel {

		@Test
		void sort() {

			int[] arr = {54, 26, 93, 17, 77, 31, 44, 55, 20};

			var res = MergeSortParallel.sort(arr);


			System.out.println(Arrays.toString(res));
			assertEquals(Arrays.toString(res), "[17, 20, 26, 31, 44, 54, 55, 77, 93]");
		}

		@Test
		void smallSort() {

			int[] arr = {2, 1};

			var res = MergeSortParallel.sort(arr);


			System.out.println(Arrays.toString(res));
			assertEquals("[1, 2]", Arrays.toString(res));
		}


	}
}