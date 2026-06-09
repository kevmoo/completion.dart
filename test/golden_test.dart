import 'package:checks/checks.dart';
import 'package:completion/completion.dart';
import 'package:test/scaffolding.dart';

void main() {
  test('golden test for completion script', () {
    final script = generateCompletionScript(['my_app'], shell: Shell.bash);

    check(script).contains('###-begin-my_app-completion-###');
    check(script).contains('###-for-bash-###');
    check(script).contains('complete -F __my_app_completion my_app');
    check(script).not((it) => it.contains('###-for-zsh-###'));
    check(script).not((it) => it.contains('###-for-fish-###'));
    check(script).contains('###-end-my_app-completion-###');
  });

  test('generate script for specific shell', () {
    final script = generateCompletionScript(['my_app'], shell: Shell.fish);

    check(script).contains('###-begin-my_app-completion-###');
    check(script).not((it) => it.contains('###-for-bash-###'));
    check(script).not((it) => it.contains('###-for-zsh-###'));
    check(script).contains('###-for-fish-###');
    check(script).contains('complete -c my_app -f -a');
    check(script).contains('###-end-my_app-completion-###');
  });

  test('generate script for nushell', () {
    final script = generateCompletionScript(['my_app'], shell: Shell.nushell);

    check(script).contains('###-begin-my_app-completion-###');
    check(script).not((it) => it.contains('###-for-bash-###'));
    check(script).not((it) => it.contains('###-for-zsh-###'));
    check(script).not((it) => it.contains('###-for-fish-###'));
    check(script).contains('###-for-nushell-###');
    check(script).contains('let __my_app_completion = {|spans|');
    check(script).contains(r'mut config = ($env.config | default {})');
    check(script).contains(
      r'$config = ($config | upsert completions.external.enable true)',
    );
    check(script).contains(
      r'$config.completions.external.completer = $__my_app_completion',
    );
    check(script).contains('###-end-my_app-completion-###');
  });
}
