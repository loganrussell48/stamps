import 'package:stamps/logic/average.dart';
import 'package:stamps/logic/generate.dart';
import 'package:test/test.dart';
import 'package:stamps/utils/extensions.dart';
void main() {
  group('convert', (){
    test('DateTime to Duration', (){
      var dt = DateTime(2020, 12, 8, 10, 44, 20, 0, 0);
      var dur = dt.toDuration();
      var durs = dur.toString();
      expect(durs.substring(0, durs.length - 3), dt.toString().split(' ')[1]);
    });
  });
  group('generate', (){
    test('between 07:00 & 23:30', (){
      DateTime start = DateTime (2020, 12, 8, 7);
      DateTime end = DateTime(2020, 12, 8, 23, 30);
      var results = generateTimeStamp(start, end, 10000);
      var before0700 = results.where((dt) => dt.hour < 7);
      var after2330 = results.where((dt) => dt.hour == 23 && dt.minute > 30);
      expect(before0700.length, 0);
      expect(after2330.length, 0);
    });
  });
  group('time2degrees', (){
    test('works for 5am', () {
      var five = DateTime(2020, 12, 6, 5);
      var five2degrees = time2degrees(five);
      expect(five2degrees, 15);
    });
    test('works for 6am', () {
      var six = DateTime(2020, 12, 6, 6);
      var six2degrees = time2degrees(six);
      expect(six2degrees, 0);
    });
    test('works for 7am', () {
      var seven = DateTime(2020, 12, 6, 7);
      var seven2degrees = time2degrees(seven);
      expect(seven2degrees, -15);
    });
    test('works for 7:01am', () {
      var seven = DateTime(2020, 12, 6, 7, 1);
      var seven2degrees = time2degrees(seven);
      expect(seven2degrees, -15.25);
    });
    test('works for 00:01am', () {
      var onemin = DateTime(2020, 12, 6, 0, 1);
      var onemin2degrees = time2degrees(onemin);
      expect(onemin2degrees, 89.75);
    });
    test('works for midnight', () {
      var midnight = DateTime(2020, 12, 6);
      var midnight2degrees = time2degrees(midnight);
      expect(midnight2degrees, 90);
    });
    test('works for 11pm', () {
      var elevenP = DateTime(2020, 12, 6, 23);
      var elevenP2degrees = time2degrees(elevenP);
      expect(elevenP2degrees, -255);
    });
  });
  group('degrees2Time', (){
    test('works for 5am', () {
      var time = DateTime(2020, 12, 6, 5);
      var degrees = 15;
      var degrees2timestamp = degrees2time(degrees);
      expect(degrees2timestamp.hour, time.hour);
      expect(degrees2timestamp.minute, time.minute);
      expect(degrees2timestamp.second, time.second);
      expect(degrees2timestamp.millisecond, time.millisecond);
    });
    test('works for 6am', () {
      var time = DateTime(2020, 12, 6, 6);
      var degrees = 0;
      var degrees2timestamp = degrees2time(degrees);
      expect(degrees2timestamp.hour, time.hour);
      expect(degrees2timestamp.minute, time.minute);
      expect(degrees2timestamp.second, time.second);
      expect(degrees2timestamp.millisecond, time.millisecond);
    });
    test('works for 7am', () {
      var time = DateTime(2020, 12, 6, 7);
      var degrees = -15;
      var degrees2timestamp = degrees2time(degrees);
      expect(degrees2timestamp.inHours, time.hour);
      expect(degrees2timestamp.minute, time.minute);
      expect(degrees2timestamp.second, time.second);
      expect(degrees2timestamp.millisecond, time.millisecond);
    });
    test('works for 7:01am', () {
      var time = DateTime(2020, 12, 6, 7, 1);
      var degrees = -15.25;
      var degrees2timestamp = degrees2time(degrees);
      expect(degrees2timestamp.hour, time.hour);
      expect(degrees2timestamp.minute, time.minute);
      expect(degrees2timestamp.second, time.second);
      expect(degrees2timestamp.millisecond, time.millisecond);
    });
    test('works for 00:01am', () {
      var time = DateTime(2020, 12, 6, 0, 1);
      var degrees = 89.75;
      var degrees2timestamp = degrees2time(degrees);
      expect(degrees2timestamp.hour, time.hour);
      expect(degrees2timestamp.minute, time.minute);
      expect(degrees2timestamp.second, time.second);
      expect(degrees2timestamp.millisecond, time.millisecond);
    });
    test('works for midnight', () {
      var time = DateTime(2020, 12, 6, 0, 0);
      var degrees = 90;
      var degrees2timestamp = degrees2time(degrees);
      expect(degrees2timestamp.hour, time.hour);
      expect(degrees2timestamp.minute, time.minute);
      expect(degrees2timestamp.second, time.second);
      expect(degrees2timestamp.millisecond, time.millisecond);
    });
    test('works for 11pm', () {
      var time = DateTime(2020, 12, 6, 23);
      var degrees = -255;
      var degrees2timestamp = degrees2time(degrees);
      expect(degrees2timestamp.hour, time.hour);
      expect(degrees2timestamp.minute, time.minute);
      expect(degrees2timestamp.second, time.second);
      expect(degrees2timestamp.millisecond, time.millisecond);
    });
  });
}