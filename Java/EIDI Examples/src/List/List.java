package List;


import java.util.function.Predicate;

public class List<T> {
	private final T info;
	private final List next;

	public List(T info, List next) {
		this.info = info;
		this.next = next;
	}

	static <S> List<S> filter(List<S> node, Predicate<S> pred) {
		List<S> result = null;

		List<S> curr = node;

		while (curr != null) {

			if (pred.test(curr.info)) {
				result = new List<S>(curr.info, result);
			}
			curr = curr.next;
		}

		return result;
	}

	@Override
	public String toString() {
		String res = "";

		res += info + ", ";
		if (next != null) {
			res += next.toString();
		}
		return res;
	}
}
