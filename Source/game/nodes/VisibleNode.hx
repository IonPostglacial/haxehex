package game.nodes;

import openfl.display.Sprite;

import ash.core.Node;

import game.components.Visible;
import hex.Position;

class VisibleNode extends Node<VisibleNode> {
	public var visible:Visible;
	public var position:Position;
}