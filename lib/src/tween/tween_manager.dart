part of cobblestone;

/// A set of tweens that updates each one
class TweenManager {

  // List of tweens in the manager
  List<Tween> _activeTweens = [];

  // Buffer of tweens to add before the next update
  List<Tween> _tweensToAdd = [];

  TweenManager();

  /// Adds a tween to the manager
  add(Tween tween) {
    _tweensToAdd.add(tween);
  }

  /// Updates all tweens in the manager
  update(num delta) {
    for(var tween in _tweensToAdd) {
      _activeTweens.add(tween);
    }
    _tweensToAdd.clear();

    for(var tween in _activeTweens) {
      tween.update(delta);
    }
    _activeTweens.removeWhere((t) => t.finished);
  }

}