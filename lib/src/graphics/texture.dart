part of cobblestone;

Future<GameTexture> loadTexture(String url, handle(ImageElement ele)) {
  var completer = new Completer<GameTexture>();
  var element = new ImageElement();
  element.onLoad.listen((e) {
    var texture = handle(element);
    GameTexture gameTexture = new GameTexture(texture, url, element.width, element.height);
    completer.complete(gameTexture);
  });
  element.src = url;
  return completer.future;
}

Texture mipMap(ImageElement image) {
  Texture texture = gl.createTexture();
  gl.pixelStorei(UNPACK_FLIP_Y_WEBGL, 1);
  gl.bindTexture(TEXTURE_2D, texture);
  gl.texImage2D(TEXTURE_2D, 0, RGBA, RGBA, UNSIGNED_BYTE, image);
  gl.texParameteri(TEXTURE_2D, TEXTURE_MAG_FILTER, LINEAR);
  gl.texParameteri(TEXTURE_2D, TEXTURE_MIN_FILTER, LINEAR_MIPMAP_NEAREST);
  gl.texParameteri(TEXTURE_2D, TEXTURE_WRAP_S, CLAMP_TO_EDGE);
  gl.texParameteri(TEXTURE_2D, TEXTURE_WRAP_T, CLAMP_TO_EDGE);
  gl.generateMipmap(TEXTURE_2D);
  gl.bindTexture(TEXTURE_2D, null);
  return texture;
}

Texture nearest(ImageElement element) {
  Texture texture = gl.createTexture();
  gl.bindTexture(TEXTURE_2D, texture);
  gl.pixelStorei(UNPACK_FLIP_Y_WEBGL, 1);
  gl.texImage2D(TEXTURE_2D, 0, RGBA, RGBA, UNSIGNED_BYTE, element);
  gl.texParameteri(TEXTURE_2D, TEXTURE_MAG_FILTER, NEAREST);
  gl.texParameteri(TEXTURE_2D, TEXTURE_MIN_FILTER, NEAREST);
  gl.texParameteri(TEXTURE_2D, TEXTURE_WRAP_S, CLAMP_TO_EDGE);
  gl.texParameteri(TEXTURE_2D, TEXTURE_WRAP_T, CLAMP_TO_EDGE);
  gl.bindTexture(TEXTURE_2D, null);
  return texture;
}

class GameTexture {

  Texture texture;

  num u, v, u2, v2;

  String source;

  num sourceWidth;
  num sourceHeight;

  num width;
  num height;

  GameTexture(this.texture, this.source, this.sourceWidth, this.sourceHeight) {
    setRegion(0, 0, sourceWidth, sourceHeight);
  }

  GameTexture.clone(GameTexture other) {
    this.texture = other.texture;

    this.source = other.source;
    this.sourceWidth = other.sourceWidth;
    this.sourceHeight = other.sourceHeight;

    this.width = other.width;
    this.height = other.height;

    this.u = other.u;
    this.v = other.v;
    this.u2 = other.u2;
    this.v2 = other.v2;
  }

  setRegion(int x, int y, int width, int height) {
    double invTexWidth = 1.0 / sourceWidth;
    double invTexHeight = 1.0 / sourceHeight;
    setRegionCoords(x * invTexWidth, y * invTexHeight, (x + width) * invTexWidth, (y + height) * invTexHeight);

    this.width = width;
    this.height = height;
  }

  setRegionCoords(double u, double v, double u2, double v2) {
    width = ((u2 - u).abs() * sourceWidth).round();
    height = ((v2 - v).abs() * sourceHeight).round();

    // For a 1x1 region, adjust UVs toward pixel center to avoid filtering artifacts on AMD GPUs when drawing very stretched.
    if (width == 1 && height == 1) {
      num adjustX = 0.25 / sourceWidth;
      u += adjustX;
      u2 -= adjustX;
      num adjustY = 0.25 / sourceWidth;
      v += adjustY;
      v2 -= adjustY;
    }

    this.u = u;
    this.v = v;
    this.u2 = u2;
    this.v2 = v2;
  }

  List<GameTexture> split(int tileWidth, int tileHeight) {
    int x = u;
    int y = v + height - tileHeight;

    int rows = (height / tileHeight).floor();
    int cols = (width / tileWidth).floor();

    int startX = x;
    List<GameTexture> tiles = [];
    for (int row = 0; row < rows; row++, y -= tileHeight) {
      x = startX;
      for (int col = 0; col < cols; col++, x += tileWidth) {
        GameTexture tile = new GameTexture.clone(this);
        tile.setRegion(x, y, tileWidth, tileHeight);
        tiles.add(tile);
      }
    }

    return tiles;
  }

  int bind() {
    gl.activeTexture(TEXTURE0);
    gl.bindTexture(TEXTURE_2D, texture);
    return 0;
  }

}
