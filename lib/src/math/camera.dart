part of cobblestone;

const num near = -100;
const num far = 100;

class Camera2D {

  Matrix4 projection;
  Matrix4 combined;

  Transform transform;

  Camera2D.originBottomLeft(num width, num height) {
    setDefaults();
    projection = makeOrthographicMatrix(0.0, width, 0.0, height, near, far);
    update();
  }

  Camera2D.originCenter(num width, num height) {
    setDefaults();
    projection = makeOrthographicMatrix(-width / 2, width / 2, -height / 2, height / 2, near, far);
    update();
  }

  Camera2D.sides(num left, num right, num top, num bottom) {
    setDefaults();
    projection = makeOrthographicMatrix(left, right, bottom, top, near, far);
    update();
  }

  Camera2D.copy(Camera2D other) {
    setDefaults();
    projection = new Matrix4.copy(other.projection);
    transform = new Transform.copy(other.transform);
    update();
  }

  void setDefaults() {
    transform = new Transform.identity();
    combined = new Matrix4.identity();
  }

  void translate(x, [num y]) {
    transform.translate(x, y);
  }

  void rotate(num amount, bool counter) {
    transform.rotate(amount, counter);
  }

  void scale(x, [num y]) {
    transform.scale(x, y);
  }

  void update() {
    transform.update();
    combined.setFrom(projection);
    combined.multiply(transform.combined);
  }

}