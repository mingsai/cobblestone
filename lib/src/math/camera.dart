part of cobblestone;

/// An orhographic camera,
///
/// Use [combined] as the projection matrix on batches to use when drawing.
class Camera2D {

  // Camera values for near and far planes
  static const double _near = -100;
  static const double _far = 100;

  /// Projection matrix for the camera.
  Matrix4 projection;

  /// The transformations applied to the camera.
  Transform transform = Transform.identity();

  /// Matrix updated to combine camera projection and transformations.
  ///
  /// Set this as projection matrix on batches to use when drawing.
  Matrix4 combined = Matrix4.identity();

  /// Quad, updated with the corners as the boundaries of the region the camera projects on screen.
  Quad view = Quad();

  /// Width of the view seen through this camera.
  int viewWidth;
  /// Width of the view seen through this camera.
  int viewHeight;

  // Offsets used to calculate view, set by constructors.
  double _projOffsetX;
  double _projOffsetY;

  /// Creates a camera width 0, 0 in the bottom left of the view.
  Camera2D.originBottomLeft(this.viewWidth, this.viewHeight) {
    projection = makeOrthographicMatrix(0, viewWidth.toDouble(), 0,
        viewHeight.toDouble(),
        _near, _far);
    _projOffsetX = 0;
    _projOffsetY = 0;
    update();
  }

  /// Creates a camera width 0, 0 in the center of the view.
  Camera2D.originCenter(this.viewWidth, this.viewHeight) {
    projection = makeOrthographicMatrix(
        -viewWidth / 2, viewWidth / 2, -viewHeight / 2, viewHeight / 2, _near, _far);
    _projOffsetX = -viewWidth / 2;
    _projOffsetY = -viewHeight / 2;
    update();
  }

  /// Creates a camera with a view bounded by [left], [right], [top], and [bottom].
  Camera2D.sides(double left, double right, double top, double bottom) {
    projection = makeOrthographicMatrix(left, right, bottom, top, _near, _far);
    viewWidth = (right - left).toInt();
    viewHeight = (top - bottom).toInt();
    _projOffsetX = -left;
    _projOffsetY = -bottom;
    update();
  }

  /// Creates a camera identical to [other].
  Camera2D.copy(Camera2D other) {
    projection = Matrix4.copy(other.projection);
    transform = Transform.copy(other.transform);
    viewWidth = other.viewWidth;
    viewHeight = other.viewHeight;
    _projOffsetX = other._projOffsetX;
    _projOffsetY = other._projOffsetY;
    update();
  }

  /// Updates the state of the camera transform, the combined matrix, and the view bounds.
  void update() {
    transform.update();

    combined.setFrom(projection);
    // Matrix of camera should apply opposite transforms to objects in world.
    combined.multiply(transform.invCombined);

    view.point0.setValues(_projOffsetX, _projOffsetY, 0);
    view.point1.setValues(_projOffsetX + viewWidth, _projOffsetY, 0);
    view.point2.setValues(_projOffsetX + viewWidth, _projOffsetY + viewHeight, 0);
    view.point3.setValues(_projOffsetX, _projOffsetY + viewHeight, 0);

    view.transform(transform.combined);
  }

}
