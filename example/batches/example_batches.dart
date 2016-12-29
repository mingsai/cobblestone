import 'package:cobblestone/cobblestone.dart';

main() {
  new GeometryExample();
}

class GeometryExample extends BaseGame {

  Camera2D camera;
  Matrix4 pMatrix;

  PointBatch pointBatch;
  PhysboxBatch physboxBatch;

  @override
  create() {
    camera = new Camera2D.originBottomLeft(width, height);
    pointBatch = new PointBatch.defaultShader();
    physboxBatch = new PhysboxBatch.defaultShader();

    setGLViewport(canvasWidth, canvasHeight);
  }

  @override
  preload() {
  }

  @override
  render(num delta) {
    clearScreen(0.0, 0.0, 0.0, 1.0);

    camera.update();

    pointBatch.projection = camera.combined;
    pointBatch.begin();

    pointBatch.draw(new Vector3(10.0, 10.0, 0.0), new Vector4(0.0, 1.0, 0.0, 1.0));

    pointBatch.end();

    physboxBatch.projection = camera.combined;
    physboxBatch.begin();

    Aabb2 box = new Aabb2.centerAndHalfExtents(new Vector2(10.0, 10.0), new Vector2(10.0, 100.0));
    physboxBatch.draw2D(box);

    Obb3 ob = new Obb3();
    Matrix3 rotation = new Matrix3.rotationZ(PI / 8);
    ob
      ..center.setFrom(new Vector3(100.0, 100.0, 0.0))
      ..halfExtents.setFrom(new Vector3(50.0, 75.0, 0.0))
      ..rotate(rotation);
    physboxBatch.draw2D(ob);

    physboxBatch.end();
  }

  resize(num width, num height) {
    setGLViewport(canvasWidth, canvasHeight);
  }

  @override
  update(num delta) {
  }
}