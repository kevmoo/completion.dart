import 'package:args/args.dart';
import 'package:completion/src/get_args_completions.dart';
import 'package:test/test.dart';

void main() {
  test('heuristic subcommand detection', () {
    final parser = ArgParser()
      ..addFlag('verbose')
      ..addCommand('commit', ArgParser()..addFlag('amend'));

    final args = ['--unknown', 'commit', '--a'];
    final completions = getArgsCompletions(
      parser,
      args,
      args.join(' '),
      args.join(' ').length,
    );

    expect(completions, contains('--amend'));
  });

  test('heuristic subcommand detection with multiple invalid args', () {
    final parser = ArgParser()
      ..addCommand('commit', ArgParser()..addFlag('amend'));

    final args = ['--unknown', 'junk', 'commit', '--a'];
    final completions = getArgsCompletions(
      parser,
      args,
      args.join(' '),
      args.join(' ').length,
    );

    expect(completions, contains('--amend'));
  });

  test('heuristic subcommand detection - no subcommand found', () {
    final parser = ArgParser()
      ..addCommand('commit', ArgParser()..addFlag('amend'));

    final args = ['--unknown', 'junk', '--a'];
    final completions = getArgsCompletions(
      parser,
      args,
      args.join(' '),
      args.join(' ').length,
    );

    expect(completions, isEmpty);
  });
}
