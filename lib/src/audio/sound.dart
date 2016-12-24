part of cobblestone;

Future<Sound> loadSound;

WebAudio.AudioContext audioContext = new WebAudio.AudioContext();

Future<Sound> loadGameSound(String url) {
  return HttpRequest.request(url, responseType: 'arraybuffer').then((HttpRequest request) {
    return audioContext.decodeAudioData(request.response).then((WebAudio.AudioBuffer buffer) {
      return new Sound(buffer);
    });
  });
}


class Sound {

  List<WebAudio.AudioBufferSourceNode> sources;

  WebAudio.AudioBuffer buffer;
  WebAudio.GainNode gainNode;

  Sound(this.buffer) {
    gainNode = audioContext.createGain();
    sources = [];
  }

  play([bool loop = false]) {
    WebAudio.AudioBufferSourceNode source = audioContext.createBufferSource();
    source.connectNode(gainNode, 0, 0);
    gainNode.connectNode(audioContext.destination, 0, 0);
    source.buffer = buffer;
    source.loop = loop;
    source.start(0);
    sources.add(source);
  }

  stop() {
    for(WebAudio.AudioBufferSourceNode source in sources) {
      source.stop(0);
    }
    sources.clear();
  }

  loop() {
    play(true);
  }

}