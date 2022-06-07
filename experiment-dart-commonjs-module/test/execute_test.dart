import 'package:test/test.dart';

import 'package:experiment_dart_commonjs_module/execute.dart';

void main() {
  test('execute basic', () {
    assert(execute('hello') == 'hellohello');
  });
}
