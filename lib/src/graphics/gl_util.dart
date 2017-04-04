part of cobblestone;

WebGL.RenderingContext gl;

loadDefaultShaders() {
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

int textureBind(int id) {
  switch(id) {
    case 0:
      return WebGL.TEXTURE0;
    case 1:
      return WebGL.TEXTURE1;
    case 2:
      return WebGL.TEXTURE2;
    case 3:
      return WebGL.TEXTURE3;
    case 4:
      return WebGL.TEXTURE4;
    case 5:
      return WebGL.TEXTURE5;
    case 6:
      return WebGL.TEXTURE6;
    case 7:
      return WebGL.TEXTURE7;
    case 8:
      return WebGL.TEXTURE8;
    case 9:
      return WebGL.TEXTURE9;
    case 10:
      return WebGL.TEXTURE10;
    case 11:
      return WebGL.TEXTURE11;
    case 12:
      return WebGL.TEXTURE12;
    case 13:
      return WebGL.TEXTURE13;
    case 14:
      return WebGL.TEXTURE14;
    case 15:
      return WebGL.TEXTURE15;
    case 16:
      return WebGL.TEXTURE16;
    case 17:
      return WebGL.TEXTURE17;
    case 18:
      return WebGL.TEXTURE18;
    case 19:
      return WebGL.TEXTURE19;
    case 20:
      return WebGL.TEXTURE20;
    case 21:
      return WebGL.TEXTURE21;
    case 22:
      return WebGL.TEXTURE22;
    case 23:
      return WebGL.TEXTURE23;
    case 24:
      return WebGL.TEXTURE24;
    case 25:
      return WebGL.TEXTURE25;
    case 26:
      return WebGL.TEXTURE26;
    case 27:
      return WebGL.TEXTURE27;
    case 28:
      return WebGL.TEXTURE28;
    case 29:
      return WebGL.TEXTURE29;
    case 30:
      return WebGL.TEXTURE30;
    case 31:
      return WebGL.TEXTURE31;
    default:
      return WebGL.TEXTURE0;
  }
}
