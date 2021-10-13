

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health/health.dart';

class User {
  final String id;
  final String gender;
  final String name;
  final Timestamp birthday;
  final num height;
  final num weight;
  final String country;
  final String icon;
  final Map<String, dynamic> onboardingResponses;
  final List<HealthDataPoint> healthData;

  num get bmi {
    return weight / (height * height);
  }

  num get age {
    DateTime now = DateTime.now();
    DateTime birthdayDt = birthday.toDate();
    int age = now.year - birthdayDt.year;
    if (now.month < birthdayDt.month || (now.month == birthdayDt.month && now.day < birthdayDt.day)) {
      age--;
    }

    return age;
  }

  User(this.id) :
    gender = "",
    name = "",
    birthday = Timestamp.fromDate(DateTime.now()),
    height = 0,
    weight = 0,
    country = "",
    icon = "",
    onboardingResponses = {},
    healthData = [];

  User.fromJson(Map<String, dynamic> data) :
    id = data["id"]! as String,
    gender = data["gender"]! as String,
    name = data["name"]! as String,
    birthday = data["birthday"]! as Timestamp,
    height = data["height"]! as num,
    weight = data["weight"]! as num,
    country = data["country"]! as String,
    icon = data["icon"]! as String,
    onboardingResponses = data["onboardingResponses"]! as Map<String, dynamic>,
    healthData =
      List<Map<String, dynamic>>.from(data["healthData"]!).map(
        (e) => HealthDataPoint.fromJson(e)
      ).toList();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gender': gender,
      'name': name,
      'birthday': birthday,
      'height': height,
      'weight': weight,
      'country': country,
      'icon': icon,
      'onboardingResponses': onboardingResponses,
      'healthData': healthData.map((e) => e.toJson()).toList()
    };
  }
}

//
//  Lookups for customNextTemplate in onboarding_custom.dart
//  TODO: Required until logic is moved into Firebase
//

class Gender {
  static const String male = "Male";
  static const String female = "Female";
  static const String others = "Others";
}