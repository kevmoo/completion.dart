import 'package:checks/checks.dart';
import 'package:completion/completion.dart';
import 'package:test/scaffolding.dart';

void main() {
  test('golden test for completion script', () {
    final script = generateCompletionScript(['my_app'], shell: Shell.bash);

    check(script)
      ..contains('###-begin-my_app-completion-###')
      ..contains('###-for-bash-###')
      ..contains('complete -F __my_app_completion my_app')
      ..not((it) => it.contains('###-for-zsh-###'))
      ..not((it) => it.contains('###-for-fish-###'))
      ..contains('###-end-my_app-completion-###');
  });

  test('generate script for specific shell', () {
    final script = generateCompletionScript(['my_app'], shell: Shell.fish);

    check(script)
      ..contains('###-begin-my_app-completion-###')
      ..not((it) => it.contains('###-for-bash-###'))
      ..not((it) => it.contains('###-for-zsh-###'))
      ..contains('###-for-fish-###')
      ..contains('complete -c my_app -f -a')
      ..contains('###-end-my_app-completion-###');
  });

  test('generate script for nushell', () {
    final script = generateCompletionScript(['my_app'], shell: Shell.nushell);

    check(script)
      ..contains('###-begin-my_app-completion-###')
      ..not((it) => it.contains('###-for-bash-###'))
      ..not((it) => it.contains('###-for-zsh-###'))
      ..not((it) => it.contains('###-for-fish-###'))
      ..contains('###-for-nushell-###')
      ..contains('let __my_app_completion = {|spans|')
      ..contains(r'mut config = ($env.config | default {})')
      ..contains(
        r'$config = ($config | upsert completions.external.enable true)',
      )
      ..contains(
        r'$config.completions.external.completer = $__my_app_completion',
      )
      ..contains('###-end-my_app-completion-###');
  });
}
