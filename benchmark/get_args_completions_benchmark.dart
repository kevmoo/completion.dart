import 'package:completion/src/get_args_completions.dart';
import '../test/completion_tests_args.dart';

void main() {
  final parser = getHelloSampleParser();
  final args = ['--friendly', '--salutation', 'Mr', 'help', ''];
  final compLine = args.join(' ');
  final compPoint = compLine.length;

  const iterations = 100000;

  // Warmup
  for (var i = 0; i < 10000; i++) {
    getArgsCompletions(parser, args, compLine, compPoint);
  }

  final watch = Stopwatch()..start();
  for (var i = 0; i < iterations; i++) {
    getArgsCompletions(parser, args, compLine, compPoint).toList();
  }
  watch.stop();

  print('Iterations: $iterations');
  print('Total time: ${watch.elapsedMilliseconds}ms');
  print('Average time: ${watch.elapsedMicroseconds / iterations}us');
}
