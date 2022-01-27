import org.junit.jupiter.api.Test;

import java.util.Arrays;

import static org.junit.jupiter.api.Assertions.*;

class ReducerTest {

	@Test
	void reduceExample1() throws InterruptedException {

		int[] array = {1, 2, 3, 4, 5, 6, 7, 8};
		Reducer.reduce(array, (a, b) -> a + b);

		System.out.println(Arrays.toString(array));

		assertArrayEquals(new int[]{36, 2, 7, 4, 26, 6, 15, 8}, array);

		assertEquals(1 + 2 + 3 + 4 + 5 + 6 + 7 + 8, array[0]);
	}

	@Test
	void reduceExample2() throws InterruptedException {

		int[] array = {1, 2, 3, 4};
		Reducer.reduce(array, (a, b) -> a + b);

		System.out.println(Arrays.toString(array));

		assertArrayEquals(new int[]{10, 2, 7, 4}, array);

		assertEquals(1 + 2 + 3 + 4, array[0]);
	}

	@Test
	void reduceExample3() throws InterruptedException {

		int[] array = {1, 2, 3, 4, 5, 6, 7, 8};
		Reducer.reduce(array, (a, b) -> a * b);

		System.out.println(Arrays.toString(array));

		assertArrayEquals(new int[]{40320, 2, 12, 4, 1680, 6, 56, 8}, array);

		assertEquals(8 * 7 * 6 * 5 * 4 * 3 * 2, array[0]);
	}
}