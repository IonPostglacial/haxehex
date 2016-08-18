package;

import openfl.display.Sprite;
import gbm.Path;
import gbm.Point;
import gbm.Distance;

class Main extends Sprite
{
	static var TILE_SIZE = 32;
	static var SQUARE_SIZE = 10;

	static function smallSquare(step:gbm.Point):Bool
	{
		return step.x >= 0 && step.x < SQUARE_SIZE && step.y >= 0 && step.y < SQUARE_SIZE;
	}

	public function new()
	{
		super();
		graphics.beginFill(0x000000);
		graphics.drawRect(0, 0, SQUARE_SIZE * TILE_SIZE, SQUARE_SIZE * TILE_SIZE);
		graphics.endFill();

		var path = Path.shortestBetween(new gbm.Point(0, 0), new gbm.Point(9, 5), Distance.manhattan, smallSquare);
		trace(path.length);

		graphics.beginFill(0xffffff);
		for (step in path)
		{
			graphics.drawRect(step.x * TILE_SIZE, step.y * TILE_SIZE, TILE_SIZE, TILE_SIZE);
		}
		graphics.endFill();
	}
}
