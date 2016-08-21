part of cobblestone;

class ImediateRenderer {

  ShaderProgram shaderProgram;

  ImediateRenderer.customShader(this.shaderProgram);

  Vector4 color;

  ImediateRenderer.defaultShader() {
    shaderProgram = assetManager.get("packages/cobblestone/shaders/untextured");
  }

  begin() {
    shaderProgram.startProgram();
    color = new Vector4.identity();
  }

  draw(Mesh mesh, Matrix4 projection, Matrix4 transfrom) {
    gl.bindBuffer(ARRAY_BUFFER, mesh.vertexBufer);

    gl.vertexAttribPointer(
        shaderProgram.attributes[vertPosAttrib], 3, FLOAT, false, 0, 0);
    gl.uniform4fv(shaderProgram.uniforms[colorUni], color.storage);
    gl.uniformMatrix4fv(shaderProgram.uniforms[projMatUni], false, projection.storage);
    gl.uniformMatrix4fv(shaderProgram.uniforms[transMatUni], false, transfrom.storage);

    gl.drawArrays(mesh.drawMode, 0, mesh.vertexCount);
  }

  end() {

  }

}