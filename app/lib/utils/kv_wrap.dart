import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:hea/services/service_locator.dart';

dynamic kvDump(String module) {
  String? json =
      serviceLocator<SharedPreferences>().getString('data-' + module);
  json ??= "{}";
  return jsonDecode(json);
}

kvWrite<T>(String module, String key, T value) {
  String? json =
      serviceLocator<SharedPreferences>().getString('data-' + module);
  json ??= "{}";
  Map object = jsonDecode(json);
  object[key] = value;
  json = jsonEncode(object);
  serviceLocator<SharedPreferences>().setString('data-' + module, json);
}

T? kvDelete<T>(String module, String key) {
  String? json =
      serviceLocator<SharedPreferences>().getString('data-' + module);
  json ??= "{}";
  Map object = jsonDecode(json);
  object.remove(key);
  json = jsonEncode(object);
  serviceLocator<SharedPreferences>().setString('data-' + module, json);
  return null;
}

T? kvRead<T>(String module, String key) {
  String? json =
      serviceLocator<SharedPreferences>().getString('data-' + module);
  json ??= "{}";
  Map object = jsonDecode(json);
  dynamic v = object[key];
  if (v is T) {
    return v;
  }
  return null;
}

int? kvReadInt(String module, String key) {
  return kvRead<int>(module, key);
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
  kvWrite(module, key, JTimeOfDay.from(value).toJson());
}

TimeOfDay? kvReadTimeOfDay(String module, String key) {
  dynamic v = kvRead(module, key);
  if (v is Map<String, dynamic>) {
    return JTimeOfDay.fromJson(v);
  }
  return null;
}

kvWriteTimeOfDayRange(String module, String key, TimeOfDayRange value) {
  kvWrite(module, key, value.toJson());
}

class JTimeOfDay extends TimeOfDay {
  JTimeOfDay.from(TimeOfDay timeOfDay)
      : super(hour: timeOfDay.hour, minute: timeOfDay.minute);
  JTimeOfDay.fromJson(Map<String, dynamic> json)
      : super(hour: json["hour"], minute: json["minute"]);
  toJson() => {
        "hour": hour,
        "minute": minute,
      };
}

class TimeOfDayRange {
  final JTimeOfDay start;
  final JTimeOfDay end;
  TimeOfDayRange(TimeOfDay start, TimeOfDay end)
      : start = JTimeOfDay.from(start),
        end = JTimeOfDay.from(end);
  TimeOfDayRange.fromJson(Map<String, dynamic> json)
      : start = JTimeOfDay.fromJson(json["start"]),
        end = JTimeOfDay.fromJson(json["end"]);
  toJson() => {
        "start": start.toJson(),
        "end": end.toJson(),
      };
}

TimeOfDayRange? kvReadTimeOfDayRange(String module, String key) {
  dynamic v = kvRead(module, key);
  if (v is Map<String, dynamic>) {
    return TimeOfDayRange.fromJson(v);
  }
  return null;
}
