part of cobblestone;

// The current state of a user's mouse
class Mouse {
  // Width and height of the game
  num _width, _height;
  // Game canvas
  CanvasElement _canvas;

  // Position of the mouse on the canvas
  Vector2 canvasPos = Vector2.zero();
  // Position of the mouse on the engine screen
  Vector2 screenPos = Vector2.zero();

  // Temporary variable used for camera unprojection
  Vector3 _coordTransform = Vector3.zero();

  // A map between button numbers and the time the key was pressed
  Map<int, num> _buttons = new Map<int, num>();

  // A map of buttons pressed last frame
  Map<int, num> _lastButtons = new Map<int, num>();

  bool get leftDown => _buttons.containsKey(0);
  bool get middleDown => _buttons.containsKey(1);
  bool get rightDown => _buttons.containsKey(2);

  bool get leftJustReleased =>
      _lastButtons.containsKey(0) && !_buttons.containsKey(0);
  bool get middleJustReleased =>
      _lastButtons.containsKey(1) && !_buttons.containsKey(0);
  bool get rightJustReleased =>
      _lastButtons.containsKey(2) && !_buttons.containsKey(0);

  bool get leftJustPressed =>
      !_lastButtons.containsKey(0) && _buttons.containsKey(0);
  bool get middleJustPressed =>
      !_lastButtons.containsKey(1) && _buttons.containsKey(1);
  bool get rightJustPressed =>
      !_lastButtons.containsKey(2) && _buttons.containsKey(2);

  List<StreamSubscription> _subs = [];

  Mouse(this._canvas) {
    _subs.add(window.onMouseDown.listen((MouseEvent e) {
      _updatePos(e);
      if (!_buttons.containsKey(e.button)) _buttons[e.button] = e.timeStamp;
    }));
    _subs.add(window.onMouseMove.listen((MouseEvent e) => _updatePos(e)));
    _subs.add(window.onMouseUp.listen((MouseEvent e) {
      _updatePos(e);
      if (_buttons.containsKey(e.button)) _buttons.remove(e.button);
    }));

    _subs.add(window.onContextMenu.listen((MouseEvent e) {
      e.preventDefault();
    }));
  }

  // Calculate screenPos from the canvasPos of the event
  void _updatePos(MouseEvent e) {
    canvasPos.setValues(
        e.client.x.toDouble(), (window.innerHeight - e.client.y).toDouble());
    var rect = _canvas.getBoundingClientRect();
    screenPos = new Vector2(
        (canvasPos.x - rect.left) * (_width / _canvas.width),
        (canvasPos.y - rect.top) * (_height / _canvas.height));
    if (screenPos.x < 0) {
      screenPos.x = 0.0;
    }
    if (screenPos.x > _width) {
      screenPos.x = _width;
    }
    if (screenPos.y < 0) {
      screenPos.y = 0.0;
    }
    if (screenPos.y > _height) {
      screenPos.y = _height;
    }
  }

  // Returns the coordinates of the point which would project to the current mouse position
  Vector2 worldCoord(Camera2D camera) {
    unproject(camera.projection, 0.0, _width, 0.0, _height,
        screenPos.x, screenPos.y, 1.0, _coordTransform);
    _coordTransform = camera.transform.combined.transform3(_coordTransform);
    return _coordTransform.xy;
  }

  update() {
    _lastButtons.clear();
    _lastButtons.addAll(_buttons);
  }

  resize(num width, num height) {
    this._width = width;
    this._height = height;
  }

  cancelSubs() {
    for (var sub in _subs) {
      sub.cancel();
    }
  }
}
