public class IntDoubleList {

    IntDoubleListElement head = null;
    IntDoubleListElement tail = null;

    int size;

    IntDoubleList() {

    }

    ////////////////////////////////////////////////
    ////////////////////////////////////////////////

    void append(int info) {
        IntDoubleListElement el = new IntDoubleListElement(info, head, null);

        if (tail == null) {
            tail = el;
        }

        if (head != null) {
            head.next = el;
        }

        head = el;
        size++;
    }

    ////////////////////////////////////////////////
    ////////////////////////////////////////////////

    int size() {
        return size;
    }

    ////////////////////////////////////////////////
    ////////////////////////////////////////////////

    IntDoubleListElement traceBack(int count, IntDoubleListElement start) {
        if (count == 0) {
            return start;
        }
        return traceBack(count - 1, start.prev);
    }

    IntDoubleListElement traceForward(int count, IntDoubleListElement start) {
        if (count == 0) {
            return start;
        }
        return traceForward(count - 1, start.next);
    }

    IntDoubleListElement get(int pos) {
        if (pos < 0 || pos > size() - 1) {
            return null;
        }

        if (pos < size() / 2.0) {
            return traceForward(pos, tail);
        } else {
            return traceBack(size() - 1 - pos, head);
        }

    }

    ////////////////////////////////////////////////
    ////////////////////////////////////////////////

    void remove(int pos) {
        IntDoubleListElement El = get(pos);

        if (El != null) {
            size--;
            if (El.prev == null) {
                El.next.prev = null;
                tail = El.next;
                return;
            }

            if (El.next == null) {
                El.prev.next = null;
                head = El.prev;
                return;
            }

            El.prev.next = El.next;
            El.next.prev = El.prev;

        }
    }

    ////////////////////////////////////////////////
    ////////////////////////////////////////////////

    public String toString() {

        StringBuilder SB = new StringBuilder();
        IntDoubleListElement LE = tail;

        while (LE != null) {
            SB.append(LE);
            if (LE.next != null) {
                SB.append(",");
            }
            LE = LE.next;
        }

        return SB.toString();
    }

    ////////////////////////////////////////////////
    ////////////////////////////////////////////////

    void appendList(IntDoubleList other) {

        head.next = other.tail;
        other.tail.prev = head;

        size += other.size();
        head = other.head;
    }

    ////////////////////////////////////////////////
    ////////////////////////////////////////////////

    boolean isEqual(IntDoubleList other) {

        IntDoubleListElement el1 = tail;
        IntDoubleListElement el2 = other.tail;

        while (el1 != null && el2 != null) {
            if (el1.getInfo() != el2.getInfo()) {
                return false;
            }
            el1 = el1.next;
            el2 = el2.next;
        }

        if (el1 == null ^ el2 == null) {
            return false;
        }

        return true;
    }

    ////////////////////////////////////////////////
    ////////////////////////////////////////////////

    int sum() {
        IntDoubleListElement el = tail;
        int sum = 0;
        while (el != null) {
            sum += el.getInfo();
            el = el.next;
        }
        return sum;
    }

    ////////////////////////////////////////////////
    ////////////////////////////////////////////////

    IntDoubleList copy() {
        IntDoubleList N = new IntDoubleList();

        IntDoubleListElement el = tail;
        while (el != null) {
            N.append(el.getInfo());
            el = el.next;
        }
        return N;
    }
}
