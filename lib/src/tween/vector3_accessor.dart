part of cobblestone;

class Vector3Accessor implements TweenAccessor<Vector3>{

  static const X = 1;
  static const Y = 2;
  static const Z = 3;
  static const XYZ = 4;

  int getValues(Vector3 target, Tween tween, int tweenType, List<num> returnValues){
    if(tweenType == X){
      returnValues[0] = target.x;
      return 1;
    } else if(tweenType == Y) {
      returnValues[0] = target.y;
      return 1;
    } else if(tweenType == Z) {
      returnValues[0] = target.z;
      return 1;
    } else if(tweenType == XYZ) {
      returnValues[0] = target.x;
      returnValues[1] = target.y;
      returnValues[2] = target.z;
      return 3;
    }
    return 0;
  }

  void setValues(Vector3 target, Tween tween, int tweenType, List<num> newValues){
    if(tweenType == X){
      target.x = newValues[0];
    } else if(tweenType == Y) {
      target.y = newValues[0];
    } else if(tweenType == Z) {
      target.z = newValues[0];
    } else if(tweenType == XYZ) {
      target.x = newValues[0];
      target.y = newValues[1];
      target.z = newValues[2];
    }
  }
}


