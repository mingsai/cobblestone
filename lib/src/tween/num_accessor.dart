part of cobblestone;

class NumberAccessor implements TweenAccessor<num>{

  static const value = 0;

  int getValues(num target, Tween tween, int tweenType, List<num> returnValues){
    if(tweenType == value) {
      returnValues[0] = target;
      return 1;
    }
    return 0;
  }

  void setValues(num target, Tween tween, int tweenType, List<num> newValues){
    if(tweenType == value){
      target = newValues[0];
    }
  }
}