part of cobblestone;

/// A state (screen) of a game
abstract class State {

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
