part of examples;

class TilemapExample extends BaseGame {
  Camera2D camera;

  SpriteBatch renderer;
  DebugBatch debug;

  Tilemap map;

  bool north = false, east = false, south = false, west = false;

  @override
  create() {
    gl.setGLViewport(canvasWidth, canvasHeight);
    camera = new Camera2D.originBottomLeft(width, height);

    renderer = new SpriteBatch.defaultShader(gl);
    debug = new DebugBatch.defaultShader(gl);

    Map<String, Texture> atlas = assetManager.get("atlas");
    map = assetManager.get("islands2.tmx");
    map.giveTileset(atlas);
  }

  @override
  config() {
    scaleMode = ScaleMode.resize;
  }

  @override
  preload() {
    assetManager.load("islands2.tmx", loadTilemap("tilemap/islands2.tmx"));
    assetManager.load(
        "atlas", loadAtlas("tilemap/atlas.json", loadTexture(gl, "tilemap/atlas.png", nearest)));
  }

  @override
  render(num delta) {
    gl.clearScreen(41 / 256, 38 / 256, 52 / 256, 1.0);

    camera.update();

    renderer.projection = camera.combined;
    renderer.begin();

    map.render(renderer, 0, 0, camera);

    int offset = 0;
    for (BasicTile texture in map.basicTiles.values) {
      renderer.draw(texture.texture, offset, height - 16);
      offset += 16;
    }

    renderer.end();

    debug.projection = camera.combined;
    debug.begin();
    for (MapObject object in map.objectGroups.first.objects) {
      debug.color = object.properties["color"];
      debug.drawMap(object);
    }
    debug.end();
  }

  resize(num width, num height) {
    gl.setGLViewport(canvasWidth, canvasHeight);
    camera = new Camera2D.originBottomLeft(width, height);
  }

  @override
  update(num delta) {
    if (keyboard.keyJustPressed(KeyCode.W)) north = true;
    if (keyboard.keyJustPressed(KeyCode.D)) east = true;
    if (keyboard.keyJustPressed(KeyCode.S)) south = true;
    if (keyboard.keyJustPressed(KeyCode.A)) west = true;

    if (keyboard.keyJustReleased(KeyCode.W)) north = false;
    if (keyboard.keyJustReleased(KeyCode.D)) east = false;
    if (keyboard.keyJustReleased(KeyCode.S)) south = false;
    if (keyboard.keyJustReleased(KeyCode.A)) west = false;

    if (north) camera.transform.translate(0.0, -delta * 20);
    if (east) camera.transform.translate(-delta * 20, 0.0);
    if (south) camera.transform.translate(0.0, delta * 20);
    if (west) camera.transform.translate(delta * 20, 0.0);
    camera.transform.roundInt = true;
    map.update(delta);
  }
}
