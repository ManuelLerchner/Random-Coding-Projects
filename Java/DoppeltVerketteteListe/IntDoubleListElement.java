public class IntDoubleListElement {

    private int info;
    public IntDoubleListElement next;
    public IntDoubleListElement prev;

    IntDoubleListElement(int info, IntDoubleListElement prev, IntDoubleListElement next) {
        this.info = info;
        this.next = next;
        this.prev = prev;
    }

    public String toString() {
        return String.valueOf(info);
    }

    int getInfo(){
        return info;
    }
}
