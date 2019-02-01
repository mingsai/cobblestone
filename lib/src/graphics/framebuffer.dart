part of cobblestone;

/// An offscreen texture that can be rendered to
class Framebuffer {
  GLWrapper wrapper;
  GL.RenderingContext context;
  
  Texture texture;
  GL.Framebuffer buffer;

  ShaderProgram shader;
  SpriteBatch batch;

  int width;
  int height;

  /// Called during rendering, use [setUniform] to provide additional data to
  /// shaders here
  Function setAdditionalUniforms = null;

  /// Creates a new framebuffer of [width], [height]. Can use [shader] for effects.
  Framebuffer(this.wrapper, this.width, this.height, {this.shader: null, filter: WebGL.NEAREST}) {
    context = wrapper.context;
    
    if (shader == null) {
      shader = wrapper.batchShader;
    }
    batch = new SpriteBatch(wrapper, shader, maxSprites: 2);

    texture = new Texture.empty(wrapper, width, height, filter);

    buffer = context.createFramebuffer();
    context.bindFramebuffer(WebGL.FRAMEBUFFER, buffer);

    context.framebufferTexture2D(WebGL.FRAMEBUFFER, WebGL.COLOR_ATTACHMENT0,
        WebGL.TEXTURE_2D, texture.texture, 0);

    endCapture();
  }

  /// Directs all further rendering to this framebuffer
  void beginCapture() {
    context.bindFramebuffer(WebGL.FRAMEBUFFER, buffer);
  }

  /// Stops capturing the rendering
  void endCapture() {
    context.bindFramebuffer(WebGL.FRAMEBUFFER, null);
  }

  /// Sets a uniform for [shader]
  void setUniform(String name, dynamic value) => shader.setUniform(name, value);

  // Renders the FBO to the screen. Calls [setAdditionalUniforms] midway.
  void render(Matrix4 projection, [int x = 0, int y = 0, int width = null, int height = null]) {
    wrapper.clearScreen(0.0, 0.0, 0.0, 1.0);
    batch.projection = projection;
    batch.begin();

    if(setAdditionalUniforms != null) {
      setAdditionalUniforms();
    }

    if(width == null) {
      width = this.width ~/ 2;
    }
    if(height == null) {
      height = this.height ~/ 2;
    }
    batch.draw(texture, x, y, width: width, height: height);
    batch.end();
  }
}
