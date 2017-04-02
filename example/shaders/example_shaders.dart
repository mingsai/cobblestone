import 'package:cobblestone/cobblestone.dart';

main() {
  new PerformanceExample();
}

class PerformanceExample extends BaseGame {
  Camera2D camera;

  SpriteBatch renderer;

  Texture water;

  double angleWave = 0.0;

  @override
  create() {
    camera = new Camera2D.originBottomLeft(width, height);
    renderer = new SpriteBatch(assetManager.get("water"));

    setGLViewport(canvasWidth, canvasHeight);

    water = assetManager.get("water.png");
  }

  @override
  preload() {
    assetManager.load("water.png", loadTexture("water.png"));
    assetManager.load("water", loadProgram("water.vertex", "ambient.fragment"));
  }

  @override
  render(num delta) {
    clearScreen(0.0, 0.0, 0.0, 1.0);

    camera.update();

    renderer.projection = camera.combined;
    renderer.begin();
    for (int i = 0; i < width / 64; i++) {
      for (int j = 0; j < height / 64; j++) {
        renderer.draw(water, i * 64, j * 64, width: 64, height: 64);
      }
    }
    renderer.setUniform("waveData", new Vector2(angleWave, 0.9));
    renderer.setUniform("uLightColor", Colors.navy);
    renderer.end();
  }

  resize(num width, num height) {
    setGLViewport(canvasWidth, canvasHeight);
  }

  @override
  update(num delta) {
    angleWave += delta * 5.0;
    while (angleWave > PI * 2) angleWave -= PI * 2;
  }
}

class BoulderSprite {
  Texture texture;

  num x, y;

  BoulderSprite(this.texture, this.x, this.y);
}
