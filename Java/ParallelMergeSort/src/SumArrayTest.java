import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class SumArrayTest {

	@Nested
	class Normal {
		@Test
		void sum() {
			int[] arr = {1, 2, 7, -2, -5};

			assertEquals(1 + 2 + 7 + -2 + -5, SumArray.sum(arr));
		}

		@Test
		void sumSmall() {
			int[] arr = {5, -3};

			assertEquals(5 - 3, SumArray.sum(arr));
		}
	}

	@Nested
	class EndRecursive {
		@Test
		void sum() {
			int[] arr = {1, 2, 7, -2, -5};

			assertEquals(1 + 2 + 7 + -2 + -5, SumArray.sumEndRec(arr));
		}

		@Test
		void sumSmall() {
			int[] arr = {5, -3};

			assertEquals(5 - 3, SumArray.sumEndRec(arr));
		}
	}


}