package RLEncoding;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class RLEncodingTest {

	@Test
	void rlEncode() {

		String text = "aaabbcaa";

		assertEquals("a3b2c1a2", RLEncoding.rlEncode(text));

	}

	@Test
	void rlEncode2() {

		String text = "Hallo Welt, kannst du mich hören";

		assertEquals("H1a1l2o1 1W1e1l1t1,1 1k1a1n2s1t1 1d1u1 1m1i1c1h1 1h1ö1r1e1n1", RLEncoding.rlEncode(text));

	}
}