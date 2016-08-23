part of cobblestone;

Future<Sound> loadSound;

AudioContext audioContext = new AudioContext();

Future<Sound> loadGameSound(String url) {
  return HttpRequest.request(url, responseType: 'arraybuffer').then((HttpRequest request) {
    return audioContext.decodeAudioData(request.response).then((AudioBuffer buffer) {
      return new Sound(buffer);
    });
  });
}


class Sound {

  List<AudioBufferSourceNode> sources;

  AudioBuffer buffer;
  GainNode gainNode;

  Sound(this.buffer) {
    gainNode = audioContext.createGain();
    sources = [];
  }

  play([bool loop = false]) {
    AudioBufferSourceNode source = audioContext.createBufferSource();
    source.connectNode(gainNode, 0, 0);
    gainNode.connectNode(audioContext.destination, 0, 0);
    source.buffer = buffer;
    source.loop = loop;
    source.start(0);
    sources.add(source);
  }

  stop() {
    for(AudioBufferSourceNode source in sources) {
      source.stop();
    }
    sources.clear();
  }

  loop() {
    play(true);
  }

}