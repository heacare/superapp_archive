import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:hea/services/service_locator.dart';

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
  kvWrite(module, key, {
    "hour": value.hour,
    "minute": value.minute,
  });
}

TimeOfDay? kvReadTimeOfDay(String module, String key) {
  dynamic v = kvRead(module, key);
  if (v is Map) {
    if (v["hour"] is int && v["minute"] is int) {
      return TimeOfDay(hour: v["hour"], minute: v["minute"]);
    }
  }
  return null;
}
