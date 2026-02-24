import 'package:args/args.dart';
import 'package:completion/src/get_args_completions.dart';
import 'package:test/test.dart';

void main() {
  test('hidden options are not completed by default', () {
    final parser = ArgParser()
      ..addOption('visible', help: 'visible option')
      ..addOption('hidden', hide: true, help: 'hidden option');

    final completions = getArgsCompletions(parser, ['--'], '--', 2);
    expect(completions, contains('--visible'));
    expect(completions, isNot(contains('--hidden')));
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
    expect(completions, contains('--visible'));
    expect(completions, contains('--hidden'));
  });

  test('hidden flags are not completed by default', () {
    final parser = ArgParser()
      ..addFlag('visible', help: 'visible flag')
      ..addFlag('hidden', hide: true, help: 'hidden flag');

    final completions = getArgsCompletions(parser, ['--'], '--', 2);
    expect(completions, contains('--visible'));
    expect(completions, isNot(contains('--hidden')));
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
    expect(completions, contains('--visible'));
    expect(completions, contains('--hidden'));
  });
}
