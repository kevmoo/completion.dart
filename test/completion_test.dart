import 'package:args/args.dart';
import 'package:completion/src/get_args_completions.dart';
import 'package:test/test.dart';

import 'completion_tests_args.dart';

void main() {
  group('hello world sample', () {
    final parser = getHelloSampleParser();

    final allOptions = _getAllOptions(parser);

    final pairs = <_CompletionSet>[
      (
        'empty input, just give all the commands',
        [],
        parser.commands.keys.toList(),
      ),
      ('just a dash: should be empty. Vague', ['-'], []),
      ('double-dash, give all the options', ['--'], allOptions),
      ('+flag complete --frie to --friendly', ['--frie'], ['--friendly']),
      (
        '+flag complete full, final option to itself',
        ['--friendly'],
        ['--friendly'],
      ),
      (
        "+command starting to complete 'help' - finish with help",
        ['he'],
        ['help'],
      ),
      ("+command all of 'help' - finish with help", ['help'], ['help']),
      ('too much', ['helpp'], []),
      ('wrong case', ['Help'], []),
      ("+command complete 'assistance'", ['help', 'assist'], ['assistance']),
      ('show the yell flag for help', ['help', '--'], ['--yell', '--no-yell']),
      (
        "+command help - complete '--n' to '--no-yell'",
        ['help', '--n'],
        ['--no-yell'],
      ),
      (
        '+command help has sub-command - assistance',
        ['help', ''],
        ['assistance'],
      ),
      (
        "+flag don't offer --friendly twice",
        ['--friendly', '--'],
        ['--loud', '--no-loud', '--salutation', '--middle-name'],
      ),
      (
        "+abbr+flag+no-multiple don't offer --friendly twice, even if the "
            'first one is the abbreviation',
        ['-f', '--'],
        ['--loud', '--no-loud', '--salutation', '--middle-name'],
      ),
      (
        "+flag+no-multiple don't complete a second --friendly",
        ['--friendly', '--friend'],
        [],
      ),
      (
        "+abbr+flag+no-multiple don't complete a second --friendly, even if "
            'the first one is the abbreviation',
        ['-f', '--friend'],
        [],
      ),
      (
        "+flag+negatable+no-multiple don't complete the opposite of a "
            'negatable - 1',
        ['--no-loud', '--'],
        ['--friendly', '--salutation', '--middle-name'],
      ),
      (
        "+flag+negatable+no-multiple don't complete the opposite of a "
            'negatable - 2',
        ['--loud', '--'],
        ['--friendly', '--salutation', '--middle-name'],
      ),
      (
        "+option+no-allowed+multiple okay to have multiple 'multiple' options",
        ['--middle-name', 'Robert', '--'],
        allOptions,
      ),
      (
        "+option+no-allowed+multiple okay to have multiple 'multiple' "
            'options, even abbreviations',
        ['-m', '"John Davis"', '--'],
        allOptions,
      ),
      (
        "+option+no-allowed don't suggest if an option is waiting for a value",
        ['--middle-name', ''],
        [],
      ),
      (
        "+abbr+option+no-allowed don't suggest if an option is waiting for a "
            'value',
        ['-m', ''],
        [],
      ),
      (
        '+option+allowed suggest completions for an option with allowed '
            'defined',
        ['--salutation', ''],
        ['Mr', 'Mrs', 'Dr', 'Ms'],
      ),
      (
        '+option+allowed finish a completion for an option (added via abbr) '
            'with allowed defined',
        ['-s', 'M'],
        ['Mr', 'Mrs', 'Ms'],
      ),
      ("+abbr+option+allowed don't finish a bad completion", ['-s', 'W'], []),
      ('+abbr+option+allowed confirm a completion', ['-s', 'Dr'], ['Dr']),
      (
        '+abbr+option+allowed back to command completion after a completed '
            'option',
        ['-s', 'Dr', ''],
        ['help'],
      ),
      (
        '+abbr+option+allowed back to option completion after a completed '
            'option',
        ['-s', 'Dr', '--'],
        ['--friendly', '--loud', '--no-loud', '--middle-name'],
      ),
      (
        'heuristic: --unknown help -> suggest assistance',
        ['--unknown', 'help', ''],
        ['assistance'],
      ),
      (
        'heuristic: --unknown help -- -> suggest flags',
        ['--unknown', 'help', '--'],
        ['--yell', '--no-yell'],
      ),
      (
        'heuristic: --unknown help ass -> suggest assistance',
        ['--unknown', 'help', 'ass'],
        ['assistance'],
      ),
    ];

    test('compPoint not at the end', () {
      const compLine = 'help';
      final args = ['help'];

      _testCompletionPair(parser, args, ['help'], compLine, compLine.length);
      _testCompletionPair(parser, args, [], compLine, compLine.length - 1);
    });

    for (final (description, args, suggestions) in pairs) {
      final compLine = args.join(' ');
      final compPoint = compLine.length;

      test(description, () {
        _testCompletionPair(parser, args, suggestions, compLine, compPoint);
      });
    }
  });
}

List<String> _getAllOptions(ArgParser parser) {
  final list = <String>[];

  parser.options.forEach((k, v) {
    if (k != v.name) {
      throw StateError('Boo!');
    }

    list.add(_optionIze(k));

    if (v.negatable!) {
      list.add(_optionIze('no-$k'));
    }
  });

  return list;
}

String _optionIze(String input) => '--$input';

void _testCompletionPair(
  ArgParser parser,
  List<String> args,
  List<String> suggestions,
  String compLine,
  int compPoint,
) {
  final completions = getArgsCompletions(parser, args, compLine, compPoint);

  expect(
    completions,
    unorderedEquals(suggestions),
    reason: 'for args: $args expected: $suggestions but got: $completions',
  );
}

typedef _CompletionSet = (
  String description,
  List<String> args,
  List<String> suggestions,
);
