import 'package:args/args.dart';

import 'src/get_args_completions.dart';
import 'src/try_completion.dart';

export 'src/generate.dart';

ArgResults tryArgsCompletion(List<String> mainArgs, ArgParser parser) {
  tryCompletion(mainArgs, (List<String> args, String compLine, int compPoint) {
    return getArgsCompletions(parser, args, compLine, compPoint);
  });
  return parser.parse(mainArgs);
}
