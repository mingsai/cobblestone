part of cobblestone;

class Vector4Accessor implements TweenAccessor<Vector4>{

  static const X = 1, R = 1;
  static const Y = 2, G = 2;
  static const Z = 3, B = 3;
  static const W = 4, A = 4;
  static const XYZW = 5, RGBA = 5;

  int getValues(Vector4 target, Tween tween, int tweenType, List<num> returnValues){
    if(tweenType == X){
      returnValues[0] = target.x;
      return 1;
    } else if(tweenType == Y) {
      returnValues[0] = target.y;
      return 1;
    } else if(tweenType == Z) {
      returnValues[0] = target.z;
      return 1;
    } else if(tweenType == W) {
      returnValues[0] = target.w;
      return 1;
    } else if(tweenType == XYZW) {
      returnValues[0] = target.x;
      returnValues[1] = target.y;
      returnValues[2] = target.z;
      returnValues[3] = target.w;
      return 4;
    }
    return 0;
  }

  void setValues(Vector4 target, Tween tween, int tweenType, List<num> newValues){
    if(tweenType == X){
      target.x = newValues[0];
    } else if(tweenType == Y) {
      target.y = newValues[0];
    } else if(tweenType == Z) {
      target.z = newValues[0];
    } else if(tweenType == W) {
      target.w = newValues[0];
    } else if(tweenType == XYZW) {
      target.x = newValues[0];
      target.y = newValues[1];
      target.z = newValues[2];
      target.w = newValues[3];
    }
  }
}


