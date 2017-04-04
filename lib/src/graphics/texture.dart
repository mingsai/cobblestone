part of cobblestone;

Future<Texture> loadTexture(String url, [handle(ImageElement ele) = nearest]) {
  var completer = new Completer<Texture>();
  var element = new ImageElement();
  element.onLoad.listen((e) {
    var texture = handle(element);
    Texture gameTexture =
        new Texture(texture, url, element.width, element.height);
    completer.complete(gameTexture);
  });
  element.src = url;
  return completer.future;
}

WebGL.Texture mipMap(ImageElement image) {
  WebGL.Texture texture = gl.createTexture();
  gl.pixelStorei(WebGL.UNPACK_FLIP_Y_WEBGL, 1);
  gl.bindTexture(WebGL.TEXTURE_2D, texture);
  gl.texImage2D(
      WebGL.TEXTURE_2D, 0, WebGL.RGBA, WebGL.RGBA, WebGL.UNSIGNED_BYTE, image);
  gl.texParameteri(WebGL.TEXTURE_2D, WebGL.TEXTURE_MAG_FILTER, WebGL.LINEAR);
  gl.texParameteri(
      WebGL.TEXTURE_2D, WebGL.TEXTURE_MIN_FILTER, WebGL.LINEAR_MIPMAP_NEAREST);
  gl.texParameteri(WebGL.TEXTURE_2D, WebGL.TEXTURE_WRAP_S, WebGL.CLAMP_TO_EDGE);
  gl.texParameteri(WebGL.TEXTURE_2D, WebGL.TEXTURE_WRAP_T, WebGL.CLAMP_TO_EDGE);
  gl.generateMipmap(WebGL.TEXTURE_2D);
  gl.bindTexture(WebGL.TEXTURE_2D, null);
  return texture;
}

WebGL.Texture nearest(ImageElement element) {
  WebGL.Texture texture = gl.createTexture();
  gl.bindTexture(WebGL.TEXTURE_2D, texture);
  gl.pixelStorei(WebGL.UNPACK_FLIP_Y_WEBGL, 1);
  gl.texImage2D(WebGL.TEXTURE_2D, 0, WebGL.RGBA, WebGL.RGBA,
      WebGL.UNSIGNED_BYTE, element);
  gl.texParameteri(WebGL.TEXTURE_2D, WebGL.TEXTURE_MAG_FILTER, WebGL.NEAREST);
  gl.texParameteri(WebGL.TEXTURE_2D, WebGL.TEXTURE_MIN_FILTER, WebGL.NEAREST);
  gl.texParameteri(WebGL.TEXTURE_2D, WebGL.TEXTURE_WRAP_S, WebGL.CLAMP_TO_EDGE);
  gl.texParameteri(WebGL.TEXTURE_2D, WebGL.TEXTURE_WRAP_T, WebGL.CLAMP_TO_EDGE);
  gl.bindTexture(WebGL.TEXTURE_2D, null);
  return texture;
}

class Texture {
  WebGL.Texture texture;

  num u, v, u2, v2;

  String source;

  num sourceWidth;
  num sourceHeight;

  num width;
  num height;

  Texture(this.texture, this.source, this.sourceWidth, this.sourceHeight) {
    setRegion(0, 0, sourceWidth, sourceHeight);
  }

  Texture.clone(Texture other) {
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

  Texture.empty(this.width, this.height) {
    texture = gl.createTexture();
    gl.bindTexture(WebGL.TEXTURE_2D, texture);
    //gl.pixelStorei(WebGL.UNPACK_FLIP_Y_WEBGL, 1);
    gl.texParameteri(WebGL.TEXTURE_2D, WebGL.TEXTURE_MAG_FILTER, WebGL.NEAREST);
    gl.texParameteri(WebGL.TEXTURE_2D, WebGL.TEXTURE_MIN_FILTER, WebGL.NEAREST);
    gl.texParameteri(
        WebGL.TEXTURE_2D, WebGL.TEXTURE_WRAP_S, WebGL.CLAMP_TO_EDGE);
    gl.texParameteri(
        WebGL.TEXTURE_2D, WebGL.TEXTURE_WRAP_T, WebGL.CLAMP_TO_EDGE);
    gl.texImage2D(WebGL.TEXTURE_2D, 0, WebGL.RGBA, width, height, 0, WebGL.RGBA,
        WebGL.UNSIGNED_BYTE, null);
    gl.bindTexture(WebGL.TEXTURE_2D, null);

    this.source = "None";

    this.sourceWidth = width;
    this.sourceHeight = height;

    this.u = 0;
    this.v = 0;
    this.u2 = 1;
    this.v2 = 1;
  }

  setRegion(int x, int y, int width, int height) {
    double invTexWidth = 1.0 / sourceWidth;
    double invTexHeight = 1.0 / sourceHeight;
    setRegionCoords(x * invTexWidth, y * invTexHeight,
        (x + width) * invTexWidth, (y + height) * invTexHeight);

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

  List<Texture> split(int tileWidth, int tileHeight) {
    int x = u;
    int y = v + height - tileHeight;

    int rows = (height / tileHeight).floor();
    int cols = (width / tileWidth).floor();

    int startX = x;
    List<Texture> tiles = [];
    for (int row = 0; row < rows; row++, y -= tileHeight) {
      x = startX;
      for (int col = 0; col < cols; col++, x += tileWidth) {
        Texture tile = new Texture.clone(this);
        tile.setRegion(x, y, tileWidth, tileHeight);
        tiles.add(tile);
      }
    }

    return tiles;
  }

  int bind([int location = 0]) {
    gl.activeTexture(textureBind(location));
    gl.bindTexture(WebGL.TEXTURE_2D, texture);
    return location;
  }
}
