import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';

class AverageCommand extends Command{

  AverageCommand(){
    argParser
      ..addOption(file, abbr: 'f', defaultsTo: 'times.csv', help: fileHelp)
      ..addOption(output, abbr: 'o', defaultsTo: 'stdout', help: outputHelp);
  }

  static final String _name = 'average';
  static final String _description =
  '''
  Calculates the average time (hour/minute) of the list of times in the provided
  comma-separated-values (csv) file
  ''';

  static const file = 'file';
  static const fileHelp =
  '''
    The csv file containing Timestamps.
    default value is times.csv
  ''';

  static const output = 'output';
  static const outputHelp =
  '''
    output flag -output OR -o
    default value is stdout instead of a file
    Acceptable Values:
      stdout - will cause program to print output to stdout
      filename - any acceptable file name
  ''';


  @override
  String get description => _description;

  @override
  String get name => _name;

  @override
  FutureOr<int> run() {
    var filename = argResults[AverageCommand.file];
    var output = argResults[AverageCommand.output];
    var f = File(filename);
    if(!f.existsSync()){
      print('The provided file does not exist');
      exit(69);
    }
    else{
      print('Reading file...');
      var content = f.readAsStringSync();
      print('Parsing results...');
      var split = content.split(',');
      var dateTimes = split.map((e) => DateTime.parse(e));
      var values = dateTimes.map((DateTime e) => Runtime(e.hour, e.minute, e.second, e.millisecond).value);
      var average = values.stats.average.toTime();
      if('stdout' == output){
        print(average);
      }
      else{
        var outputFile = File(output);
        if(outputFile.existsSync()){
          print('The file $outputFile already exists. Do you want to overwrite it? y/n');
          var input = stdin.readLineSync(encoding: Encoding.getByName('utf-8'));
          if('y' == input.toLowerCase()){
            outputFile.writeAsStringSync('$average');
          }
          else {
            print('Cancelling File Output.');
            print('Average: $average');
          }
        }
        else {
          outputFile.writeAsStringSync('$average');
        }

        outputFile.writeAsStringSync('$average', mode: FileMode.write);
      }
    }

  }
}

class Runtime {
  int hour;
  int minute;
  int seconds;
  int millis;
  Runtime(hour, this.minute, this.seconds, this.millis) : this.hour = hour == 0 ? 24 : hour;
  num get value => hour + minute/60 + seconds/60/60 + millis/60/60/1000;
}
class NumSummaryStatistics {
  num _min = ~(1 << 63);
  num _max = 1 << 63;
  num _range = (1 << 63) - (~(1 << 63));
  int _count = 0;
  num _sum = 0;
  num _avg = 0;
  NumSummaryStatistics(Iterable<num> iterable) {
    if (iterable.isEmpty) return;
    var it = iterable.iterator;
    while (it.moveNext()) {
      _count++;
      if (it.current < _min) _min = it.current;
      if (it.current > _max) _max = it.current;
      _sum += it.current;
    }
    _range = _max - _min;
    _avg = _sum / count;
  }

  num get min => _min;

  num get max => _max;

  num get range => _range;

  int get count => _count;

  num get average => _avg;

  num get sum => _sum;

  @override
  String toString() {
    return 'IntSummaryStatistics{min: $min, max: $max, range: $range, count: $count, average: $average, sum: $sum}';
  }
}
extension BIterableNum on Iterable<num> {
  static final String _rangeInputSizeErrorMessage =
  '''The iterable upon which the "range" getter was invoked has invalid size.
       Make sure there are only 2 num elements in the iterable.''';

  ///Returns the sum of the elements as a BigInt to avoid overflow
  BigInt get sum => fold(BigInt.zero, (l, r) => l + BigInt.from(r));

  ///Returns the product of the elements as a BigInt to avoid overflow
  BigInt get product => fold(BigInt.one, (l, r) => l * BigInt.from(r));

  ///Returns the summary stats for this iterable. Stats include,
  ///sum, product, max, min, count, and range
  NumSummaryStatistics get stats => NumSummaryStatistics(this);

  ///returns an iterable containing all the ints in the given range, inclusive
  ///
  /// Notice that the input is `num` not `int`.
  Iterable<int> get range {
    if (length != 2) throw ArgumentError(_rangeInputSizeErrorMessage);
    var it = iterator;
    var start = (it..moveNext()).current;
    var end = (it..moveNext()).current;
    return [for (int i = start.ceil(); i <= end; i++) i];
  }
}
extension NumToTime on num {
  Duration toTime(){
    var value = this.abs();
    var hours = value.toInt(); value -= hours;
    var minutes = (value*=60).toInt(); value -= minutes;
    var seconds = (value *= 60).toInt(); value -= seconds;
    var millis = (value *= 1000).toInt(); value -= millis;
    var micros = (value *= 1000000).toInt(); value -= micros;
    var d = Duration(
        hours: hours%24,
        minutes: minutes,
        seconds: seconds,
        milliseconds: millis,
        microseconds: micros
    );
    return d;
  }
}