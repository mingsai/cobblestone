part of examples;

class TilemapExample extends BaseGame {
  Camera2D camera;

  SpriteBatch renderer;
  DebugBatch debug;

  Tilemap map;

  bool north = false, east = false, south = false, west = false;

  // TODO demo both tilemap modes at once
  bool useAtlas = false;

  @override
  create() {
    gl.setGLViewport(canvasWidth, canvasHeight);
    camera = Camera2D.originBottomLeft(32 * 16, 18 * 16);
    camera.transform.roundInt = true;

    renderer = SpriteBatch.defaultShader(gl);
    debug = DebugBatch.defaultShader(gl);

    map = assetManager.get("map.tmx");
  }

  @override
  config() {
    scaleMode = ScaleMode.fit;
    requestedWidth = 32 * 16;
    requestedHeight = 18 * 16;
  }

  @override
  preload() {
    if(useAtlas) {
      assetManager.load("atlas.png",
          loadTexture(gl, "tilemap/atlas.png", nearest));
      assetManager.load("atlas.atlas", loadAtlas("tilemap/atlas.atlas",
          assetManager.getLoading("atlas.png")));
      assetManager.load("tiles.tsx", loadTileset("tilemap/tiles.tsx",
          assetManager.getLoading("atlas.atlas")));
      assetManager.load("map.tmx", loadTilemap("tilemap/islands3.tmx",
          tileset: assetManager.getLoading("tiles.tsx")));
    } else {
      assetManager.load(
          "tileset", loadTexture(gl, "tilemap/floating_islands_extruded.png"));
      assetManager.load("map.tmx", loadTilemap("tilemap/islands.tmx",
          atlas: assetManager.getLoading("tileset"),
          extraMargin: 1, extraSpacing: 2));
    }
  }

  @override
  render(num delta) {
    gl.clearScreen(41 / 256, 38 / 256, 52 / 256, 1.0);

    camera.update();

    renderer.projection = camera.combined;
    renderer.begin();

    map.render(renderer, 0, 0, camera);

    double offset = camera.transform.x;
    for (BasicTile texture in map.tileset.basicTiles.values) {
      renderer.draw(texture.texture, offset, height - 16 + camera.transform.y);
      offset += 16;
    }

    renderer.end();

    /*
    debug.projection = camera.combined;
    debug.begin();
    for (MapObject object in map.objectGroups.first.objects) {
      debug.color = object.properties["color"];
      debug.drawMap(object);
    }
    debug.end();*/
  }

  resize(num width, num height) {
    gl.setGLViewport(canvasWidth, canvasHeight);
    camera = Camera2D.originBottomLeft(32 * 16, 18 * 16);
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
