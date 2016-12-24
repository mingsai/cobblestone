part of cobblestone;

class PointBatch extends VertexBatch {

  final int drawMode = WebGL.POINTS;

  final int vertexSize = 7;
  final int verticesPerSprite = 1;
  final int indicesPerSprite = 1;

  PointBatch(ShaderProgram shaderProgram) : super(shaderProgram);

  PointBatch.defaultShader() : this(assetManager.get("packages/cobblestone/shaders/point"));

  @override
  setAttribPointers() {
    gl.vertexAttribPointer(shaderProgram.attributes[vertPosAttrib], 3, WebGL.FLOAT, false, vertexSize * 4, 0);
    gl.vertexAttribPointer(shaderProgram.attributes[colorAttrib], 4, WebGL.FLOAT, false, vertexSize * 4, 3 * 4);
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
  }

}