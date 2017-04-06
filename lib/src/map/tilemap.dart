part of cobblestone;

/// Loads a JSON tilemap from a URL. Use Tiled to create these. (http://www.mapeditor.org/)
Future<Tilemap> loadTilemap(String url) {
  return HttpRequest
      .getString(url)
      .then((String file) => new Tilemap(JSON.decode(file)));
}

/// A 2D orthographic tilemap
class Tilemap {
  Map file;

  List<MapLayer> layers;

  int width, height;
  int tileWidth, tileHeight;

  Map<int, BasicTile> basicTiles;
  Map<int, Tile> tileset;

  /// Creates a new tilemap from a JSON map
  Tilemap(this.file) {
    this.width = file["width"];
    this.height = file["height"];

    this.tileWidth = file["tilewidth"];
    this.tileHeight = file["tileheight"];

    layers = [];
    for (Map layer in file["layers"]) {
      if (layer["type"] == "tilelayer") layers.add(new TileLayer(layer, this));
    }
    //layers = layers.reversed.toList();
  }

  /// Gives the tilemap the textures it needs to render
  giveTileset(Map<String, Texture> set) {
    basicTiles = new Map<int, BasicTile>();
    tileset = new Map<int, BasicTile>();
    file["tilesets"][0]["tiles"].forEach((id, tile) {
      basicTiles[int.parse(id)] = new BasicTile(
          set[Path.basenameWithoutExtension(tile["image"])], tile);
    });

    file["tilesets"][0]["tiles"].forEach((id, tile) {
      if (tile["animation"] != null) {
        tileset[int.parse(id)] = new AnimatedTile(tile, basicTiles);
      } else {
        tileset[int.parse(id)] = basicTiles[int.parse(id)];
      }
    });
  }

  /// Updates the tilemap, for animations
  update(double delta) {
    for (Tile tile in tileset.values) {
      tile.update(delta);
    }
  }

  /// Renders the tilemap layers. If [filter] is set, only renders the layers with names selected by the it.
  render(SpriteBatch batch, num x, num y, {Pattern filter: null}) {
    if (filter == null) {
      for (MapLayer layer in layers) {
        layer.render(batch, x, y);
      }
    } else {
      for (MapLayer layer in getLayersContaining(filter)) {
        layer.render(batch, x, y);
      }
    }
  }

  /// Returns a list of map layers with names satisfying [filter]
  List<MapLayer> getLayersContaining(Pattern filter) {
    return layers.where((MapLayer layer) => layer.name.contains(filter));
  }
}

/// A renderable layer of the map
abstract class MapLayer {
  String name;

  render(SpriteBatch batch, num x, num y);
}

/// A tilemap layer filed with tiles
class TileLayer extends MapLayer {
  Tilemap parent;

  var layer;

  List<int> tiles;

  int tileWidth;
  int tileHeight;

  int width;
  int height;

  /// Creates a new tile layer from JSON data
  TileLayer(this.layer, this.parent) {
    width = layer["width"];
    height = layer["height"];

    name = layer["name"];

    tiles = layer["data"];

    tileWidth = parent.tileWidth;
    tileHeight = parent.tileHeight;
  }

  /// Renders this to batch
  @override
  render(SpriteBatch batch, num x, num y) {
    for (int row = 0; row < height; row++) {
      for (int col = 0; col < width; col++) {
        if (getTile(col, row) != null)
          getTile(col, row).render(batch, col * tileWidth + x,
              row * tileHeight + y, tileWidth, tileHeight);
      }
    }
  }

  /// Returns the tile at ([x], [y]) from the bottom-left
  Tile getTile(x, y) {
    //I know this function makes little sense to us mere mortals, but it works (I think)!
    return parent.tileset[tiles[width * (height - y - 1) + x] - 1];
  }
}
