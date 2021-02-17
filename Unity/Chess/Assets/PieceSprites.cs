using UnityEngine;

namespace Chess.Game {
    public class PieceSprites : MonoBehaviour {
        public Sprite pawnW, rookW, knightW, bishopW, queenW, kingW;
        public Sprite pawnS, rookS, knightS, bishopS, queenS, kingS;

        public Sprite getSprite(bool black, int i) {

            if (black) {
                return new Sprite[] { null, pawnS, rookS, knightS, bishopS, queenS, kingS }[i];
            } else {
                return new Sprite[] { null, pawnW, rookW, knightW, bishopW, queenW, kingW }[i];
            }

        }
    }
}