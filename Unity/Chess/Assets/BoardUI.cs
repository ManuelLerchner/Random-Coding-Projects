using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class BoardUI : MonoBehaviour {

    MeshRenderer[,] MR = new MeshRenderer[8, 8];
    SpriteRenderer[,] SR = new SpriteRenderer[8, 8];

    public Color colWhite, colBlack, colBackground, colGreen, colPrecomputed;

    Board Board;
    GameController GC;

    void Start() {

        Board = gameObject.GetComponent<Board>();
        GC = gameObject.GetComponent<GameController>();

        Shader s = Shader.Find("Unlit/Color");

        //Background
        GameObject bg = GameObject.CreatePrimitive(PrimitiveType.Quad);
        bg.name = "bg";
        bg.transform.parent = transform;
        bg.transform.localScale = Vector3.one * 8f;
        bg.transform.position = Vector3.forward * 0.1f;

        Material squareMaterial = new Material(s);
        bg.GetComponent<MeshRenderer>().material = squareMaterial;
        bg.GetComponent<MeshRenderer>().material.color = colBackground;

        for (int i = 0; i < 8; i++) {
            for (int j = 0; j < 8; j++) {
                ///Grid
                GameObject square = GameObject.CreatePrimitive(PrimitiveType.Quad);

                square.transform.parent = transform;
                square.transform.position = PositionFromCoord(i, j);
                square.transform.localScale = Vector3.one * 0.98f;

                square.GetComponent<MeshRenderer>().material = squareMaterial;

                MR[i, j] = square.GetComponent<MeshRenderer>();

                //Grid
                GameObject Piece = new GameObject();
                Piece.AddComponent<SpriteRenderer>();
                Piece.name = "Piece";

                Piece.transform.parent = transform;
                Piece.transform.position = PositionFromCoord(i, j) + Vector3.back * 0.1f;

                SR[i, j] = Piece.GetComponent<SpriteRenderer>();

            }
        }


    }


    Vector3 PositionFromCoord(int file, int rank) {
        return Vector2.up * (rank - 3.5f) + Vector2.right * (file - 3.5f);
    }


    Sprite getSpriteAt(int file, int rank) {
        Piece P = Board.board[file, rank];
        if (P != null) {
            return P.sprite;
        } else {
            return null;
        }
    }


    void Update() {
        showGrid();
        showSprites();
        movePieces();
    }



    void showSprites() {
        for (int i = 0; i < 8; i++) {
            for (int j = 0; j < 8; j++) {
                SpriteRenderer Piece = SR[i, j];
                Sprite Sprite = getSpriteAt(i, j);
                Piece.sprite = Sprite;
                Piece.transform.localScale = Vector3.one;
            }
        }
    }

    void movePieces() {
        for (int i = 0; i < 8; i++) {
            for (int j = 0; j < 8; j++) {
                if (Board.board[i, j] != null) {
                    if (Board.board[i, j].selected) {
                        Vector3 pos = Camera.main.ScreenToWorldPoint(Input.mousePosition);
                        pos.z = -1f;
                        SR[i, j].transform.position = pos;
                        SR[i, j].transform.localScale = Vector3.one * 1.2f;
                        showPossibleMoves(Board.board[i, j].possibleMoves);
                    } else {
                        Vector3 pos = PositionFromCoord(Board.getPieceAt(i, j).pos.x, Board.getPieceAt(i, j).pos.y);
                        pos.z = -0.1f;
                        SR[i, j].transform.position = pos;
                    }
                }
            }
        }
    }


    void showPossibleMoves(List<Move> possibleMoves) {
        foreach (Move possible in possibleMoves) {
            MR[possible.posEnd.x, possible.posEnd.y].material.color = colGreen;
        }
    }




    void showGrid() {
        for (int i = 0; i < 8; i++) {
            for (int j = 0; j < 8; j++) {
                MR[i, j].material.color = (i + j) % 2 == 1 ? colWhite : colBlack;
            }
        }
    }
}


