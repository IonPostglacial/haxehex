package game.nodes;

import ash.core.Node;

import game.components.EyeCandy;
import game.components.Speed;
import hex.Position;

class MovingGraphicalNode extends Node<MovingGraphicalNode> {
	public var speed:Speed;
	public var eyeCandy:EyeCandy;
	public var position:Position;
}