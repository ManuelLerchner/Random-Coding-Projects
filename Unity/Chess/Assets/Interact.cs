using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class Interact : MonoBehaviour {

    Board Board;
    GameController GC;

    public Canvas c;
    HUD HUD;


    void Start() {
        Board = gameObject.GetComponent<Board>();
        GC = gameObject.GetComponent<GameController>();
        HUD = c.GetComponent<HUD>();

    }


    void Update() {


        if (Input.GetMouseButtonDown(0)) {

            if (HUD.show) {
                HUD.hideHUD();
                if (Board.gameOver) {
                    Board.reset();
                }
                return;
            }

            Vector3 MousePos = Camera.main.ScreenToWorldPoint(Input.mousePosition);
            Vector2Int BoardPos = getBoardPos(MousePos);

            if (!Board.isInsideBoard(BoardPos)) {
                return;
            }

            //Grab Piece
            if (Board.pieceSelected == null) {

                Piece P = Board.getPieceAt(BoardPos.x, BoardPos.y);


                if (P != null) {

                    if (P.col != Board.playerTurn) {
                        return;
                    }

                    P.selected = true;
                    P.calcPossibleMoves(Board);


                    Board.pieceSelected = P;

                }
                return;
            }

            //Place on same Spot
            if (Board.pieceSelected != null) {
                Piece P = Board.getPieceAt(BoardPos.x, BoardPos.y);
                if (P != null) {
                    if (P.pos == Board.pieceSelected.pos) {

                        Board.pieceSelected.selected = false;
                        Board.pieceSelected = null;
                        return;
                    }
                }
            }



            //Place Piece on Empty spot
            if (Board.pieceSelected != null) {
                if (Board.getPieceAt(BoardPos.x, BoardPos.y) == null) {
                    Move Move = new Move(Board, Board.pieceSelected, BoardPos);

                    Piece Selected = Board.pieceSelected;
                    //Rochade
                    if (Selected.type == "König" && Selected.hasMoved == false) {

                        if (BoardPos == new Vector2Int(Selected.pos.x + 2, Selected.pos.y)) {
                            Move.flag = "RochadeRechts";
                        }

                        if (BoardPos == new Vector2Int(Selected.pos.x - 2, Selected.pos.y)) {
                            Move.flag = "RochadeLinks";
                        }

                    }

                    //PawnTwoForward
                    if (Selected.type == "Bauer" && Selected.hasMoved == false) {
                        if (BoardPos == new Vector2Int(Selected.pos.x, Selected.pos.y == 6 ? 4 : 3)) {
                            Move.flag = "PawnTwoForward";
                        }
                    }

                    //EnPassantRechts
                    if (Selected.type == "Bauer" && Selected.hasMoved) {

                        Piece Rechts = Board.getPieceAt(Selected.pos.x + 1, Selected.pos.y);
                        if (Rechts != null && Rechts.lastMove.flag == "PawnTwoForward") {
                            if (BoardPos == new Vector2Int(Selected.pos.x + 1, Selected.col == "White" ? Selected.pos.y + 1 : Selected.pos.y - 1)) {
                                Move.flag = "EnPassantRechts";
                            }
                        }
                    }

                    //EnPassantLinks
                    if (Selected.type == "Bauer" && Selected.hasMoved) {

                        Piece Rechts = Board.getPieceAt(Selected.pos.x - 1, Selected.pos.y);
                        if (Rechts != null && Rechts.lastMove.flag == "PawnTwoForward") {
                            if (BoardPos == new Vector2Int(Selected.pos.x - 1, Selected.col == "White" ? Selected.pos.y + 1 : Selected.pos.y - 1)) {
                                Move.flag = "EnPassantLinks";
                            }
                        }
                    }





                    if (!Board.pieceSelected.legalMove(Move)) {
                        return;
                    }


                    Board.pieceSelected.selected = false;


                    Board.makeMove(Move);

                    Board.Promote(Board.pieceSelected);

                    Board.pieceSelected = null;
                    Board.switchPlayer();

                    return;
                }
            }




            //Attack
            if (Board.pieceSelected != null) {

                Piece P = Board.getPieceAt(BoardPos.x, BoardPos.y);
                if (P.col != Board.pieceSelected.col) {
                    Move Move = new Move(Board, Board.pieceSelected, BoardPos);
                    if (!Board.pieceSelected.legalMove(Move)) {
                        return;
                    }



                    Board.pieceSelected.selected = false;
                    Board.makeMove(Move);

                    Board.Promote(Board.pieceSelected);
                    Board.pieceSelected = null;
                    Board.switchPlayer();
                    return;
                }
            }

        }
    }


    Vector2Int getBoardPos(Vector3 worldPos) {
        return new Vector2Int(Mathf.RoundToInt(worldPos.x + 3.5f), Mathf.RoundToInt(worldPos.y + 3.5f));
    }
}
