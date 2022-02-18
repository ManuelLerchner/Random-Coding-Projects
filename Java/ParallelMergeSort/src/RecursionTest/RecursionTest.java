package RecursionTest;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class RecursionTest {

	@Test
	void rec() {

		var res = Recursion.rec(6);
		assertEquals(2, res);
	}

	@Test
	void rec2() {

		var res = Recursion.rec(11);
		assertEquals(2, res);
	}
}