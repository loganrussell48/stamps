import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:stamps/commands/average-command.dart';
import 'package:stamps/commands/generate-command.dart';

int main(List<String> args){
  exitCode = 0;
  final generateCommand = GenerateCommand();
  final averageCommand = AverageCommand();
  
  var runner = CommandRunner('stamps', 'generate or calculate average of time stamps')
    ..addCommand(generateCommand)
    ..addCommand(averageCommand);

  var onError = (error){
    if(error is! UsageException) throw error;
    print(error);
    exit(64);
  };

  runner.run(args).catchError(onError);

  return exitCode;
}



