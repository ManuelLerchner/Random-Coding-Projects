using UnityEngine;
using System.Collections.Generic;
using System;

public struct Move {

    public Piece P { get; }
    public Piece attacked { get; }
    public Vector2Int posEnd { get; }
    public Vector2Int posStart { get; }


    public bool hasMovedBevore { get; }
    public string flag { get; set; }

    public Move(Board Board, Piece P, Vector2Int pos) {
        this.P = P;
        this.posEnd = pos;
        this.posStart = P.pos;
        hasMovedBevore = P.hasMoved;
        attacked = Board.getPieceAt(pos.x, pos.y);
        flag = "";
    }

    public Move(Board Board, Piece P, Vector2Int pos, String ev) {
        this.P = P;
        this.posEnd = pos;
        this.posStart = P.pos;
        hasMovedBevore = P.hasMoved;
        attacked = Board.getPieceAt(pos.x, pos.y);
        flag = ev;
    }



    public override string ToString() => $"{P} attacks {posEnd}, flag: {flag}, hasmovedbevore {hasMovedBevore}";



}