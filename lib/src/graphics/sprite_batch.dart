part of cobblestone;

class SpriteBatch {

  final List<double> baseRectangle =
    [1.0, 1.0, 0.0,
     0.0, 1.0, 0.0,
     1.0, 0.0, 0.0,
     0.0, 0.0, 0.0,
     0.0, 1.0, 0.0,
     1.0, 0.0, 0.0];

  final int maxSprites = 2000;

  final int vertexSize = 9;
  final int verticesPerSprite = 6;

  int spritesInBatch = 0;
  int index = 0;

  Float32List vertices;
  Buffer vertexBuffer;

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

    vertices = new Float32List(maxSprites * vertexSize * verticesPerSprite);
    vertexBuffer = gl.createBuffer();

    reset();
  }

  reset() {
    index = 0;
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
    if(spritesInBatch >= maxSprites) {
      flush();
    }
    if(this.texture != null) {
      if (texture.texture != this.texture.texture) {
        flush();
      }
    }
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

    num x1 = x;
    num y1 = y;

    num x2 = x;
    num y2 = y + height;

    num x3 = x + width;
    num y3 = y;

    num x4 = x + width;
    num y4 = y + height;

    if(angle != 0) {
      if(counterTurn) {
        angle = 360 - angle;
      }

      num cx = x + width / 2;
      num cy = y + height / 2;

      num sinAng = sin(angle);
      num cosAng = cos(angle);

      num tempX = x1 - cx;
      num tempY = y1 - cy;

      num rotatedX = tempX * cosAng - tempY * sinAng;
      num rotatedY = tempX * sinAng + tempY * cosAng;

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

    num u = texture.u;
    num u2 = texture.u2;

    num v = texture.v;
    num v2 = texture.v2;

    if(flipX) {
      num temp = u;
      u = u2;
      u2 = temp;
    }
    if(flipY) {
      num temp = v;
      v = v2;
      v2 = temp;
    }

    addVertex(x1, y1, 0, color.r, color.g, color.b, color.a, u, v);
    addVertex(x2, y2, 0, color.r, color.g, color.b, color.a, u, v2);
    addVertex(x3, y3, 0, color.r, color.g, color.b, color.a, u2, v);

    addVertex(x4, y4, 0, color.r, color.g, color.b, color.a, u2, v2);
    addVertex(x3, y3, 0, color.r, color.g, color.b, color.a, u2, v);
    addVertex(x2, y2, 0, color.r, color.g, color.b, color.a, u, v2);
  }

  addVertex(num x, num y, num z, num r, num g, num b, num a, num u, num v) {
    vertices[index] = x.toDouble();
    index++;
    vertices[index] = y.toDouble();
    index++;
    vertices[index] = z.toDouble();
    index++;

    vertices[index] = u.toDouble();
    index++;
    vertices[index] = v.toDouble();
    index++;

    vertices[index] = r.toDouble();
    index++;
    vertices[index] = g.toDouble();
    index++;
    vertices[index] = b.toDouble();
    index++;
    vertices[index] = a.toDouble();
    index++;
  }

  flush() {
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

    gl.drawArrays(TRIANGLES, 0, maxSprites);

    reset();
  }

  end() {
    flush();
  }

}