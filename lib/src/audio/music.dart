part of cobblestone;

/// Loads a sound using an [AudioElement]
Future<Music> loadMusic(AudioWrapper audio, String url) async {
  AudioElement element = new AudioElement(url);
  return new Music(audio, element);
}

/// A longer sound, streamed from an [AudioElement]
class Music extends AudioPlayer {
  AudioWrapper audio;
  WebAudio.AudioContext context;

  MediaElement element;

  double get time => element.currentTime;
  double get duration => element.duration;

  bool _playing = false;
  double _volume = 1.0;

  Music(this.audio, this.element) {
    this.context = audio.context;
  }

  /// Plays this music. If [loop] is true, repeats indefinitely
  play({bool loop = false, Function onEnd}) {
    element.loop = loop;
    element.volume = volume;
    element.onEnded.first.then((e) {
      onEnd?.call();
    });
    element.play();
    playing = true;
  }

  /// Stops this sound
  stop() {
    element.pause();
    element.currentTime = 0;
  }

  /// Loops this sound indefinitely
  loop() {
    play(loop: true);
  }

  bool get playing => _playing;

  set playing(bool playing) {
    _playing = playing;
    if (playing) {
      audio.addPlaying(this);
    } else {
      audio.removePlaying(this);
    }
  }

  double get volume => _volume;

  set volume(double volume) {
    _volume = volume;
    if (_volume < 0) {
      _volume = 0;
    } else if (_volume > 1) {
      _volume = 1;
    }
    element.volume = _volume;
  }
}
