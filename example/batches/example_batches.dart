part of examples;

class BatchExample extends BaseGame {
  Camera2D camera;
  Matrix4 pMatrix;

  PointBatch pointBatch;
  DebugBatch debugBatch;

  @override
  create() {
    camera = new Camera2D.originBottomLeft(width, height);
    pointBatch = new PointBatch.defaultShader(gl, maxSprites: 2);

    debugBatch = new DebugBatch.defaultShader(gl, maxSprites: 8);

    gl.setGLViewport(canvasWidth, canvasHeight);
  }

  @override
  preload() {}

  @override
  render(num delta) {
    gl.clearScreen(0.0, 0.0, 0.0, 1.0);

    camera.update();

    pointBatch.projection = camera.combined;
    pointBatch.begin();

    pointBatch.draw(
        new Vector3(10.0, 10.0, 0.0), new Vector4(0.0, 1.0, 0.0, 1.0));
    pointBatch.draw(
        new Vector3(10.0, 20.0, 0.0), new Vector4(1.0, 1.0, 0.0, 1.0));

    pointBatch.end();

    debugBatch.projection = camera.combined;
    debugBatch.begin();

    Aabb2 box = new Aabb2.centerAndHalfExtents(
        new Vector2(10.0, 10.0), new Vector2(10.0, 100.0));
    debugBatch.drawBox(box);

    Obb3 ob = new Obb3();
    Matrix3 rotation = new Matrix3.rotationZ(pi / 8);
    ob
      ..center.setFrom(new Vector3(100.0, 100.0, 0.0))
      ..halfExtents.setFrom(new Vector3(50.0, 75.0, 0.0))
      ..rotate(rotation);
    debugBatch.drawBox(ob);

    debugBatch.end();
  }

  resize(num width, num height) {
    gl.setGLViewport(canvasWidth, canvasHeight);
  }

  @override
  update(num delta) {}
}
