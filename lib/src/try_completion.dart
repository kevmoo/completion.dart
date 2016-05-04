import 'dart:io';

import 'package:bot/bot.dart';
import 'package:path/path.dart' as p;

import 'util.dart';

/// The string 'completion' used to denote that arguments provided to an app are
/// for command completion.
///
/// The expected arg format is: completion -- {process name} {rest of current
/// args}
const String COMPLETION_COMMAND_NAME = 'completion';

const _COMP_POINT_VAR = 'COMP_POINT';

void tryCompletion(List<String> args,
    List<String> completer(List<String> args, String compLine, int compPoint)) {
  String scriptName;
  try {
    scriptName = p.basename(Platform.script.toFilePath());
  } on UnsupportedError catch (e, stack) {
    log(e);
    log(stack);
    return;
  }

  if (scriptName.isEmpty) {
    // should have a script name...weird...
    return;
  }

  log('Checking for completion on script:\t$scriptName');
  if (args.length >= 3 &&
      args[0] == COMPLETION_COMMAND_NAME &&
      args[1] == '--') {
    try {
      log('Starting completion');
      log('completion-reported exe: ${args[2]}');

      final env = Platform.environment;

      // There are 3 interesting env paramaters passed by the completion logic
      // COMP_LINE:  the full contents of the completion
      final compLine = env['COMP_LINE'];
      require(compLine != null, 'Environment variable COMP_LINE must be set');

      // COMP_CWORD: number of words. Also might be nice
      // COMP_POINT: where the cursor is on the completion line
      final compPointValue = env[_COMP_POINT_VAR];
      require(compPointValue != null && !compPointValue.isEmpty,
          'Environment variable $_COMP_POINT_VAR must be set and non-empty');
      final compPoint = int.parse(compPointValue, onError: (val) {
        throw new FormatException('Could not parse $_COMP_POINT_VAR value '
            '"$val" into an integer');
      });

      final trimmedArgs = args.sublist(3);

      log('input args:     ${helpfulToString(trimmedArgs)}');

      final completions = completer(trimmedArgs, compLine, compPoint);

      log('completions: ${helpfulToString(completions)}');

      for (final comp in completions) {
        print(comp);
      }
      exit(0);
    } catch (ex, stack) {
      log('An error occurred while attemping completion');
      log(ex);
      log(stack);
      exit(1);
    }
  }

  log('Completion params not found');
}
