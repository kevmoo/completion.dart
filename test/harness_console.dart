library harness_console;

import 'package:unittest/unittest.dart';
import 'package:unittest/vm_config.dart';

import 'completion_test.dart' as completion;

void main() {
  testCore(new VMConfiguration());
}

void testCore(Configuration config) {
  unittestConfiguration = config;
  groupSep = ' - ';

  completion.main();
}
