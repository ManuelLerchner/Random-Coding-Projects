import java.util.Arrays;

public class Buffer {


	final int[] buffer;


	int cap, free, first, last;

	public Buffer(int n) {
		free = cap = n;
		first = last = 0;
		buffer = new int[n];
	}


	public synchronized void produce(int i) throws InterruptedException {
		while (free == 0) {
			System.out.println(Thread.currentThread().getName() + " producer wait");
			wait();
			System.out.println(Thread.currentThread().getName() + " producer wake up");
		}
		buffer[last] = i;
		last = (last + 1) % cap;
		free--;
		notifyAll();

		Thread.sleep(1000);
	}

	public synchronized int consume() throws InterruptedException {
		while (free == cap) {
			System.out.println(Thread.currentThread().getName() + " consumer wait");
			wait();
			System.out.println(Thread.currentThread().getName() + " consumer wake up");
		}
		var res = buffer[first];
		first = (first + 1) % cap;
		free++;
		notifyAll();

		Thread.sleep(1000);
		return res;
	}
}
