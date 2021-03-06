package game.systems;

import ash.core.Engine;
import ash.core.Node;
import ash.core.NodeList;
import ash.core.System;

import game.map.ITargetObjectListener;
import game.map.TargetObject;

import game.components.Visible;
import game.components.Position;
import grid.ICoordinateSystem;


class VisibleNode extends Node<VisibleNode> {
	public var visible:Visible;
	public var position:Position;
}

class VisibleSystem extends System implements ITargetObjectListener {
	var coordinates:ICoordinateSystem;
	var visibles:NodeList<VisibleNode>;
	var mapRenderer:rendering.MapRenderer;

	public function new(coordinates:ICoordinateSystem, mapRenderer:rendering.MapRenderer) {
		this.coordinates = coordinates;
		this.mapRenderer = mapRenderer;
		super();
	}

	public function targetObjectStatusChanged(target:TargetObject, active:Bool):Void {
		this.mapRenderer.getTileForObjectId(target.objectId).visible = active;
	}

	override function update(deltaTime:Float):Void {
		this.mapRenderer.update(deltaTime);
		super.update(deltaTime);
	}

	override public function addToEngine(engine:Engine) {
		openfl.Lib.current.addChildAt(this.mapRenderer, 0);
		function prepareVisibles (node:VisibleNode) {
			var pixPosition = this.coordinates.toPixel(node.position.x, node.position.y);
			node.visible.sprite.x = pixPosition.x;
			node.visible.sprite.y = pixPosition.y;
			openfl.Lib.current.addChild(node.visible.sprite);
			node.visible.tile = this.mapRenderer.getTileForObjectId(node.visible.objectId);
		}
		visibles = engine.getNodeList(VisibleNode);
		for (node in visibles) {
			prepareVisibles(node);
		}
		visibles.nodeAdded.add(prepareVisibles);
		visibles.nodeRemoved.add(function (node:VisibleNode) {
			openfl.Lib.current.removeChild(node.visible.sprite);
			if (node.visible.tile != null) {
				this.mapRenderer.removeTile(node.visible.tile);
			}
		});
		super.addToEngine(engine);
	}
}
