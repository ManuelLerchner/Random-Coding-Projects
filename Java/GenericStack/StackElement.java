public class StackElement<T> {

    T val;
    StackElement<T> prev;

    StackElement(T val, StackElement<T> prev) {
        this.val = val;
        this.prev = prev;
    }

}
