part of cobblestone;

Future<ShaderProgram> loadProgram(String vertex, String fragment) {
  return Future.wait([HttpRequest.getString(vertex), HttpRequest.getString(fragment)])
      .then((List<String> sources) => new ShaderProgram.compile(sources[0], sources[1]));
}

class ShaderProgram {

  Map<String, int> attributes = new Map<String, int>();
  Map<String, WebGL.UniformLocation> uniforms = new Map<String, WebGL.UniformLocation>();
  WebGL.Program program;

  WebGL.Shader fragShader, vertShader;

  ShaderProgram.compile(String vertexSource, String fragmentSource) {
    fragShader = gl.createShader(WebGL.FRAGMENT_SHADER);
    gl.shaderSource(fragShader, fragmentSource);
    gl.compileShader(fragShader);

    vertShader = gl.createShader(WebGL.VERTEX_SHADER);
    gl.shaderSource(vertShader, vertexSource);
    gl.compileShader(vertShader);

    program = gl.createProgram();
    gl.attachShader(program, vertShader);
    gl.attachShader(program, fragShader);
    gl.linkProgram(program);

    if (!gl.getProgramParameter(program, WebGL.LINK_STATUS)) {
      print("Could not initialise shaders");
    }

    int activeAttributes = gl.getProgramParameter(program, WebGL.ACTIVE_ATTRIBUTES);
    int activeUniforms = gl.getProgramParameter(program, WebGL.ACTIVE_UNIFORMS);

    for (int i = 0; i < activeAttributes; i++) {
      WebGL.ActiveInfo a = gl.getActiveAttrib(program, i);
      int attributeLocation = gl.getAttribLocation(program, a.name);
      attributes[a.name] = attributeLocation;
    }

    for (int i = 0; i < activeUniforms; i++) {
      WebGL.ActiveInfo a = gl.getActiveUniform(program, i);
      uniforms[a.name] = gl.getUniformLocation(program, a.name);
    }
  }

  startProgram() {
    attributes.forEach((name, location) =>
        gl.enableVertexAttribArray(location));
    gl.useProgram(program);
  }

  endProgram() {
    attributes.forEach((name, location) =>
        gl.disableVertexAttribArray(location));
  }

}