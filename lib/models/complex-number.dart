import 'dart:math';

class ComplexNumber {
  num x;
  num y;

  ComplexNumber({this.x = 0, this.y = 0});

  ComplexNumber operator +(ComplexNumber z) {
    return ComplexNumber(x: this.x + z.x, y: this.y + z.y);
  }

  ComplexNumber operator -(ComplexNumber z) {
    return ComplexNumber(x: this.x - z.x, y: this.y - z.y);
  }

  ComplexNumber operator *(ComplexNumber z) {
    return ComplexNumber(
        x: this.x * z.x - this.y * z.y, y: this.x * z.y + this.y * z.x);
  }

  ComplexNumber inv() {
    final sup = modulus * modulus;
    return ComplexNumber(x: x / sup, y: -y / sup);
  }

  ComplexNumber operator /(ComplexNumber z) {
    return this * (z.inv());
  }

  double get modulus {
    return sqrt(x * x + y * y);
  }

  double get argument {
    var base = atan(y / x);
    var additive = x < 0.000001 ? pi : 0;
    return base + additive;
  }

  @override
  String toString() {
    var result = '';
    if (x != 0) result += x.toString();
    if (y != 0) {
      if (y > 0 && x != 0) result += '+';
      result += y.toString() + 'i';
    }
    if (result == '') result += '0';
    return result;
  }
}
