import 'package:completion/src/try_completion.dart';
import 'package:test/test.dart';

void main() {
  group('tryCompletion environment parsing', () {
    test('missing COMP_LINE returns 1', () {
      final args = ['completion', '--', 'exe'];
      final exitCode = tryCompletionImpl(
        args,
        (a, l, p) => [],
        environment: {},
      );
      expect(exitCode, 1);
    });

    test('missing COMP_POINT returns 1', () {
      final args = ['completion', '--', 'exe'];
      final exitCode = tryCompletionImpl(
        args,
        (a, l, p) => [],
        environment: {'COMP_LINE': 'exe '},
      );
      expect(exitCode, 1);
    });

    test('valid completion returns 0', () {
      final args = ['completion', '--', 'exe', 'a'];
      final exitCode = tryCompletionImpl(args, (a, l, p) {
        expect(l, 'exe a');
        expect(p, 5);
        return ['completion'];
      }, environment: {'COMP_LINE': 'exe a', 'COMP_POINT': '5'});
      expect(exitCode, 0);
    });

    test('no completion args returns null', () {
      final args = ['not-completion'];
      final exitCode = tryCompletionImpl(
        args,
        (a, l, p) => [],
        environment: {},
      );
      expect(exitCode, isNull);
    });
  });
}
