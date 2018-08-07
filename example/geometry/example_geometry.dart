part of examples;

class GeometryExample extends BaseGame {
  ShaderProgram shaderProgram;

  Camera2D camera;

  SpriteBatch renderer;
  Texture nehe;

  bool get isLoaded => nehe != null;

  num rot = 0.0;

  @override
  create() {
    camera = new Camera2D.originBottomLeft(width, height);
    renderer = new SpriteBatch.defaultShader(gl);

    gl.setGLViewport(canvasWidth, canvasHeight);

    nehe = assetManager.get("nehe.gif");
  }

  @override
  preload() {
    assetManager.load("nehe.gif", loadTexture(gl, "geometry/nehe.gif"));
  }

  @override
  render(num delta) {
    gl.clearScreen(0.0, 0.0, 0.0, 1.0);

    camera.update();

    renderer.projection = camera.combined;
    renderer.begin();

    renderer.color = Colors.indianRed;
    renderer.draw(nehe, 0.0, 0.0, width: 100.0, height: 100.0);

    renderer.color = Colors.forestGreen;
    renderer.draw(nehe, 25.0, 25.0,
        width: 100.0, height: 100.0, flipX: true, flipY: true);

    if (rot < 2 * PI) {
      renderer.color = Colors.saddleBrown;
      renderer.draw(nehe, width - 50.0, 0.0, width: 50.0, height: height);
      print(rot);
    }

    renderer.color = Colors.lightSkyBlue;
    renderer.draw(nehe, 0.0, height - 100.0,
        width: 100.0, height: 100.0, flipY: true);

    renderer.color = Colors.lightGoldenrodYellow;
    renderer.draw(nehe, width / 2 - 50, height / 2 - 50,
        width: 100.0,
        height: 100.0,
        flipX: true,
        angle: rot,
        counterTurn: true);

    renderer.end();
  }

  resize(num width, num height) {
    gl.setGLViewport(canvasWidth, canvasHeight);
  }

  @override
  update(num delta) {
    rot += 0.5 * delta;
  }

  @override
  config() {
    scaleMode = ScaleMode.fit;
  }

}
