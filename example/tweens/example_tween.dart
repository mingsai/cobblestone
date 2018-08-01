import 'package:cobblestone/cobblestone.dart';

main() {
  new TweenExample();
}

class TweenExample extends BaseGame {
  ShaderProgram shaderProgram;

  Camera2D camera;

  SpriteBatch renderer;
  Texture nehe;

  Box box;

  @override
  create() {
    camera = new Camera2D.originBottomLeft(width, height);
    renderer = new SpriteBatch.defaultShader(gl);

    gl.setGLViewport(canvasWidth, canvasHeight);

    nehe = assetManager.get("nehe.gif");

    box = new Box(0.0, 0.0);

    new Tween()
      ..get = [() => box.x, () => box.y]
      ..set = [(v) => box.x = v, (v) => box.y = v]
      ..target = [width - 50, height - 50]
      ..duration = 10.0
      ..delay = 1.0
      ..ease = backInOut
      ..callback = (() => print("Tween Complete"))
      ..start(tweenManager);
  }

  @override
  preload() {
    assetManager.load("nehe.gif", loadTexture(gl, "nehe.gif", nearest));
  }

  @override
  render(num delta) {
    gl.clearScreen(0.0, 0.0, 0.0, 1.0);

    camera.update();

    renderer.projection = camera.combined;
    renderer.begin();

    renderer.draw(nehe, box.x, box.y, width: 50, height: 50);

    renderer.end();
  }

  resize(num width, num height) {
    gl.setGLViewport(canvasWidth, canvasHeight);
  }

  @override
  update(num delta) {

  }

  @override
  config() {
    scaleMode = ScaleMode.fit;
  }

}

class Box {
  double x, y;

  Box(this.x, this.y);
}
