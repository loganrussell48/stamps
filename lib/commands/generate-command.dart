import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:args/command_runner.dart';

class GenerateCommand extends Command{

  GenerateCommand(){
    argParser
      ..addOption(quantity, abbr: 'q', defaultsTo: '10000', help: quantityHelp)
      ..addOption(output, abbr: 'o', defaultsTo: 'times.csv', help: outputHelp)
      ..addOption(start, abbr: 's', defaultsTo: '2010-12-31 23:50:00.000', help: startHelp)
      ..addOption(end, abbr: 'e', defaultsTo: '2010-12-31 00:10:00.000')
    ;
  }

  static final String _name = 'generate';
  static final String _description = '';

  static const quantity = 'quantity';
  var quantityDefault = '10000';
  static const quantityHelp =
  '''
    The number of timestamps to generate.
    default value is 10000
    for loop starts at 0, so negative values will result in 0 timestamps being
    generated
    ''';

  static const output = 'output';
  var outputDefault = 'times.csv';
  static const outputHelp =
  '''
    output flag -output OR -o
    default value is 'times.csv'
    Acceptable Values:
      stdout - will cause program to print output to stdout
      filename - any acceptable file name
    ''';

  static const start = 'start';
  var startDefault = '2010-12-31 23:50:00.000';
  static const startHelp =
    '''
    A Timestamp to be used as a limit for the generated times. 
    Only the Hour & Minute are used - Year, Month, Day, Second, Milliseconds are
    all ignored. 2010-12-31 23:50:00.000 = to 1900-06-17 23:50:00.000 for this
    method. It must be a valid time stamp. 
    ''';

  static const end = 'end';
  var endDefault = '2010-12-31 24:10:00.000';
  static const endHelp =
  '''
    A Timestamp to be used as a limit for the generated times. 
    Only the Hour & Minute are used - Year, Month, Day, Second, Milliseconds are
    all ignored. 2010-12-31 24:10:00.000 = to 1900-06-17 24:10:00.000 for this
    method. It must be a valid time stamp. 
    ''';

  @override
  String get description => _description;

  @override
  String get name => _name;

  var startHour;
  var startMin;
  var endHour;
  var endMin;

  @override
  void run() {
    var startArg = argResults[GenerateCommand.start] ?? startDefault;
    var startTime = DateTime.parse(startArg);
    var endArg = argResults[GenerateCommand.end] ?? endDefault;
    var endTime = DateTime.parse(endArg);
    var quantity = int.parse(argResults[GenerateCommand.quantity] ?? quantityDefault);
    var outputLocation = argResults[GenerateCommand.output] ?? outputDefault;
    var result;
    if('stdout' == outputLocation){
      result = generateTimeStamp(startTime, endTime, quantity);
      print(result.join(','));
    }
    else{
      var f = File(outputLocation);
      if(f.existsSync()){
        print('The file $outputLocation already exists. Do you want to overwrite it? y/n');
        var input = stdin.readLineSync(encoding: Encoding.getByName('utf-8'));
        if('y' == input.toLowerCase()){
          writeResultsToFile(result, startTime, endTime, quantity, f);
        }
      }
      else {
        writeResultsToFile(result, startTime, endTime, quantity, f);
      }
    }
  }

  void writeResultsToFile(result, DateTime startTime, DateTime endTime, int quantity, File f) {
    print('Generating results...');
    result = generateTimeStamp(startTime, endTime, quantity);
    print('Writing results to file...');
    f.writeAsStringSync(result.join(','), mode: FileMode.write);
  }

  List<DateTime> generateTimeStamp(DateTime start, DateTime end, int quantity){
    var daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    var hours = [for(int i = start.hour; i < (end.hour == 0 ? 24 : end.hour); i++) i.toString().padLeft(2, '0')];
    var allMinutes = [for(int i = 0; i < 60; i++) i.toString().padLeft(2, '0')];
    var minutes = {
      start.hour.toString().padLeft(2, '0'): [for(int i = start.minute; i < 60; i++) i.toString().padLeft(2, '0')],
      end.hour.toString().padLeft(2, '0'): [for(int i = 0; i < end.minute; i++) i.toString().padLeft(2, '0')]
    };
    var rand = Random();
    const yearsBaseline = 1900;
    var yearsRange = DateTime.now().year - yearsBaseline;
    var result = <DateTime>[];
    for(int i = 0; i < quantity; i++) {
      var randYear = rand.nextInt(yearsRange)+yearsBaseline;
      var randMonth = rand.nextInt(12);
      var month = randMonth.toString().padLeft(2, '0');
      var randDay = (rand.nextInt(daysInMonth[randMonth]) + 1);
      var day = randDay.toString().padLeft(2, '0');
      var randHour = hours[rand.nextInt(hours.length)];
      var hour = randHour.toString().padLeft(2, '0');
      var minList = (minutes[randHour] ?? allMinutes);
      var randMinute = minList[rand.nextInt(minList.length)];
      var minute = randMinute.toString().padLeft(2, '0');
      var randSecond = rand.nextInt(60);
      var second = randSecond.toString().padLeft(2, '0');
      var randMillis = rand.nextInt(1000);
      var millis = randMillis.toString().padLeft(3, '0');
      result.add(DateTime.parse('$randYear-$month-${day} $hour:$minute:$second.${millis}'));
    }
    return result;
  }
}