#!/usr/bin/env dart

import 'dart:io';

import 'package:args/args.dart';
import 'package:completion/completion.dart';

void main(List<String> arguments) {
  final parser = ArgParser()
    ..addMultiOption(
      'shell',
      abbr: 's',
      help: 'The shells to generate completion scripts for.',
      allowed: Shell.values.map((e) => e.name).toList(),
      defaultsTo: Shell.values.map((e) => e.name).toList(),
    );

  ArgResults results;
  try {
    results = parser.parse(arguments);
  } on FormatException catch (e) {
    stderr.writeln(e.message);
    stderr.writeln();
    stderr.writeln(
      'Usage: shell_completion_generator [options] <binary_names>',
    );
    stderr.writeln(parser.usage);
    exitCode = 1;
    return;
  }

  final binaryNames = results.rest;

  if (binaryNames.isEmpty) {
    stderr.writeln('Provide the name of at least one command.');
    stderr.writeln();
    stderr.writeln(
      'Usage: shell_completion_generator [options] <binary_names>',
    );
    stderr.writeln(parser.usage);
    exitCode = 1;
    return;
  }

  final shellNames = results['shell'] as List<String>;
  final shells = shellNames.map((name) => Shell.parse(name)!).toSet();

  try {
    print(generateCompletionScript(binaryNames, shells: shells));
  } catch (e) {
    stderr.writeln(e);
    exitCode = 1;
  }
}
