part of cobblestone;

/// An offscreen texture that can be rendered to
class Framebuffer {
  Texture texture;
  WebGL.Framebuffer buffer;

  ShaderProgram shader;
  SpriteBatch batch;

  int width;
  int height;

  /// Creates a new framebuffer of [width], [height]. Can use [shader] for effects.
  Framebuffer(this.width, this.height, {this.shader: null}) {
    if (shader == null) {
      shader = assetManager.get("packages/cobblestone/shaders/batch");
    }
    batch = new SpriteBatch(shader, maxSprites: 2);

    texture = new Texture.empty(width, height);

    buffer = gl.createFramebuffer();
    gl.bindFramebuffer(WebGL.FRAMEBUFFER, buffer);

    gl.framebufferTexture2D(WebGL.FRAMEBUFFER, WebGL.COLOR_ATTACHMENT0,
        WebGL.TEXTURE_2D, texture.texture, 0);

    endCapture();
  }

  /// Directs all further rendering to this framebuffer
  void beginCapture() {
    gl.bindFramebuffer(WebGL.FRAMEBUFFER, buffer);
  }

  /// Stops capturing the rendering
  void endCapture() {
    gl.bindFramebuffer(WebGL.FRAMEBUFFER, null);
  }

  /// Sets a uniform for [shader]
  void setUniform(String name, dynamic value) => shader.setUniform(name, value);

  /// Renders this to the screen
  void render(Matrix4 projection, [int x = 0, int y = 0, int width = null, int height = null]) {
    if(width == null) {
      width = this.width ~/ 2;
    }
    if(height == null) {
      height = this.height ~/ 2;
    }
    clearScreen(0.0, 0.0, 0.0, 1.0);
    batch.projection = projection;
    batch.begin();
    batch.draw(texture, x, y, width: width, height: height);
    batch.end();
  }
}
