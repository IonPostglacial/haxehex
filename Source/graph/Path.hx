/*
 * Author Nicolas Galipot
 * This file is part of the haxehex project, licensed under a 3-Clause BSD license.
 * See LICENSE.txt in the root folder for more information.
 */
package graph;

import haxe.ds.HashMap;
import de.polygonal.ds.Heap;
import de.polygonal.ds.Heapable;

interface Step<T>
{
	function equals(other:T):Bool;
	function hashCode():Int;
}

class Node<Step_t:Step<Step_t>> implements Heapable<Node<Step_t>>
{
	public var currentStep:Step_t;
	public var previousStep:Step_t;
	public var costSoFar:Int;
	public var estimatedCost:Int;
	public var position:Int;

	public function new(currentStep:Step_t, previousStep:Step_t, costSoFar:Int, heuristic:Int)
	{
		this.currentStep = currentStep;
		this.previousStep = previousStep;
		this.costSoFar = costSoFar;
		this.estimatedCost = costSoFar + heuristic;
	}

	public function compare(other:Node<Step_t>):Int
	{
		return other.estimatedCost - this.estimatedCost;
	}
}

class Path
{
	static inline function reconstructPath<Step_t:Step<Step_t>>(nodes:HashMap<Step_t, Node<Step_t>>, start:Step_t, goal:Step_t):Array<Step_t>
	{
		var path = [];
		var currentStep = goal;

		while (!currentStep.equals(start))
		{
			path.push(currentStep);
			currentStep = nodes.get(currentStep).previousStep;
		}
		path.push(start);
		return path;
	}

	public static function find<Step_t:Step<Step_t>>(graph:Pathfindable<Step_t>, start:Step_t, goal:Step_t):Array<Step_t>
	{
		var nodes = new HashMap<Step_t, Node<Step_t>>();
		var frontier = new Heap<Node<Step_t>>();
		var firstNode = new Node(start, null, 0, graph.distanceBetween(start, goal));

		nodes.set(start, firstNode);
		frontier.add(firstNode);

		while (!frontier.isEmpty())
		{
			var currentNode = frontier.pop();
			var currentStep = currentNode.currentStep;

			if (currentStep.equals(goal))
				return reconstructPath(nodes, start, goal);
			for (neighbor in graph.neighborsOf(currentStep))
			{
				var costToNeighbor = currentNode.costSoFar + graph.distanceBetween(currentStep, neighbor);
				var heuristic = graph.distanceBetween(neighbor, goal);
				var previousEvaluation = nodes.get(neighbor);

				if (previousEvaluation == null || costToNeighbor < previousEvaluation.costSoFar)
				{
					var neighborNode = new Node(neighbor, currentStep, costToNeighbor, heuristic);

					nodes.set(neighbor, neighborNode);
					frontier.add(neighborNode);
				}
			}
		}
		return [];
	}
}
