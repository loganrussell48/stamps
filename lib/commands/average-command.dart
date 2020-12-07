import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:stamps/logic/average.dart';

class AverageCommand extends Command{

  AverageCommand(){
    argParser
      ..addOption(file, abbr: 'f', defaultsTo: 'times.csv', help: fileHelp)
      ..addOption(output, abbr: 'o', defaultsTo: 'stdout', help: outputHelp);
  }

  static final String _name = 'average';
  static final String _description = 'Calculates the average time (hour/minute) of the list of times in the provided comma-separated-values (csv) file';

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
      var average_degrees = average(dateTimes.map((e) => time2degrees(e)));
      var res = degrees2time(average_degrees);
      if('stdout' == output){
        print(res);
      }
      else{
        var outputFile = File(output);
        if(outputFile.existsSync()){
          print('The file $outputFile already exists. Do you want to overwrite it? y/n');
          var input = stdin.readLineSync(encoding: Encoding.getByName('utf-8'));
          if('y' == input.toLowerCase()){
            outputFile.writeAsStringSync('$res');
          }
          else {
            print('Cancelling File Output.');
            print('Average: $res');
          }
        }
        else {
          outputFile.writeAsStringSync('$res');
        }
        outputFile.writeAsStringSync('$res', mode: FileMode.write);
      }
    }
    return 0;
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