import 'package:cobblestone/cobblestone.dart';

main() {
  new GeometryExample();
}

class GeometryExample extends BaseGame {

  Camera2D camera;
  Matrix4 pMatrix;

  PointBatch renderer;


  @override
  create() {
    camera = new Camera2D.originBottomLeft(width, height);
    renderer = new PointBatch.defaultShader();

    setGLViewport(canvasWidth, canvasHeight);
  }

  @override
  preload() {
  }

  @override
  render(num delta) {
    clearScreen(0.0, 0.0, 0.0, 1.0);

    camera.update();

    renderer.projection = camera.combined;
    renderer.begin();

    renderer.draw(new Vector3(10.0, 10.0, 0.0), new Vector4(0.0, 1.0, 0.0, 1.0));

    renderer.end();
  }

  resize(num width, num height) {
    setGLViewport(canvasWidth, canvasHeight);
  }

  @override
  update(num delta) {
  }
}