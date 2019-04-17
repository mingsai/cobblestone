part of cobblestone;

/// Loads a sound from a url
Future<Sound> loadSound(audio, String url) async {
  var request = await HttpRequest.request(url, responseType: 'arraybuffer');
  var buffer = await audio.context.decodeAudioData(request.response);
  return new Sound(audio, buffer);
}

/// A playable sound using WebAudio
class Sound extends AudioPlayer {
  AudioWrapper audio;
  WebAudio.AudioContext context;

  var buffer;

  var _sources;
  int _nextID = 0;

  WebAudio.GainNode _gainNode;

  bool _playing = false;

  double _volume = 1.0;

  /// Creates a new sound form an audio buffer
  Sound(this.audio, this.buffer) {
    this.context = audio.context;
    _gainNode = context.createGain();
    _sources = {};
  }

  _createSourceNode(bool loop) {
    WebAudio.AudioBufferSourceNode source = context.createBufferSource();
    source.buffer = buffer;
    source.loop = loop;
    source.start(0);
    return source;
  }

  /// Plays this sound. If [loop] is set, repeats indefinitely
  play({bool loop = false, Function onEnd}) {
    final int id = _nextID;

    var source = _createSourceNode(loop);

    _gainNode.gain.value = volume;
    source.connectNode(_gainNode, 0, 0);
    _gainNode.connectNode(context.destination, 0, 0);

    source.onEnded.listen((Event e) {
      onEnd?.call();
      _removeInstance(id);
    });

    _sources[id] = source;

    _nextID++;
    playing = true;
  }

  /// Play sound only if not already playing
  playIfNot({bool loop = false, Function onEnd}) {
    if (!playing) {
      play(loop: loop, onEnd: onEnd);
    }
  }

  /// Stops all instances of this sound
  stop() {
    for (var source in _sources.values) {
      source.stop(0);
    }
    _sources.clear();
    playing = false;
  }

  _removeInstance(var id) {
    // Remove node when it finishes playing
    if (_sources[id] != null) {
      _sources[id].stop(0);
      _sources.remove(id);
    }
    playing = _sources.length != 0;
  }

  bool get playing => _playing;

  void set playing(bool playing) {
    _playing = playing;
    if (playing) {
      audio.addPlaying(this);
    } else {
      audio.removePlaying(this);
    }
  }

  double get volume => _volume;

  void set volume(double volume) {
    _volume = volume;
    if (_volume < 0) {
      _volume = 0;
    } else if (_volume > 1) {
      _volume = 1;
    }
    _gainNode.gain.value = _volume;
  }
}
