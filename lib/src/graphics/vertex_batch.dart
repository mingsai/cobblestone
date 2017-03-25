part of cobblestone;

abstract class VertexBatch {

  int maxSprites = 8000;

  int vertexSize = 3;
  int verticesPerSprite = 1;
  int indicesPerSprite = 1;

  int drawMode = WebGL.POINTS;

  int spritesInFlush = 0;
  int spritesToEnd = 0;
  int index = 0;
  int elementIndex = 0;

  Float32List vertices;
  Int16List indices;

  WebGL.Buffer vertexBuffer;
  WebGL.Buffer indexBuffer;

  ShaderProgram shaderProgram;

  Matrix4 projection;
  Matrix4 transform;

  VertexBatch(this.shaderProgram, {this.maxSprites = 8000}) {
    projection = new Matrix4.identity();
    transform = new Matrix4.identity();

    vertexBuffer = gl.createBuffer();
    indexBuffer = gl.createBuffer();

    rebuildBuffer();

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
    spritesInFlush = 0;
    vertices.fillRange(0, vertices.length, 0.0);
  }

  begin() {
    reset();
    shaderProgram.startProgram();
  }

  appendAttrib(num value) {
    vertices[index] = value.toDouble();
    index++;
  }

  createIndices() {
    for(int i = 0; i < indices.length; i++) {
      indices[i] = i;
    }

    gl.bindBuffer(WebGL.ELEMENT_ARRAY_BUFFER, indexBuffer);
    gl.bufferData(WebGL.ELEMENT_ARRAY_BUFFER, indices, WebGL.STATIC_DRAW);
  }

  flush() {
    gl.bindBuffer(WebGL.ARRAY_BUFFER, vertexBuffer);
    gl.bufferData(WebGL.ARRAY_BUFFER, vertices, WebGL.DYNAMIC_DRAW);
    gl.bindBuffer(WebGL.ELEMENT_ARRAY_BUFFER, indexBuffer);

    setAttribPointers();

    gl.uniformMatrix4fv(shaderProgram.uniforms[projMatUni], false, projection.storage);
    gl.uniformMatrix4fv(shaderProgram.uniforms[transMatUni], false, transform.storage);

    //The indices are important!
    gl.drawElements(drawMode, spritesInFlush * indicesPerSprite, WebGL.UNSIGNED_SHORT, 0);

    spritesToEnd += spritesInFlush;
    reset();
  }

  void setAttribPointers();

  setUniform(String name, dynamic value) {
    if(value is int) {
      gl.uniform1i(shaderProgram.uniforms[name], value);
    } else if(value is double) {
      gl.uniform1f(shaderProgram.uniforms[name], value);
    } else if(value is Vector2) {
      gl.uniform2f(shaderProgram.uniforms[name], value.x, value.y);
    } else if(value is Vector3) {
      gl.uniform3f(shaderProgram.uniforms[name], value.x, value.y, value.z);
    } else if(value is Vector4) {
      gl.uniform4f(shaderProgram.uniforms[name], value.x, value.y, value.z, value.w);
    } else if(value is Matrix4) {
      gl.uniformMatrix4fv(shaderProgram.uniforms[name], false, value.storage);
    }
  }

  end() {
    flush();
    if(spritesToEnd > maxSprites) {
      maxSprites = spritesToEnd;
      print("Resized: " + maxSprites.toString());
      rebuildBuffer();
    }
    spritesToEnd = 0;
    shaderProgram.endProgram();
  }

}