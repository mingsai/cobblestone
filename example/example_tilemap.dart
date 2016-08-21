import 'package:cobblestone/cobblestone.dart';

main() {
  new GeometryExample();
}

class GeometryExample extends BaseGame {

  Camera2D camera;

  SpriteBatch renderer;

  Tilemap map;

  @override
  create() {
    camera = new Camera2D.originBottomLeft(width, height);
    renderer = new SpriteBatch.defaultShader();

    setGLViewport(canvasWidth, canvasHeight);

    GameTexture tileset = assetManager.get("numberTiles.png");
    map = assetManager.get("test.json");
    map.giveTileset(tileset);
  }

  @override
  config() {
    scaleMode = ScaleMode.resize;
  }

  @override
  preload() {
    assetManager.load("test.json", loadTilemap("test.json"));
    assetManager.load("numberTiles.png", loadTexture("numberTiles.png", nearest));
  }

  @override
  render(num delta) {
    clearScreen(0.0, 0.0, 0.0, 1.0);

    camera.update();

    renderer.projection = camera.combined;
    renderer.begin();

    map.render(renderer, camera);

    int offset = 0;
    for(GameTexture texture in map.tileset) {
      renderer.draw(texture, offset, height - 16, 16, 16);
      offset += 16;
    }

    renderer.end();
  }

  resize(num width, num height) {
    setGLViewport(canvasWidth, canvasHeight);
    camera = new Camera2D.originBottomLeft(width, height);
  }

  @override
  update(num delta) {

  }
}

class BoulderSprite {

  GameTexture texture;

  num x, y;

  BoulderSprite(this.texture, this.x, this.y);

}