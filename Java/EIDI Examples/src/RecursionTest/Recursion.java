package RecursionTest;

public class Recursion {

	static int rec(int pull) {
		System.out.println(pull);

		for (int next = pull - 1; next > 1; next = next - 1) {
			if (next % 2 == 0) {
				return rec(next);
			}
		}
		return pull;
	}
}
