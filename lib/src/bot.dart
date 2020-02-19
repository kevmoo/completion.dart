
class Util {
  static int getHashCode(Iterable source) {
    requireArgumentNotNull(source, 'source');

    var hash = 0;
    for (final h in source) {
      final next = h == null ? 0 : h.hashCode;
      hash = 0x1fffffff & (hash + next);
      hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
      hash ^= hash >> 6;
    }
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    hash ^= hash >> 11;
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

void require(bool truth, [String message]) {
  if (!truth) {
    throw Exception(message);
  }
}

void requireArgumentNotNull(argument, String argName) {
  _metaRequireArgumentNotNullOrEmpty(argName);
  if (argument == null) {
    throw ArgumentError.notNull(argName);
  }
}

void _metaRequireArgumentNotNullOrEmpty(String argName) {
  if (argName == null || argName.isEmpty) {
    throw UnsupportedError("That's just sad. Give me a good argName");
  }
}
