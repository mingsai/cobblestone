part of cobblestone;

/// A batch of bounding boxes, drawn in wireframe.
class PhysboxBatch extends VertexBatch {
  int maxSprites = 2000;

  final int drawMode = WebGL.LINES;

  final int vertexSize = 3;
  final int verticesPerSprite = 4;
  final int indicesPerSprite = 8;

  Vector3 point = new Vector3.zero();

  PhysboxBatch(ShaderProgram shaderProgram, {this.maxSprites: 2000})
      : super(shaderProgram);

  PhysboxBatch.defaultShader({int maxSprites: 2000})
      : this(assetManager.get("packages/cobblestone/shaders/wire"),
            maxSprites: maxSprites);

  @override
  setAttribPointers() {
    gl.vertexAttribPointer(shaderProgram.attributes[vertPosAttrib], 3,
        WebGL.FLOAT, false, vertexSize * 4, 0);

    gl.uniform4fv(shaderProgram.uniforms[colorUni], Colors.white.storage);
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

    gl.bindBuffer(WebGL.ELEMENT_ARRAY_BUFFER, indexBuffer);
    gl.bufferData(WebGL.ELEMENT_ARRAY_BUFFER, indices, WebGL.STATIC_DRAW);
  }

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
      box.copyCorner(0, point);
      appendAttrib(point.x);
      appendAttrib(point.y);
      appendAttrib(0);

      box.copyCorner(2, point);
      appendAttrib(point.x);
      appendAttrib(point.y);
      appendAttrib(0);

      box.copyCorner(6, point);
      appendAttrib(point.x);
      appendAttrib(point.y);
      appendAttrib(0);

      box.copyCorner(4, point);
      appendAttrib(point.x);
      appendAttrib(point.y);
      appendAttrib(0);

      spritesInFlush++;
    }
  }
}
