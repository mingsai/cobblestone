part of cobblestone;

/// Loads a TMX tilemap from a URL.
///
/// Use Tiled to create these. (http://www.mapeditor.org/)
Future<Tilemap> loadTilemap(String url) {
  return HttpRequest
      .getString(url)
      .then((String file) => Tilemap(XML.parse(file)));
}

/// A 2D orthographic tilemap.
class Tilemap {
  /// Raw XML data describing this tilemap.
  XML.XmlDocument file;

  /// List of tile map layers in the map.
  List<TileLayer> layers = [];
  /// List of object groups in the map.
  List<ObjectGroup> objectGroups = [];

  /// The width of the tilemap, in tiles.
  int width;
  /// The height of the tilemap, in tiles.
  int height;

  /// The width of tiles in this map, in pixels.
  int tileWidth;
  /// The height of tiles in this map, in pixels.
  int tileHeight;

  /// Set of all static tiles, i.e. not animated.
  Map<int, BasicTile> basicTiles;
  /// Set of all tiles used in the map.
  Map<int, Tile> tileset;

  /// Creates a new tilemap from a TMX map
  Tilemap(this.file) {
    this.width = int.parse(file.rootElement.getAttribute("width"));
    this.height = int.parse(file.rootElement.getAttribute("height"));

    this.tileWidth = int.parse(file.rootElement.getAttribute("tilewidth"));
    this.tileHeight = int.parse(file.rootElement.getAttribute("tileheight"));

    for (XML.XmlElement layer in file.rootElement.findElements("layer")) {
      layers.add(TileLayer(this, layer));
    }
    for (XML.XmlElement group in file.rootElement.findElements("objectgroup")) {
      objectGroups.add(ObjectGroup(this, group));
    }
  }

  /// Gives the tilemap the textures it needs to render
  giveTileset(Map<String, Texture> set) {
    basicTiles = Map<int, BasicTile>();
    tileset = Map<int, Tile>();
    file.rootElement.findElements("tileset").first.findElements("tile").forEach((tile) {
      basicTiles[int.parse(tile.getAttribute("id"))] = BasicTile(
          set[Path.basenameWithoutExtension(tile.findElements("image").first.getAttribute("source"))], tile);
    });

    file.rootElement.findElements("tileset").first.findElements("tile").forEach((tile) {
      if (tile.findElements("animation").isNotEmpty) {
        tileset[int.parse(tile.getAttribute("id"))] = AnimatedTile(tile, basicTiles);
      } else {
        tileset[int.parse(tile.getAttribute("id"))] = basicTiles[int.parse(tile.getAttribute("id"))];
      }
    });

    layers.forEach((TileLayer layer) => layer.giveTileset(tileset));
  }

  /// Updates the tilemap, for animations
  update(double delta) {
    for (Tile tile in tileset.values) {
      tile.update(delta);
    }
  }

  /// Renders the tilemap layers. If [filter] is set, only renders the layers with names selected by the it.
  render(SpriteBatch batch, num x, num y, Camera2D camera, {Pattern filter}) {
    if (filter == null) {
      for (TileLayer layer in layers) {
        layer.render(batch, x, y, camera);
      }
    } else {
      for (TileLayer layer in getLayersContaining(filter)) {
        layer.render(batch, x, y, camera);
      }
    }
  }

  /// Returns a list of map layers with names satisfying [filter]
  List<TileLayer> getLayersContaining(Pattern filter) {
    return layers.where((TileLayer layer) => layer.name.contains(filter));
  }
}

/// A tilemap layer filed with tiles
class TileLayer {
  /// The map this layer is a part of.
  Tilemap parent;

  /// The name of this layer.
  String name;

  // Actual map data
  List<Tile> _tiles;
  List<int> _tileIds;

  /// The width of tiles in this layer, in pixels.
  int tileWidth;
  /// The height of tiles in this layer, in pixels.
  int tileHeight;

  /// The width of this layer, in tiles.
  int width;
  /// The height of this layer, in pixels.
  int height;

  /// Creates a new tile layer from TMX data.
  TileLayer(this.parent, XML.XmlElement layer) {
    width = int.parse(layer.getAttribute("width"));
    height = int.parse(layer.getAttribute("height"));

    name = layer.getAttribute("name");

    XML.XmlElement data = layer.findElements("data").first;
    if(data.getAttribute("encoding") == "csv") {
      _tileIds = _parseCsv(data.text, int.parse);
    } else if(data.getAttribute("encoding") == "base64") {
      _tileIds = base64.decode(data.text);
    }

    tileWidth = parent.tileWidth;
    tileHeight = parent.tileHeight;
  }

  /// Updates the layer with the new tileset.
  giveTileset(Map<int, Tile> tileset) {
    _tiles = [];
    _tileIds.forEach((int id) => _tiles.add(parent.tileset[id - 1]));
  }

  /// Renders this tile layer to given [batch].
  ///
  /// [giveTileset] must be called before this function will work.
  render(SpriteBatch batch, num x, num y, Camera2D camera) {
    double startX = min(min(camera.view.point0.x, camera.view.point1.x), min(camera.view.point2.x, camera.view.point3.x)) - x;
    double startY = min(min(camera.view.point0.y, camera.view.point1.y), min(camera.view.point2.y, camera.view.point3.y)) - y;

    double endX = max(max(camera.view.point0.x, camera.view.point1.x), max(camera.view.point2.x, camera.view.point3.x)) - x;
    double endY = max(max(camera.view.point0.y, camera.view.point1.y), max(camera.view.point2.y, camera.view.point3.y)) - y;
    
    for (int row = max(startY ~/ tileHeight, 0); row < min(endY ~/ tileHeight + 1, height - 1); row++) {
      for (int col = max(startX ~/ tileWidth, 0); col < min(endX ~/ tileWidth + 1, width - 1); col++) {
        if (getTile(col, row) != null) {
          getTile(col, row).render(batch, col * tileWidth + x,
              row * tileHeight + y, tileWidth, tileHeight);
        }
      }
    }
  }

  /// Returns the tile at ([x], [y]) from the bottom-left.
  ///
  /// [giveTileset] must be called for this function to work.
  Tile getTile(x, y) {
    return _tiles[width * (height - y - 1) + x];
  }

}

/// A group of objects in the map.
class ObjectGroup {

  /// The map this ObjectGroup is a part of.
  Tilemap map;

  /// The name of this object group.
  String name;

  /// A list of objects in this group.
  List<MapObject> objects = [];

  /// Creates a new object group from TMX data.
  ObjectGroup(this.map, XML.XmlElement group) {
    name = group.getAttribute("name");

    for (XML.XmlElement object in group.findElements("object")) {
      objects.add(MapObject.load(this, object));
    }
  }

}