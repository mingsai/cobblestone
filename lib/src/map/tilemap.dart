part of cobblestone;

/// Loads a TMX tilemap from a URL. Use Tiled to create these. (http://www.mapeditor.org/)
Future<Tilemap> loadTilemap(String url) {
  return HttpRequest
      .getString(url)
      .then((String file) => new Tilemap(XML.parse(file)));
}

List<int> parseCsv(String csv) {
  List<int> parsed = [];
  csv.split(",").forEach((String tile) => parsed.add(int.parse(tile)));
  return parsed;
}

/// A 2D orthographic tilemap
class Tilemap {
  XML.XmlDocument file;

  List<MapLayer> layers;

  int width, height;
  int tileWidth, tileHeight;

  Map<int, BasicTile> basicTiles;
  Map<int, Tile> tileset;

  /// Creates a new tilemap from a TMX map
  Tilemap(this.file) {
    this.width = int.parse(file.rootElement.getAttribute("width"));
    this.height = int.parse(file.rootElement.getAttribute("height"));

    this.tileWidth = int.parse(file.rootElement.getAttribute("tilewidth"));
    this.tileHeight = int.parse(file.rootElement.getAttribute("tileheight"));

    layers = [];
    for (XML.XmlElement layer in file.rootElement.findElements("layer")) {
      layers.add(new TileLayer(layer, this));
    }
    //layers = layers.reversed.toList();
  }

  /// Gives the tilemap the textures it needs to render
  giveTileset(Map<String, Texture> set) {
    basicTiles = new Map<int, BasicTile>();
    tileset = new Map<int, BasicTile>();
    file.rootElement.findElements("tileset").first.findElements("tile").forEach((tile) {
      basicTiles[int.parse(tile.getAttribute("id"))] = new BasicTile(
          set[Path.basenameWithoutExtension(tile.findElements("image").first.getAttribute("source"))], tile);
    });

    file.rootElement.findElements("tileset").first.findElements("tile").forEach((tile) {
      if (tile.findElements("animation").length > 0) {
        tileset[int.parse(tile.getAttribute("id"))] = new AnimatedTile(tile, basicTiles);
      } else {
        tileset[int.parse(tile.getAttribute("id"))] = basicTiles[int.parse(tile.getAttribute("id"))];
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

  XML.XmlElement layer;

  List<int> tiles;

  int tileWidth;
  int tileHeight;

  int width;
  int height;

  /// Creates a new tile layer from TMX data
  TileLayer(this.layer, this.parent) {
    width = int.parse(layer.getAttribute("width"));
    height = int.parse(layer.getAttribute("height"));

    name = layer.getAttribute("name");

    XML.XmlElement data = layer.findElements("data").first;
    if(data.getAttribute("encoding") == "csv") {
      tiles = parseCsv(data.text);
    } else if(data.getAttribute("encoding") == "base64") {
      tiles = BASE64.decode(data.text);
    }


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
