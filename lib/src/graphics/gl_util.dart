part of cobblestone;

RenderingContext gl;

loadDefaultShaders() {
  //assetManager.load("packages/cobblestone/shaders/textured",
  //    loadProgram("packages/cobblestone/shaders/textured.vertex", "packages/cobblestone/shaders/textured.fragment"));
  //assetManager.load("packages/cobblestone/shaders/untextured",
  //    loadProgram("packages/cobblestone/shaders/untextured.vertex", "packages/cobblestone/shaders/untextured.fragment"));
  assetManager.load("packages/cobblestone/shaders/batch",
      loadProgram("packages/cobblestone/shaders/batch.vertex", "packages/cobblestone/shaders/batch.fragment"));
  assetManager.load("packages/cobblestone/shaders/point",
      loadProgram("packages/cobblestone/shaders/point.vertex", "packages/cobblestone/shaders/point.fragment"));
}

clearScreen(r, [num g, num b, num a]) {
  if(r is Vector4) {
    gl.clearColor(r.r, r.g, r.b, r.a);
  }else {
    gl.clearColor(r, g, b, a);
  }

  gl.clear(COLOR_BUFFER_BIT | DEPTH_BUFFER_BIT);
}

setGLOptions() {
  gl.disable(DEPTH_TEST);
  gl.enable(BLEND);
}

setGLViewport(num width, num height) {
  gl.viewport(0, 0, width, height);
}

int intToTextureBind(int id) {
  switch(id) {
    case 0:
      return TEXTURE0;
    case 1:
      return TEXTURE1;
    case 2:
      return TEXTURE2;
    case 3:
      return TEXTURE3;
    case 4:
      return TEXTURE4;
    case 5:
      return TEXTURE5;
    case 6:
      return TEXTURE6;
    case 7:
      return TEXTURE7;
    case 8:
      return TEXTURE8;
    case 9:
      return TEXTURE9;
    case 10:
      return TEXTURE10;
    case 11:
      return TEXTURE11;
    case 12:
      return TEXTURE12;
    case 13:
      return TEXTURE13;
    case 14:
      return TEXTURE14;
    case 15:
      return TEXTURE15;
    case 16:
      return TEXTURE16;
    case 17:
      return TEXTURE17;
    case 18:
      return TEXTURE18;
    case 19:
      return TEXTURE19;
    case 20:
      return TEXTURE20;
    case 21:
      return TEXTURE21;
    case 22:
      return TEXTURE22;
    case 23:
      return TEXTURE23;
    case 24:
      return TEXTURE24;
    case 25:
      return TEXTURE25;
    case 26:
      return TEXTURE26;
    case 27:
      return TEXTURE27;
    case 28:
      return TEXTURE28;
    case 29:
      return TEXTURE29;
    case 30:
      return TEXTURE30;
    case 31:
      return TEXTURE31;
    default:
      return TEXTURE0;
  }
}