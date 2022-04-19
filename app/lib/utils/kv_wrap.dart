import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:hea/services/service_locator.dart';

dynamic kvDump(String module) {
  String? json =
      serviceLocator<SharedPreferences>().getString('data-' + module);
  if (json == null) {
    json = "{}";
  }
  return jsonDecode(json);
}

kvWrite<T>(String module, String key, T value) {
  String? json =
      serviceLocator<SharedPreferences>().getString('data-' + module);
  if (json == null) {
    json = "{}";
  }
  Map object = jsonDecode(json);
  object[key] = value;
  json = jsonEncode(object);
  serviceLocator<SharedPreferences>().setString('data-' + module, json);
}

T kvRead<T>(String module, String key) {
  String? json =
      serviceLocator<SharedPreferences>().getString('data-' + module);
  if (json == null) {
    json = "{}";
  }
  Map object = jsonDecode(json);
  return object[key];
}

int? kvReadInt(String module, String key) {
  dynamic v = kvRead(module, key);
  if (v is int) {
    return v;
  }
  return null;
}

List<String> kvReadStringList(String module, String key) {
  dynamic v = kvRead(module, key);
  List<String> items = [];
  if (v is List) {
    for (var item in v) {
      if (item is String) {
        items.add(item);
      }
    }
  }
  return items;
}

kvWriteTimeOfDay(String module, String key, TimeOfDay value) {
  kvWrite(module, key, _TimeOfDay.from(value).toJSON());
}

TimeOfDay? kvReadTimeOfDay(String module, String key) {
  dynamic v = kvRead(module, key);
  if (v is Map<String, dynamic>) {
    return _TimeOfDay.fromJSON(v);
  }
  return null;
}

kvWriteTimeOfDayRange(String module, String key, TimeOfDayRange value) {
  kvWrite(module, key, value.toJSON());
}

class _TimeOfDay extends TimeOfDay {
  _TimeOfDay.from(TimeOfDay timeOfDay)
      : super(hour: timeOfDay.hour, minute: timeOfDay.minute);
  _TimeOfDay.fromJSON(Map<String, dynamic> json)
      : super(hour: json["hour"], minute: json["minute"]);
  toJSON() => {
        "hour": hour,
        "minute": minute,
      };
}

class TimeOfDayRange {
  final _TimeOfDay start;
  final _TimeOfDay end;
  TimeOfDayRange(TimeOfDay start, TimeOfDay end)
      : start = _TimeOfDay.from(start),
        end = _TimeOfDay.from(end);
  TimeOfDayRange.fromJSON(Map<String, dynamic> json)
      : start = _TimeOfDay.fromJSON(json["start"]),
        end = _TimeOfDay.fromJSON(json["end"]);
  toJSON() => {
        "start": start.toJSON(),
        "end": end.toJSON(),
      };
}

TimeOfDayRange? kvReadTimeOfDayRange(String module, String key) {
  dynamic v = kvRead(module, key);
  if (v is Map<String, dynamic>) {
    return TimeOfDayRange.fromJSON(v);
  }
  return null;
}
