package game.systems;

import ash.core.Engine;
import ash.core.Node;
import ash.tools.ListIteratingSystem;

import game.components.Movement;
import game.components.LinearWalker;
import game.components.Position;
import game.mapmanagement.GroundType;


class LinearWalkingNode extends Node<LinearWalkingNode> {
	public var position:Position;
	public var linearWalker:LinearWalker;
	public var movement:Movement;
}

class LinearMovementSystem extends ListIteratingSystem<LinearWalkingNode> {
	var stage:Stage;
	var engine:Engine;

	public function new(stage:Stage) {
		this.stage = stage;
		super(LinearWalkingNode, updateNode);
	}

	override public function addToEngine(engine:Engine) {
		this.engine = engine;
		super.addToEngine(engine);
	}

	function updateNode(node:LinearWalkingNode, deltaTime:Float) {
		if (node.movement.timeSinceLastMove >= node.movement.period) {
			switch (stage.ground.forVehicle(node.movement.vehicle).at(node.position)) {
			case GroundType.Arrow(dx, dy):
				node.linearWalker.dx = dx;
				node.linearWalker.dy = dy;
			case GroundType.Uncrossable:
				engine.removeEntity(node.entity);
				return;
			default: // pass
			}
			node.movement.oldPosition = node.position.copy();
			node.movement.timeSinceLastMove -= node.movement.period;
			node.position.x += node.linearWalker.dx;
			node.position.y += node.linearWalker.dy;
		}
	}
}
