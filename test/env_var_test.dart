import 'package:completion/src/try_completion.dart';
import 'package:test/test.dart';

void main() {
  group('tryCompletion environment parsing', () {
    test('missing COMP_LINE returns 1', () {
      final args = <String>['completion', '--', 'exe'];
      final exitCode = tryCompletionImpl(
        args,
        (List<String> a, String l, int p) => <String>[],
        environment: <String, String>{},
      );
      expect(exitCode, 1);
    });

    test('missing COMP_POINT returns 1', () {
      final args = <String>['completion', '--', 'exe'];
      final exitCode = tryCompletionImpl(
        args,
        (List<String> a, String l, int p) => <String>[],
        environment: <String, String>{'COMP_LINE': 'exe '},
      );
      expect(exitCode, 1);
    });

    test('valid completion returns 0', () {
      final args = <String>['completion', '--', 'exe', 'a'];
      final exitCode = tryCompletionImpl(args, (List<String> a, String l, int p) {
        expect(l, 'exe a');
        expect(p, 5);
        return <String>['completion'];
      }, environment: <String, String>{'COMP_LINE': 'exe a', 'COMP_POINT': '5'});
      expect(exitCode, 0);
    });

    test('no completion args returns null', () {
      final args = <String>['not-completion'];
      final exitCode = tryCompletionImpl(
        args,
        (List<String> a, String l, int p) => <String>[],
        environment: <String, String>{},
      );
      expect(exitCode, isNull);
    });

    test('exception in completer returns 1', () {
      final args = <String>['completion', '--', 'exe', 'a'];
      final exitCode = tryCompletionImpl(args, (List<String> a, String l, int p) {
        throw StateError('Test exception');
      }, environment: <String, String>{'COMP_LINE': 'exe a', 'COMP_POINT': '5'});
      expect(exitCode, 1);
    });
  });
}
