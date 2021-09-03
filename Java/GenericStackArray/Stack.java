
import java.util.ArrayList;
import java.util.Iterator;

public class Stack<T> implements Iterable<T> {

    T[] stack;
    int size;

    int index = 0;

    Stack() {
        stack = (T[]) new Object[4];
        size = 4;
    }

    Stack(int initialSize) {
        stack = (T[]) new Object[initialSize];
        size = initialSize;
    }

    void push(T obj) {

        if (index >= size) {
            increaseSize();
        }

        stack[index] = obj;
        index++;
    }

    T pop() {

        if (index <= 0) {
            return null;
        }

        if (index < size / 2) {
            shrinkSize();
        }

        index -= 1;
        return stack[index];
    }

    void increaseSize() {
        int newSize = size * 2;
        T[] newStack = (T[]) new Object[newSize];

        for (int i = 0; i < size; i++) {
            newStack[i] = stack[i];
        }

        stack = newStack;
        size = newSize;
    }

    void shrinkSize() {
        int newSize = size / 2;
        T[] newStack = (T[]) new Object[newSize];

        for (int i = 0; i < newSize; i++) {
            newStack[i] = stack[i];
        }

        stack = newStack;
        size = newSize;
    }

    public Iterator<T> iterator() {

        return new Iterator<T>() {

            int iterIndex = 0;

            public boolean hasNext() {
                return iterIndex < index;
            }

            public T next() {
                T out = stack[iterIndex];
                iterIndex++;
                return out;
            }

        };

    }
}