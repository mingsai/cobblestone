part of cobblestone;

typedef Easing = double Function(double, double, double, double);

/// A set of easing functions for use with [Tween].
///
/// Based on [Robert Penner's Easing Functions](http://www.robertpenner.com/easing/).
/// See [this chart](https://easings.net) for animations of each function.
class Ease {
  /// An easing function based on a linear equation.
  static double linearInOut(double t, double b, double c, double d) {
    return c * t / d + b;
  }

  /// An easing function based on a quadratic equation.
  ///
  /// Moves slowly at first and speeds up over time.
  static double quadIn(double t, double b, double c, double d) {
    return c * (t /= d) * t + b;
  }

  /// An easing function based on a quadratic equation.
  ///
  /// Moves quickly at first and slows down over time.
  static double quadOut(double t, double b, double c, double d) {
    return -c * (t /= d) * (t - 2) + b;
  }

  /// An easing function based on a quadratic equation.
  ///
  /// Moves slowly at the ends, and more quickly in the middle.
  static double quadInOut(double t, double b, double c, double d) {
    if ((t /= d / 2) < 1) return c / 2 * t * t + b;
    return -c / 2 * ((--t) * (t - 2) - 1) + b;
  }

  /// An easing function based on a cubic equation.
  ///
  /// Moves slowly at first and speeds up over time.
  static double cubicIn(double t, double b, double c, double d) {
    return c * (t /= d) * t * t + b;
  }

  /// An easing function based on a cubic equation.
  ///
  /// Moves quickly at first and slows down over time.
  static double cubicOut(double t, double b, double c, double d) {
    return c * ((t = t / d - 1) * t * t + 1) + b;
  }

  /// An easing function based on a cubic equation.
  ///
  /// Moves slowly at the ends, and more quickly in the middle.
  static double cubicInOut(double t, double b, double c, double d) {
    if ((t /= d / 2) < 1) return c / 2 * t * t * t + b;
    return c / 2 * ((t -= 2) * t * t + 2) + b;
  }

  /// An easing function based on a quartic equation.
  ///
  /// Moves slowly at first and speeds up over time.
  static double quartIn(double t, double b, double c, double d) {
    return c * (t /= d) * t * t * t + b;
  }

  /// An easing function based on a quartic equation.
  ///
  /// Moves quickly at first and slows down over time.
  static double quartOut(double t, double b, double c, double d) {
    return -c * ((t = t / d - 1) * t * t * t - 1) + b;
  }

  /// An easing function based on a quartic equation.
  ///
  /// Moves slowly at the ends, and more quickly in the middle.
  static double quartInOut(double t, double b, double c, double d) {
    if ((t /= d / 2) < 1) return c / 2 * t * t * t * t + b;
    return -c / 2 * ((t -= 2) * t * t * t - 2) + b;
  }

  /// An easing function based on a quintic equation.
  ///
  /// Moves slowly at first and speeds up over time.
  static double quintIn(double t, double b, double c, double d) {
    return c * (t /= d) * t * t * t * t + b;
  }

  /// An easing function based on a quintic equation.
  ///
  /// Moves quickly at first and slows down over time.
  static double quintOut(double t, double b, double c, double d) {
    return c * ((t = t / d - 1) * t * t * t * t + 1) + b;
  }

  /// An easing function based on a quintic equation.
  ///
  /// Moves slowly at the ends, and more quickly in the middle.
  static double quintInOut(double t, double b, double c, double d) {
    if ((t /= d / 2) < 1) return c / 2 * t * t * t * t * t + b;
    return c / 2 * ((t -= 2) * t * t * t * t + 2) + b;
  }

  /// An easing function based on a sinusoidal equation.
  ///
  /// Moves slowly at first and speeds up over time.
  static double sineIn(double t, double b, double c, double d) {
    return -c * cos(t / d * (pi / 2)) + c + b;
  }

  /// An easing function based on a sinusoidal equation.
  ///
  /// Moves quickly at first and slows down over time.
  static double sineOut(double t, double b, double c, double d) {
    return c * sin(t / d * (pi / 2)) + b;
  }

  /// An easing function based on a sinusoidal equation.
  ///
  /// Moves slowly at the ends, and more quickly in the middle.
  static double sineInOut(double t, double b, double c, double d) {
    return -c / 2 * (cos(pi * t / d) - 1) + b;
  }

  /// An easing function based on an exponential equation.
  ///
  /// Moves slowly at first and speeds up over time.
  static double expoIn(double t, double b, double c, double d) {
    return (t == 0) ? b : c * pow(2, 10 * (t / d - 1)) + b;
  }

  /// An easing function based on an exponential equation.
  ///
  /// Moves quickly at first and slows down over time.
  static double expoOut(double t, double b, double c, double d) {
    return (t == d) ? b + c : c * (-pow(2, -10 * t / d) + 1) + b;
  }

  /// An easing function based on an exponential equation.
  ///
  /// Moves slowly at the ends, and more quickly in the middle.
  static double expoInOut(double t, double b, double c, double d) {
    if (t == 0) return b;
    if (t == d) return b + c;
    if ((t /= d / 2) < 1) return c / 2 * pow(2, 10 * (t - 1)) + b;
    return c / 2 * (-pow(2, -10 * --t) + 2) + b;
  }

  /// An easing function based on the equation of a circle.
  ///
  /// Moves slowly at first and speeds up over time.
  static double circIn(double t, double b, double c, double d) {
    return -c * (sqrt(1 - (t /= d) * t) - 1) + b;
  }

  /// An easing function based on the equation of a circle.
  ///
  /// Moves quickly at first and slows down over time.
  static double circOut(double t, double b, double c, double d) {
    return c * sqrt(1 - (t = t / d - 1) * t) + b;
  }

  /// An easing function based on the equation of a circle.
  ///
  /// Moves slowly at the ends, and more quickly in the middle.
  static double circInOut(double t, double b, double c, double d) {
    if ((t /= d / 2) < 1) return -c / 2 * (sqrt(1 - t * t) - 1) + b;
    return c / 2 * (sqrt(1 - (t -= 2) * t) + 1) + b;
  }

  /// An easing function that wiggles around the start before launching to the target.
  static double elasticIn(double t, double b, double c, double d) {
    double s = 1.70158;
    double p = 0.0;
    double a = c;
    if (t == 0) return b;
    if ((t /= d) == 1) return b + c;
    if (p == 0) p = d * .3;
    if (a < c.abs()) {
      a = c;
      s = p / 4;
    } else {
      s = p / (2 * pi) * asin(c / a);
    }
    return -(a * pow(2, 10 * (t -= 1)) * sin((t * d - s) * (2 * pi) / p)) + b;
  }

  /// An easing function that wiggles around the target before stopping.
  static double elasticOut(double t, double b, double c, double d) {
    double s = 1.70158;
    double p = 0.0;
    double a = c;
    if (t == 0) return b;
    if ((t /= d) == 1) return b + c;
    if (p == 0) p = d * .3;
    if (a < c.abs()) {
      a = c;
      s = p / 4;
    } else {
      s = p / (2 * pi) * asin(c / a);
    }
    return a * pow(2, -10 * t) * sin((t * d - s) * (2 * pi) / p) + c + b;
  }

  /// An easing function that wiggles around both at the start and at the target.
  static double elasticInOut(double t, double b, double c, double d) {
    double s = 1.70158;
    double p = 0.0;
    double a = c;
    if (t == 0) return b;
    if ((t /= d / 2) == 2) return b + c;
    if (p == 0) p = d * (.3 * 1.5);
    if (a < c.abs()) {
      a = c;
      s = p / 4;
    } else {
      s = p / (2 * pi) * asin(c / a);
    }
    if (t < 1) {
      return -.5 *
              (a * pow(2, 10 * (t -= 1)) * sin((t * d - s) * (2 * pi) / p)) +
          b;
    }
    return a * pow(2, -10 * (t -= 1)) * sin((t * d - s) * (2 * pi) / p) * .5 +
        c +
        b;
  }

  /// An easing function that moves backwards slightly before going towards the target.
  static double backIn(double t, double b, double c, double d) {
    double s = 1.70158;
    return c * (t /= d) * t * ((s + 1) * t - s) + b;
  }

  /// An easing function that overshoots the target and then moves back.
  static double backOut(double t, double b, double c, double d) {
    double s = 1.70158;
    return c * ((t = t / d - 1) * t * ((s + 1) * t + s) + 1) + b;
  }

  /// An easing function that moves backwards slightly before going towards the target overshooting it and moving back.
  static double backInOut(double t, double b, double c, double d) {
    double s = 1.70158;
    if ((t /= d / 2) < 1) {
      return c / 2 * (t * t * (((s *= (1.525)) + 1) * t - s)) + b;
    }
    return c / 2 * ((t -= 2) * t * (((s *= (1.525)) + 1) * t + s) + 2) + b;
  }

  /// An easing function that bounces back several times before moving to the target.
  static double bounceIn(double t, double b, double c, double d) {
    return c - bounceOut(d - t, 0, c, d) + b;
  }

  /// An easing function that bounces back several times after moving to the target.
  static double bounceOut(double t, double b, double c, double d) {
    if ((t /= d) < (1 / 2.75)) {
      return c * (7.5625 * t * t) + b;
    } else if (t < (2 / 2.75)) {
      return c * (7.5625 * (t -= (1.5 / 2.75)) * t + .75) + b;
    } else if (t < (2.5 / 2.75)) {
      return c * (7.5625 * (t -= (2.25 / 2.75)) * t + .9375) + b;
    } else {
      return c * (7.5625 * (t -= (2.625 / 2.75)) * t + .984375) + b;
    }
  }

  /// An easing function that bounces back several times before and after reaching the target.
  static double bounceInOut(double t, double b, double c, double d) {
    if (t < d / 2) return bounceIn(t * 2, 0, c, d) * .5 + b;
    return bounceOut(t * 2 - d, 0, c, d) * .5 + c * .5 + b;
  }
}
