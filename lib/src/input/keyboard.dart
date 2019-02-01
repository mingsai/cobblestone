part of cobblestone;

// Based on code from https://stackoverflow.com/questions/13746105/how-to-listen-to-key-press-repetitively-in-dart-for-games
class Keyboard {

  // A map between key codes and the time the key was pressed
  Map<int, num> keys = new Map<int, num>();

  // A map of just-typed keys
  Map<int, num> justTyped = new Map<int, num>();

  List<StreamSubscription> _subs = [];

  Keyboard() {
    _subs.add(window.onKeyDown.listen((KeyboardEvent e) {
      // If the key is not set yet, set it with a timestamp.
      if (!keys.containsKey(e.keyCode))
        keys[e.keyCode] = e.timeStamp;
    }));
        _subs.add(window.onKeyUp.listen((KeyboardEvent e) {
      // Remove the key, it is no longer pressed
      keys.remove(e.keyCode);

      // Typed doesn't fire until key up
      justTyped[e.keyCode] = e.timeStamp;
    }));

    _subs.add(window.onFocus.listen((Event e) {
      // Clear all keys, they shouldn't be active when the window is unfocused
      keys.clear();
    }));
    _subs.add(window.onBlur.listen((Event e) {
      // Clear all keys, they shouldn't be active when the window is unfocused
      keys.clear();
    }));
  }

  update() {
    // Only keep these for a frame
    justTyped.clear();
  }

  // Checks if a given key code, from [KeyCode], is pressed
  keyPressed(int keyCode) => keys.containsKey(keyCode);

  // Checks if a key was just typed. Only true for a frame
  keyJustTyped(int keyCode) => justTyped.containsKey(keyCode);

  cancelSubs() {
    for(var sub in _subs) {
      sub.cancel();
    }
  }

}