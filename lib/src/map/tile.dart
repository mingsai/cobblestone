part of cobblestone;

abstract class Tile {

  void render(SpriteBatch batch, num x, num y, num width, num height);

  void update(double delta) {

  }

}

class BasicTile extends Tile {

  GameTexture texture;

  BasicTile(this.texture);

  @override
  void render(SpriteBatch batch, num x, num y, num width, num height) {
    batch.draw(texture, x, y, width: width, height: height);
  }

}

class AnimatedTile extends Tile {

  List<GameTexture> frames = [];
  List<num> timings = [];

  GameTexture texture;

  double currentTime = 0.0;

  AnimatedTile(dynamic data, List<BasicTile> basicTiles) {
    for(dynamic frame in data["animation"]) {
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
      if(currentTime > timeSum) {
        print(currentTime);
        texture = frames[i];
      }
      timeSum += timings[i];
    }

    if(currentTime > timeSum) {
      currentTime = 0.0;
      texture = frames[0];
    }
  }

  @override
  void render(SpriteBatch batch, num x, num y, num width, num height) {
    batch.draw(texture, x, y, width: width, height: height);
  }

}