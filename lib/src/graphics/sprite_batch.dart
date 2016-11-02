part of cobblestone;

class SpriteBatch {

  final List<double> baseRectangle =
  [1.0, 1.0, 0.0,
  0.0, 1.0, 0.0,
  1.0, 0.0, 0.0,
  0.0, 0.0, 0.0,
  0.0, 1.0, 0.0,
  1.0, 0.0, 0.0];

  int maxSprites = 2000;

  final int vertexSize = 9;
  final int verticesPerSprite = 4;
  final int indicesPerSprite = 6;

  int spritesTotal = 0;
  int spritesInBatch = 0;
  int index = 0;
  int elementIndex = 0;

  Float32List vertices;
  Int16List indices;

  Buffer vertexBuffer;
  Buffer indexBuffer;

  ShaderProgram shaderProgram;

  Matrix4 projection;
  Matrix4 transform;

  Vector4 color;

  GameTexture texture;

  SpriteBatch.customShader(this.shaderProgram);

  SpriteBatch.defaultShader() {
    shaderProgram = assetManager.get("packages/cobblestone/shaders/batch");

    projection = new Matrix4.identity();
    transform = new Matrix4.identity();

    color = new Vector4.all(1.0);

    rebuildBuffer();
    vertexBuffer = gl.createBuffer();
    indexBuffer = gl.createBuffer();

    reset();
  }

  rebuildBuffer() {
    vertices = new Float32List(maxSprites * vertexSize * verticesPerSprite);
    indices = new Int16List(maxSprites * indicesPerSprite);
    createIndices();
  }

  reset() {
    index = 0;
    elementIndex = 0;
    spritesInBatch = 0;
    vertices.fillRange(0, vertices.length, 0.0);
  }

  begin() {
    reset();
    shaderProgram.startProgram();
  }

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

  createIndices() {
    for(int i = 0, j = 0; i < indices.length; i += 6, j += 4) {
      indices[i] = j;
      indices[i + 1] = j + 1;
      indices[i + 2] = j + 2;
      indices[i + 3] = j + 2;
      indices[i + 4] = j + 3;
      indices[i + 5] = j + 1;
      print(j + 3);
    }

    gl.bindBuffer(ELEMENT_ARRAY_BUFFER, indexBuffer);
    gl.bufferData(ELEMENT_ARRAY_BUFFER, indices, STATIC_DRAW);
  }

  flush() {
    print("Flush batch");
    gl.bindBuffer(ARRAY_BUFFER, vertexBuffer);
    gl.bufferData(ARRAY_BUFFER, vertices, DYNAMIC_DRAW);

    //offsets and strides are by byte, thus multiplied by 4
    gl.vertexAttribPointer(shaderProgram.attributes[vertPosAttrib], 3, FLOAT, false, vertexSize * 4, 0);
    gl.vertexAttribPointer(shaderProgram.attributes[textureCoordAttrib], 3, FLOAT, false, vertexSize * 4, 3 * 4);
    gl.vertexAttribPointer(shaderProgram.attributes[colorAttrib], 4, FLOAT, false, vertexSize * 4, 5 * 4);

    gl.uniform1i(shaderProgram.uniforms[samplerUni], texture.bind());
    //gl.uniform4fv(shaderProgram.uniforms[colorUni], color.storage);
    gl.uniformMatrix4fv(shaderProgram.uniforms[projMatUni], false, projection.storage);
    gl.uniformMatrix4fv(shaderProgram.uniforms[transMatUni], false, transform.storage);

    gl.drawElements(TRIANGLES, maxSprites, UNSIGNED_SHORT, 0);

    reset();
  }

  end() {
    print("End");
    flush();
    if(spritesTotal > maxSprites) {
      maxSprites = spritesTotal;
      rebuildBuffer();
      print(maxSprites);
    }
    spritesTotal = 0;
  }

}