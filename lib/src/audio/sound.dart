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

  AudioBuffer buffer;
  AudioBufferSourceNode source;
  GainNode gainNode;

  Sound(this.buffer) {
    source = audioContext.createBufferSource();
    gainNode = audioContext.createGain();
    source.connectNode(gainNode, 0, 0);
    gainNode.connectNode(audioContext.destination, 0, 0);
    source.buffer = buffer;
  }

  play() {
    source.start();
  }

  stop() {
    source.loop = false;
    source.stop();
  }

  loop() {
    source.loop = true;
    play();
  }

}