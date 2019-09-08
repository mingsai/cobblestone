part of examples;

class FontExample extends BaseGame {
  SpriteBatch renderer;
  Camera2D camera;

  int textWidth = 640;

  BitmapFont font;
  String text;

  @override
  create() {
    font = assetManager.get("font");
    text = assetManager.get("lipsum");

    camera = Camera2D.originBottomLeft(width, height);
    renderer = SpriteBatch.defaultShader(gl);

    gl.setGLViewport(canvasWidth, canvasHeight);

    startTween();
  }

  @override
  preload() {
    assetManager.load("font", loadFont("font/lora.fnt", loadTexture(gl, "font/lora_0.png", linear)));
    assetManager.load("lipsum", HttpRequest.getString("font/lipsum.txt"));
  }

  @override
  render(double delta) {
    gl.clearScreen(Colors.white);

    camera.update();

    renderer.projection = camera.combined;
    gl.context.disable(WebGL.DEPTH_TEST);
    gl.context.enable(WebGL.BLEND);
    gl.context.blendFunc(WebGL.SRC_ALPHA, WebGL.ONE_MINUS_SRC_ALPHA);
    renderer.begin();
    font.drawParagraph(renderer, (width - textWidth) ~/ 2, height, text, lineWidth: textWidth, align: TextAlign.right, scale: 1.0);
    renderer.end();
  }

  resize(int width, int height) {
    gl.setGLViewport(canvasWidth, canvasHeight);
    camera = Camera2D.originBottomLeft(width, height);
  }

  @override
  update(double delta) {}

  startTween() {
    if(textWidth == 640) {
      Tween()
        ..set = [(v) => textWidth = v.toInt()]
        ..get = [() => textWidth]
        ..target = [200]
        ..duration = 10
        ..ease = Ease.quartOut
        ..callback = startTween
        ..start(tweenManager);
    } else {
      Tween()
        ..set = [(v) => textWidth = v.toInt()]
        ..get = [() => textWidth]
        ..target = [640]
        ..duration = 10
        ..ease = Ease.quartOut
        ..callback = startTween
        ..start(tweenManager);
    }
  }

  @override
  config() {
    scaleMode = ScaleMode.resize;
  }
}
