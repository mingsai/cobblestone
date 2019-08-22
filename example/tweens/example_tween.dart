part of examples;

class TweenExample extends BaseGame {
  ShaderProgram shaderProgram;

  Camera2D camera;

  SpriteBatch renderer;
  Texture nehe;

  Box box;

  @override
  create() {
    camera = Camera2D.originBottomLeft(width, height);
    renderer = SpriteBatch.defaultShader(gl);

    gl.setGLViewport(canvasWidth, canvasHeight);

    nehe = assetManager.get("nehe.gif");

    box = Box(0.0, 0.0);

    var getPos = [() => box.x, () => box.y];
    var setPos = [(v) => box.x = v, (v) => box.y = v];

    Tween()
      ..get = getPos
      ..set = setPos
      ..target = [width - 50, height - 50]
      ..duration = 10.0
      ..delay = 1.0
      ..ease = Ease.backInOut
      ..callback = (() => print("Tween 1 Complete"))
      ..chain(Tween()
        ..get = getPos
        ..set = setPos
        ..target = [0.0, 0.0]
        ..duration = 10.0
        ..ease = Ease.expoInOut)
      ..start(tweenManager);
  }

  @override
  preload() {
    assetManager.load("nehe.gif", loadTexture(gl, "tweens/nehe.gif", nearest));
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
  update(num delta) {}

  @override
  config() {
    scaleMode = ScaleMode.fit;
  }
}

class Box {
  double x, y;

  Box(this.x, this.y);
}
