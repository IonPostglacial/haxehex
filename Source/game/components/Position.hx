/*
 * Author Nicolas Galipot
 * This file is part of the haxehex project, licensed under a 3-Clause BSD license.
 * See LICENSE.txt in the root folder for more information.
 */
package game.components;

class Position {
	public var x:Int;
	public var y:Int;

	public inline function new(x, y) {
		this.x = x;
		this.y = y;
	}

	public inline function equals(other):Bool {
		return this.x == other.x && this.y == other.y;
	}

	public inline function copy():Position {
		return new Position(x, y);
	}

	public inline function hashCode():Int {
		return y | (x << 16); // x can be negative while y cannot.
	}
}
