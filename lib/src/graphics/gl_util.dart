part of cobblestone;

/// Returns the texture constant for the given id.
/// E.g. when [id] is 0, this returns [WebGL.TEXTURE0]
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
