import 'dart:io';

import 'package:TimeAverage/commands/average-command.dart';
import 'package:TimeAverage/commands/generate-command.dart';
import 'package:args/args.dart';
import 'package:args/command_runner.dart';

int main(List<String> args){
  ArgResults argResults;
  exitCode = 0;
  final generateCommand = GenerateCommand();
  final averageCommand = AverageCommand();
  
  var runner = CommandRunner('times', 'generate or calculate average of time stamps')
    ..addCommand(generateCommand)
    ..addCommand(averageCommand);



  runner.run(args).catchError((error) {
    if (error is! UsageException) throw error;
    print(error);
    exit(64);
  });



  // var times = [for(int i = 0; i < 1000000; i++) generateTimeStamp()];
  // print(times.join(','));
  // var time = times.map((e) => Runtime(e.hour, e.minute, e.second, e.millisecond)).map((e) => e.value);
  // print(time.stats.average.toTime());
  return exitCode;
}



