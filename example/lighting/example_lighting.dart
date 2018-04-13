import 'package:cobblestone/cobblestone.dart';

main() {
  new GeometryExample();
}

class GeometryExample extends BaseGame {
  ShaderProgram shaderProgram;

  Camera2D camera;

  SpriteBatch renderer;
  Texture wall;
  Texture wallNorm;

  List<Vector3> lightPos = [new Vector3(0.0, 0.0, 0.075), new Vector3(0.0, 0.0, 0.075),
    new Vector3(0.0, 0.0, 0.075), new Vector3(0.0, 0.0, 0.075)];
  List<Vector4> lightColor = [Colors.mediumVioletRed, Colors.orange, Colors.greenYellow, Colors.aliceBlue];

  Vector4 ambientColor = new Vector4(0.6, 0.6, 1.0, 0.001);
  Vector3 attenuation = new Vector3(0.4, 3.0, 20.0);

  @override
  create() {
    camera = new Camera2D.originBottomLeft(width, height);
    renderer = new SpriteBatch(gl, assetManager.get("lighting"));

    gl.setGLViewport(canvasWidth, canvasHeight);

    wall = assetManager.get("tileDiffuse");
    wallNorm = assetManager.get("tileNormal");
  }

  @override
  preload() {
    assetManager.load("lighting", loadProgram(gl, "basic.vertex", "lighting.fragment"));
    assetManager.load("tileDiffuse", loadTexture(gl, "hp_floor_tiles_02.png", mipMap));
    assetManager.load("tileNormal", loadTexture(gl, "hp_floor_tiles_02_norm.png", mipMap));
  }

  @override
  render(num delta) {
    gl.clearScreen(0.0, 0.0, 0.0, 1.0);

    camera.update();

    renderer.projection = camera.combined;

    renderer.begin();
    renderer.draw(wall, 0.0, 0.0, width: height, height: height);
    renderer.draw(wall, height, 0, width: height, height: height);

    renderer.setUniform('uLightPos', lightPos);
    renderer.setUniform('uLightColor', lightColor);
    renderer.setUniform('uAmbientLightColor', ambientColor);
    renderer.setUniform('uScreenRes', new Vector2(width.toDouble(), height.toDouble()));
    renderer.setUniform('uFalloff', attenuation);
    renderer.setUniform('uDiffuse', wall.bind(1));
    renderer.setUniform('uNormal', wallNorm.bind(2));
    renderer.end();
  }

  resize(num width, num height) {
    gl.setGLViewport(canvasWidth, canvasHeight);
  }

  @override
  update(num delta) {
    if(mouse.x != null) {
      lightPos[0].x = mouse.x.toDouble() / width;
      lightPos[0].y = mouse.y.toDouble() / height;
      lightPos[1].x = mouse.x.toDouble() / width;
      lightPos[1].y = (height - mouse.y.toDouble()) / height;
      lightPos[2].x = (width - mouse.x.toDouble()) / width;
      lightPos[2].y = mouse.y.toDouble() / height;
      lightPos[3].x = (width - mouse.x.toDouble()) / width;
      lightPos[3].y = (height - mouse.y.toDouble()) / height;
    }
  }

  @override
  config() {
    scaleMode = ScaleMode.resize;
  }

}
