part of cobblestone;

class Camera2D {

  static const num _near = -100;
  static const num _far = 100;

  /// Projection matrix for the camera.
  Matrix4 projection;

  /// The transformations applied to the camera.
  Transform transform;

  /// Matrix updated to combine camera projection and transformations.
  ///
  /// Set this as projection matrix on batches to use when drawing.
  Matrix4 combined;

  /// Quad, updated with the corners as the boundaries of the region the camera projects on screen.
  Quad view = Quad();

  /// Width of the view seen through this camera.
  num viewWidth;
  /// Width of the view seen through this camera.
  num viewHeight;

  num _projOffsetX;
  num _projOffsetY;

  /// Creates a camera width 0, 0 in the bottom left of the view.
  Camera2D.originBottomLeft(this.viewWidth, this.viewHeight) {
    setDefaults();
    projection = makeOrthographicMatrix(0, viewWidth, 0, viewHeight, _near, _far);
    _projOffsetX = 0;
    _projOffsetY = 0;
    update();
  }

  /// Creates a camera width 0, 0 in the center of the view.
  Camera2D.originCenter(this.viewWidth, this.viewHeight) {
    setDefaults();
    projection = makeOrthographicMatrix(
        -viewWidth / 2, viewWidth / 2, -viewHeight / 2, viewHeight / 2, _near, _far);
    _projOffsetX = -viewWidth / 2;
    _projOffsetY = -viewHeight / 2;
    update();
  }

  /// Creates a camera with a view bounded by [left], [right], [top], and [bottom].
  Camera2D.sides(num left, num right, num top, num bottom) {
    setDefaults();
    projection = makeOrthographicMatrix(left, right, bottom, top, _near, _far);
    viewWidth = right - left;
    viewHeight = top - bottom;
    _projOffsetX = -left;
    _projOffsetY = -bottom;
    update();
  }

  /// Creates a camera identical to [other]
  Camera2D.copy(Camera2D other) {
    setDefaults();
    projection = new Matrix4.copy(other.projection);
    transform = new Transform.copy(other.transform);
    viewWidth = other.viewWidth;
    viewHeight = other.viewHeight;
    _projOffsetX = other._projOffsetX;
    _projOffsetY = other._projOffsetY;
    update();
  }

  void setDefaults() {
    transform = new Transform.identity();
    combined = new Matrix4.identity();
  }

  void translate(x, [num y]) {
    transform.translate(x, y);
  }

  void setTranslation(x, [num y]) {
    transform.setTranslation(x, y);
  }

  void rotate(num amount, bool counter) {
    transform.rotate(amount, counter);
  }

  void setRotation(num angle) {
    transform.setRotation(angle);
  }

  void scale(x, [num y]) {
    transform.scale(x, y);
  }

  void setScale(x, [num y]) {
    transform.setScale(x, y);
  }

  void update() {
    transform.update();

    combined.setFrom(projection);
    combined.multiply(transform.invCombined);

    view.point0.setValues(_projOffsetX, _projOffsetY, 0);
    view.point1.setValues(_projOffsetX + viewWidth, _projOffsetY, 0);
    view.point2.setValues(_projOffsetX + viewWidth, _projOffsetY + viewHeight, 0);
    view.point3.setValues(_projOffsetX, _projOffsetY + viewHeight, 0);

    view.transform(transform.combined);
  }

  bool get roundInt => transform.roundInt;
  set roundInt(bool round) {
    transform.roundInt = round;
  }

  num get x => transform.x;
  num get y => transform.y;

  set x(num x) {
    transform.x = x;
  }

  set y(num y) {
    transform.y = y;
  }

  num get scaleX => transform.scaleX;
  num get scaleY => transform.scaleY;

  set scaleX(num scaleX) =>
      transform.setTranslation(scaleX.toDouble(), scaleY.toDouble());
  set scaleY(num scaleY) =>
      transform.setTranslation(scaleX.toDouble(), scaleY.toDouble());
}
