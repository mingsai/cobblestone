part of cobblestone;

/// A tile on the map
abstract class Tile {
  /// Data from the map file describing it
  var data = null;
  /// The image currently used by the tile
  String image = "";

  /// Renders the tile using [batch]
  void render(SpriteBatch batch, num x, num y, num width, num height);

  void update(double delta) {}
}

/// A static tile, with a single image
class BasicTile extends Tile {
  /// The texture used for rendering this tile
  Texture texture;

  BasicTile(this.texture, var data) {
    this.data = data;
    image = Path.basenameWithoutExtension(data["image"]);
  }

  @override
  void render(SpriteBatch batch, num x, num y, num width, num height) {
    batch.draw(texture, x, y, width: width, height: height);
  }
}

/// An looping animated tile
class AnimatedTile extends Tile {
  List<Texture> frames = [];
  List<num> timings = [];

  Texture texture;

  double currentTime = 0.0;

  AnimatedTile(var data, Map<int, BasicTile> basicTiles) {
    this.data = data;
    for (dynamic frame in data["animation"]) {
      frames.add(basicTiles[frame["tileid"]].texture);
      timings.add(frame["duration"]);
    }
    update(0.0);
  }

  @override
  void update(double delta) {
    currentTime += delta * 1000;

    int timeSum = 0;
    for (var i = 0; i < timings.length; i++) {
      if (currentTime >= timeSum) {
        texture = frames[i];
      }
      timeSum += timings[i];
    }

    if (currentTime >= timeSum) {
      currentTime = 0.0;
      texture = frames[0];
    }
  }

  @override
  void render(SpriteBatch batch, num x, num y, num width, num height) {
    batch.draw(texture, x, y, width: width, height: height);
  }
}
