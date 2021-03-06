package grid;


class Map2D<T> implements haxe.Constraints.IMap<Coordinates, T> {
	public var width(default,null):Int;
	public var height(default,null):Int;
	public var data:Array<T>;
	public var defaultData(default,null):Null<T>;
	public var size(get, never):Int;

	private function new(width, height, ?value:T) {
		this.width = width;
		this.height = height;
		this.data = [for (i in 0...width * height) value];
	}

	public function indexOf(x:TilesCoord, y:TilesCoord) {
		return 0;
	}

	public function contains(x:TilesCoord, y:TilesCoord) {
		return false;
	}

	public function keys():Iterator<Coordinates> {
		return null;
	}

	public function iterator():Iterator<T> {
		return null;
	}

	public function get(coordinates:Coordinates):T {
		return getAt(coordinates.x, coordinates.y);
	}

	public function set(coordinates:Coordinates, value:T) {
		setAt(coordinates.x, coordinates.y, value);
	}

	public function getAt(x:TilesCoord, y:TilesCoord):T {
		return data[indexOf(x, y)];
	}

	public function setAt(x:TilesCoord, y:TilesCoord, value:T) {
		data[indexOf(x, y)] = value;
	}

	public function remove(coordinates:Coordinates):Bool {
		data[indexOf(coordinates.x, coordinates.y)] = defaultData;
		return true;
	}

	public function exists(coordinates):Bool {
		return contains(coordinates.x, coordinates.y);
	}

	public function toString() {
		var buffer = new StringBuf();
		buffer.add("{ ");
		for (coordinates in keys()) {
			buffer.add(coordinates);
			buffer.add(": ");
			buffer.add(get(coordinates));
		}
		buffer.add(" }");
		return buffer.toString();
	}

	public inline function get_size():Int {
		return data.length;
	}
}
