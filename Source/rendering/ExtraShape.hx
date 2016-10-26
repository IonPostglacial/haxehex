package rendering;

import geometry.Hexagon;
import geometry.HexagonalGrid;
import openfl.display.Graphics;
import openfl.geom.Point;


class ExtraShape {
	static var SQRT3 = Math.sqrt(3);

	public static inline function gridPixelWidth(grid:HexagonalGrid, radius:Float):Int {
		return Std.int(SQRT3 * grid.width * radius);
	}

	public static inline function gridPixelHeight(grid:HexagonalGrid, radius:Float):Int {
		return Std.int((1.5 * grid.height + 0.5) * radius);
	}

	public static function drawHexagon(graphics:Graphics, hexagon:Hexagon) {
		var corners = hexagon.corners;

		graphics.moveTo(corners[5].x, corners[5].y);
		for (corner in corners) {
			graphics.lineTo(corner.x, corner.y);
		}
	}

	public static function drawHexagonGrid(graphics:Graphics, grid:HexagonalGrid, radius:Float) {
		for (position in grid.cells()) {
			var pixelY = Std.int(radius + 1.5 * radius * position.y);
			var pixelX = Std.int((pixelY - radius) / SQRT3 + SQRT3 * radius * (position.x + 0.5));
			drawHexagon(graphics, new Hexagon(pixelX, pixelY, radius));
		}
	}
}