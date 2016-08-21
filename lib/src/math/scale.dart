part of cobblestone;

enum ScaleMode {
  static, fill, fit, resize
}

scaleCanvas(CanvasElement element, ScaleMode mode,
    int requestWidth, int requestHeight,
    int parentWidth, int parentHeight) {
  switch(mode) {
    case ScaleMode.static:
      break;
    case ScaleMode.fill:
      num scale = max(parentWidth / requestWidth, parentHeight / requestHeight);
      element.width = requestWidth * scale;
      element.height = requestHeight * scale;
      break;
    case ScaleMode.fit:
      num scale = min(parentWidth / requestWidth, parentHeight / requestHeight);
      element.width = requestWidth * scale;
      element.height = requestHeight * scale;
      break;
    case ScaleMode.resize:
      element.width = window.innerWidth;
      element.height = window.innerHeight;
      break;
  }
}

int effectiveDimension(ScaleMode mode, int requested, int canvas) {
  switch(mode) {
    case ScaleMode.resize:
      return canvas;
    default:
      return requested;
  }
}