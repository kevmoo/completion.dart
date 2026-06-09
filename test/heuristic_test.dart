import 'package:args/args.dart';
import 'package:checks/checks.dart';
import 'package:completion/src/get_args_completions.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('heuristic subcommand detection', () {
    final parser = ArgParser()
      ..addFlag('verbose')
      ..addCommand('commit', ArgParser()..addFlag('amend'));

    void testHeuristic(
      String description,
      List<String> args,
      void Function(Subject<List<String>>) condition,
    ) {
      test(description, () {
        final completions = getArgsCompletions(
          parser,
          args,
          args.join(' '),
          args.join(' ').length,
        );
        condition(check(completions));
      });
    }

    testHeuristic('simple', [
      '--unknown',
      'commit',
      '--a',
    ], (it) => it.contains('--amend'));

    testHeuristic('with multiple invalid args', [
      '--unknown',
      'junk',
      'commit',
      '--a',
    ], (it) => it.contains('--amend'));

    testHeuristic('no subcommand found', [
      '--unknown',
      'junk',
      '--a',
    ], (it) => it.isEmpty());
  });
}
