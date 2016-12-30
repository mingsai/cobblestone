import 'package:cobblestone/cobblestone.dart';

main() {
  new TilemapExample();
}

class TilemapExample extends BaseGame {

  Camera2D camera;

  SpriteBatch renderer;

  Tilemap map;

  bool north, east, south, west;

  @override
  create() {
    camera = new Camera2D.originBottomLeft(width / 2, height / 2);
    renderer = new SpriteBatch.defaultShader();

    setGLViewport(canvasWidth, canvasHeight);

    GameTexture tileset = assetManager.get("floating_islands.png");
    map = assetManager.get("islands.json");
    map.giveTileset(tileset);

    window.onKeyDown.listen(startMove);
    window.onKeyUp.listen(endMove);
  }

  void startMove(KeyboardEvent e) {
    if(e.keyCode == KeyCode.W) north = true;
    if(e.keyCode == KeyCode.D) east = true;
    if(e.keyCode == KeyCode.S) south = true;
    if(e.keyCode == KeyCode.A) west = true;
  }

  void endMove(KeyboardEvent e) {
    if(e.keyCode == KeyCode.W) north = false;
    if(e.keyCode == KeyCode.D) east = false;
    if(e.keyCode == KeyCode.S) south = false;
    if(e.keyCode == KeyCode.A) west = false;
  }

  @override
  config() {
    scaleMode = ScaleMode.resize;
  }

  @override
  preload() {
    assetManager.load("islands.json", loadTilemap("islands.json"));
    assetManager.load("floating_islands.png", loadTexture("floating_islands.png", nearest));
  }

  @override
  render(num delta) {
    clearScreen(41 / 256, 38 / 256, 52 / 256, 1.0);

    camera.update();

    renderer.projection = camera.combined;
    renderer.begin();

    map.render(renderer, camera);

    int offset = 0;
    for(BasicTile texture in map.basicTiles) {
      renderer.draw(texture.texture, offset, height - 16);
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
    if(north) camera.translate(0.0, -delta * 20);
    if(east) camera.translate(-delta * 20, 0.0);
    if(south) camera.translate(0.0, delta * 20);
    if(west) camera.translate(delta * 20, 0.0);
    camera.roundInt = true;
    map.update(delta);
  }

}