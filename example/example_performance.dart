import 'package:cobblestone/cobblestone.dart';

main() {
  new GeometryExample();
}

class GeometryExample extends BaseGame {

  Camera2D camera;

  SpriteBatch renderer;

  List<BoulderSprite> boulders = [];

  @override
  create() {
    camera = new Camera2D.originBottomLeft(width, height);
    renderer = new SpriteBatch.defaultShader();

    setGLViewport(canvasWidth, canvasHeight);

    Random rand = new Random();

    GameTexture boulderSheet = assetManager.get("boulders2.png");
    int num = 0;
    for(GameTexture texture in boulderSheet.split(16, 16)) {
      for(int i = 0; i < 3; i++) {
        num++;
        if(num <= 8000)
          boulders.add(new BoulderSprite(texture, rand.nextInt(width), rand.nextInt(height)));
      }
    }
    print(boulders.length);
  }

  @override
  preload() {
    assetManager.load("boulders2.png", loadTexture("boulders2.png", nearest));
  }

  @override
  render(num delta) {
    clearScreen(0.0, 0.0, 0.0, 1.0);

    camera.update();

    renderer.projection = camera.combined;
    renderer.begin();

    for(BoulderSprite sprite in boulders) {
      renderer.draw(sprite.texture, sprite.x, sprite.y, 16, 16);
    }

    renderer.end();
  }

  resize(num width, num height) {
    setGLViewport(canvasWidth, canvasHeight);
  }

  @override
  update(num delta) {

  }
}

class BoulderSprite {

  GameTexture texture;

  num x, y;

  BoulderSprite(this.texture, this.x, this.y);

}