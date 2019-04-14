part of cobblestone;

// Based on code from https://stackoverflow.com/questions/13746105/how-to-listen-to-key-press-repetitively-in-dart-for-games
class Keyboard {
  // A map between key codes and the time the key was pressed
  Map<int, num> _keys = new Map<int, num>();

  // A map of keys pressed last frame
  Map<int, num> _lastKeys = new Map<int, num>();

  List<StreamSubscription> _subs = [];

  Keyboard() {
    _subs.add(window.onKeyDown.listen((KeyboardEvent e) {
      // If the key is not set yet, set it with a timestamp.
      if (!_keys.containsKey(e.keyCode)) _keys[e.keyCode] = e.timeStamp;
    }));
    _subs.add(window.onKeyUp.listen((KeyboardEvent e) {
      // Remove the key, it is no longer pressed
      _keys.remove(e.keyCode);
    }));

    _subs.add(window.onFocus.listen((Event e) {
      // Clear all keys, they shouldn't be active when the window is unfocused
      _keys.clear();
    }));
    _subs.add(window.onBlur.listen((Event e) {
      // Clear all keys, they shouldn't be active when the window is unfocused
      _keys.clear();
    }));
  }

  update() {
    _lastKeys.clear();
    _lastKeys.addAll(_keys);
  }

  // Checks if a given key code, from [KeyCode], is pressed
  keyPressed(int keyCode) => _keys.containsKey(keyCode);

  // Checks if a key was just released. Only true for a frame
  keyJustReleased(int keyCode) =>
      _lastKeys.containsKey(keyCode) && !_keys.containsKey(keyCode);

  // Checks if a key was just pressed. Only true for a frame
  keyJustPressed(int keyCode) =>
      !_lastKeys.containsKey(keyCode) && _keys.containsKey(keyCode);

  cancelSubs() {
    for (var sub in _subs) {
      sub.cancel();
    }
  }
}
