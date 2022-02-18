package FindMax;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class FindMaxTest {

	@Test
	void run() throws InterruptedException {

		int[] data = {477, 9, 1, 177, 23};
		FindMax master = new FindMax(data, 2);
		master.start();
		master.join();
		System.out.println(master.max);

		assertEquals(477, master.max);
	}

	@Test
	void run2() throws InterruptedException {

		int[] data = {477, 9, 1, 177, 23, 999};
		FindMax master = new FindMax(data, 2);
		master.start();
		master.join();
		System.out.println(master.max);
		assertEquals(999, master.max);
	}


	@Test
	void run4() throws InterruptedException {

		int[] data = {477, 9, 1, 177, 23, 999};
		FindMax master = new FindMax(data, 10);
		master.start();
		master.join();
		System.out.println(master.max);

		assertEquals(999, master.max);
	}

	@Test
	void run5() throws InterruptedException {

		int[] data = {477, 9, 1, 177, 23, 999};
		FindMax master = new FindMax(data, 1);
		master.start();
		master.join();
		System.out.println(master.max);

		assertEquals(999, master.max);
	}
}