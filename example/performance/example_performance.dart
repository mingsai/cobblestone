import 'package:cobblestone/cobblestone.dart';

main() {
  new PerformanceExample();
}

class PerformanceExample extends BaseGame {

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

    List<GameTexture> textures = boulderSheet.split(16, 16);
    for(int i = 0; i < 20000; i++) {
      boulders.add(new BoulderSprite(textures[rand.nextInt(textures.length)], rand.nextInt(width), rand.nextInt(height)));
    }
  }

  @override
  preload() {
    assetManager.load("boulders2.png", loadTexture("boulders2.png", nearest));
  }

  @override
  render(num delta) {
    clearScreen(0.0, 0.0, 0.0, 1.0);

    window.console.time("Begin Batch");
    camera.update();

    renderer.projection = camera.combined;
    renderer.begin();
    window.console.timeEnd("Begin Batch");

    window.console.time("Build Batch");
    for(BoulderSprite sprite in boulders) {
      renderer.draw(sprite.texture, sprite.x, sprite.y);
    }
    window.console.timeEnd("Build Batch");

    window.console.time("Flush Batch");
    renderer.end();
    window.console.timeEnd("Flush Batch");
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