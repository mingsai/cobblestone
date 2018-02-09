part of cobblestone;

// A wrapper around the WebAudio context, will have extra features later
class AudioWrapper {

  // The actual WebAudio context
  WebAudio.AudioContext context;

  //TODO Keep track of currently playing sounds

  AudioWrapper() {
    this.context = new WebAudio.AudioContext();
  }

}