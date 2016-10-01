package game.systems;

import openfl.events.MouseEvent;
import openfl.geom.Rectangle;
import openfl.Lib;

import ash.core.Node;
import ash.tools.ListIteratingSystem;

import game.actions.Move;
import game.components.Controled;
import game.components.Position;
import game.drawing.Shape;


enum Order {
	MovementOrdered(goal:Position);
	PowerOrdered(goal:Position);
	TargetSelected(position:Position);
	GroupSelected(area:Rectangle);
}

class ControledNode extends Node<ControledNode> {
	public var controled:Controled;
	public var position:Position;
}

class ControledSystem extends ListIteratingSystem<ControledNode> {
	var stage:Stage;
	var events:Array<Order>;
	var pointedPosition:Position;

	public function new(stage:Stage) {
		this.stage = stage;
		this.events = [];
		Lib.current.addEventListener(MouseEvent.CLICK, function(e) {
			var mousePosition = Shape.pointToPosition(new openfl.geom.Point(e.stageX, e.stageY), stage.hexagonRadius);
			pointedPosition = mousePosition;
		});
		super(ControledNode, updateNode);
	}

	override function update(deltaTime:Float) {
		if (pointedPosition != null) {
			var targetSelected = false;
			for (node in nodeList) {
				if (node.position.equals(pointedPosition)) {
					targetSelected = true;
					break;
				}
			}
			if (targetSelected) {
				events.push(TargetSelected(pointedPosition.copy()));
			} else {
				events.push(MovementOrdered(pointedPosition.copy()));
			}
			pointedPosition = null;
		}
		super.update(deltaTime);
		events = [];
	}

	function updateNode(node:ControledNode, deltaTime:Float) {
		for (event in events) {
			switch (event) {
			case MovementOrdered(goal):
				if (node.controled.selected) {
					node.controled.actions = [new Move(stage, node.entity, goal)];
				}
			case TargetSelected(position):
				node.controled.selected = !node.controled.selected && node.position.equals(position);
			case GroupSelected(area): // TODO: implement it :p
			case PowerOrdered(goal): // TODO: implement it :p
			}
		}
		var tileType = stage.tileAt(node.position);
		if (tileType.isArrow()) {
			node.controled.actions = [new Move(stage, node.entity, new Position(node.position.x + tileType.dx(), node.position.y + tileType.dy()))];
		}
	}
}
