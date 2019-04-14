part of examples;

class AudioExample extends BaseGame {
  Camera2D camera;
  Matrix4 pMatrix;

  SpriteBatch renderer;
  Texture nehe;

  bool get isLoaded => nehe != null;

  Music music;
  Sound beat;

  @override
  create() {
    camera = new Camera2D.originBottomLeft(width, height);

    gl.setGLViewport(canvasWidth, canvasHeight);

    music = assetManager.get("technogeek.wav");
    music.volume = 0.1;
    beat = assetManager.get("short wind sound.wav");
  }

  @override
  preload() {
    assetManager.load("technogeek.wav", loadMusic(audio, "audio/technogeek.wav"));
    assetManager.load("spaceship.wav", loadSound(audio, "audio/spaceship.wav"));
    assetManager.load(
        "short wind sound.wav", loadSound(audio, "audio/short wind sound.wav"));
  }

  @override
  render(num delta) {
    gl.clearScreen(0.0, 0.0, 0.0, 1.0);

    camera.update();
  }

  resize(num width, num height) {
    gl.setGLViewport(canvasWidth, canvasHeight);
  }

  @override
  update(num delta) {
    if (keyboard.keyJustPressed(KeyCode.ONE)) {
      beat.play();
    } else if (keyboard.keyJustPressed(KeyCode.TWO)) {
      music.loop();
    } else if (keyboard.keyJustReleased(KeyCode.ZERO)) {
      audio.stopAll();
    }
  }
}
