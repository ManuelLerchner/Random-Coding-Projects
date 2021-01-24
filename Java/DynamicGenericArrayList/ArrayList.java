public class ArrayList<T> {

    int index = 0;
    int size = 4;
    T[] arr = (T[]) new Object[size];

    ArrayList() {

    }

    void add(T val) {
        if (index == size) {
            createNew(2 * size);
        }
        arr[index] = val;
        index++;
    }

    void remove(int idx) {
        if (index == size) {
            createNew(2 * size);
        }
        arr[index] = val;
        index++;
    }

    void createNew(int newSize) {

        T[] newArr = (T[]) new Object[newSize];

        for (int i = 0; i < size; i++) {
            newArr[i] = arr[i];
        }

        arr = newArr;
        size = newSize;

    }

    void print() {
        String out = "";
        for (int i = 0; i < index; i++) {
            out += arr[i] + ", ";
        }
        System.out.println(out);
    }

}
