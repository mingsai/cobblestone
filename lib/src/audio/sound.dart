part of cobblestone;

/// Loads a sound from a url
Future<Sound> loadSound(audio, String url) {
  return HttpRequest
      .request(url, responseType: 'arraybuffer')
      .then((HttpRequest request) {
    return audio.context
        .decodeAudioData(request.response)
        .then((WebAudio.AudioBuffer buffer) {
      return new Sound(audio, buffer);
    });
  });
}

/// A playable sound using WebAudio
class Sound {
  AudioWrapper audio;
  WebAudio.AudioContext context;

  List<WebAudio.AudioBufferSourceNode> sources;

  WebAudio.AudioBuffer buffer;
  WebAudio.GainNode gainNode;

  /// The volume of the sound, from 0 to 1
  double volume = 1.0;

  /// Creates a new sound form an audio buffer
  Sound(this.audio, this.buffer) {
    this.context = audio.context;
    gainNode = context.createGain();
    sources = [];
  }

  /// Plays this sound. If [loop] is set, repeats indefinitely
  play([bool loop = false]) {
    gainNode.gain.value = volume;
    WebAudio.AudioBufferSourceNode source = context.createBufferSource();
    source.connectNode(gainNode, 0, 0);
    gainNode.connectNode(context.destination, 0, 0);
    source.buffer = buffer;
    source.loop = loop;
    source.start(0);
    sources.add(source);
  }

  /// Stops all instances of this sound
  stop() {
    for (WebAudio.AudioBufferSourceNode source in sources) {
      source.stop(0);
    }
    sources.clear();
  }

  /// Loops this sound indefinitely
  loop() {
    play(true);
  }
}
