import 'dart:io';

import 'package:completion/completion.dart';

void main(List<String> arguments) {
  try {
    print(generateCompletionScript(arguments));
  } catch (e) {
    print(e);
    exit(1);
  }
}
