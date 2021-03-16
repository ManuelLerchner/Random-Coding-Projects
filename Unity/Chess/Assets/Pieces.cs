using UnityEngine;
using System.Collections.Generic;

public class Piece {

    public string col, type;
    public bool selected;

    public Vector2Int pos;
    public Sprite sprite;

    protected Vector2Int[] moveVectors;
    protected bool extendMoveDir;

    public bool hasMoved;

    public List<Move> possibleMoves = new List<Move>();

    public Move lastMove;

    public override string ToString() => $"{col} {type} at {pos}";

    virtual public void calcPossibleMoves(Board Board) {
        possibleMoves.Clear();
        foreach (Vector2Int moveVec in moveVectors) {

            if (extendMoveDir) {
                //Add Extended Move Vectors
                Vector2Int possible = pos + moveVec;
                while (Board.isInsideBoard(possible)) {

                    Piece P = Board.getPieceAt(possible.x, possible.y);
                    Move Move = new Move(Board, this, possible);
                    if (P != null) {
                        if (P.col == col) {
                            break;
                        } else {
                            if (Board.illegalMoves.Contains(Move)) {
                                return;
                            }
                            possibleMoves.Add(Move);
                            break;
                        }
                    }

                    if (Board.illegalMoves.Contains(Move)) {
                        possible += moveVec;
                        continue;
                    }
                    possibleMoves.Add(Move);
                    possible += moveVec;
                }


            } else {
                //Add Normal Move Vectors
                Vector2Int possible = pos + moveVec;
                if (Board.isInsideBoard(possible)) {
                    Piece P = Board.getPieceAt(possible.x, possible.y);
                    Move Move = new Move(Board, this, possible);
                    if (P != null) {
                        if (P.col == col) {  // Nicht Teammates angreifen
                            continue;
                        } else if (type == "Bauer" && moveVec.x == 0) {
                            continue;       // Bauer nicht grade angreifen
                        }
                    } else if (type == "Bauer" && moveVec.x != 0) {
                        continue; // Bauer nicht schräg laufen
                    }

                    if (Board.illegalMoves.Contains(Move)) {
                        continue;
                    }

                    possibleMoves.Add(Move);
                }
            }


        }

    }



    public bool legalMove(Move target) {
        return possibleMoves.Contains(target);
    }

    public void calcMoveVector(Vector2Int[] moves, bool flipY) {
        moveVectors = new Vector2Int[moves.Length];
        for (int i = 0; i < moves.Length; i++) {
            Vector2Int result = new Vector2Int(moves[i].x, flipY ? -moves[i].y : moves[i].y);
            moveVectors[i] = result;
        }

    }
}




public class Pawn : Piece {

    public Pawn(string col) {
        base.col = col;
        base.type = "Bauer";
        base.calcMoveVector(new Vector2Int[]{
            new Vector2Int(0,1),
            new Vector2Int(-1,1),
            new Vector2Int(1,1),
        }, col == "Black");
    }

    override public void calcPossibleMoves(Board Board) {
        //PawnTwoForward
        base.calcPossibleMoves(Board);

        if (!hasMoved) {
            Piece Infront = Board.getPieceAt(pos.x, pos.y == 6 ? 5 : 2);
            Piece twoInfront = Board.getPieceAt(pos.x, pos.y == 6 ? 4 : 3);
            if (Infront == null && twoInfront == null) {
                Move M = new Move(Board, this, new Vector2Int(pos.x, pos.y == 6 ? 4 : 3), "PawnTwoForward");
                if (Board.illegalMoves.Contains(M)) {
                    return;
                }
                possibleMoves.Add(M);
            }
        }

        //EnPassantLeft
        if (Board.isInsideBoard(new Vector2Int(pos.x - 1, pos.y))) {
            Piece Left = Board.getPieceAt(pos.x - 1, pos.y);
            if (Left != null && Left.hasMoved) {
                if (Left.type == "Bauer" && Left.lastMove.flag == "PawnTwoForward") {
                    Move M = new Move(Board, this, new Vector2Int(pos.x - 1, col == "White" ? pos.y + 1 : pos.y - 1), "EnPassantLinks");
                    if (Board.illegalMoves.Contains(M)) {
                        return;
                    }
                    possibleMoves.Add(M);
                }
            }
        }

        //EnPassantRight
        if (Board.isInsideBoard(new Vector2Int(pos.x + 1, pos.y))) {
            Piece Right = Board.getPieceAt(pos.x + 1, pos.y);
            if (Right != null && Right.hasMoved) {
                if (Right.type == "Bauer" && Right.lastMove.flag == "PawnTwoForward") {
                    Move M = new Move(Board, this, new Vector2Int(pos.x + 1, col == "White" ? pos.y + 1 : pos.y - 1), "EnPassantRechts");
                    if (Board.illegalMoves.Contains(M)) {
                        return;
                    }
                    possibleMoves.Add(M);
                }
            }
        }



    }

}

public class Rook : Piece {

    public Rook(string col) {
        base.col = col;
        base.type = "Turm";
        base.calcMoveVector(new Vector2Int[]{
            new Vector2Int(0,1),
            new Vector2Int(0,-1),
            new Vector2Int(1,0),
            new Vector2Int(-1,0),
        }, col == "Black");
        base.extendMoveDir = true;
    }

}
public class Knigth : Piece {

    public Knigth(string col) {
        base.col = col;
        base.type = "Pferd";
        base.calcMoveVector(new Vector2Int[]{
            new Vector2Int(1,2),
            new Vector2Int(1,-2),
            new Vector2Int(-1,2),
            new Vector2Int(-1,-2),
            new Vector2Int(2,1),
            new Vector2Int(2,-1),
            new Vector2Int(-2,1),
            new Vector2Int(-2,-1),

        }, col == "Black");
    }

}
public class Bishop : Piece {

    public Bishop(string col) {
        base.col = col;
        base.type = "Läufer";
        base.calcMoveVector(new Vector2Int[]{
            new Vector2Int(1,1),
            new Vector2Int(1,-1),
            new Vector2Int(-1,1),
            new Vector2Int(-1,-1),
        }, col == "Black");
        base.extendMoveDir = true;
    }

}
public class Queen : Piece {

    public Queen(string col) {
        base.col = col;
        base.type = "Dame";
        base.calcMoveVector(new Vector2Int[]{
            new Vector2Int(1,1),
            new Vector2Int(1,-1),
            new Vector2Int(-1,1),
            new Vector2Int(-1,-1),
            new Vector2Int(0,1),
            new Vector2Int(0,-1),
            new Vector2Int(1,0),
            new Vector2Int(-1,0),
        }, col == "Black");
        base.extendMoveDir = true;
    }
}

public class King : Piece {

    public King(string col) {
        base.col = col;
        base.type = "König";
        base.calcMoveVector(new Vector2Int[]{
            new Vector2Int(1,1),
            new Vector2Int(1,-1),
            new Vector2Int(-1,1),
            new Vector2Int(-1,-1),
            new Vector2Int(0,1),
            new Vector2Int(0,-1),
            new Vector2Int(1,0),
            new Vector2Int(-1,0),
        }, col == "Black");
    }


    override public void calcPossibleMoves(Board Board) {

        //Rochade
        base.calcPossibleMoves(Board);
        if (!hasMoved) {

            Piece TurmRechts = Board.getPieceAt(7, pos.y);
            Piece TurmLinks = Board.getPieceAt(0, pos.y);

            if (TurmRechts != null && !TurmRechts.hasMoved) {

                bool allClear = true;
                for (int i = 5; i <= 6; i++) {
                    Piece Spots = Board.getPieceAt(i, pos.y);
                    if (Spots != null) {
                        allClear = false;
                    }
                    Move M = new Move(Board, this, new Vector2Int(i, pos.y));
                    if (Board.illegalMoves.Contains(M)) {
                        allClear = false;
                    }
                }
                if (allClear) {
                    Move M = new Move(Board, this, new Vector2Int(pos.x + 2, pos.y), "RochadeRechts");
                    if (Board.illegalMoves.Contains(M)) {
                        return;
                    }
                    possibleMoves.Add(M);
                }

            }

            if (TurmLinks != null && !TurmLinks.hasMoved) {
                bool allClear = true;
                for (int i = 1; i <= 3; i++) {
                    Piece Spots = Board.getPieceAt(i, pos.y);
                    if (Spots != null) {
                        allClear = false;
                    }
                    Move M = new Move(Board, this, new Vector2Int(i, pos.y));
                    if (Board.illegalMoves.Contains(M)) {
                        allClear = false;
                    }
                }

                if (allClear) {
                    Move M = new Move(Board, this, new Vector2Int(pos.x - 2, pos.y), "RochadeLinks");
                    if (Board.illegalMoves.Contains(M)) {
                        return;
                    }
                    possibleMoves.Add(M);
                }

            }




        }
    }



}