package List;

import org.junit.jupiter.api.Test;

import java.util.function.Predicate;

import static org.junit.jupiter.api.Assertions.*;

class ListTest {

	@Test
	void filter() {

		List<Integer> list = new List<Integer>(5, new List(2, new List(-5, new List(7, new List(33, null)))));

		Predicate<Integer> pred = (i) -> i > 6;


		System.out.println(list);

		System.out.println(List.filter(list, pred));

	}
}