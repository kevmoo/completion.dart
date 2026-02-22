/// Format for unified bash and zsh completion script:
/// https://npmjs.org/
/// https://github.com/isaacs/npm/blob/master/lib/utils/completion.sh
///
/// Inspiration for auto-generating completion scripts:
/// https://github.com/mklabs/node-tabtab
/// https://github.com/mklabs/node-tabtab/blob/master/lib/completion.sh
library;

import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

const _binNameReplacement = '{{binName}}';
const _funcNameReplacement = '{{funcName}}';

/// Must be at least one char.
/// Must start with a letter or number
/// Can contain letters, numbers, '_', '-', '.'
/// Must end with letter or number
final _binNameMatch = RegExp(r'^[a-zA-Z0-9]((\w|-|\.)*[a-zA-Z0-9])?$');

/// The shells that we support completion generation for.
enum Shell {
  bash(_bashTemplate),
  zsh(_zshTemplate),
  fish(_fishTemplate),
  nushell(_nushellTemplate);

  /// Parse a shell name from a string.
  static Shell? parse(String name) =>
      Shell.values.where((e) => e.name == name).singleOrNull;

  const Shell(this.template);

  final String template;
}

/// Generate a completion script for the given [binaryNames] and [shell].
///
/// [binaryNames] is the list of binary names to generate completion scripts
/// for.
///
/// [shell] is the shell to generate a completion script for.
String generateCompletionScript(
  List<String> binaryNames, {
  required Shell shell,
}) {
  if (binaryNames.isEmpty) {
    throw ArgumentError('Provide the name of at least of one command');
  }

  for (final binName in binaryNames) {
    if (!_binNameMatch.hasMatch(binName)) {
      final msg =
          'The provided name - "$binName" - is invalid\n'
          'It must match regex: ${_binNameMatch.pattern}';
      throw StateError(msg);
    }
  }

  final buffer = StringBuffer();

  final prefix = LineSplitter.split(
    _prefix,
  ).map((l) => '# $l'.trim()).join('\n');
  buffer
    ..writeln(prefix)
    ..writeln();

  for (final binName in binaryNames) {
    buffer.writeln(_printBinName(binName, shell));
  }

  final detailLines = ['Generated ${DateTime.now().toUtc()}'];

  if (Platform.script.scheme == 'file') {
    var scriptPath = Platform.script.toFilePath();
    scriptPath = p.absolute(p.normalize(scriptPath));

    detailLines.add('By $scriptPath');
  }

  final details = detailLines.map((l) => '## $l').join('\n');
  buffer.write(details);

  return buffer.toString();
}

String _printBinName(String binName, Shell shell) {
  var funcName = binName.replaceAll('.', '_');
  funcName = '__${funcName}_completion';

  final buffer = StringBuffer()..writeln('###-begin-$binName-completion-###');

  buffer.writeln('###-for-${shell.name}-###');
  buffer.writeln(
    shell.template
        .replaceAll(_binNameReplacement, binName)
        .replaceAll(_funcNameReplacement, funcName),
  );

  buffer.writeln('###-end-$binName-completion-###');

  return buffer.toString();
}

const _prefix = '''

Installation:

Via shell config file  ~/.bashrc  (or ~/.zshrc)

  Append the contents to config file
  'source' the file in the config file

Via fish config file  ~/.config/fish/config.fish

  Append the contents to config file

Via nushell config file  ~/.config/nushell/env.nu

  Append the contents to config file

You may also have a directory on your system that is configured
   for completion files, such as:

   /usr/local/etc/bash_completion.d/
''';

const _bashTemplate = r'''
if type complete &>/dev/null; then
  {{funcName}}() {
    local si="$IFS"
    IFS=$'\n' COMPREPLY=($(COMP_CWORD="$COMP_CWORD" \
                           COMP_LINE="$COMP_LINE" \
                           COMP_POINT="$COMP_POINT" \
                           {{binName}} completion -- "${COMP_WORDS[@]}" \
                           2>/dev/null)) || return $?
    IFS="$si"
  }
  complete -F {{funcName}} {{binName}}
fi
''';

const _zshTemplate = r'''
if type compdef &>/dev/null; then
  {{funcName}}() {
    local si
    si=$IFS
    IFS=$'\n'
    local reply
    reply=($(COMP_CWORD="$((CURRENT-1))" \
             COMP_LINE="$BUFFER" \
             COMP_POINT="$CURSOR" \
             {{binName}} completion -- "${words[@]}" \
             2>/dev/null)) || return $?
    IFS=$si
    if [ -n "$reply" ]; then
        _describe '{{binName}}' reply
    fi
  }
  compdef {{funcName}} {{binName}}
fi
''';

const _fishTemplate = '''
if type complete &>/dev/null && [ (complete -c {{binName}} | wc -l) -eq 0 ]; then
  complete -c {{binName}} -f -a "({{binName}} completion -- (commandline -opc) (commandline -t))"
fi
''';

const _nushellTemplate = r'''
def "{{funcName}}" [context: string, offset: int] {
  let cursor_str = ($context | str substring ..$offset)
  let is_trailing_space = ($cursor_str | str ends-with " ")
  let words = ($cursor_str | split row ' ' | where { |it| $it != "" })
  let final_words = if $is_trailing_space { $words | append "" } else { $words }

  with-env {
    COMP_LINE: $context,
    COMP_POINT: ($offset | into string)
  } {
    {{binName}} completion -- ...$final_words | lines
  }
}

export extern "{{binName}}" [
  ...args: string@"{{funcName}}"
]
''';
