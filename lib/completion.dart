/// Support for generating shell completion scripts and using them.
library;

export 'src/generate.dart' show Shell, generateCompletionScript;
export 'src/try_args_completion.dart' show tryArgsCompletion;
export 'src/try_completion.dart' show completionCommandName, tryCompletion;
