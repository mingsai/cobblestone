part of cobblestone;

/// A container that tracks current state of a user's mouse
class Mouse {
  /// Width and height of the [BaseGame]
  num _width, _height;
  CanvasElement _canvas;

  /// A list of subscription events used to get mouse data
  List<StreamSubscription> _subs = [];

  /// The current position of the mouse on the game canvas
  Vector2 canvasPos = Vector2.zero();
  /// The current position of the mouse on the engine screen, as created by the [BaseGame]'s [ScaleMode]
  Vector2 screenPos = Vector2.zero();

  /// Temporary variable used for camera unprojection
  Vector3 _coordTransform = Vector3.zero();

  /// A map between button numbers and the time the key was pressed
  Map<int, num> _buttons = new Map<int, num>();

  /// A map of buttons pressed last frame
  Map<int, num> _lastButtons = new Map<int, num>();

  /// Returns true if the left mouse button is currently down
  bool get leftDown => _buttons.containsKey(0);
  /// Returns true if the middle mouse button is currently down
  bool get middleDown => _buttons.containsKey(1);
  /// Returns true if the right mouse button is currently down
  bool get rightDown => _buttons.containsKey(2);

  /// Returns true if the left mouse button was just released this frame
  bool get leftJustReleased =>
      _lastButtons.containsKey(0) && !_buttons.containsKey(0);
  /// Returns true if the middle mouse button was just released this frame
  bool get middleJustReleased =>
      _lastButtons.containsKey(1) && !_buttons.containsKey(0);
  /// Returns true if the right mouse button was just released this frame
  bool get rightJustReleased =>
      _lastButtons.containsKey(2) && !_buttons.containsKey(0);

  /// Returns true if the left mouse button was just pressed this frame
  bool get leftJustPressed =>
      !_lastButtons.containsKey(0) && _buttons.containsKey(0);
  /// Returns true if the middle mouse button was just pressed this frame
  bool get middleJustPressed =>
      !_lastButtons.containsKey(1) && _buttons.containsKey(1);
  /// Returns true if the right mouse button was just pressed this frame
  bool get rightJustPressed =>
      !_lastButtons.containsKey(2) && _buttons.containsKey(2);

  /// Creates a new Mouse and subscribes to input events
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

  /// Calculate screenPos from the canvasPos of the event
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

  /// Returns the coordinates of the point in a scene rendered through [camera] which would project to the current mouse position
  Vector2 worldCoord(Camera2D camera) {
    unproject(camera.projection, 0.0, _width, 0.0, _height,
        screenPos.x, screenPos.y, 1.0, _coordTransform);
    _coordTransform = camera.transform.combined.transform3(_coordTransform);
    return _coordTransform.xy;
  }

  /// Moves the mouse into the next logical "frame".
  ///
  /// Automatically called in [BaseGame] but may be used for a implementing a custom timestep.
  update() {
    _lastButtons.clear();
    _lastButtons.addAll(_buttons);
  }

  _resize(num width, num height) {
    this._width = width;
    this._height = height;
  }

  _cancelSubs() {
    for (var sub in _subs) {
      sub.cancel();
    }
  }
}
