part of cobblestone;

class Vector2Accessor implements TweenAccessor<Vector2>{

  static const X = 1;
  static const Y = 2;
  static const XY = 3;

  int getValues(Vector2 target, Tween tween, int tweenType, List<num> returnValues){
    if(tweenType == X){
      returnValues[0] = target.x;
      return 1;
    } else if(tweenType == Y) {
      returnValues[0] = target.y;
      return 1;
    } else if(tweenType == XY) {
      returnValues[0] = target.x;
      returnValues[1] = target.y;
      return 2;
    }
    return 0;
  }

  void setValues(Vector2 target, Tween tween, int tweenType, List<num> newValues){
    if(tweenType == X){
      target.x = newValues[0].toDouble();
    } else if(tweenType == Y) {
      target.y = newValues[0].toDouble();
    } else if(tweenType == XY) {
      target.x = newValues[0].toDouble();
      target.y = newValues[1].toDouble();
    }
  }
}


