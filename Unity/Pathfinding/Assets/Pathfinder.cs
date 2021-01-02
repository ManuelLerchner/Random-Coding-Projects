

using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

public class Pathfinder : MonoBehaviour {



	public myGrid myGrid;






	public List<Node> solve(Node start, Node target) {


		foreach (Node N in myGrid.grid) {
			N.Parent = null;
		}



		List<Node> Path = new List<Node>();


		List<Node> openSet = new List<Node>();
		List<Node> closedSet = new List<Node>();

		openSet.Add(start);


		int maxIter = 0;
		while (openSet.Count > 0 && maxIter < 1000) {

			Node current = minFCost(openSet);

			if (current == target) {

				Node now = current;


				while (now.Parent != null) {
					now = now.Parent;
					Path.Add(now);
				}


				Path.Reverse();
				return Path;
			}

			openSet.Remove(current);
			closedSet.Add(current);

			foreach (Node N in myGrid.neighbour(current)) {

				if (!N.walkable || closedSet.Contains(N)) {
					continue;
				}

				int newPathLength = current.gCost + heuristic(current, N);

				if (newPathLength < N.gCost || !openSet.Contains(N)) {
					N.gCost = newPathLength;
					N.hCost = heuristic(N, target);

					N.Parent = current;

					if (!openSet.Contains(N)) {
						openSet.Add(N);
					}

				}



			}

			maxIter++;
		}


		return null;

	}


	int heuristic(Node A, Node B) {

		int deltaX = Mathf.Abs(A.x - B.x);
		int deltaY = Mathf.Abs(A.y - B.y);

		int diag = Mathf.Min(deltaX, deltaY);
		int gerade = Mathf.Max(deltaX, deltaY) - diag;

		return 14 * diag + 10 * gerade;
	}


	Node minFCost(List<Node> List) {

		Node min = List[0];
		foreach (Node N in List) {
			if (N.fCost() < min.fCost()) {
				min = N;
			}
		}

		return min;
	}









}
