package FindMax;

import org.junit.jupiter.api.Order;

import java.util.ArrayList;

public class FindMax extends Thread {

	private final boolean isMaster;
	private final int start;
	private final int size;
	private final int[] data;

	public int max = Integer.MIN_VALUE;


	public FindMax(int[] data, int size) {
		this.isMaster = true;
		this.start = 0;
		this.size = size;
		this.data = data;
	}

	public FindMax(int[] data, int start, int size) {
		this.isMaster = false;
		this.start = start;
		this.size = size;
		this.data = data;
	}

	@Override
	public void run() {
		if (isMaster) {
			ArrayList<FindMax> slaves = new ArrayList<>();

			int i = 0;
			for (; i < data.length; i += size) {
				slaves.add(new FindMax(data, i, size));
			}

			if (i > data.length) {
				slaves.add(new FindMax(data, i - size, data.length - (i - size)));
			}

			for (var slave : slaves) {
				slave.start();
			}

			try {
				for (var slave : slaves) {
					slave.join();
				}
			} catch (Exception ignored) {
			}


			for (var slave : slaves) {
				max = Math.max(max, slave.max);
			}

		} else {
			for (int i = 0; i < data.length; i++) {
				max = Math.max(max, data[i]);
			}
		}
	}
}
