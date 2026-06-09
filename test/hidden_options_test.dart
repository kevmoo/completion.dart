import 'package:args/args.dart';
import 'package:checks/checks.dart';
import 'package:completion/src/get_args_completions.dart';
import 'package:test/scaffolding.dart';

void main() {
  test('hidden options are not completed by default', () {
    final parser = ArgParser()
      ..addOption('visible', help: 'visible option')
      ..addOption('hidden', hide: true, help: 'hidden option');

    final completions = getArgsCompletions(parser, ['--'], '--', 2);
    check(completions)
      ..contains('--visible')
      ..not((it) => it.contains('--hidden'));
  });

  test('hidden options are completed when includeHidden is true', () {
    final parser = ArgParser()
      ..addOption('visible', help: 'visible option')
      ..addOption('hidden', hide: true, help: 'hidden option');

    final completions = getArgsCompletions(
      parser,
      ['--'],
      '--',
      2,
      includeHidden: true,
    );
    check(completions)
      ..contains('--visible')
      ..contains('--hidden');
  });

  test('hidden flags are not completed by default', () {
    final parser = ArgParser()
      ..addFlag('visible', help: 'visible flag')
      ..addFlag('hidden', hide: true, help: 'hidden flag');

    final completions = getArgsCompletions(parser, ['--'], '--', 2);
    check(completions)
      ..contains('--visible')
      ..not((it) => it.contains('--hidden'));
  });

  test('hidden flags are completed when includeHidden is true', () {
    final parser = ArgParser()
      ..addFlag('visible', help: 'visible flag')
      ..addFlag('hidden', hide: true, help: 'hidden flag');

    final completions = getArgsCompletions(
      parser,
      ['--'],
      '--',
      2,
      includeHidden: true,
    );
    check(completions)
      ..contains('--visible')
      ..contains('--hidden');
  });
}
