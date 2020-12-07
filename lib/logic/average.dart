import 'dart:math';

import 'package:TimeAverage/utils/extensions.dart';
import 'package:TimeAverage/models/implementations/complex-number.dart';

///degrees per hour on a 24hr clock
num dph = 360 / (24);

///degrees per minute on a 24hr clock
num dpm = dph / 60;

///degrees per second
num dps = dpm / 60;

///degrees per millisecond
num dpmilli = dps / 1000;

///converts a time to degrees on a 24hr clock
///00:00.000 will be 90, 06:00.000 will be 0 since it is 1/4th of a day
num time2degrees(DateTime time) {
  var h = time.hour;
  var m = time.minute;
  var s = time.second;
  var mi = time.millisecond;
  var t = -h * dph - m * dpm - s * dps - mi * dpmilli + 90;
  return t;
}

Duration degrees2time(num degrees) {
  degrees = degrees % 360;
  var hours = degrees ~/ dph % 24;
  degrees -= hours * dph;
  var mins = degrees ~/ dpm;
  degrees -= mins * dpm;
  var seconds = degrees ~/ dps;
  degrees -= seconds * dps;
  var millis = degrees ~/ dpmilli;
  degrees -= millis * dpmilli;
  var date = DateTime(2020, 12, 6).add(Duration(hours: 6)).subtract(Duration(
      hours: hours, minutes: mins, seconds: seconds, milliseconds: millis));
  return Duration(
      hours: date.hour,
      minutes: date.minute,
      seconds: date.second,
      milliseconds: date.millisecond);
}

num average(Iterable<num> degrees_list) {
  var sines = degrees_list.map((e) => sin(e.toRadians));
  var cosines = degrees_list.map((e) => cos(e.toRadians));
  var zipped = cosines.zip(sines).toList();
  var complexNumbers =
      zipped.map((e) => ComplexNumber(x: e[0], y: e[1])).toList();
  var N = ComplexNumber(x: complexNumbers.length);
  var sum = complexNumbers.fold(
          ComplexNumber(), (previousValue, element) => previousValue + element)
      as ComplexNumber;
  var average = sum / N;
  return average.argument.toDegrees;
}
