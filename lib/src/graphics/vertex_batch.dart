part of cobblestone;

abstract class VertexBatch {

  int maxSprites = 8000;

  int vertexSize = 3;
  int verticesPerSprite = 1;
  int indicesPerSprite = 1;

  int drawMode = WebGL.POINTS;

  int spritesTotal = 0;
  int spritesInBatch = 0;
  int index = 0;
  int elementIndex = 0;

  Float32List vertices;
  Int16List indices;

  WebGL.Buffer vertexBuffer;
  WebGL.Buffer indexBuffer;

  ShaderProgram shaderProgram;

  Matrix4 projection;
  Matrix4 transform;

  VertexBatch(this.shaderProgram) {
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
    spritesInBatch = 0;
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

    gl.drawElements(drawMode, maxSprites, WebGL.UNSIGNED_SHORT, 0);

    reset();
  }

  setAttribPointers();

  end() {
    flush();
    if(spritesTotal > maxSprites) {
      maxSprites = spritesTotal;
      rebuildBuffer();
    }
    spritesTotal = 0;
    shaderProgram.endProgram();
  }

}