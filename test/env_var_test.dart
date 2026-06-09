import 'package:checks/checks.dart';
import 'package:completion/src/try_completion.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('tryCompletion environment parsing', () {
    test('missing COMP_LINE returns 1', () {
      final args = ['completion', '--', 'exe'];
      final exitCode = tryCompletionImpl(
        args,
        (a, l, p) => [],
        environment: {},
      );
      check(exitCode).equals(1);
    });

    test('missing COMP_POINT returns 1', () {
      final args = ['completion', '--', 'exe'];
      final exitCode = tryCompletionImpl(
        args,
        (a, l, p) => [],
        environment: {'COMP_LINE': 'exe '},
      );
      check(exitCode).equals(1);
    });

    test('valid completion returns 0', () {
      final args = ['completion', '--', 'exe', 'a'];
      final exitCode = tryCompletionImpl(args, (a, l, p) {
        check(l).equals('exe a');
        check(p).equals(5);
        return ['completion'];
      }, environment: {'COMP_LINE': 'exe a', 'COMP_POINT': '5'});
      check(exitCode).equals(0);
    });

    test('no completion args returns null', () {
      final args = ['not-completion'];
      final exitCode = tryCompletionImpl(
        args,
        (a, l, p) => [],
        environment: {},
      );
      check(exitCode).isNull();
    });

    test('exception in completer returns 1', () {
      final args = ['completion', '--', 'exe', 'a'];
      final exitCode = tryCompletionImpl(args, (a, l, p) {
        throw StateError('Test exception');
      }, environment: {'COMP_LINE': 'exe a', 'COMP_POINT': '5'});
      check(exitCode).equals(1);
    });
  });
}
