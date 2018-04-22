import 'package:cobblestone/cobblestone.dart';

main() {
  new HandpaintExample();
}

class HandpaintExample extends BaseGame {
  Camera2D camera;

  SpriteBatch renderer;

  List<FlashSprite> boulders = [];

  @override
  create() {
    camera = new Camera2D.originBottomLeft(width, height);
    renderer = new SpriteBatch.defaultShader(gl, maxSprites: 2000);

    gl.setGLViewport(canvasWidth, canvasHeight);

    Random rand = new Random();

    var atlas = assetManager.get("atlas");
    for (int i = 0; i < 2000; i++) {
      boulders.add(new FlashSprite(atlas["m_" + (rand.nextInt(16) + 1).toString()],
          rand.nextInt(width), rand.nextInt(height)));
    }
  }

  @override
  preload() {
    assetManager.load("atlas", loadAtlas("sprites.json", loadTexture(gl, "sprites.png", mipMap)));
  }

  @override
  render(num delta) {
    gl.clearScreen(0.0, 0.0, 0.0, 1.0);

    window.console.time("Begin Batch");
    camera.update();

    renderer.projection = camera.combined;
    renderer.begin();
    window.console.timeEnd("Begin Batch");

    window.console.time("Build Batch");
    for (FlashSprite sprite in boulders) {
      renderer.draw(sprite.texture, sprite.x, sprite.y);
    }
    window.console.timeEnd("Build Batch");

    window.console.time("Flush Batch");
    renderer.end();
    window.console.timeEnd("Flush Batch");
  }

  resize(num width, num height) {
    gl.setGLViewport(canvasWidth, canvasHeight);
  }

  @override
  update(num delta) {}

  @override
  config() {
    scaleMode = ScaleMode.resize;
  }
}

class FlashSprite {
  Texture texture;

  num x, y;

  FlashSprite(this.texture, this.x, this.y);
}
