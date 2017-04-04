part of cobblestone;

abstract class State {

  preload();

  create();

  pause();

  resume();

  update(num delta);

  render(num delta);

  resize(num width, num height);

  end();

}
