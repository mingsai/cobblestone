part of cobblestone;

/// A set of tweens that updates each one
class TweenManager {

  // List of tweens in the manager
  List<Tween> _activeTweens = [];

  TweenManager();

  /// Adds a tween to the manager
  add(Tween tween) {
    _activeTweens.add(tween);
  }

  /// Updates all tweens in the manager
  update(num delta) {
    for(var tween in _activeTweens) {
      tween.update(delta);
    }
    _activeTweens.removeWhere((t) => t.finished);
  }

}