import 'dart:io';

import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;

import 'util.dart';

/// The string 'completion' used to denote that arguments provided to an app are
/// for command completion.
///
/// The expected arg format is: completion -- {process name} {rest of current
/// args}
const String completionCommandName = 'completion';

const _compPointVar = 'COMP_POINT';

/// Try to complete the given [args].
///
/// If the arguments indicate that completion is being requested, then the
/// [completer] function is called to generate the list of possible
/// completions. If the [completer] returns a non-empty list, then each
/// completion is printed to standard output, one per line. In this case, the
/// function returns the exit code 0. If the [completer] returns an empty list,
/// the function returns the exit code 1.
///
/// If the arguments do not indicate that completion is being requested, then
/// the function returns `null`.
///
/// The optional [logFile] parameter is used to log information about the
/// completion process. This is useful for debugging, but should not be enabled
/// in production code.
int? tryCompletion(
  List<String> args,
  List<String> Function(List<String> args, String compLine, int compPoint)
  completer, {
  @Deprecated('Useful for testing, but do not release with this set.')
  bool? logFile,
}) => tryCompletionImpl(args, completer, logFile: logFile);

@internal
int? tryCompletionImpl(
  List<String> args,
  List<String> Function(List<String> args, String compLine, int compPoint)
  completer, {
  @Deprecated('Useful for testing, but do not release with this set.')
  bool? logFile,
  Map<String, String>? environment,
}) {
  environment ??= Platform.environment;
  if (logFile ?? false) {
    final logFile = File('_completion.log');

    void logLine(String content) {
      logFile.writeAsStringSync('$content\n', mode: FileMode.writeOnlyAppend);
    }

    logLine(' *' * 50);

    Logger.root.onRecord.listen((e) {
      final loggerName = e.loggerName.split('.');
      if (loggerName.isNotEmpty && loggerName.first == 'completion') {
        loggerName.removeAt(0);
        assert(e.level == Level.INFO);
        logLine(
          '${loggerName.join('.').padLeft(Tag.longestTagLength)}  '
          '${e.message}',
        );
      }
    });
  }

  String scriptName;
  try {
    scriptName = p.basename(Platform.script.toFilePath());
  } on FileSystemException {
    // Script may not have a current working directory.
    scriptName = '<unknown>';
  } on UnsupportedError // ignore: avoid_catching_errors
  {
    scriptName = '<unknown>';
  }

  log('Checking for completion on script:\t$scriptName');
  if (args.length >= 3 && args[0] == completionCommandName && args[1] == '--') {
    try {
      log('Starting completion');
      log('All args: $args');
      log('completion-reported exe: ${args[2]}');

      // There are 3 interesting env parameters passed by the completion logic
      // COMP_LINE:  the full contents of the completion
      final compLine = environment['COMP_LINE'];
      if (compLine == null) {
        throw StateError('Environment variable COMP_LINE must be set');
      }

      // COMP_CWORD: number of words. Also might be nice
      // COMP_POINT: where the cursor is on the completion line
      final compPointValue = environment[_compPointVar];
      if (compPointValue == null || compPointValue.isEmpty) {
        throw StateError(
          'Environment variable $_compPointVar must be set and non-empty',
        );
      }
      final compPoint = int.tryParse(compPointValue);

      if (compPoint == null) {
        throw FormatException(
          'Could not parse $_compPointVar value '
          '"$compPointValue" into an integer',
        );
      }

      final trimmedArgs = args.sublist(3);

      log('input args:     ${helpfulToString(trimmedArgs)}');

      final completions = completer(trimmedArgs, compLine, compPoint);

      log('completions: ${helpfulToString(completions)}');

      for (final comp in completions) {
        print(comp);
      }
      return 0;
    } catch (ex, stack) {
      log('An error occurred while attemping completion');
      log(ex);
      log(stack);
      return 1;
    }
  }

  log('Completion params not found');
  return null;
}
