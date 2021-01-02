using UnityEngine;


public class Node {

	public bool walkable;
	public bool isStart;
	public bool isTarget;

	public Node Parent;



	public int gCost, hCost;

	public int x, y;

	public Vector3 pos;
	public Color color;


	public Node(Vector3 pos, int x, int y) {
		this.pos = pos;
		this.x = x;
		this.y = y;
	}



	public float fCost() {

		return gCost + hCost;
	}

}
