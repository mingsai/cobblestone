part of cobblestone;

/// A batch of bounding boxes, drawn in wireframe.
class PhysboxBatch extends VertexBatch {
  int maxSprites = 2000;

  final int drawMode = WebGL.LINES;

  final int vertexSize = 3;
  final int verticesPerSprite = 4;
  final int indicesPerSprite = 8;

  Vector3 _point = new Vector3.zero();

  /// Creates a new physbox batch with a custom shader.
  PhysboxBatch(GLWrapper wrapper, ShaderProgram shaderProgram, {this.maxSprites = 2000})
      : super(wrapper, shaderProgram);

  /// Creates a new physbox batch with a basic internal shader.
  PhysboxBatch.defaultShader(GLWrapper wrapper, {int maxSprites = 2000})
      : this(wrapper, wrapper.wireShader, maxSprites: maxSprites);

  @override
  setAttribPointers() {
    _context.vertexAttribPointer(shaderProgram.attributes[vertPosAttrib], 3,
        WebGL.FLOAT, false, vertexSize * 4, 0);

    _context.uniform4fv(shaderProgram.uniforms[colorUni], Colors.white.storage);
    //print(shaderProgram.attributes);
  }

  @override
  createIndices() {
    for (int i = 0, j = 0; i < indices.length; i += 8, j += 4) {
      indices[i] = j;
      indices[i + 1] = j + 1;
      indices[i + 2] = j + 1;
      indices[i + 3] = j + 2;
      indices[i + 4] = j + 2;
      indices[i + 5] = j + 3;
      indices[i + 6] = j + 3;
      indices[i + 7] = j;
    }

    _context.bindBuffer(WebGL.ELEMENT_ARRAY_BUFFER, indexBuffer);
    _context.bufferData(WebGL.ELEMENT_ARRAY_BUFFER, indices, WebGL.STATIC_DRAW);
  }

  /// Draws an [Aabb2] or [Obb3], flattened on the z-axis.
  draw2D(dynamic box) {
    if (box is Aabb2) {
      appendAttrib(box.max.x);
      appendAttrib(box.max.y);
      appendAttrib(0);

      appendAttrib(box.min.x);
      appendAttrib(box.max.y);
      appendAttrib(0);

      appendAttrib(box.min.x);
      appendAttrib(box.min.y);
      appendAttrib(0);

      appendAttrib(box.max.x);
      appendAttrib(box.min.y);
      appendAttrib(0);

      spritesInFlush++;
    } else if (box is Obb3) {
      box.copyCorner(0, _point);
      appendAttrib(_point.x);
      appendAttrib(_point.y);
      appendAttrib(0);

      box.copyCorner(2, _point);
      appendAttrib(_point.x);
      appendAttrib(_point.y);
      appendAttrib(0);

      box.copyCorner(6, _point);
      appendAttrib(_point.x);
      appendAttrib(_point.y);
      appendAttrib(0);

      box.copyCorner(4, _point);
      appendAttrib(_point.x);
      appendAttrib(_point.y);
      appendAttrib(0);

      spritesInFlush++;
    }
  }
}
