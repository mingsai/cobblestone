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

  List<GameTexture> tileset;

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

  giveTileset(GameTexture set) {
    tileset = set.split(tileWidth, tileHeight);
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
    print(tiles);

    tileWidth = parent.tileWidth;
    tileHeight = parent.tileHeight;
  }

  @override
  render(SpriteBatch batch, Camera2D camera) {
    for(int row = 0; row < height; row++) {
      int y = width * tileHeight - row * tileHeight - tileHeight;
      for(int col = 0; col < width; col++) {
        if(tiles != null && tiles[width * row + col] != 0)
          batch.draw(parent.tileset[tiles[width * row + col] - 1], (col * tileHeight), y, tileWidth, tileHeight);
      }
    }
  }



}