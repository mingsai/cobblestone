part of cobblestone;

/// A generic batch, used as a base for others like [SpriteBatch]
abstract class VertexBatch {
  GLWrapper wrapper;
  GL.RenderingContext context;
  
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

  GL.Buffer vertexBuffer;
  GL.Buffer indexBuffer;

  ShaderProgram shaderProgram;

  Matrix4 projection;
  Matrix4 transform;

  /// Called during rendering, use [setUniform] to provide additional data to
  /// shaders here
  Function setAdditionalUniforms = null;

  VertexBatch(this.wrapper, this.shaderProgram, {this.maxSprites: 8000}) {
    context = wrapper.context;
    
    projection = new Matrix4.identity();
    transform = new Matrix4.identity();

    vertexBuffer = context.createBuffer();
    indexBuffer = context.createBuffer();

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
  }

  begin() {
    shaderProgram.startProgram();

    if(setAdditionalUniforms != null) {
      setAdditionalUniforms();
    }
  }

  appendAttrib(num value) {
    vertices[index] = value.toDouble();
    index++;
  }

  createIndices() {
    for (int i = 0; i < indices.length; i++) {
      indices[i] = i;
    }

    context.bindBuffer(WebGL.ELEMENT_ARRAY_BUFFER, indexBuffer);
    context.bufferData(WebGL.ELEMENT_ARRAY_BUFFER, indices, WebGL.STATIC_DRAW);
  }

  flush() {
    context.bindBuffer(WebGL.ARRAY_BUFFER, vertexBuffer);
    context.bufferData(WebGL.ARRAY_BUFFER, vertices, WebGL.DYNAMIC_DRAW);
    context.bindBuffer(WebGL.ELEMENT_ARRAY_BUFFER, indexBuffer);

    setAttribPointers();

    context.uniformMatrix4fv(
        shaderProgram.uniforms[projMatUni], false, projection.storage);
    context.uniformMatrix4fv(
        shaderProgram.uniforms[transMatUni], false, transform.storage);

    //The indices are important!
    context.drawElements(
        drawMode, spritesInFlush * indicesPerSprite, WebGL.UNSIGNED_SHORT, 0);

    spritesToEnd += spritesInFlush;
    reset();
  }

  void setUniform(String name, dynamic value) =>
      shaderProgram.setUniform(name, value);

  void setAttribPointers();

  end() {
    flush();
    if (spritesToEnd > maxSprites) {
      maxSprites = spritesToEnd;
      print("Resized: " + maxSprites.toString());
      rebuildBuffer();
    }
    spritesToEnd = 0;
    shaderProgram.endProgram();
  }
}
