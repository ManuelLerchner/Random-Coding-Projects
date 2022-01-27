public class ConsumerProducer {

	public static void main(String[] args) throws InterruptedException {

		Buffer buffer = new Buffer(10);


		for (int i = 0; i < 20; i++) {
			(new Thread(new Producer(buffer))).start();
		}

		for (int i = 0; i < 10; i++) {
			(new Thread(new Consumer(buffer))).start();
		}


		System.out.println("Main thread finished");
	}

	public static class Producer implements Runnable {

		static int i = 0;
		private final Buffer buffer;

		public Producer(Buffer buffer) {
			this.buffer = buffer;
		}

		@Override
		public void run() {


			while (true) {
				try {
					buffer.produce(i);
					System.out.println("produced " + i);
				} catch (InterruptedException e) {
					e.printStackTrace();
				}
				i++;
			}

		}
	}

	public static class Consumer implements Runnable {

		private final Buffer buffer;

		public Consumer(Buffer buffer) {
			this.buffer = buffer;
		}

		@Override
		public void run() {
			while (true) {
				try {
					int r = buffer.consume();
					System.out.println("consumed:" + r);
				} catch (InterruptedException e) {
					e.printStackTrace();
				}
			}

		}
	}


}
