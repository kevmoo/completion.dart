// #region usage
import 'package:args/args.dart';
import 'package:completion/completion.dart' as completion;

void main(List<String> args) {
  final argParser = ArgParser()..addFlag('option', help: 'flag help');
  // ... add more options ...
  final argResults = completion.tryArgsCompletion(args, argParser);
  if (argResults == null) return;
  // ...
  print(argResults['option']); // #hide
}
// #endregion usage
