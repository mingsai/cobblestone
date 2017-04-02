part of cobblestone;

WebAudio.AudioContext audioContext = new WebAudio.AudioContext();

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

class Sound {
  List<WebAudio.AudioBufferSourceNode> sources;

  WebAudio.AudioBuffer buffer;
  WebAudio.GainNode gainNode;

  double volume = 1.0;

  Sound(this.buffer) {
    gainNode = audioContext.createGain();
    sources = [];
  }

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

  stop() {
    for (WebAudio.AudioBufferSourceNode source in sources) {
      source.stop(0);
    }
    sources.clear();
  }

  loop() {
    play(true);
  }
}
