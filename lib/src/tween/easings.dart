part of cobblestone;

/**
 * A set of [Easing] functions for animation
 *
 * Based on [Robert Penner's Easing Functions](http://www.robertpenner.com/easing/)
 *
 */

typedef Easing = double Function(double, double, double, double);

double linear(time, start, change, duration) {
  return change * time / duration + start;
}

double quadIn(t, b, c, d) {
  return c * (t /= d) * t + b;
}

double quadOut(t, b, c, d) {
  return -c * (t /= d) * (t - 2) + b;
}

double quadInOut(t, b, c, d) {
  if ((t /= d / 2) < 1) return c / 2 * t * t + b;
  return -c / 2 * ((--t) * (t - 2) - 1) + b;
}

double cubicIn(t, b, c, d) {
  return c * (t /= d) * t * t + b;
}

double cubicOut(t, b, c, d) {
  return c * ((t = t / d - 1) * t * t + 1) + b;
}

double cubicInOut(t, b, c, d) {
  if ((t /= d / 2) < 1) return c / 2 * t * t * t + b;
  return c / 2 * ((t -= 2) * t * t + 2) + b;
}

double quartIn(t, b, c, d) {
  return c * (t /= d) * t * t * t + b;
}

double quartOut(t, b, c, d) {
  return -c * ((t = t / d - 1) * t * t * t - 1) + b;
}

double quartInOut(t, b, c, d) {
  if ((t /= d / 2) < 1) return c / 2 * t * t * t * t + b;
  return -c / 2 * ((t -= 2) * t * t * t - 2) + b;
}

double quintIn(t, b, c, d) {
  return c * (t /= d) * t * t * t * t + b;
}

double quintOut(t, b, c, d) {
  return c * ((t = t / d - 1) * t * t * t * t + 1) + b;
}

double quintInOut(t, b, c, d) {
  if ((t /= d / 2) < 1) return c / 2 * t * t * t * t * t + b;
  return c / 2 * ((t -= 2) * t * t * t * t + 2) + b;
}

double sineIn(t, b, c, d) {
  return -c * cos(t / d * (PI / 2)) + c + b;
}

double sineOut(t, b, c, d) {
  return c * sin(t / d * (PI / 2)) + b;
}

double sineInOut(t, b, c, d) {
  return -c / 2 * (cos(PI * t / d) - 1) + b;
}

double expoIn(t, b, c, d) {
  return (t == 0) ? b : c * pow(2, 10 * (t / d - 1)) + b;
}

double expoOut(t, b, c, d) {
  return (t == d) ? b + c : c * (-pow(2, -10 * t / d) + 1) + b;
}

double expoInOut(t, b, c, d) {
  if (t == 0) return b;
  if (t == d) return b + c;
  if ((t /= d / 2) < 1) return c / 2 * pow(2, 10 * (t - 1)) + b;
  return c / 2 * (-pow(2, -10 * --t) + 2) + b;
}

double circIn(t, b, c, d) {
  return -c * (sqrt(1 - (t /= d) * t) - 1) + b;
}

double circOut(t, b, c, d) {
  return c * sqrt(1 - (t = t / d - 1) * t) + b;
}

double circInOut(t, b, c, d) {
  if ((t /= d / 2) < 1) return -c / 2 * (sqrt(1 - t * t) - 1) + b;
  return c / 2 * (sqrt(1 - (t -= 2) * t) + 1) + b;
}

double elasticIn(t, b, c, d) {
  double s = 1.70158;
  double p = 0.0;
  double a = c;
  if (t == 0) return b;
  if ((t /= d) == 1) return b + c;
  if (p == 0) p = d * .3;
  if (a < c.abs()) {
    a = c;
    s = p / 4;
  } else
    s = p / (2 * PI) * asin(c / a);
  return -(a * pow(2, 10 * (t -= 1)) * sin((t * d - s) * (2 * PI) / p)) + b;
}

double elasticOut(t, b, c, d) {
  double s = 1.70158;
  double p = 0.0;
  double a = c;
  if (t == 0) return b;
  if ((t /= d) == 1) return b + c;
  if (p == 0) p = d * .3;
  if (a < c.abs()) {
    a = c;
    s = p / 4;
  } else
    s = p / (2 * PI) * asin(c / a);
  return a * pow(2, -10 * t) * sin((t * d - s) * (2 * PI) / p) + c + b;
}

double elasticInOut(t, b, c, d) {
  double s = 1.70158;
  double p = 0.0;
  double a = c;
  if (t == 0) return b;
  if ((t /= d / 2) == 2) return b + c;
  if (p == 0) p = d * (.3 * 1.5);
  if (a < c.abs()) {
    a = c;
    s = p / 4;
  } else
    s = p / (2 * PI) * asin(c / a);
  if (t < 1)
    return -.5 * (a * pow(2, 10 * (t -= 1)) * sin((t * d - s) * (2 * PI) / p)) +
        b;
  return a * pow(2, -10 * (t -= 1)) * sin((t * d - s) * (2 * PI) / p) * .5 +
      c +
      b;
}

double backIn(t, b, c, d) {
  double s = 1.70158;
  return c * (t /= d) * t * ((s + 1) * t - s) + b;
}

double backOut(t, b, c, d) {
  double s = 1.70158;
  return c * ((t = t / d - 1) * t * ((s + 1) * t + s) + 1) + b;
}

double backInOut(t, b, c, d) {
  double s = 1.70158;
  if ((t /= d / 2) < 1)
    return c / 2 * (t * t * (((s *= (1.525)) + 1) * t - s)) + b;
  return c / 2 * ((t -= 2) * t * (((s *= (1.525)) + 1) * t + s) + 2) + b;
}

double bounceIn(t, b, c, d) {
  return c - bounceOut(d - t, 0, c, d) + b;
}

double bounceOut(t, b, c, d) {
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

double bounceInOut(t, b, c, d) {
  if (t < d / 2) return bounceIn(t * 2, 0, c, d) * .5 + b;
  return bounceOut(t * 2 - d, 0, c, d) * .5 + c * .5 + b;
}

/*
 *
 * TERMS OF USE - EASING EQUATIONS
 *
 * Open source under the BSD License.
 *
 * Copyright © 2001 Robert Penner
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice, this list of
 * conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, this list
 * of conditions and the following disclaimer in the documentation and/or other materials
 * provided with the distribution.
 *
 * Neither the name of the author nor the names of contributors may be used to endorse
 * or promote products derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY
 * EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
 * COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 * EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 * GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
 * AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 */