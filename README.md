*Add shell command completion to your Dart console applications.*

[![Build Status](https://travis-ci.org/kevmoo/completion.dart.svg?branch=master)](https://travis-ci.org/kevmoo/completion.dart)
[![Coverage Status](https://coveralls.io/repos/kevmoo/completion.dart/badge.svg?branch=master)](https://coveralls.io/r/kevmoo/completion.dart)

To use this package, instead of this:

```dart
import 'packages:args/args.dart';

void main(List<String> args) {
  ArgParser argParser = new ArgParser();
  argParser.addFlag('option', help: 'flag help');
  // ... add more options ...
  ArgResults argResults = argParser.parse(args);
  // ...
}
```

do this:

```dart
import 'packages:args/args.dart';
import 'packages:completion/completion.dart' as completion;

void main(List<String> args) {
  ArgParser argParser = new ArgParser();
  argParser.addFlag('option', help: 'flag help');
  // ... add more options ...
  ArgResults argResults = completion.tryArgsCompletion(args, argParser);
  // ...
}
```

(The only difference is calling `complete.tryArgsCompletion` in place of `argParser.parse`)

This will add a "completion" command to your app, which the shell will use
to complete arguments.

To generate the setup script automatically, call `generateCompletionScript`
with the names of the executables that your Dart script runs as (typically
just one, but it could be more).

Also, see [the example](./example).