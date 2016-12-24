part of cobblestone;

class SpriteBatch extends VertexBatch {

  int maxSprites = 2000;

  int drawMode = WebGL.TRIANGLES;

  final int vertexSize = 9;
  final int verticesPerSprite = 4;
  final int indicesPerSprite = 6;

  Vector4 color;

  GameTexture texture;

  SpriteBatch(shaderProgram) : super(shaderProgram) {
    color = new Vector4.all(1.0);
  }

  SpriteBatch.defaultShader() : this(assetManager.get("packages/cobblestone/shaders/batch"));

  draw(GameTexture texture, num x, num y,
      {num width: null, num height: null, num scaleX: 1, num scaleY: 1,
      bool flipX: false, bool flipY: false,
      num angle: 0, bool counterTurn: false}) {

    x = x.toDouble();
    y = y.toDouble();

    if(spritesInBatch >= maxSprites) {
      print("Batch full");
      flush();
    }
    if(this.texture != null) {
      if (texture.texture != this.texture.texture) {
        print("Wrong texture");
        flush();
      }
    }
    spritesTotal++;
    spritesInBatch++;

    this.texture = texture;

    if(width == null) {
      width = texture.width;
    }
    if(height == null) {
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

    if(angle != 0) {
      if(counterTurn) {
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

    double u = texture.u;
    double u2 = texture.u2;

    double v = texture.v;
    double v2 = texture.v2;

    if(flipX) {
      double temp = u;
      u = u2;
      u2 = temp;
    }
    if(flipY) {
      double temp = v;
      v = v2;
      v2 = temp;
    }

    addVertex(x1, y1, 0.0, color.r, color.g, color.b, color.a, u, v);
    addVertex(x2, y2, 0.0, color.r, color.g, color.b, color.a, u, v2);
    addVertex(x3, y3, 0.0, color.r, color.g, color.b, color.a, u2, v);
    addVertex(x4, y4, 0.0, color.r, color.g, color.b, color.a, u2, v2);
  }

  addVertex(double x, double y, double z, double r, double g, double b, double a, double u, double v) {
    vertices[index] = x;
    index++;
    vertices[index] = y;
    index++;
    vertices[index] = z;
    index++;

    vertices[index] = u;
    index++;
    vertices[index] = v;
    index++;

    vertices[index] = r;
    index++;
    vertices[index] = g;
    index++;
    vertices[index] = b;
    index++;
    vertices[index] = a;
    index++;
  }

  @override
  createIndices() {
    for(int i = 0, j = 0; i < indices.length; i += 6, j += 4) {
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
    gl.vertexAttribPointer(shaderProgram.attributes[vertPosAttrib], 3, WebGL.FLOAT, false, vertexSize * 4, 0);
    gl.vertexAttribPointer(shaderProgram.attributes[textureCoordAttrib], 3, WebGL.FLOAT, false, vertexSize * 4, 3 * 4);
    gl.vertexAttribPointer(shaderProgram.attributes[colorAttrib], 4, WebGL.FLOAT, false, vertexSize * 4, 5 * 4);

    gl.uniform1i(shaderProgram.uniforms[samplerUni], texture.bind());
  }
}