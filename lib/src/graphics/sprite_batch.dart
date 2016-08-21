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

  draw(GameTexture texture, num x, num y, num width, num height) {
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

    num x1 = x;
    num y1 = y;

    num x2 = x;
    num y2 = y + height;

    num x3 = x + width;
    num y3 = y;

    num x4 = x + width;
    num y4 = y + height;

    addVertex(x1, y1, 0, color.r, color.g, color.b, color.a, texture.u, texture.v);
    addVertex(x2, y2, 0, color.r, color.g, color.b, color.a, texture.u, texture.v2);
    addVertex(x3, y3, 0, color.r, color.g, color.b, color.a, texture.u2, texture.v);

    addVertex(x4, y4, 0, color.r, color.g, color.b, color.a, texture.u2, texture.v2);
    addVertex(x3, y3, 0, color.r, color.g, color.b, color.a, texture.u2, texture.v);
    addVertex(x2, y2, 0, color.r, color.g, color.b, color.a, texture.u, texture.v2);
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