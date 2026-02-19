import 'dart:io';

import 'package:args/args.dart';

import 'get_args_completions.dart';
import 'try_completion.dart';

/// Try to complete the command line arguments.
///
/// If [mainArgs] indicate that completion is requested, this function will
/// print the completion suggestions to standard output and call [exit] with
/// the suggested exit code.
///
/// If [mainArgs] do not indicate that completion is requested, this function
/// will return the arguments parsed with [parser].
///
/// [logFile] is a deprecated argument that is useful for testing, but should
/// not be used in production code.
ArgResults tryArgsCompletion(
  List<String> mainArgs,
  ArgParser parser, {
  @Deprecated('Useful for testing, but do not released with this set.')
  bool? logFile,
}) {
  final suggestedExitCode = tryCompletionImpl(
    mainArgs,
    (List<String> args, String compLine, int compPoint) =>
        getArgsCompletions(parser, args, compLine, compPoint),
    // ignore: deprecated_member_use_from_same_package,deprecated_member_use
    logFile: logFile,
  );

  if (suggestedExitCode != null) {
    // Generally, one does NOT want to call `exit` in a library, but this is
    // the only way to signal to the shell that completion was successful
    // and to terminate the process.
    exit(suggestedExitCode);
  }

  return parser.parse(mainArgs);
}
