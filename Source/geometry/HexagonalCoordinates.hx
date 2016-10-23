package geometry;

import openfl.geom.Point;


class HexagonalCoordinates implements CoordinatesSystem {
	static var SQRT3 = Math.sqrt(3);

	var radius:Float = 0;

	public function new(radius) {
		this.radius = radius;
	}

	public function fromPixel(point:Point):Coordinates {
		var WIDTH_NUM = Std.int(point.x / (SQRT3 * radius / 2));
		var HEIGHT_NUM = Std.int(point.y / (radius / 2));
		var HEX_Y = Std.int(HEIGHT_NUM / 3);
		var HEX_X = Std.int((WIDTH_NUM - HEX_Y) / 2);

		return new Coordinates(HEX_X, HEX_Y);
	}

	public function toPixel(coordinates:Coordinates):Point {
		var PIX_Y = Std.int(radius + 1.5 * radius * coordinates.y);
		var PIX_X = Std.int((PIX_Y - radius) / SQRT3 + SQRT3 * radius * (coordinates.x + 0.5));

		return new Point(PIX_X, PIX_Y);
	}
}