import 'package:cobblestone/cobblestone.dart';

main() {
  new GeometryExample();
}

class GeometryExample extends BaseGame {

  ShaderProgram shaderProgram;

  Mesh triangle, square;

  Camera2D camera;
  Matrix4 pMatrix;

  SpriteBatch renderer;
  GameTexture nehe;

  bool get isLoaded => nehe != null;

  num x = 0;
  num mod = 5;

  num rot = 0.5;

  @override
  create() {
    camera = new Camera2D.originBottomLeft(width, height);
    renderer = new SpriteBatch.defaultShader();

    setGLViewport(canvasWidth, canvasHeight);

    nehe = assetManager.get("nehe.png");
  }

  @override
  preload() {
    assetManager.load("nehe.png", loadTexture("nehe.png", nearest));
  }

  @override
  render(num delta) {
    clearScreen(0.0, 0.0, 0.0, 1.0);

    camera.update();

    renderer.projection = camera.combined;
    renderer.begin();

    renderer.color = Colors.indianRed;
    renderer.draw(nehe, 0.0, 0.0, 100.0, 100.0);

    renderer.color = Colors.forestGreen;
    renderer.draw(nehe, 25.0, 25.0, 100.0, 100.0);

    renderer.color = Colors.saddleBrown;
    renderer.draw(nehe, width - 50.0, 0.0, 50.0, height);

    renderer.color = Colors.lightSkyBlue;
    renderer.draw(nehe, 0.0, height - 100.0, 100.0, 100.0);

    renderer.color = Colors.lightGoldenrodYellow;
    renderer.draw(nehe, width / 2 - 50, height / 2 - 50, 100.0, 100.0);

    renderer.end();
  }

  resize(num width, num height) {
    setGLViewport(canvasWidth, canvasHeight);
  }

  @override
  update(num delta) {
    x += mod * delta;
    if(x >= width) {
      mod = -mod;
    }
    if(x <= -200) {
      mod = -mod;
    }

    rot += 0.5 * delta;
  }
}