using UnityEngine;

namespace Chess.Game {
    public class BoardUI : MonoBehaviour {
        public Color lightCol, darkCol;

        MeshRenderer[,] squareRenderers;
        SpriteRenderer[,] squarePieceRenderers;
        public PieceSprites Sprites;


        Board board;

        void Start() {
            CreateBoardUI();
            board = new Board();
        }

        void Update() {
            UpdatePosition(board);
        }

        void CreateBoardUI() {
            Shader squareShader = Shader.Find("Unlit/Color");
            squareRenderers = new MeshRenderer[8, 8];
            squarePieceRenderers = new SpriteRenderer[8, 8];

            for (int rank = 0; rank < 8; rank++) {
                for (int file = 0; file < 8; file++) {
                    // Create square
                    Transform square = GameObject.CreatePrimitive(PrimitiveType.Quad).transform;
                    square.parent = transform;
                    square.position = PositionFromCoord(file, rank, 0);

                    squareRenderers[file, rank] = square.gameObject.GetComponent<MeshRenderer>();
                    Material squareMaterial = new Material(squareShader);
                    squareRenderers[file, rank].material = squareMaterial;

                    SetSquareColour(file, rank, lightCol, darkCol);

                    // Create piece sprite renderer for current square
                    SpriteRenderer pieceRenderer = new GameObject("Piece").AddComponent<SpriteRenderer>();
                    pieceRenderer.transform.parent = square;
                    pieceRenderer.transform.position = PositionFromCoord(file, rank, 0.2f);
                    squarePieceRenderers[file, rank] = pieceRenderer;
                }
            }
        }

        void SetSquareColour(int file, int row, Color lightCol, Color darkCol) {
            squareRenderers[file, row].material.color = (file + row) % 2 == 0 ? lightCol : darkCol;
        }


        public void UpdatePosition(Board board) {
            for (int rank = 0; rank < 8; rank++) {
                for (int file = 0; file < 8; file++) {
                    Coord coord = new Coord(file, rank);
                    int piece = board.Square[coord.x, coord.y];
                    squarePieceRenderers[file, rank].sprite = GetPieceSprite(piece);
                    squarePieceRenderers[file, rank].transform.position = PositionFromCoord(file, rank, -0.1f);
                }
            }

        }



        Sprite GetPieceSprite(int piece) {
            return Sprites.getSprite(false, piece);
        }

        public Vector3 PositionFromCoord(int file, int rank, float depth = 0) {
            return new Vector3(-3.5f + file, -3.5f + rank, depth);
        }
    }
}