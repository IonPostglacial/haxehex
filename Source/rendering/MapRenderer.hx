package rendering;

import openfl.Assets;
import openfl.display.Tile;
import openfl.display.Tilemap;
import openfl.display.Tileset;
import openfl.geom.Rectangle;

import geometry.Coordinates;
import geometry.Map2D;
import geometry.HexagonalMap;
import geometry.OrthogonalMap;

import tmx.TiledMap;


class MapRenderer extends Tilemap {
	var map:TiledMap;
	var tilesByObjectsId:Map<Int, Tile> = new Map();

	public function new(map:TiledMap) {
		this.map = map;
		tileset = new Tileset(map.tilesets[0].image);
		super(openfl.Lib.current.stage.stageWidth, openfl.Lib.current.stage.stageHeight, tileset);
		loadTilesets(map);
		loadTileLayer(map);
		loadObjectsLayer(map);
	}

	inline function loadTileLayer(map:TiledMap) {
		var baseLayer = map.tileLayers[0];
		for (position in baseLayer.tiles.keys()) {
			var pixPosition = map.coordinates.toPixel(position);
			var tileId = baseLayer.tiles.get(position) - map.tilesets[0].firstGid;
			this.addTile(new Tile(tileId, pixPosition.x, pixPosition.y));
		}
	}

	inline function loadObjectsLayer(map:TiledMap) {
		for(objectLayer in map.objectLayers) {
			for (tiledObject in objectLayer.objects) {
				var normalizedPosition = map.coordinates.toPixel(tiledObject.coords);
				var objectTile = this.createObjectTile(tiledObject.gid, normalizedPosition.x, normalizedPosition.y);
				tilesByObjectsId.set(tiledObject.id, objectTile);
				this.addTile(objectTile);
			}
		}
	}

	inline function loadTilesets(map:TiledMap) {
		for (mapTileset in map.tilesets) {
			var rectWidth = mapTileset.tileWidth;
			var rectHeight = mapTileset.tileHeight;
			var i = 0;
			for (tileType in 0...mapTileset.tileCount) {
				tileset.addRect(new Rectangle(rectWidth * i, 0, rectWidth, rectHeight));
				i += 1;
			}
		}
	}

	inline function createObjectTile(type:Int, x:Float, y:Float):Tile {
		return new Tile(type - map.tilesets[0].firstGid, x, y);
	}

	public inline function getTileForObjectId(objectId:Int):Tile {
		return tilesByObjectsId.get(objectId);
	}

	public inline function getTileFromCoords(layerId:Int, position:Coordinates):Tile {
		var tileIndex = 0;
		for (layerIndex in 0...layerId) {
			tileIndex += this.map.tileLayers[layerId].tiles.size;
		}
		tileIndex += this.map.tileLayers[layerId].tiles.indexOf(position.x, position.y);
		return this.getTileAt(tileIndex);
	}
}
