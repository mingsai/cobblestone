part of examples;

class HandpaintedExample extends BaseGame {
  ShaderProgram shaderProgram;

  Camera2D camera;

  SpriteBatch renderer;
  Texture wall;

  num rot = 0.0;
  num scale = 0.0;
  num scalemod = 1;

  @override
  create() {
    camera = new Camera2D.originBottomLeft(width, height);
    renderer = new SpriteBatch.defaultShader(gl);

    gl.setGLViewport(canvasWidth, canvasHeight);

    wall = assetManager.get("largewall.png");
  }

  @override
  preload() {
    assetManager.load("largewall.png", loadTexture(gl, "handpainted/largewall.png", mipMap));
  }

  @override
  render(num delta) {
    gl.clearScreen(0.0, 0.0, 0.0, 1.0);

    camera.update();

    renderer.projection = camera.combined;
    renderer.color = Colors.aliceBlue;
    renderer.begin();

    renderer.draw(wall, 0.0, 0.0, width: height, height: height);

    renderer.draw(wall, height, 0, width: height, height: height);

    renderer.draw(wall, width / 2 - 50, height / 2 - 50,
        width: 100.0,
        height: 100.0,
        flipX: true,
        scaleX: scale,
        scaleY: scale,
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
    if(scale > 5 || scale < 0.1) {
      scalemod = -scalemod;
    }
    scale += scalemod * 2 * delta;
  }

  @override
  config() {
    scaleMode = ScaleMode.resize;
  }

}
