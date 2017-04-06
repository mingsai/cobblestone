part of cobblestone;

WebAudio.AudioContext audioContext = new WebAudio.AudioContext();

/// Loads a sound from a url
Future<Sound> loadSound(String url) {
  return HttpRequest
      .request(url, responseType: 'arraybuffer')
      .then((HttpRequest request) {
    return audioContext
        .decodeAudioData(request.response)
        .then((WebAudio.AudioBuffer buffer) {
      return new Sound(buffer);
    });
  });
}

/// A playable sound using WebAudio
class Sound {
  List<WebAudio.AudioBufferSourceNode> sources;

  WebAudio.AudioBuffer buffer;
  WebAudio.GainNode gainNode;

  /// The volume of the sound, from 0 to 1
  double volume = 1.0;

  /// Creates a new sound form an audio buffer
  Sound(this.buffer) {
    gainNode = audioContext.createGain();
    sources = [];
  }

  /// Plays this sound. If [loop] is set, repeats indefinitely
  play([bool loop = false]) {
    gainNode.gain.value = volume;
    WebAudio.AudioBufferSourceNode source = audioContext.createBufferSource();
    source.connectNode(gainNode, 0, 0);
    gainNode.connectNode(audioContext.destination, 0, 0);
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
