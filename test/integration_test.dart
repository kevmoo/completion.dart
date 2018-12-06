import 'package:path/path.dart' as p;
import 'package:test/test.dart';
import 'package:test_process/test_process.dart';

import 'test_utils.dart';

final _exampleFileName = 'example.dart';
final _exampleFilePath = p.join('example', _exampleFileName);

void main() {
  test('normal execution', () async {
    var process = await TestProcess.start(dartPath, [_exampleFilePath]);

    await expectLater(process.stdout, emitsThrough('Hello, World'));

    await process.shouldExit(0);
  });

  test('basic completion', () async {
    var process = await TestProcess.start(dartPath,
        [_exampleFilePath, 'completion', '--', _exampleFileName, '--'],
        environment: {'COMP_POINT': '15', 'COMP_LINE': '$_exampleFileName --'});

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
