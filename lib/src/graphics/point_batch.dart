part of cobblestone;

/// A batch of points
class PointBatch extends VertexBatch {
  int maxSprites = 8000;

  final int drawMode = WebGL.POINTS;

  final int vertexSize = 7;
  final int verticesPerSprite = 1;
  final int indicesPerSprite = 1;

  PointBatch(GLWrapper wrapper, ShaderProgram shaderProgram, {this.maxSprites = 8000})
      : super(wrapper, shaderProgram);

  PointBatch.defaultShader(GLWrapper wrapper, {int maxSprites = 8000})
      : this(wrapper, wrapper.pointShader, maxSprites: maxSprites);

  @override
  setAttribPointers() {
    context.vertexAttribPointer(shaderProgram.attributes[vertPosAttrib], 3,
        WebGL.FLOAT, false, vertexSize * 4, 0);
    context.vertexAttribPointer(shaderProgram.attributes[colorAttrib], 4,
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
