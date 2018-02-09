part of cobblestone;

/// Loads a texture from a url
Future<Texture> loadTexture(GLWrapper wrapper, String url, [handle(GLWrapper wrapper, ImageElement ele) = nearest]) {
  var completer = new Completer<Texture>();
  var element = new ImageElement();
  element.onLoad.listen((e) {
    var texture = handle(wrapper, element);
    Texture gameTexture =
        new Texture(wrapper, texture, url, element.width, element.height);
    completer.complete(gameTexture);
  });
  element.src = url;
  return completer.future;
}

/// Converts an [ImageElement] to a mip-mapped texture
WebGL.Texture mipMap(GLWrapper wrapper, ImageElement image) {
  var context = wrapper.context;
  
  WebGL.Texture texture = context.createTexture();
  context.pixelStorei(WebGL.UNPACK_FLIP_Y_WEBGL, 1);
  context.bindTexture(WebGL.TEXTURE_2D, texture);
  context.texImage2D(
      WebGL.TEXTURE_2D, 0, WebGL.RGBA, WebGL.RGBA, WebGL.UNSIGNED_BYTE, image);
  context.texParameteri(WebGL.TEXTURE_2D, WebGL.TEXTURE_MAG_FILTER, WebGL.LINEAR);
  context.texParameteri(
      WebGL.TEXTURE_2D, WebGL.TEXTURE_MIN_FILTER, WebGL.LINEAR_MIPMAP_NEAREST);
  context.texParameteri(WebGL.TEXTURE_2D, WebGL.TEXTURE_WRAP_S, WebGL.CLAMP_TO_EDGE);
  context.texParameteri(WebGL.TEXTURE_2D, WebGL.TEXTURE_WRAP_T, WebGL.CLAMP_TO_EDGE);
  context.generateMipmap(WebGL.TEXTURE_2D);
  context.bindTexture(WebGL.TEXTURE_2D, null);
  return texture;
}

/// Converts an [ImageElement] to texture with nearest neighbor scaling
WebGL.Texture nearest(GLWrapper wrapper, ImageElement element) {
  var context = wrapper.context;
  
  WebGL.Texture texture = context.createTexture();
  context.bindTexture(WebGL.TEXTURE_2D, texture);
  context.pixelStorei(WebGL.UNPACK_FLIP_Y_WEBGL, 1);
  context.texImage2D(WebGL.TEXTURE_2D, 0, WebGL.RGBA, WebGL.RGBA,
      WebGL.UNSIGNED_BYTE, element);
  context.texParameteri(WebGL.TEXTURE_2D, WebGL.TEXTURE_MAG_FILTER, WebGL.NEAREST);
  context.texParameteri(WebGL.TEXTURE_2D, WebGL.TEXTURE_MIN_FILTER, WebGL.NEAREST);
  context.texParameteri(WebGL.TEXTURE_2D, WebGL.TEXTURE_WRAP_S, WebGL.CLAMP_TO_EDGE);
  context.texParameteri(WebGL.TEXTURE_2D, WebGL.TEXTURE_WRAP_T, WebGL.CLAMP_TO_EDGE);
  context.bindTexture(WebGL.TEXTURE_2D, null);
  return texture;
}

/// A texture used in the game
class Texture {
  GLWrapper wrapper;
  WebGL.RenderingContext context;

  WebGL.Texture texture;

  num u, v, u2, v2;

  String source;

  num sourceWidth;
  num sourceHeight;

  num width;
  num height;

  /// Creates a new texture from a [WebGL.Texture]
  Texture(this.wrapper, this.texture, this.source, this.sourceWidth, this.sourceHeight) {
    context = wrapper.context;
    setRegion(0, 0, sourceWidth, sourceHeight);
  }

  /// Creates a clone of another texture
  Texture.clone(Texture other) {
    this.wrapper = other.wrapper;
    this.context = other.context;

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

  /// Creates an empty texture
  Texture.empty(this.wrapper, this.width, this.height) {
    context = wrapper.context;

    texture = context.createTexture();
    context.bindTexture(WebGL.TEXTURE_2D, texture);
    //context.pixelStorei(WebGL.UNPACK_FLIP_Y_WEBGL, 1);
    context.texParameteri(WebGL.TEXTURE_2D, WebGL.TEXTURE_MAG_FILTER, WebGL.NEAREST);
    context.texParameteri(WebGL.TEXTURE_2D, WebGL.TEXTURE_MIN_FILTER, WebGL.NEAREST);
    context.texParameteri(
        WebGL.TEXTURE_2D, WebGL.TEXTURE_WRAP_S, WebGL.CLAMP_TO_EDGE);
    context.texParameteri(
        WebGL.TEXTURE_2D, WebGL.TEXTURE_WRAP_T, WebGL.CLAMP_TO_EDGE);
    context.texImage2D(WebGL.TEXTURE_2D, 0, WebGL.RGBA, width, height, 0, WebGL.RGBA,
        WebGL.UNSIGNED_BYTE, null);
    context.bindTexture(WebGL.TEXTURE_2D, null);

    this.source = "None";

    this.sourceWidth = width;
    this.sourceHeight = height;

    this.u = 0;
    this.v = 0;
    this.u2 = 1;
    this.v2 = 1;
  }

  /// Sets the bounds of the texture, from the bottom left
  setRegion(int x, int y, int width, int height) {
    double invTexWidth = 1.0 / sourceWidth;
    double invTexHeight = 1.0 / sourceHeight;
    setRegionCoords(x * invTexWidth, y * invTexHeight,
        (x + width) * invTexWidth, (y + height) * invTexHeight);

    this.width = width;
    this.height = height;
  }

  /// Sets the uv coordinates of the texture manually
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

  /// Splits this texture into pieces of [tileWidth] by [tileHeight]
  List<Texture> split(int tileWidth, int tileHeight) {
    int x = u * sourceWidth;
    int y = v * sourceWidth + height - tileHeight;

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

  /// Binds this texture to a given location, or [WebGL.TEXTURE0]
  int bind([int location = 0]) {
    context.activeTexture(textureBind(location));
    context.bindTexture(WebGL.TEXTURE_2D, texture);
    return location;
  }
}
