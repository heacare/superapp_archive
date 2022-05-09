import 'dart:convert';

class Log {
  final String key;
  final DateTime date;
  final String value;

  Log(this.key, this.date, this.value);
  Log.fromDynamic(this.key, this.date, dynamic value) : value = json.encode(value);

  Map<String, dynamic> toJson() {
    return {
      'key': key,
	  'date': date.toIso8601String(),
      'value': value,
    };
  }
}
