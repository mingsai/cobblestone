part of cobblestone;

// A wrapper containing several useful WebGL functions
class GLWrapper {

  // The actual rendering context
  GL.RenderingContext context;

  ShaderProgram batchShader, wireShader, pointShader;

  GLWrapper(this.context) {
    _setGLOptions();
    _loadBuiltinShaders();
  }

  ShaderProgram compileShader(String vertexSource, String fragmentSource) {
    return new ShaderProgram.compile(this, vertexSource, fragmentSource);
  }

  /// Clears the screen either to [r] as a [Vector4] or [r], [g], [b], [a] as numbers.
  clearScreen(r, [num g, num b, num a]) {
    if (r is Vector4) {
      context.clearColor(r.r, r.g, r.b, r.a);
    } else {
      context.clearColor(r, g, b, a);
    }

    context.clear(WebGL.COLOR_BUFFER_BIT | WebGL.DEPTH_BUFFER_BIT);
  }

  /// Sets the WebGL viewport to the given width and height
  setGLViewport(num width, num height) {
    context.viewport(0, 0, width, height);
  }

  /// Sets the default WebGL options.
  _setGLOptions() {
    context.disable(WebGL.DEPTH_TEST);
    context.enable(WebGL.BLEND);
    context.blendFunc(WebGL.SRC_ALPHA, WebGL.ONE_MINUS_SRC_ALPHA);
  }

  /// Loads the shaders used by built in batches
  _loadBuiltinShaders() {
    batchShader = compileShader(_batchVertexShaderSrc, _batchFragmentShaderSrc);
    wireShader = compileShader(_wireVertexShaderSrc, _wireFragmentShaderSrc);
    pointShader = compileShader(_pointVertexShaderSrc, _pointFragmentShaderSrc);
  }

}