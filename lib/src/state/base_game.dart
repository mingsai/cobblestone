part of cobblestone;

/// Global reference to the asset manager
AssetManager assetManager;
/// Global reference to the tween manager
Tween.TweenManager tweenManager;

/// The effective width of the game. Use this for most calculations.
/// Varies based on actual canvas size, and [scaleMode]
int width;
/// The effective width of the game. Use this for most calculations.
/// Varies based on actual canvas size, and [scaleMode]
int height;

/// A base class for programming games
///
/// This is the starting point for most development with the engine
abstract class BaseGame implements State {

  /// A stopwatch, used to calculate delta time
  Stopwatch _stopwatch;

  /// The requested width of the game window. Used for [ScaleMode.fit] or [ScaleMode.fill]
  int requestedWidth = 640;
  /// The requested width of the game window. Used for [ScaleMode.fit] or [ScaleMode.fill]
  int requestedHeight = 480;
  /// The method used to scale the game canvas
  ScaleMode scaleMode = ScaleMode.fit;

  CanvasElement canvas;
  /// The actual width of the canvas
  int canvasWidth;
  /// The actual height of the canvas
  int canvasHeight;

  bool _started;

  /// Creates a new game with the first canvas element
  BaseGame(): this.query("canvas");

  /// Creates a new game with the canvas selected by [selector]
  BaseGame.query(String selector): this.withCanvas(querySelector(selector));


  /// Creates a new game with [canvas]
  BaseGame.withCanvas(this.canvas) {
    config();
    gl = canvas.getContext3d();
    _resizeCanvas();
    _startLoop();
  }

  /// Resizes the canvas upon resize events
  _resizeCanvas() {
    scaleCanvas(canvas, scaleMode, requestedWidth, requestedHeight,
        window.innerWidth, window.innerHeight);
    canvasWidth = canvas.width;
    canvasHeight = canvas.height;

    width = effectiveDimension(scaleMode, requestedWidth, canvasWidth);
    height = effectiveDimension(scaleMode, requestedHeight, canvasHeight);

    setGLViewport(canvasWidth, canvasHeight);

    if (_started) resize(width, height);
  }

  /// Sets some things up, and starts the loop.
  _startLoop() {
    assetManager = new AssetManager();
    tweenManager = new Tween.TweenManager();

    Tween.Tween.combinedAttributesLimit = 4;
    Tween.Tween.registerAccessor(num, new NumberAccessor());
    Tween.Tween.registerAccessor(Vector2, new Vector2Accessor());
    Tween.Tween.registerAccessor(Vector3, new Vector3Accessor());
    Tween.Tween.registerAccessor(Vector4, new Vector4Accessor());

    loadDefaultShaders();
    preload();

    _tick(0);
  }

  /// First method in lifecycle. Set [scaleMode], [requestedWidth], and [requestedHeight] here.
  config() {}

  /// Second method in lifecycle. Load assets here using [assetManager]
  preload();

  /// Last method called in the beginning of the game. Create new game elements with loaded assets here.
  create();

  /// Actually initializes the game
  _start() {
    create();

    _stopwatch = new Stopwatch();
    _stopwatch.start();

    _resizeCanvas();
    window.onResize.listen(_resizeCanvas());

    _started = true;
  }

  /// A tick in the game loop
  _tick(time) {
    if (_started) {
      double delta = _stopwatch.elapsedMilliseconds / 1000.0;
      _stopwatch.reset();

      _setGLOptions();

      tweenManager.update(delta);
      update(delta);
      render(delta);
    } else if (assetManager.allLoaded()) {
      _start();
    }

    window.animationFrame.then(_tick);
  }

  /// Updates the game. Called before [render]
  update(num delta);

  /// Renders the game. Called after [update]
  render(num delta);

  /// Called after canvas changes size
  resize(num width, num height) {}

  /// Pauses the game. Unsubscribe from input here.
  pause() {}

  /// Resumes the game. Subscribe to input here.
  resume() {}

}
