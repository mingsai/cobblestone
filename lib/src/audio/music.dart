part of cobblestone;

Future<Music> loadMusic(String url) async {
  AudioElement audio = new AudioElement(url);
  return new Music(audio);
}

class Music {

  AudioElement audio;

  double volume = 1.0;

  Music(this.audio) {

  }

  play([bool loop = false]) {
    audio.loop = loop;
    audio.volume = volume;
    audio.play();
  }

  stop() {
    audio.pause();
    audio.currentTime = 0;
  }

  loop() {
    play(true);
  }

}