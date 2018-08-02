part of examples;

const double gravity = -9.8;
Random rand = new Random();

class PerformanceExample extends BaseGame {
  Camera2D camera;

  SpriteBatch renderer;

  List<BoulderSprite> boulders = [];

  @override
  create() {
    camera = new Camera2D.originBottomLeft(width, height);
    renderer = new SpriteBatch.defaultShader(gl, maxSprites: 20000);

    gl.setGLViewport(canvasWidth, canvasHeight);

    Texture boulderSheet = assetManager.get("boulders2.png");
    int num = 0;

    List<Texture> textures = boulderSheet.split(16, 16);
    for (int i = 0; i < 100000; i++) {
      boulders.add(new BoulderSprite(textures[rand.nextInt(textures.length)],
          rand.nextInt(width), rand.nextInt(height ~/ 2) + height / 2));
    }
  }

  @override
  preload() {
    assetManager.load("boulders2.png", loadTexture(gl, "performance/boulders2.png"));
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
    for (BoulderSprite sprite in boulders) {
      sprite.update(delta);
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
}

class BoulderSprite {
  Texture texture;

  num speedX, speedY;
  num x, y;

  BoulderSprite(this.texture, this.x, this.y) {
    speedX = (rand.nextDouble() * 100) - 50;
    speedY = (rand.nextDouble() * 100) - 50;
  }

  update(double delta) {
    this.x += speedX * delta;
    this.y += speedY * delta;
    this.speedY += gravity * delta;

    if (x > 640) {
      speedX *= -1;
      x = 640;
    } else if (x < 0) {
      speedX *= -1;
      x = 0;
    }

    if (y < 0) {
      speedY *= -0.85;
      y = 0;
    } else if (y > 480) {
      speedY = 0;
      y = 480;
    }
  }

}
