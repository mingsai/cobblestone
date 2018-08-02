part of examples;

class FBOExample extends BaseGame {
  ShaderProgram effect;

  Camera2D camera;

  SpriteBatch renderer;
  Texture nehe;

  Framebuffer fbo;

  num rot = 0.0;

  @override
  create() {
    camera = new Camera2D.originBottomLeft(width, height);
    renderer = new SpriteBatch.defaultShader(gl);

    gl.setGLViewport(canvasWidth, canvasHeight);

    nehe = assetManager.get("nehe.gif");
    effect = assetManager.get("effect");

    fbo = new Framebuffer(gl, canvasWidth, canvasHeight, shader: effect);
  }

  @override
  preload() {
    assetManager.load("nehe.gif", loadTexture(gl, "fbo/nehe.gif", nearest));
    assetManager.load(
        "effect", loadProgram(gl, "fbo/effect.vertex", "fbo/effect.fragment"));
  }

  @override
  render(num delta) {
    fbo.beginCapture();
    gl.clearScreen(0.0, 0.0, 0.0, 1.0);

    camera.update();

    renderer.projection = camera.combined;
    renderer.begin();

    renderer.color = Colors.indianRed;
    renderer.draw(nehe, 0.0, 0.0, width: 100.0, height: 100.0);

    renderer.color = Colors.forestGreen;
    renderer.draw(nehe, 25.0, 25.0,
        width: 100.0, height: 100.0, flipX: true, flipY: true);

    renderer.color = Colors.saddleBrown;
    renderer.draw(nehe, width - 50.0, 0.0, width: 50.0, height: height);

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
    fbo.endCapture();

    fbo.render(camera.projection, 20, 20, width, height);
  }

  resize(num width, num height) {
    gl.setGLViewport(canvasWidth, canvasHeight);
  }

  @override
  update(num delta) {
    rot += 0.5 * delta;
  }
}
