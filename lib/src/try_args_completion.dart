import 'dart:io';

import 'package:args/args.dart';

import 'get_args_completions.dart';
import 'try_completion.dart';

/// Try to complete the command line arguments.
///
/// If [mainArgs] indicate that completion is requested, this function will
/// print the completion suggestions to standard output, set [exitCode] to
/// the suggested exit code, and return `null`.
///
/// If [mainArgs] do not indicate that completion is requested, this function
/// will return the arguments parsed with [parser].
///
/// [logFile] is a deprecated argument that is useful for testing, but should
/// not be used in production code.
///
/// If [includeHidden] is `true`, options marked as hidden will be included in
/// the completion suggestions.
/// (Hidden commands are always included.)
ArgResults? tryArgsCompletion(
  List<String> mainArgs,
  ArgParser parser, {
  @Deprecated('Useful for testing, but do not release with this set.')
  bool? logFile,
  bool includeHidden = false,
}) {
  final suggestedExitCode = tryCompletionImpl(
    mainArgs,
    (List<String> args, String compLine, int compPoint) => getArgsCompletions(
      parser,
      args,
      compLine,
      compPoint,
      includeHidden: includeHidden,
    ),
    // ignore: deprecated_member_use_from_same_package,deprecated_member_use
    logFile: logFile,
  );

  if (suggestedExitCode != null) {
    exitCode = suggestedExitCode;
    return null;
  }

  return parser.parse(mainArgs);
}
