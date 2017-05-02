part of cobblestone;

/// A batch of points
class PointBatch extends VertexBatch {
  int maxSprites = 8000;

  final int drawMode = WebGL.POINTS;

  final int vertexSize = 7;
  final int verticesPerSprite = 1;
  final int indicesPerSprite = 1;

  PointBatch(ShaderProgram shaderProgram, {this.maxSprites: 8000})
      : super(shaderProgram);

  PointBatch.defaultShader({int maxSprites: 8000})
      : this(assetManager.get("packages/cobblestone/shaders/point"),
            maxSprites: maxSprites);

  @override
  setAttribPointers() {
    gl.vertexAttribPointer(shaderProgram.attributes[vertPosAttrib], 3,
        WebGL.FLOAT, false, vertexSize * 4, 0);
    gl.vertexAttribPointer(shaderProgram.attributes[colorAttrib], 4,
        WebGL.FLOAT, false, vertexSize * 4, 3 * 4);
    //print(shaderProgram.attributes);
  }

  draw(Vector3 pos, Vector4 color) {
    appendAttrib(pos.x);
    appendAttrib(pos.y);
    appendAttrib(pos.z);
    appendAttrib(color.r);
    appendAttrib(color.g);
    appendAttrib(color.b);
    appendAttrib(color.a);

    spritesInFlush++;
  }
}
