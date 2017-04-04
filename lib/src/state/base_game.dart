part of cobblestone;

AssetManager assetManager;
Tween.TweenManager tweenManager;

int width, height;

abstract class BaseGame implements State {
  num delta = 0;
  Stopwatch stopwatch;

  int requestedWidth = 640;
  int requestedHeight = 480;
  ScaleMode scaleMode = ScaleMode.fit;

  CanvasElement canvas;
  int canvasWidth, canvasHeight;

  bool started;

  BaseGame() {
    canvas = querySelector("canvas");
    gl = canvas.getContext3d();
    config();
    resizeCanvas();
    startLoop();
  }

  BaseGame.query(String selector) {
    canvas = querySelector(selector);
    config();
    gl = canvas.getContext3d();
    resizeCanvas();
    startLoop();
  }

  BaseGame.withCanvas(CanvasElement canvas) {
    gl = canvas.getContext3d();
    resizeCanvas();
    startLoop();
  }

  resizeCanvas() {
    scaleCanvas(canvas, scaleMode, requestedWidth, requestedHeight,
        window.innerWidth, window.innerHeight);
    canvasWidth = canvas.width;
    canvasHeight = canvas.height;

    width = effectiveDimension(scaleMode, requestedWidth, canvasWidth);
    height = effectiveDimension(scaleMode, requestedHeight, canvasHeight);

    setGLViewport(canvasWidth, canvasHeight);

    if (started) resize(width, height);
  }

  startLoop() {
    assetManager = new AssetManager();
    tweenManager = new Tween.TweenManager();

    Tween.Tween.combinedAttributesLimit = 4;
    Tween.Tween.registerAccessor(num, new NumberAccessor());
    Tween.Tween.registerAccessor(Vector2, new Vector2Accessor());
    Tween.Tween.registerAccessor(Vector3, new Vector3Accessor());
    Tween.Tween.registerAccessor(Vector4, new Vector4Accessor());

    loadDefaultShaders();
    preload();

    tick(0);
  }

  config() {}

  preload();

  create();

  void start() {
    create();

    stopwatch = new Stopwatch();
    stopwatch.start();

    resizeCanvas();
    window.onResize.listen((Event e) {
      resizeCanvas();
    });

    started = true;
  }

  tick(time) {
    if (started) {
      delta = stopwatch.elapsedMilliseconds / 1000.0;
      stopwatch.reset();

      setGLOptions();

      tweenManager.update(delta);
      update(delta);
      render(delta);
    } else if (assetManager.allLoaded()) {
      start();
    }

    window.animationFrame.then(tick);
  }

  update(num delta);

  render(num delta);

  resize(num width, num height) {}

  end() {}

  pause() {}

  resume() {}

}
