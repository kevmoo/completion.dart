@TestOn('!windows')
library;

import 'dart:convert';
import 'dart:io';

import 'package:completion/completion.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';
import 'package:test_process/test_process.dart';

import 'test_utils.dart';

const _exampleFileName = 'example.dart';
final _exampleFilePath = p.join('example', _exampleFileName);

void main() {
  bool getHasNu() {
    try {
      return Process.runSync('nu', ['--version']).exitCode == 0;
    } on ProcessException {
      return false;
    }
  }

  test(
    'nushell completer hook executes correctly',
    skip: getHasNu() ? null : 'nushell not installed',

    () async {
      final tempDir = Directory.systemTemp.createTempSync('nu_shell_test');
      addTearDown(() => tempDir.deleteSync(recursive: true));

      // 1. Create a fake executable `my_app` that redirects to our example
      final myAppFile = File(p.join(tempDir.path, 'my_app'));
      final absoluteExamplePath = p.normalize(p.absolute(_exampleFilePath));
      myAppFile.writeAsStringSync('''#!/bin/bash
"$dartPath" "$absoluteExamplePath" "\$@"
''');
      Process.runSync('chmod', ['+x', myAppFile.path]);

      // 2. Generate the completion script
      final script = generateCompletionScript(['my_app'], shell: Shell.nushell);

      // 3. Create a Nushell script that loads the completion and invokes it
      final nuTestScript =
          '''
\$env.PATH = (\$env.PATH | prepend "${tempDir.path}")
\$env.config = {
    completions: {
        external: {
            enable: true
            completer: null
        }
    }
}

$script

# Invoke the completer directly for our binary, passing an active flag
let result = (do \$env.config.completions.external.completer ["my_app" "--"])
print (\$result | to json)
''';

      final nuFile = File(p.join(tempDir.path, 'test_completion.nu'));
      nuFile.writeAsStringSync(nuTestScript);

      // 4. Execute the test using `nu`
      final process = await TestProcess.start('nu', [nuFile.path]);

      final stdout = await process.stdout.rest.toList();
      final allOutput = stdout.join();

      // Attempt to decode the JSON
      final decoded = jsonDecode(allOutput) as List<dynamic>;
      expect(decoded, contains('--friendly'));
      expect(decoded, contains('--loud'));
      expect(decoded, contains('--no-loud'));

      await process.shouldExit(0);
    },
  );
}
