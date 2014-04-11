library harness_console;

import 'package:unittest/unittest.dart';

import 'completion_test.dart' as completion;

void main() {
  groupSep = ' - ';

  completion.main();
}
