import 'dart:convert';

class Log {
  final String key;
  final String value;

  Log(this.key, this.value);
  Log.fromDynamic(this.key, dynamic value) : value = json.encode(value);

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'value': value,
    };
  }
}
