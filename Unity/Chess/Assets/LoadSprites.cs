using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LoadSprites : MonoBehaviour {

    public Sprite BauerW, TurmW, LäuferW, PferdW, DameW, KönigW;
    public Sprite BauerS, TurmS, LäuferS, PferdS, DameS, KönigS;

    Sprite[] BLACK = new Sprite[8];
    Sprite[] WHITE = new Sprite[8];

    void Awake() {
        BLACK = new Sprite[] { null, BauerS, TurmS, LäuferS, PferdS, DameS, KönigS };
        WHITE = new Sprite[] { null, BauerW, TurmW, LäuferW, PferdW, DameW, KönigW };
    }


    public Sprite getSprite(string col, string type) {
        int idx = 0;
        switch (type) {
            case "Bauer":
                idx = 1;
                break;
            case "Turm":
                idx = 2;
                break;
            case "Läufer":
                idx = 3;
                break;
            case "Pferd":
                idx = 4;
                break;
            case "Dame":
                idx = 5;
                break;
            case "König":
                idx = 6;
                break;
        }
        return (col == "Black") ? BLACK[idx] : WHITE[idx];
    }
}
