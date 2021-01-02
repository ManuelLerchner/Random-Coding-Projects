using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

public class movePlayer : MonoBehaviour {


	public Pathfinder pf;
	public GameObject Target;



	List<Node> Path;

	public float speed = 2f;


	Vector3 dir;

	void FixedUpdate() {

		Node start = pf.myGrid.NodeFromPos(transform.position);
		Node target = pf.myGrid.NodeFromPos(Target.transform.position);


		Path = null;


		if (target.walkable) {


			Path = pf.solve(start, target);
		}


		if (Path != null) {


			move();
		}




	}



	void move() {

		if (Path.Count > 1) {

			dir = Path[1].pos - Path[0].pos;
		}

		transform.position += dir * speed * Time.deltaTime;


	}



	void OnDrawGizmos() {


		if (Path != null) {
			if (Path.Count > 1) {
				for (int i = 1; i < Path.Count; i++) {

					Vector3 p1 = Path[i].pos;
					Vector3 p2 = Path[i - 1].pos;

					Handles.DrawBezier(p1, p2, p1, p2, Color.red, null, 5);

				}
			}
		}





	}

}
