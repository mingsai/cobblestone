part of cobblestone;

/// Global WedAudio context
// TODO THE LAST GLOBAL


/// A base class for programming games
///
/// This is the starting point for most development with the engine
abstract class BaseGame implements State {

  /// A stopwatch, used to calculate delta time
  Stopwatch _stopwatch;

  /// Wrapper around common WebGL functions
  GLWrapper gl;

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

  /// The effective width of the game. Use this for most calculations.
  /// Varies based on actual canvas size, and [scaleMode]
  int width;
  /// The effective width of the game. Use this for most calculations.
  /// Varies based on actual canvas size, and [scaleMode]
  int height;

  /// Game asset manager to the asset manager
  final AssetManager assetManager = new AssetManager();

  /// The game tween manager
  final TweenManager tweenManager = new TweenManager();

  // Game audio context
  final AudioWrapper audio = new AudioWrapper();

  // Keyboard input polling
  Keyboard keyboard;
  // Mouse input polling
  Mouse mouse;

  BaseGame get game => this;

  bool _started;

  /// Creates a new game with the first canvas element
  BaseGame(): this.query("canvas");

  /// Creates a new game with the canvas selected by [selector]
  BaseGame.query(String selector): this.withCanvas(querySelector(selector));


  /// Creates a new game with [canvas]
  BaseGame.withCanvas(this.canvas) {
    config();
    gl = new GLWrapper(canvas.getContext3d());
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

    gl.setGLViewport(canvasWidth, canvasHeight);

    if (_started) resize(width, height);
  }

  /// Sets some things up, and starts the loop.
  _startLoop() {
    keyboard = new Keyboard();
    mouse = new Mouse();

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
    window.onResize.listen((Event e) => _resizeCanvas());

    _started = true;
  }

  /// A tick in the game loop
  _tick(time) {
    if (_started) {
      double delta = _stopwatch.elapsedMilliseconds / 1000.0;
      _stopwatch.reset();

      // Don't update right after long breaks (e.g. window minimized)
      delta = delta < 1 ? delta : 0.0;

      tweenManager.update(delta);
      update(delta);
      render(delta);

      keyboard.update();
      mouse.update();
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
