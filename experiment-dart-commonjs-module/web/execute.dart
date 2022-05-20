import 'package:js/js.dart';

import 'package:experiment_dart_commonjs_module/execute.dart';

@JS('exports.execute')
external set _execute(Function);

void main() {
  _execute = allowInterop(execute);
}
