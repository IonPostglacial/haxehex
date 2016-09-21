package game.components;

import hex.Position;

class Movement {
	public var transportation:Tile.Transportation;
	public var period:Float;
	public var delta(get, never):Float;
	public var ready(get, never):Bool;
	public var oldPosition(default, set):Position;
	var timeSinceLastMove:Float;

	public function new(transportation, period) {
		this.transportation = transportation;
		this.period = period;
		this.timeSinceLastMove = 0;
		this.oldPosition = new Position(-1, -1);
	}

	public function get_ready():Bool {
		return timeSinceLastMove >= period;
	}

	public function make(deltaTime:Float) {
		if (timeSinceLastMove < period) {
			timeSinceLastMove += deltaTime;
		}
	}

	public function set_oldPosition(oldPosition:Position):Position {
		this.oldPosition = oldPosition;
		timeSinceLastMove -= period;
		return oldPosition;
	}

	public function get_delta():Float {
		var delta = timeSinceLastMove / period;
		return delta <= 1 ? delta : 1;
	}
}