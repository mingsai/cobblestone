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
    gl.setGLViewport(canvasWidth, canvasHeight);
    camera = new Camera2D.originBottomLeft(width, height);

    renderer = new SpriteBatch.defaultShader(gl);

    Map<String, Texture> atlas = assetManager.get("atlas");
    map = assetManager.get("islands2.tmx");
    map.giveTileset(atlas);

    window.onKeyDown.listen(startMove);
    window.onKeyUp.listen(endMove);
  }

  void startMove(KeyboardEvent e) {
    if (e.keyCode == KeyCode.W) north = true;
    if (e.keyCode == KeyCode.D) east = true;
    if (e.keyCode == KeyCode.S) south = true;
    if (e.keyCode == KeyCode.A) west = true;
  }

  void endMove(KeyboardEvent e) {
    if (e.keyCode == KeyCode.W) north = false;
    if (e.keyCode == KeyCode.D) east = false;
    if (e.keyCode == KeyCode.S) south = false;
    if (e.keyCode == KeyCode.A) west = false;
  }

  @override
  config() {
    scaleMode = ScaleMode.resize;
  }

  @override
  preload() {
    assetManager.load("islands2.tmx", loadTilemap("islands2.tmx"));
    assetManager.load(
        "atlas", loadAtlas("atlas.json", loadTexture(gl, "atlas.png", nearest)));
  }

  @override
  render(num delta) {
    gl.clearScreen(41 / 256, 38 / 256, 52 / 256, 1.0);

    camera.update();

    renderer.projection = camera.combined;
    renderer.begin();

    map.render(renderer, 0, 0);

    int offset = 0;
    for (BasicTile texture in map.basicTiles.values) {
      renderer.draw(texture.texture, offset, height - 16);
      offset += 16;
    }

    renderer.end();
  }

  resize(num width, num height) {
    gl.setGLViewport(canvasWidth, canvasHeight);
    camera = new Camera2D.originBottomLeft(width, height);
  }

  @override
  update(num delta) {
    if (north) camera.translate(0.0, -delta * 20);
    if (east) camera.translate(-delta * 20, 0.0);
    if (south) camera.translate(0.0, delta * 20);
    if (west) camera.translate(delta * 20, 0.0);
    camera.roundInt = true;
    map.update(delta);
  }
}
