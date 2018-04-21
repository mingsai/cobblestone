part of cobblestone;

/// A state (screen) of a game
abstract class State {

  BaseGame get game;

  GLWrapper get gl => game.gl;

  int get requestedWidth => game.requestedWidth;
  int get requestedHeight => game.requestedHeight;

  ScaleMode get scaleMode => game.scaleMode;

  CanvasElement get canvas => game.canvas;
  int get canvasWidth => game.canvasWidth;
  int get canvasHeight => game.canvasHeight;

  int get width => game.width;
  int get height => game.height;

  AssetManager get assetManager => game.assetManager;

  Tween.TweenManager get tweenManager => game.tweenManager;

  AudioWrapper get audio => game.audio;

  Keyboard get keyboard => game.keyboard;
  Mouse get mouse => game.mouse;

  /// Loads assets here using [assetManager]
  preload();

  /// Creates new game elements with loaded assets here.
  create();

  /// Resumes the state. Subscribe to input here.
  resume();

  /// Pauses the state. Unsubscribe from input here.
  pause();

  /// Updates the state. Called before [render]
  update(num delta);

  /// Renders the state. Called before [render]
  render(num delta);

  /// Called after canvas changes size
  resize(num width, num height);

}
