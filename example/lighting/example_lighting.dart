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

  num time = 0.0;

  int numLights = 10;
  List<Vector3> lightPosData = [];
  List<Vector4> lightColorInit = [];

  List<Vector3> lightPos = [];
  List<Vector4> lightColor = [];

  Vector4 ambientColor = new Vector4(0.6, 0.6, 1.0, 0.001);
  Vector3 attenuation = new Vector3(0.4, 3.0, 20.0);

  @override
  create() {
    camera = new Camera2D.originBottomLeft(width, height);
    renderer = new SpriteBatch(gl, assetManager.get("lighting"));
    renderer.setAdditionalUniforms = () {
      renderer.setUniform('uLightPos', lightPos);
      renderer.setUniform('uLightColor', lightColor);
      renderer.setUniform('uAmbientLightColor', ambientColor);
      renderer.setUniform('uScreenRes', new Vector2(width.toDouble(), height.toDouble()));
      renderer.setUniform('uFalloff', attenuation);
      renderer.setUniform('uDiffuse', wall.bind(1));
      renderer.setUniform('uNormal', wallNorm.bind(2));
    };

    gl.setGLViewport(canvasWidth, canvasHeight);

    for(int i = 0; i < numLights; i++) {
      var newPos = new Vector3.random();
      newPos.scale(2.0);
      newPos.sub(new Vector3.all(2.0));
      lightPosData.add(newPos);
      lightColorInit.add(new Vector4.random());

      lightPos.add(new Vector3.random());
      lightPos[i].z = 0.075;
      lightColor.add(new Vector4.zero());
    }

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
    renderer.end();
  }

  resize(num width, num height) {
    gl.setGLViewport(canvasWidth, canvasHeight);
  }

  @override
  update(num delta) {
    time += delta;
    for(int i = 0; i < numLights; i++) {
      lightPos[i].x = lightPos[i].x + lightPosData[i].x * delta;
      lightPos[i].y = lightPos[i].y + lightPosData[i].y * delta;
      if(lightPos[i].x > 1) {
        lightPos[i].x = 1.0;
        lightPosData[i].x = -1.0;
      }
      if(lightPos[i].x < 0) {
        lightPos[i].x = 0.0;
        lightPosData[i].x = 1.0;
      }
      if(lightPos[i].y > 1) {
        lightPos[i].y = 1.0;
        lightPosData[i].y = -1.0;
      }
      if(lightPos[i].y < 0) {
        lightPos[i].y = 0.0;
        lightPosData[i].y = 1.0;
      }

      lightColor[i].r = cos(time);
      lightColor[i].g = sin(time);
      lightColor[i].b = sin(time);
    }
  }

  @override
  config() {
    scaleMode = ScaleMode.resize;
  }

}
