import 'package:completion/completion.dart';
import 'package:test/test.dart';

void main() {
  test('golden test for completion script', () {
    final script = generateCompletionScript(['my_app'], shell: Shell.bash);

    expect(script, contains('###-begin-my_app-completion-###'));
    expect(script, contains('###-for-bash-###'));
    expect(script, contains('complete -F __my_app_completion my_app'));
    expect(script, isNot(contains('###-for-zsh-###')));
    expect(script, isNot(contains('###-for-fish-###')));
    expect(script, contains('###-end-my_app-completion-###'));
  });

  test('generate script for specific shell', () {
    final script = generateCompletionScript(['my_app'], shell: Shell.fish);

    expect(script, contains('###-begin-my_app-completion-###'));
    expect(script, isNot(contains('###-for-bash-###')));
    expect(script, isNot(contains('###-for-zsh-###')));
    expect(script, contains('###-for-fish-###'));
    expect(script, contains('complete -c my_app -f -a'));
    expect(script, contains('###-end-my_app-completion-###'));
  });
}
