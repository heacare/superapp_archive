import 'dart:convert';

class Log {
  final String key;
  final DateTime date;
  final String value;

  Log(this.key, this.date, this.value);
  Log.fromDynamic(this.key, this.date, dynamic value)
      : value = json.encode(value);

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'date': date.toIso8601String() + dateOffset(date.timeZoneOffset),
      'value': value,
    };
  }
}

String _twoDigits(int n) {
  if (n >= 10) return "${n}";
  return "0${n}";
}

String dateOffset(Duration offset) {
  String sign = "+";
  if (offset < Duration.zero) {
    offset = offset.abs();
    sign = "-";
  }
  int minutes = offset.inMinutes.remainder(Duration.minutesPerHour);
  int hours = offset.inMinutes ~/ Duration.minutesPerHour;
  String m = _twoDigits(minutes);
  String h = _twoDigits(hours);
  return "$sign$h:$m";
}
