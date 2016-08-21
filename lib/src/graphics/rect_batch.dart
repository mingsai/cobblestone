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

  final int vertexSize = 7;
  final int verticesPerSprite = 6;

  int index = 0;

  Float32List vertices;
  Buffer vertexBuffer;

  ShaderProgram shaderProgram;

  Matrix4 projection;
  Matrix4 transform;

  Vector4 color;

  SpriteBatch.customShader(this.shaderProgram);

  SpriteBatch.defaultShader() {
    shaderProgram = assetManager.get("packages/cobblestone/shaders/untextured");

    projection = new Matrix4.identity();
    transform = new Matrix4.identity();

    color = new Vector4.identity();

    vertices = new Float32List(maxSprites * vertexSize * verticesPerSprite);
    vertexBuffer = gl.createBuffer();

    reset();
  }

  reset() {
    index = 0;
    vertices.fillRange(0, vertices.length, 0.0);
  }

  begin() {
    reset();
    shaderProgram.startProgram();
  }

  draw(num x, num y, num width, num height, {num angle: 0, bool counterTurn: false}) {
    num x1 = x;
    num y1 = y;

    num x2 = x;
    num y2 = y + height;

    num x3 = x + width;
    num y3 = y;

    num x4 = x + width;
    num y4 = y + height;

    addVertex(x1, y1, 0, color.r, color.g, color.b, color.a);
    addVertex(x2, y2, 0, color.r, color.g, color.b, color.a);
    addVertex(x3, y3, 0, color.r, color.g, color.b, color.a);

    addVertex(x4, y4, 0, color.r, color.g, color.b, color.a);
    addVertex(x3, y3, 0, color.r, color.g, color.b, color.a);
    addVertex(x2, y2, 0, color.r, color.g, color.b, color.a);
  }

  addVertex(double x, double y, double z, double r, double g, double b, double a) {
    vertices[index] = x.toDouble();
    index++;
    vertices[index] = y.toDouble();
    index++;
    vertices[index] = x.toDouble();
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
    gl.vertexAttribPointer(
        shaderProgram.attributes[vertPosAttrib], 3, FLOAT, false, vertexSize * 4, 0);
    gl.vertexAttribPointer(shaderProgram.attributes[colorAttrib], 4, FLOAT, false, vertexSize * 4, 3 * 4);

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