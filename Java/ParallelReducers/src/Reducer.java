import java.util.function.BiFunction;

//EIDI 2018 Final - Thread Example

public class Reducer extends Thread {
	private int array[];
	private int start;
	private Reducer[] reducers;
	private BiFunction<Integer, Integer, Integer> accumulator;


	public Reducer(int[] array, int start, Reducer[] reducers, BiFunction<Integer, Integer, Integer> accumulator) {
		this.array = array;
		this.start = start;
		this.accumulator = accumulator;
		this.reducers=reducers;
	}

	public static void reduce(int array[], BiFunction<Integer, Integer, Integer> accumulator) throws InterruptedException {
		Reducer[] workers;

		workers = new Reducer[array.length / 2];

		for (int i = 0; i < workers.length; i++) {
			workers[i] = new Reducer(array, i * 2, workers, accumulator);
		}

		for (int i = 0; i < workers.length; i++) {
			workers[i].start();
		}

		workers[0].join();

	}

	@Override
	public void run() {

		int nextThreadDist = 1;
		int nextValueDist = 1;
		int threadDeathModulo = 2;

		while (nextValueDist < array.length) {
			array[start] = accumulator.apply(array[start], array[start + nextValueDist]);

			if (start/2 % threadDeathModulo == 0) {
				try {
					reducers[start/2 + nextThreadDist].join();
				} catch (InterruptedException e) {
					e.printStackTrace();
				}
			} else {
				return;
			}

			nextThreadDist += 1;
			nextValueDist *= 2;
			threadDeathModulo *= 2;
		}

	}
}
