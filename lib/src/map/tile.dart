part of cobblestone;

abstract class Tile {
  XML.XmlElement data = null;
  String image = "";

  void render(SpriteBatch batch, num x, num y, num width, num height);

  void update(double delta) {}
}

class BasicTile extends Tile {
  Texture texture;

  BasicTile(this.texture, XML.XmlElement data) {
    this.data = data;
    image = Path.basenameWithoutExtension(data.findElements("image").first.getAttribute("source"));
  }

  @override
  void render(SpriteBatch batch, num x, num y, num width, num height) {
    batch.draw(texture, x, y, width: width, height: height);
  }
}

class AnimatedTile extends Tile {
  List<Texture> frames = [];
  List<num> timings = [];

  Texture texture;

  double currentTime = 0.0;

  AnimatedTile(XML.XmlElement data, Map<int, BasicTile> basicTiles) {
    this.data = data;
    for (XML.XmlElement frame in data.findElements("animation").first.findElements("frame")) {
      frames.add(basicTiles[int.parse(frame.getAttribute("tileid"))].texture);
      timings.add(int.parse(frame.getAttribute("duration")));
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
