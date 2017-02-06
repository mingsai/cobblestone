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
      basicTiles[int.parse(id)] = new BasicTile(set[Path.basenameWithoutExtension(tile["image"])]);
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

  render(SpriteBatch batch, Camera2D camera) {
    camera.update();
    batch.projection = camera.combined;
    for(MapLayer layer in layers) {
      layer.render(batch, camera);
    }
  }

}

abstract class MapLayer {

  render(SpriteBatch batch, Camera2D camera);

}

class TileLayer extends MapLayer {

  Tilemap parent;

  Map layer;

  List<int> tiles;
  int width;
  int height;

  int tileWidth;
  int tileHeight;

  String name;

  TileLayer(this.layer, this.parent) {
    width = layer["width"];
    height = layer["height"];

    name = layer["name"];

    tiles = layer["data"];
    //tiles = tiles.reversed.toList();

    tileWidth = parent.tileWidth;
    tileHeight = parent.tileHeight;
  }

  @override
  render(SpriteBatch batch, Camera2D camera) {
    for(int row = 0; row < height; row++) {
      int y = width * tileHeight - row * tileHeight - tileHeight;
      for(int col = 0; col < width; col++) {
        if(tiles != null && tiles[width * row + col] != 0)
          parent.tileset[tiles[width * row + col] - 1].render(batch, (col * tileWidth), y, tileWidth, tileHeight);
      }
    }
  }



}