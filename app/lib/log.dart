import 'package:flutter/foundation.dart' show debugPrint, kDebugMode;

void _logString(String type, dynamic object) {
  if (object is String) {
    debugPrint("$type: $object");
  } else {
    debugPrint("$type: $object");
  }
}

void logD(dynamic o) {
  if (kDebugMode) {
    _logString("DEBUG", o);
  }
}

void logW(dynamic o) {
  _logString("WARNING", o);
}
