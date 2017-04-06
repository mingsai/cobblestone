part of cobblestone;

/// Loads a sound using an [AudioElement]
Future<Music> loadMusic(String url) async {
  AudioElement audio = new AudioElement(url);
  return new Music(audio);
}

/// A longer sound, streamed from an [AudioElement]
class Music {
  AudioElement audio;

  /// The volume of this music, from 0 to 1
  double volume = 1.0;

  /// Creates a new sound from an element
  Music(this.audio) {}

  /// Plays this music. If [loop] is true, repeats indefinitely
  play([bool loop = false]) {
    audio.loop = loop;
    audio.volume = volume;
    audio.play();
  }

  /// Stops this sound
  stop() {
    audio.pause();
    audio.currentTime = 0;
  }

  /// Loops this sound indefinitely
  loop() {
    play(true);
  }
}
