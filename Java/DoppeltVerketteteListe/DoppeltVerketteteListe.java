
class DoppeltVerketteteListe {

    public static void main(String[] args) {

        IntDoubleList L = new IntDoubleList();

        L.append(1);
        L.append(2);
        L.append(3);
        L.append(4);
        L.append(5);
        L.append(6);
        L.append(7);
        L.append(8);

        System.out.println(L);

        IntDoubleList L1 = new IntDoubleList();

        L1.append(1);
        L1.append(2);
        L1.append(3);
        L1.append(4);
        L1.append(5);
        L1.append(6);
        L1.append(7);
        L1.append(8);

        System.out.println(L1);

        L.appendList(L1);
        System.out.println(L);

    }

}