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

List<String> kvReadStringList(String module, String key) {
  String? json =
      serviceLocator<SharedPreferences>().getString('data-' + module);
  if (json == null) {
    json = "{}";
  }
  Map object = jsonDecode(json);
  List<String> items = [];
  if (object[key] is List) {
    for (var item in object[key]) {
      if (item is String) {
        items.add(item);
      }
    }
  }
  return items;
}

kvWriteTimeOfDay(String module, String key, TimeOfDay value) {
  String? json =
      serviceLocator<SharedPreferences>().getString('data-' + module);
  if (json == null) {
    json = "{}";
  }
  Map object = jsonDecode(json);
  object[key] = {
    "hour": value.hour,
    "minute": value.minute,
  };
  json = jsonEncode(object);
  serviceLocator<SharedPreferences>().setString('data-' + module, json);
}

TimeOfDay? kvReadTimeOfDay(String module, String key) {
  String? json =
      serviceLocator<SharedPreferences>().getString('data-' + module);
  if (json == null) {
    json = "{}";
  }
  Map object = jsonDecode(json);
  if (object[key] is Map) {
    if (object[key]["hour"] is int && object[key]["minute"] is int) {
      return TimeOfDay(
          hour: object[key]["hour"], minute: object[key]["minute"]);
    }
  }
  return null;
}
