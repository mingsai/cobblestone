part of cobblestone;

/// A wrapper around the WebAudio context, will have extra features later
class AudioWrapper {

  /// The actual WebAudio context
  WebAudio.AudioContext context;

  var sounds = [];

  AudioWrapper() {
    this.context = new WebAudio.AudioContext();
  }

  addPlaying(AudioPlayer sound) {
    if(!sounds.contains(sound)) {
      sounds.add(sound);
    }
  }

  removePlaying(AudioPlayer sound) {
    sounds.remove(sound);
  }

  /// Stops all currently playing sounds
  stopAll() {
    var oldSounds = new List.from(sounds);
    for(var sound in oldSounds) {
      sound.stop();
    }
  }

}

/// Generic audio element, implemented by [Sound] or [Music]
abstract class AudioPlayer {

  /// True if the sound is playing, false if not
  bool get playing;

  /// The volume of the audio, from 0 to 1
  double get volume;

  /// Plays the audio. Loops if [loop] is true
  void play({bool loop = false, Function onEnd});

  /// Loops this sound indefinitely
  loop() {
    play(loop: true);
  }

  /// Stops the audio immediately
  void stop();

}