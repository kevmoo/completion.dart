import 'package:path/path.dart' as p;
import 'package:test/test.dart';
import 'package:test_process/test_process.dart';

import 'test_utils.dart';

void main() {
  test('normal execution', () async {
    var process =
        await TestProcess.start(dartPath, [p.join('example', 'hello.dart')]);

    await expectLater(process.stdout, emitsThrough('Hello, World'));

    await process.shouldExit(0);
  });

  test('basic completion', () async {
    var process = await TestProcess.start(dartPath, [
      p.join('example', 'hello.dart'),
      'completion',
      '--',
      'hello.dart',
      '--'
    ], environment: {
      'COMP_POINT': '13',
      'COMP_LINE': 'hello.dart --'
    });

    await expectLater(
        process.stdout,
        emitsInAnyOrder([
          '--friendly',
          '--loud',
          '--no-loud',
          '--salutation',
          '--middle-name',
        ]));

    await process.shouldExit(0);
  });
}
