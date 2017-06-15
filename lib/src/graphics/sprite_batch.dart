part of cobblestone;

/// A batch of textured sprites.
class SpriteBatch extends VertexBatch {
  int maxSprites = 2000;

  int drawMode = WebGL.TRIANGLES;

  final int vertexSize = 5;
  final int verticesPerSprite = 4;
  final int indicesPerSprite = 6;

  Vector4 color;

  Texture texture;

  /// Creates a new sprite batch with a custom shader
  SpriteBatch(shaderProgram, {this.maxSprites: 2000}) : super(shaderProgram) {
    color = new Vector4.all(1.0);
  }

  /// Creates a new sprite batch with a simple shader
  SpriteBatch.defaultShader({int maxSprites: 2000})
      : this(assetManager.get("packages/cobblestone/shaders/batch"),
            maxSprites: maxSprites);

  /// Draws the [texture] at ([x], [y]), the bottom left of the sprite. Can optionally draw at a given [height] and [width], scale by [scaleX] and [scaleY],
  /// flip the texture if [flipX] or [flipY], or turn [angle] around the center.
  draw(Texture texture, num x, num y,
      {num width: null,
      num height: null,
      num scaleX: 1,
      num scaleY: 1,
      bool flipX: false,
      bool flipY: false,
      num angle: 0,
      bool counterTurn: false}) {
    x = x.toDouble();
    y = y.toDouble();

    if (spritesInFlush >= maxSprites) {
      print("Batch full");
      flush();
    }
    if (this.texture != null) {
      if (texture.texture != this.texture.texture) {
        print("Wrong texture");
        flush();
      }
    }

    this.texture = texture;

    if (width == null) {
      width = texture.width;
    }
    if (height == null) {
      height = texture.height;
    }
    width *= scaleX;
    height *= scaleY;

    double x1 = x;
    double y1 = y;

    double x2 = x;
    double y2 = y + height;

    double x3 = x + width;
    double y3 = y;

    double x4 = x + width;
    double y4 = y + height;

    if (angle != 0) {
      if (counterTurn) {
        angle = 360 - angle;
      }

      double cx = x + width / 2;
      double cy = y + height / 2;

      double sinAng = sin(angle);
      double cosAng = cos(angle);

      double tempX = x1 - cx;
      double tempY = y1 - cy;

      double rotatedX = tempX * cosAng - tempY * sinAng;
      double rotatedY = tempX * sinAng + tempY * cosAng;

      x1 = rotatedX + cx;
      y1 = rotatedY + cy;

      tempX = x2 - cx;
      tempY = y2 - cy;

      rotatedX = tempX * cosAng - tempY * sinAng;
      rotatedY = tempX * sinAng + tempY * cosAng;

      x2 = rotatedX + cx;
      y2 = rotatedY + cy;

      tempX = x3 - cx;
      tempY = y3 - cy;

      rotatedX = tempX * cosAng - tempY * sinAng;
      rotatedY = tempX * sinAng + tempY * cosAng;

      x3 = rotatedX + cx;
      y3 = rotatedY + cy;

      tempX = x4 - cx;
      tempY = y4 - cy;

      rotatedX = tempX * cosAng - tempY * sinAng;
      rotatedY = tempX * sinAng + tempY * cosAng;

      x4 = rotatedX + cx;
      y4 = rotatedY + cy;
    }

    double u = texture.u.toDouble();
    double u2 = texture.u2.toDouble();

    double v = texture.v.toDouble();
    double v2 = texture.v2.toDouble();

    if (flipX) {
      double temp = u;
      u = u2;
      u2 = temp;
    }
    if (flipY) {
      double temp = v;
      v = v2;
      v2 = temp;
    }

    for(var num in [
      x1,
      y1,
      0.0,
      u,
      v,
      x2,
      y2,
      0.0,
      u,
      v2,
      x3,
      y3,
      0.0,
      u2,
      v,
      x4,
      y4,
      0.0,
      u2,
      v2
    ]) {
      print(num);
    }
    vertices.setAll(spritesInFlush * verticesPerSprite * vertexSize, [
      x1,
      y1,
      0.0,
      u,
      v,
      x2,
      y2,
      0.0,
      u,
      v2,
      x3,
      y3,
      0.0,
      u2,
      v,
      x4,
      y4,
      0.0,
      u2,
      v2
    ]);

    spritesInFlush++;
  }

  @override
  createIndices() {
    for (int i = 0, j = 0; i < indices.length; i += 6, j += 4) {
      indices[i] = j;
      indices[i + 1] = j + 1;
      indices[i + 2] = j + 2;
      indices[i + 3] = j + 2;
      indices[i + 4] = j + 3;
      indices[i + 5] = j + 1;
    }

    gl.bindBuffer(WebGL.ELEMENT_ARRAY_BUFFER, indexBuffer);
    gl.bufferData(WebGL.ELEMENT_ARRAY_BUFFER, indices, WebGL.STATIC_DRAW);
  }

  @override
  setAttribPointers() {
    gl.vertexAttribPointer(shaderProgram.attributes[vertPosAttrib], 3,
        WebGL.FLOAT, false, vertexSize * 4, 0);
    gl.vertexAttribPointer(shaderProgram.attributes[textureCoordAttrib], 3,
        WebGL.FLOAT, false, vertexSize * 4, 3 * 4);

    gl.uniform1i(shaderProgram.uniforms[samplerUni], texture.bind(0));
    gl.uniform4f(
        shaderProgram.uniforms[colorUni], color.r, color.g, color.b, color.a);
  }
}
