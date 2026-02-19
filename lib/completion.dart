/// Support for generating shell completion scripts and using them.
///
/// Most users will want to use the [tryArgsCompletion] function.
/// @docImport 'src/try_args_completion.dart';
library;

export 'src/generate.dart' show Shell, generateCompletionScript;
export 'src/try_args_completion.dart' show tryArgsCompletion;
export 'src/try_completion.dart' show completionCommandName, tryCompletion;
