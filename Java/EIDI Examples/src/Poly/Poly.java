package Poly;

import java.util.LinkedList;
import java.util.List;

public class Poly {


	public static void main(String[] args) {
		A aa = new A();
		A ba = new B();
		B bb = new B();

		System.out.println(aa.a);
		System.out.println(ba.a);
		System.out.println(((A) bb).a);

		List<String> list = new LinkedList<String>();
		list.add("b");
		list.add("a");
		list.add("c");


	}

	private static class A {
		int a = 6;

		public A() {
			a = 5;
		}
	}

	private static class B extends A {
		int a = 2;

		public B() {
			super();
			a = -1;
			super.a = -2;
		}

	}
}
