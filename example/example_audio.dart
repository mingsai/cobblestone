import 'package:cobblestone/cobblestone.dart';

main() {
  new AudioExample();
}

class AudioExample extends BaseGame {

  Camera2D camera;
  Matrix4 pMatrix;

  SpriteBatch renderer;
  GameTexture nehe;

  bool get isLoaded => nehe != null;

  num x = 0;
  num mod = 5;

  num rot = 0.5;

  @override
  create() {
    camera = new Camera2D.originBottomLeft(width, height);

    setGLViewport(canvasWidth, canvasHeight);

    Sound sound = assetManager.get("technogeek.wav");
    //sound.play();

    Sound sound2 = assetManager.get("spaceship.wav");
    sound2.loop();
  }

  @override
  preload() {
    assetManager.load("technogeek.wav", loadGameSound("technogeek.wav"));
    assetManager.load("spaceship.wav", loadGameSound("spaceship.wav"));
  }

  @override
  render(num delta) {
    clearScreen(0.0, 0.0, 0.0, 1.0);

    camera.update();

  }

  resize(num width, num height) {
    setGLViewport(canvasWidth, canvasHeight);
  }

  @override
  update(num delta) {
    x += mod * delta;
    if(x >= width) {
      mod = -mod;
    }
    if(x <= -200) {
      mod = -mod;
    }

    rot += 0.5 * delta;
  }
}