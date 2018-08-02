part of cobblestone;

// The current state of a user's mouse
class Mouse {

  int x, y;

  // A map between button numbers and the time the key was pressed
  Map<int, num> buttons = new Map<int, int>();

  // A map of just-clicked buttons
  Map<int, num> justClicked = new Map<int, int>();

  bool get leftDown => buttons.containsKey(0);
  bool get middleDown => buttons.containsKey(1);
  bool get rightDown => buttons.containsKey(2);

  bool get leftJustClicked => justClicked.containsKey(0);
  bool get middleJustClicked => justClicked.containsKey(1);
  bool get rightJustClicked => justClicked.containsKey(2);

  List<StreamSubscription> _subs = [];

  Mouse() {
    _subs.add(window.onMouseDown.listen((MouseEvent e) {
      _updatePos(e);
      if (!buttons.containsKey(e.button))
        buttons[e.button] = e.timeStamp;
    }));
    _subs.add(window.onMouseMove.listen((MouseEvent e) => _updatePos(e)));
    _subs.add(window.onMouseUp.listen((MouseEvent e) {
      _updatePos(e);
      if (buttons.containsKey(e.button))
        buttons.remove(e.button);

      // Click doesn't fire until lifted up
      justClicked[e.button] = e.timeStamp;
    }));

    _subs.add(window.onContextMenu.listen((MouseEvent e) {
      e.preventDefault();
    }));
  }

  void _updatePos(MouseEvent e) {
    x = e.client.x;
    y = window.innerHeight - e.client.y;
  }

  update() {
    // Only be just-clicked for a frame
    justClicked.clear();
  }

  cancelSubs() {
    for(var sub in _subs) {
      sub.cancel();
    }
  }

}