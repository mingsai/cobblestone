part of examples;

class ParticlesExample extends BaseGame {

  Camera2D camera;

  SpriteBatch renderer;

  ParticleEmitter emitter;

  @override
  create() {
    camera = new Camera2D.originCenter(width, height);
    renderer = new SpriteBatch.defaultShader(gl);

    gl.setGLViewport(canvasWidth, canvasHeight);

    ParticleEffect effect = assetManager.get("flame");
    emitter = new ParticleEmitter(effect);
}

  @override
  preload() {
    assetManager.load("flame", loadEffect("particles/smoke.json", loadTexture(gl, "particles/smokeparticle.png", linear)));
  }

  @override
  render(num delta) {
    gl.clearScreen(Colors.gray);

    camera.update();

    gl.context.enable(WebGL.BLEND);
    gl.context.blendFuncSeparate(WebGL.SRC_ALPHA, WebGL.ONE_MINUS_SRC_ALPHA, WebGL.ONE, WebGL.ONE_MINUS_SRC_ALPHA);
    //gl.context.blendFunc(WebGL.SRC_ALPHA, WebGL.ONE_MINUS_SRC_ALPHA);
    renderer.projection = camera.combined;
    renderer.begin();
    renderer.texture = emitter.effect.texture;

    emitter.draw(renderer);

    renderer.end();
  }

  resize(num width, num height) {
    gl.setGLViewport(canvasWidth, canvasHeight);
  }

  @override
  update(num delta) {
    emitter.update(delta);
  }

  @override
  config() {
    scaleMode = ScaleMode.fit;
  }

}
