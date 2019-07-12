part of cobblestone;

/**
 * A set of [Easing] functions for animation
 *
 * Based on [Robert Penner's Easing Functions](http://www.robertpenner.com/easing/)
 *
 */

typedef Easing = double Function(double, double, double, double);

double linearInOut(double time, double start, double change, double duration) {
  return change * time / duration + start;
}

double quadIn(double t, double b, double c, double d) {
  return c * (t /= d) * t + b;
}

double quadOut(double t, double b, double c, double d) {
  return -c * (t /= d) * (t - 2) + b;
}

double quadInOut(double t, double b, double c, double d) {
  if ((t /= d / 2) < 1) return c / 2 * t * t + b;
  return -c / 2 * ((--t) * (t - 2) - 1) + b;
}

double cubicIn(double t, double b, double c, double d) {
  return c * (t /= d) * t * t + b;
}

double cubicOut(double t, double b, double c, double d) {
  return c * ((t = t / d - 1) * t * t + 1) + b;
}

double cubicInOut(double t, double b, double c, double d) {
  if ((t /= d / 2) < 1) return c / 2 * t * t * t + b;
  return c / 2 * ((t -= 2) * t * t + 2) + b;
}

double quartIn(double t, double b, double c, double d) {
  return c * (t /= d) * t * t * t + b;
}

double quartOut(double t, double b, double c, double d) {
  return -c * ((t = t / d - 1) * t * t * t - 1) + b;
}

double quartInOut(double t, double b, double c, double d) {
  if ((t /= d / 2) < 1) return c / 2 * t * t * t * t + b;
  return -c / 2 * ((t -= 2) * t * t * t - 2) + b;
}

double quintIn(double t, double b, double c, double d) {
  return c * (t /= d) * t * t * t * t + b;
}

double quintOut(double t, double b, double c, double d) {
  return c * ((t = t / d - 1) * t * t * t * t + 1) + b;
}

double quintInOut(double t, double b, double c, double d) {
  if ((t /= d / 2) < 1) return c / 2 * t * t * t * t * t + b;
  return c / 2 * ((t -= 2) * t * t * t * t + 2) + b;
}

double sineIn(double t, double b, double c, double d) {
  return -c * cos(t / d * (pi / 2)) + c + b;
}

double sineOut(double t, double b, double c, double d) {
  return c * sin(t / d * (pi / 2)) + b;
}

double sineInOut(double t, double b, double c, double d) {
  return -c / 2 * (cos(pi * t / d) - 1) + b;
}

double expoIn(double t, double b, double c, double d) {
  return (t == 0) ? b : c * pow(2, 10 * (t / d - 1)) + b;
}

double expoOut(double t, double b, double c, double d) {
  return (t == d) ? b + c : c * (-pow(2, -10 * t / d) + 1) + b;
}

double expoInOut(double t, double b, double c, double d) {
  if (t == 0) return b;
  if (t == d) return b + c;
  if ((t /= d / 2) < 1) return c / 2 * pow(2, 10 * (t - 1)) + b;
  return c / 2 * (-pow(2, -10 * --t) + 2) + b;
}

double circIn(double t, double b, double c, double d) {
  return -c * (sqrt(1 - (t /= d) * t) - 1) + b;
}

double circOut(double t, double b, double c, double d) {
  return c * sqrt(1 - (t = t / d - 1) * t) + b;
}

double circInOut(double t, double b, double c, double d) {
  if ((t /= d / 2) < 1) return -c / 2 * (sqrt(1 - t * t) - 1) + b;
  return c / 2 * (sqrt(1 - (t -= 2) * t) + 1) + b;
}

double elasticIn(double t, double b, double c, double d) {
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

double elasticOut(double t, double b, double c, double d) {
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

double elasticInOut(double t, double b, double c, double d) {
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
    return -.5 * (a * pow(2, 10 * (t -= 1)) * sin((t * d - s) * (2 * pi) / p)) +
        b;
  }
  return a * pow(2, -10 * (t -= 1)) * sin((t * d - s) * (2 * pi) / p) * .5 + c + b;
}

double backIn(double t, double b, double c, double d) {
  double s = 1.70158;
  return c * (t /= d) * t * ((s + 1) * t - s) + b;
}

double backOut(double t, double b, double c, double d) {
  double s = 1.70158;
  return c * ((t = t / d - 1) * t * ((s + 1) * t + s) + 1) + b;
}

double backInOut(double t, double b, double c, double d) {
  double s = 1.70158;
  if ((t /= d / 2) < 1) {
    return c / 2 * (t * t * (((s *= (1.525)) + 1) * t - s)) + b;
  }
  return c / 2 * ((t -= 2) * t * (((s *= (1.525)) + 1) * t + s) + 2) + b;
}

double bounceIn(double t, double b, double c, double d) {
  return c - bounceOut(d - t, 0, c, d) + b;
}

double bounceOut(double t, double b, double c, double d) {
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

double bounceInOut(double t, double b, double c, double d) {
  if (t < d / 2) return bounceIn(t * 2, 0, c, d) * .5 + b;
  return bounceOut(t * 2 - d, 0, c, d) * .5 + c * .5 + b;
}