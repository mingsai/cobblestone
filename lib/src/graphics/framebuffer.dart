part of cobblestone;

/// An offscreen texture that can be rendered to
class Framebuffer {
  GLWrapper wrapper;
  WebGL.RenderingContext context;
  
  Texture texture;
  WebGL.Framebuffer buffer;

  ShaderProgram shader;
  SpriteBatch batch;

  int width;
  int height;

  /// Creates a new framebuffer of [width], [height]. Can use [shader] for effects.
  Framebuffer(this.wrapper, this.width, this.height, {this.shader: null}) {
    context = wrapper.context;
    
    if (shader == null) {
      shader = wrapper.batchShader;
    }
    batch = new SpriteBatch(wrapper, shader, maxSprites: 2);

    texture = new Texture.empty(wrapper, width, height);

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

  /// Clears the screen and starts the shader program
  void startRender(Matrix4 projection) {
    wrapper.clearScreen(0.0, 0.0, 0.0, 1.0);
    batch.projection = projection;
    batch.begin();
  }

  // Finishes rendering the FBO
  void endRender([int x = 0, int y = 0, int width = null, int height = null]) {
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
