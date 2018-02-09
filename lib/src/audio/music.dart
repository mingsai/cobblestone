part of cobblestone;

/// Loads a sound using an [AudioElement]
Future<Music> loadMusic(AudioWrapper audio, String url) async {
  AudioElement element = new AudioElement(url);
  return new Music(audio, element);
}

/// A longer sound, streamed from an [AudioElement]
class Music {
  AudioWrapper audio;

  AudioElement element;

  /// The volume of this music, from 0 to 1
  double volume = 1.0;

  /// Creates a new sound from an element
  Music(this.audio, this.element) {}

  /// Plays this music. If [loop] is true, repeats indefinitely
  play([bool loop = false]) {
    element.loop = loop;
    element.volume = volume;
    element.play();
  }

  /// Stops this sound
  stop() {
    element.pause();
    element.currentTime = 0;
  }

  /// Loops this sound indefinitely
  loop() {
    play(true);
  }
}
