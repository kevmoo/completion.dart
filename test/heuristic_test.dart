import 'package:args/args.dart';
import 'package:completion/src/get_args_completions.dart';
import 'package:test/test.dart';

void main() {
  group('heuristic subcommand detection', () {
    final parser = ArgParser()
      ..addFlag('verbose')
      ..addCommand('commit', ArgParser()..addFlag('amend'));

    void check(String description, List<String> args, Object matcher) {
      test(description, () {
        final completions = getArgsCompletions(
          parser,
          args,
          args.join(' '),
          args.join(' ').length,
        );
        expect(completions, matcher);
      });
    }

    check('simple', ['--unknown', 'commit', '--a'], contains('--amend'));

    check('with multiple invalid args', [
      '--unknown',
      'junk',
      'commit',
      '--a',
    ], contains('--amend'));

    check('no subcommand found', ['--unknown', 'junk', '--a'], isEmpty);
  });
}
