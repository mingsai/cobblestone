part of cobblestone;

List<num> rectData(width, height) {
  return [width, height, 0.0,
    0.0, height, 0.0,
    width, 0.0, 0.0,
    0.0, 0.0, 0.0];
}

class Mesh {

  Buffer vertexBufer;
  List<num> vertexData;
  int vertexCount;

  int drawMode;

  Mesh.vertexArray(this.vertexData, this.drawMode, RenderingContext gl) {
    vertexBufer = gl.createBuffer();

    gl.bindBuffer(ARRAY_BUFFER, vertexBufer);
    gl.bufferData(ARRAY_BUFFER, new Float32List.fromList(vertexData), STATIC_DRAW);

    vertexCount = (vertexData.length / 3).round();
  }

  Mesh.rect(num width, num height, RenderingContext gl) {
    drawMode = TRIANGLE_STRIP;
    vertexData = rectData(width, height);

    vertexBufer = gl.createBuffer();

    gl.bindBuffer(ARRAY_BUFFER, vertexBufer);
    gl.bufferData(ARRAY_BUFFER, new Float32List.fromList(vertexData), STATIC_DRAW);

    vertexCount = (vertexData.length / 3).round();
  }

}