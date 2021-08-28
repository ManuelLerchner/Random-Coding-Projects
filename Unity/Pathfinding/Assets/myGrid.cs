using UnityEngine;
using System.Collections.Generic;

public class myGrid : MonoBehaviour {

	public GameObject Ground;
    

	Vector2 gridWorldSize;

	void Start() {
		gridWorldSize = new Vector2(Ground.transform.localScale.x, Ground.transform.localScale.z);
		createGrid();
	}



	public LayerMask UnwalkableMask;
	public float nodeRadius;



	public float nodeDiameter;
	public Node[,] grid;


	public int gridLenX, gridLenY;

	Vector3 bottomLeft;






	void createGrid() {
		nodeDiameter = 2 * nodeRadius;
		gridLenX = Mathf.RoundToInt(gridWorldSize.x / nodeDiameter);
		gridLenY = Mathf.RoundToInt(gridWorldSize.y / nodeDiameter);

		grid = new Node[gridLenX, gridLenY];
		bottomLeft = transform.position - Vector3.left * gridWorldSize.x / 2 + Vector3.forward * gridWorldSize.y / 2 + nodeRadius * (Vector3.left + Vector3.back);

		for (int i = 0; i < gridLenX; i++) {
			for (int j = 0; j < gridLenY; j++) {
				Vector3 pos = bottomLeft + nodeDiameter * (Vector3.left * i + Vector3.back * j);
				grid[i, j] = new Node(pos, i, j);
			}
		}
		checkWalkable();
	}


	void Update() {
		checkWalkable();
	}


	void checkWalkable() {
		for (int i = 0; i < gridLenX; i++) {
			for (int j = 0; j < gridLenY; j++) {
				Vector3 pos = bottomLeft + nodeDiameter * (Vector3.left * i + Vector3.back * j);
				grid[i, j].walkable = !Physics.CheckSphere(pos, 1.4f * nodeRadius, UnwalkableMask);
				grid[i, j].color = (grid[i, j].walkable) ? Color.green : Color.red;
			}
		}

	}


	public List<Node> neighbour(Node Center) {
		List<Node> neighbours = new List<Node>();

		for (int i = -1; i <= 1; i++) {
			for (int j = -1; j <= 1; j++) {

				if (!(i == 0 && j == 0)) {

					int posX = Center.x + i;
					int posY = Center.y + j;

					if (posX >= 0 && posX < gridLenX) {
						if (posY >= 0 && posY < gridLenY) {
							neighbours.Add(grid[posX, posY]);
						}
					}
				}
			}
		}

		return neighbours;
	}


	public Node NodeFromPos(Vector3 pos) {
		int testX = Mathf.Clamp(Mathf.FloorToInt(map(-pos.x + gridWorldSize.x / 2, 0, gridWorldSize.x, 0, gridLenX)), 0, gridLenX - 1);
		int testY = Mathf.Clamp(Mathf.FloorToInt(map(-pos.z + gridWorldSize.y / 2, 0, gridWorldSize.y, 0, gridLenY)), 0, gridLenY - 1);
		return grid[testX, testY];
	}


	public float map(float x, float in_min, float in_max, float out_min, float out_max) {
		return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
	}

}
