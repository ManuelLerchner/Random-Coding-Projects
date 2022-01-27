public class BufferSimple extends Buffer {


	public BufferSimple(int n) {
		super(n);
	}


	@Override
	public synchronized void produce(int i) throws InterruptedException {
		if (free == 0) {
			System.out.println(Thread.currentThread().getName() + " producer wait");
			wait();
			System.out.println(Thread.currentThread().getName() + " producer wake up");
		}
		buffer[last] = i;
		last = (last + 1) % cap;
		free--;
		notify();

		Thread.sleep(1000);
	}

	@Override
	public synchronized int consume() throws InterruptedException {
		if (free == cap) {
			System.out.println(Thread.currentThread().getName() + " consumer wait");
			wait();
			System.out.println(Thread.currentThread().getName() + " consumer wake up");
		}
		var res = buffer[first];
		first = (first + 1) % cap;
		free++;
		notify();

		Thread.sleep(1000);
		return res;
	}
}
