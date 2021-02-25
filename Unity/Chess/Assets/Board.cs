using System.Collections;
using System.Collections.Generic;
using UnityEngine;

using System;
using System.Linq;

public class Board : MonoBehaviour {

    public Piece[,] board = new Piece[8, 8];


    LoadSprites GS;

    public String playerTurn = "White";
    public Piece pieceSelected;



    public List<Move> illegalMoves = new List<Move>();


    bool gameOver;
    bool check;

    void Start() {
        GS = gameObject.GetComponent<LoadSprites>();
        String standard = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq -0 1";
        loadGameStatefromFENString(standard);
        generateIllegalMoves(playerTurn);
    }


    void loadGameStatefromFENString(string fen) {

        String Aufstellung = fen.Split(' ')[0];

        int x = 0, y = 0;
        for (int i = 0; i < Aufstellung.Length; i++) {

            Char chr = Aufstellung[i];


            String type = "";
            String col = Char.IsLower(chr) ? "White" : "Black";

            if (chr == '/') {
                x = 0;
                y++;
                continue;
            }

            if (Char.IsDigit(chr)) {

                x += int.Parse(chr.ToString());
                continue;
            }

            Piece P = null;
            switch (Char.ToLower(chr)) {
                case 'r':
                    P = new Rook(col);
                    type = "Turm";
                    break;
                case 'n':
                    P = new Knigth(col);
                    type = "Pferd";
                    break;
                case 'b':
                    P = new Bishop(col);
                    type = "Läufer";
                    break;
                case 'q':
                    P = new Queen(col);
                    type = "Dame";
                    break;
                case 'k':
                    P = new King(col);
                    type = "König";
                    break;
                case 'p':
                    P = new Pawn(col);
                    type = "Bauer";
                    break;
            }


            P.pos = new Vector2Int(x, y);
            P.sprite = GS.getSprite(col, type);
            board[x, y] = P;
            x++;
        }
    }

    void Update() {

    }


    public Piece getPieceAt(int x, int y) {
        if (isInsideBoard(new Vector2Int(x, y))) {
            return board[x, y];
        }
        return null;

    }

    public Piece getPiece(String type, String col) {
        for (int i = 0; i < 8; i++) {
            for (int j = 0; j < 8; j++) {

                Piece P = getPieceAt(i, j);
                if (P == null) {
                    continue;
                }

                if (P.type == type && P.col == col) {
                    return P;
                }
            }

        }
        return null;
    }





    static public bool isInsideBoard(Vector2Int vec) {
        int x = vec.x;
        int y = vec.y;
        return (x >= 0 && x <= 7) && (y >= 0 && y <= 7);
    }

    public void switchPlayer() {
        if (playerTurn == "White") {
            playerTurn = "Black";
        } else {
            playerTurn = "White";
        }


        generateIllegalMoves(playerTurn);

    }


    public List<Move> generatePseudoLegalMoves(String colToMove) {
        List<Move> possible = new List<Move>();
        for (int i = 0; i < 8; i++) {
            for (int j = 0; j < 8; j++) {
                Piece P = getPieceAt(i, j);
                if (P != null) {
                    if (P.col == colToMove) {
                        P.calcPossibleMoves(this);
                        possible.AddRange(P.possibleMoves);
                        P.possibleMoves.Clear();
                    }
                }
            }
        }
        return possible;
    }


    void generateIllegalMoves(String col) {
        List<Move> pseudoLegal = generatePseudoLegalMoves(col);
        illegalMoves.Clear();

        String enemyCol = col == "Black" ? "White" : "Black";
        Piece myKing = getPiece("König", col);


        foreach (Move moveToVerify in pseudoLegal) {
            makeMove(moveToVerify);
            List<Move> enemyResponses = generatePseudoLegalMoves(enemyCol);

            foreach (Move attack in enemyResponses) {
                if (attack.posEnd == myKing.pos) {
                    //Opponent can captchure King last move is illegal
                    illegalMoves.Add(moveToVerify);
                }
            }

            unMakeMove(moveToVerify);
        }

        //Check
        List<Move> enemyNextMoves = generatePseudoLegalMoves(enemyCol);
        bool isChecked = false;
        foreach (Move attack in enemyNextMoves) {
            if (attack.posEnd == myKing.pos) {
                //Opponent can captchure King last move is illegal
                Debug.Log($"Check for {attack.P.col}");
                Debug.Log($"{attack.P} attacks {myKing}");
                isChecked = true;
            }
            check = isChecked;

        }

        //Checkmate
        if (illegalMoves.Count >= pseudoLegal.Count && check) {
            gameOver = true;
            Debug.Log($"Checkmate for {enemyCol}");
            Debug.Log($"GameOver {enemyCol} wins");
        }

        //Stalemate
        if (illegalMoves.Count >= pseudoLegal.Count && !check) {
            gameOver = true;
            Debug.Log($"Stalemate");
            Debug.Log($"Draw");
        }

    }




    Move prevMove;
    public void makeMove(Move Move) {
        Piece P = Move.P;

        board[Move.posEnd.x, Move.posEnd.y] = P;
        board[P.pos.x, P.pos.y] = null;

        P.pos = Move.posEnd;
        P.hasMoved = true;
        prevMove = P.lastMove;
        P.lastMove = Move;

        if (Move.flag != "") {
            handleEvent(Move);
        }


    }



    void unMakeMove(Move Move) {
        Piece P = Move.P;

        Move MoveReversed = new Move(this, P, Move.posStart);
        makeMove(MoveReversed);

        P.hasMoved = Move.hasMovedBevore;
        P.lastMove = prevMove;
        board[Move.posEnd.x, Move.posEnd.y] = Move.attacked;

        if (Move.flag != "") {
            unHandleEvent(Move);
        }
    }

    Move tempForward;
    Move tempBackward;

    void handleEvent(Move M) {
        String flag = M.flag;

        //Debug.Log("handle " + M);
        if (flag == "RochadeRechts") {
            Move TurmMove = new Move(this, getPieceAt(7, M.P.pos.y), new Vector2Int(5, M.P.pos.y));
            makeMove(TurmMove);
        }

        if (flag == "RochadeLinks") {
            Move TurmMove = new Move(this, getPieceAt(0, M.P.pos.y), new Vector2Int(3, M.P.pos.y));
            makeMove(TurmMove);
        }

        if (flag == "EnPassantRechts" || flag == "EnPassantLinks") {
            Move back = new Move(this, M.P, new Vector2Int(M.P.pos.x, M.posStart.y));
            makeMove(back);
            Move forward = new Move(this, M.P, new Vector2Int(M.P.pos.x, M.posEnd.y));
            makeMove(forward);

            tempForward = forward;
            tempBackward = back;
        }


    }

    void unHandleEvent(Move M) {
        String flag = M.flag;
        //Debug.Log("unhandle   " + M);

        if (flag == "RochadeRechts") {
            Move TurmMove = new Move(this, getPieceAt(5, M.P.pos.y), new Vector2Int(7, M.P.pos.y));
            makeMove(TurmMove);
        }

        if (flag == "RochadeLinks") {
            Move TurmMove = new Move(this, getPieceAt(3, M.P.pos.y), new Vector2Int(0, M.P.pos.y));
            makeMove(TurmMove);
        }

        if (flag == "EnPassantRechts" || flag == "EnPassantLinks") {
            unMakeMove(tempForward);
            unMakeMove(tempBackward);
            Move copy = M;
            copy.flag = "";
            unMakeMove(copy);
        }
    }

    public void Promote(Piece current) {

        if (current.type == "Bauer") {
            if (current.pos.y == 0 || current.pos.y == 7) {
                Piece P = new Queen(current.col);
                P.sprite = GS.getSprite(current.col, "Dame");
                P.pos = current.pos;
                board[current.pos.x, current.pos.y] = P;
            }
        }


    }


}



