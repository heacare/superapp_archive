import 'package:flutter/foundation.dart' show debugPrint, kDebugMode;

void _logString(final String type, final dynamic object) {
  if (object is String) {
    debugPrint('$type: $object');
  } else {
    debugPrint('$type: $object');
  }
}

void logD(final dynamic o) {
  if (kDebugMode) {
    _logString('DEBUG', o);
  }
}

void logW(final dynamic o) {
  _logString('WARNING', o);
}
