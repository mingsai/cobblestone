part of cobblestone;

Future<Tilemap> loadTilemap(String url) {
  return HttpRequest.getString(url).then((String file) =>
    new Tilemap(JSON.decode(file))
  );
}

class Tilemap {

  Map file;

  List<MapLayer> layers;

  int width, height;
  int tileWidth, tileHeight;

  Map<int, BasicTile> basicTiles;
  Map<int, Tile> tileset;

  Tilemap(this.file) {
    this.width = file["width"];
    this.height = file["height"];

    this.tileWidth = file["tilewidth"];
    this.tileHeight = file["tileheight"];

    layers = [];
    for(Map layer in file["layers"]) {
      if(layer["type"] == "tilelayer")
        layers.add(new TileLayer(layer, this));
    }
    //layers = layers.reversed.toList();
  }

  giveTileset(Map<String, GameTexture> set) {
    basicTiles = new Map<int, BasicTile>();
    tileset = new Map<int, BasicTile>();
    file["tilesets"][0]["tiles"].forEach((id, tile) {
      basicTiles[int.parse(id)] = new BasicTile(set[Path.basenameWithoutExtension(tile["image"])], tile);
    });

    file["tilesets"][0]["tiles"].forEach((id, tile) {
      if(tile["animation"] != null){
        tileset[int.parse(id)] = new AnimatedTile(tile, basicTiles);
      } else {
        tileset[int.parse(id)] = basicTiles[int.parse(id)];
      }
    });
  }

  update(double delta) {
    for(Tile tile in tileset.values) {
      tile.update(delta);
    }
  }

  render(SpriteBatch batch, num x, num y, {Pattern filter: null}) {
    if(filter == null) {
      for (MapLayer layer in layers) {
        layer.render(batch, x, y);
      }
    } else {
      for (MapLayer layer in getLayersContaining(filter)) {
        layer.render(batch, x, y);
      }
    }
  }

  List<MapLayer> getLayersContaining(Pattern filter) {
    return layers.where((MapLayer layer) =>
      layer.name.contains(filter)
    );
  }

}

abstract class MapLayer {

  String name;

  render(SpriteBatch batch, num x, num y);

}

class TileLayer extends MapLayer {

  Tilemap parent;

  var layer;

  List<int> tiles;

  int tileWidth;
  int tileHeight;

  int width;
  int height;

  TileLayer(this.layer, this.parent) {
    width = layer["width"];
    height = layer["height"];

    name = layer["name"];

    tiles = layer["data"];

    tileWidth = parent.tileWidth;
    tileHeight = parent.tileHeight;
  }

  @override
  render(SpriteBatch batch, num x, num y) {
    for(int row = 0; row < height; row++) {
      for(int col = 0; col < width; col++) {
        if(getTile(col, row) != null)
          getTile(col, row).render(batch, col * tileWidth + x, row * tileHeight + y, tileWidth, tileHeight);
      }
    }
  }

  Tile getTile(x, y) {
    //I know this function makes little sense to us mere mortals, but it works (I think)!
    return parent.tileset[tiles[width * (height - y - 1) + x] - 1];
  }

}