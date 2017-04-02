part of cobblestone;

WebGL.RenderingContext gl;

loadDefaultShaders() {
  //assetManager.load("packages/cobblestone/shaders/textured",
  //    loadProgram("packages/cobblestone/shaders/textured.vertex", "packages/cobblestone/shaders/textured.fragment"));
  //assetManager.load("packages/cobblestone/shaders/untextured",
  //    loadProgram("packages/cobblestone/shaders/untextured.vertex", "packages/cobblestone/shaders/untextured.fragment"));
  assetManager.load(
      "packages/cobblestone/shaders/batch",
      loadProgram("packages/cobblestone/shaders/batch.vertex",
          "packages/cobblestone/shaders/batch.fragment"));
  assetManager.load(
      "packages/cobblestone/shaders/point",
      loadProgram("packages/cobblestone/shaders/point.vertex",
          "packages/cobblestone/shaders/point.fragment"));
  assetManager.load(
      "packages/cobblestone/shaders/wire",
      loadProgram("packages/cobblestone/shaders/wire.vertex",
          "packages/cobblestone/shaders/wire.fragment"));
}

clearScreen(r, [num g, num b, num a]) {
  if (r is Vector4) {
    gl.clearColor(r.r, r.g, r.b, r.a);
  } else {
    gl.clearColor(r, g, b, a);
  }

  gl.clear(WebGL.COLOR_BUFFER_BIT | WebGL.DEPTH_BUFFER_BIT);
}

setGLOptions() {
  gl.disable(WebGL.DEPTH_TEST);
  gl.enable(WebGL.BLEND);
}

setGLViewport(num width, num height) {
  gl.viewport(0, 0, width, height);
}
