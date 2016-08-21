part of cobblestone;

class ImediateTextureRenderer {

  ShaderProgram shaderProgram;

  ImediateTextureRenderer.customShader(this.shaderProgram);

  Vector4 color;

  Buffer textureCoordBuffer;

  ImediateTextureRenderer.defaultShader() {
    shaderProgram = assetManager.get("packages/cobblestone/shaders/textured");

    textureCoordBuffer = gl.createBuffer();
    gl.bindBuffer(ARRAY_BUFFER, textureCoordBuffer);
    gl.bufferData(ARRAY_BUFFER, new Float32List.fromList([1.0, 1.0, 0.0, 1.0, 1.0, 0.0, 0.0, 0.0,]), STATIC_DRAW);
  }

  begin() {
    shaderProgram.startProgram();
    color = new Vector4.identity();
  }

  draw(Mesh mesh, Matrix4 projection, Matrix4 transfrom, GameTexture texture) {
    gl.bindBuffer(ARRAY_BUFFER, mesh.vertexBufer);
    gl.vertexAttribPointer(shaderProgram.attributes[vertPosAttrib], 3, FLOAT, false, 0, 0);

    gl.bindBuffer(ARRAY_BUFFER, textureCoordBuffer);
    gl.vertexAttribPointer(shaderProgram.attributes[textureCoordAttrib], 2, FLOAT, false, 0, 0);

    gl.uniform4fv(shaderProgram.uniforms[colorUni], color.storage);
    gl.uniformMatrix4fv(shaderProgram.uniforms[projMatUni], false, projection.storage);
    gl.uniformMatrix4fv(shaderProgram.uniforms[transMatUni], false, transfrom.storage);

    gl.uniform1i(shaderProgram.uniforms[samplerUni], texture.bind());

    gl.drawArrays(mesh.drawMode, 0, mesh.vertexCount);
  }

}