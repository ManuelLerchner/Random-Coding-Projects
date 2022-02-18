package CountBigger;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class CountBiggerTest {

	@Test
	void count() {

		int[] arr = {2, 3, 0, 1};

		assertEquals(4, CountBigger.count(arr));
	}


	@Test
	void count2() {

		int[] arr = {3, 2, 1, 0, -1, 0, 0, 0, 0};

		assertEquals(8 + 7 + 6 + 1 + 0, CountBigger.count(arr));
	}
}