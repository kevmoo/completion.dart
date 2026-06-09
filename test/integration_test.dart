import 'package:checks/checks.dart';
import 'package:path/path.dart' as p;
import 'package:test/scaffolding.dart';
import 'package:test_process/test_process.dart';

import 'test_utils.dart';

const _exampleFileName = 'example.dart';
final _exampleFilePath = p.join('example', _exampleFileName);

void main() {
  test('normal execution', () async {
    final process = await TestProcess.start(dartPath, [_exampleFilePath]);

    await check(process.stdout).emitsThrough((it) => it.equals('Hello, World'));

    await process.shouldExit(0);
  });

  test('basic completion', () async {
    final process = await TestProcess.start(
      dartPath,
      [_exampleFilePath, 'completion', '--', _exampleFileName, '--'],
      environment: {'COMP_POINT': '15', 'COMP_LINE': '$_exampleFileName --'},
    );

    final completions = await process.stdout.rest.toList();
    check(completions).unorderedEquals([
      '--friendly',
      '--loud',
      '--no-loud',
      '--salutation',
      '--middle-name',
    ]);

    await process.shouldExit(0);
  });

  test('heuristic completion - --unknown help', () async {
    const compLine = '$_exampleFileName --unknown help ';
    final process = await TestProcess.start(
      dartPath,
      [_exampleFilePath, 'completion', '--', ...compLine.trim().split(' ')],
      environment: {'COMP_POINT': '${compLine.length}', 'COMP_LINE': compLine},
    );

    await check(process.stdout).emits((it) => it.equals('assistance'));

    await process.shouldExit(0);
  });
}
