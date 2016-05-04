import 'package:logging/logging.dart' as logging;

void log(Object o, [List<String> subContexts]) {
  String safe;

  try {
    safe = o.toString();
  } catch (e, stack) {
    safe = 'Error converting provided object $o into '
        'String\nException:\t$e\Stack:\t$stack';
  }

  final startArgs = ['completion'];
  if (subContexts != null) {
    startArgs.addAll(subContexts);
  }

  final loggerName = startArgs.join('.');

  final logger = new logging.Logger(loggerName);

  logger.info(safe);
}

String helpfulToString(Object input) {
  if (input is Iterable) {
    final items = input.map((item) => helpfulToString(item)).toList();

    if (items.isEmpty) {
      return '-empty-';
    } else {
      return "[${items.join(', ')}]";
    }
  }

  return Error.safeToString(input);
}
