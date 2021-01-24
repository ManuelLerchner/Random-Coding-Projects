import java.util.ArrayList;
import java.util.Iterator;

public class Stack<T> implements Iterable<T> {

    StackElement<T> prev;

    public Stack() {
        prev = null;
    }

    ////////////////////////////////////////////////
    ////////////////////////////////////////////////
    void push(T val) {
        StackElement<T> el = new StackElement<T>(val, prev);
        prev = el;
    }

    ////////////////////////////////////////////////
    ////////////////////////////////////////////////
    T pop() {
        if (prev != null) {
            StackElement<T> temp = prev;
            prev = temp.prev;
            return temp.val;
        }
        return null;
    }

    ////////////////////////////////////////////////
    ////////////////////////////////////////////////
    T peek() {
        if (prev != null) {
            return prev.val;
        }
        return null;
    }

    ////////////////////////////////////////////////
    ////////////////////////////////////////////////
    boolean isEmpty() {
        return prev == null;
    }

    ////////////////////////////////////////////////
    ////////////////////////////////////////////////
    int search(T val) {
        StackElement<T> temp = prev;
        int index = 1;

        while (temp != null) {
            if (temp.val == val) {
                return index;
            }
            index++;
            temp = temp.prev;
        }
        return -1;
    }

    ////////////////////////////////////////////////
    ////////////////////////////////////////////////
    void addAll(ArrayList<T> list) {
        for (T val : list) {
            push(val);
        }
    }

    ////////////////////////////////////////////////
    ////////////////////////////////////////////////
    ArrayList<T> toArrayList() {
        ArrayList<T> out = new ArrayList<T>();
        StackElement<T> temp = prev;

        while (temp != null) {
            out.add(temp.val);
            temp = temp.prev;
        }
        return out;
    }

    ////////////////////////////////////////////////
    ////////////////////////////////////////////////
    public Iterator<T> iterator() {

        return new Iterator<T>() {
            StackElement<T> temp = prev;

            public boolean hasNext() {
                return temp != null;
            }

            public T next() {
                StackElement<T> out = temp;
                temp = temp.prev;
                return out.val;
            }

        };

    }

}
