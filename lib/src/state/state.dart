part of cobblestone;

/// A state/screen of a game
abstract class State {

  /// The base game this state is a part of.
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

  TweenManager get tweenManager => game.tweenManager;

  AudioWrapper get audio => game.audio;

  Keyboard get keyboard => game.keyboard;
  Mouse get mouse => game.mouse;

  /// Loads assets using [assetManager].
  preload();

  /// Creates new game elements with loaded assets.
  create();

  /// Resumes the state.
  resume();

  /// Pauses the state.
  pause();

  /// Updates the state. Called before [render].
  update(num delta);

  /// Renders the state. Called after [update].
  render(num delta);

  /// Called after canvas changes size. May cause internal size to change depending on [scaleMode]
  resize(num width, num height);

}
