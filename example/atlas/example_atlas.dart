import 'package:cobblestone/cobblestone.dart';

main() {
  new GeometryExample();
}

class GeometryExample extends BaseGame {
  SpriteBatch renderer;
  Camera2D camera;

  @override
  create() {
    camera = new Camera2D.originBottomLeft(width, height);
    renderer = new SpriteBatch.defaultShader(gl);

    gl.setGLViewport(canvasWidth, canvasHeight);
  }

  @override
  preload() {
    assetManager.load("atlas",
        loadAtlas("atlas/atlas.json", loadTexture(gl, "atlas/atlas.png", nearest)));
    print(defaultShader);
  }

  @override
  render(num delta) {
    gl.clearScreen(0.0, 1.0, 1.0, 1.0);

    camera.update();

    renderer.projection = camera.combined;
    renderer.begin();
    renderer.draw(assetManager.get("atlas")["spriteA"], 0, 0,
        width: 64, height: 64);
    renderer.draw(assetManager.get("atlas")["spriteB"], 64, 0,
        width: 64, height: 64);
    renderer.draw(assetManager.get("atlas")["spriteC"], 128, 0,
        width: 64, height: 64);
    renderer.end();
  }

  resize(num width, num height) {
    gl.setGLViewport(canvasWidth, canvasHeight);
  }

  @override
  update(num delta) {}
}
