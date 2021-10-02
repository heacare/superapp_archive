

import 'package:cloud_firestore/cloud_firestore.dart';

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
    onboardingResponses = {};

  User.fromJson(Map<String, dynamic> data) :
    id = data["id"]! as String,
    gender = data["gender"]! as String,
    name = data["name"]! as String,
    birthday = data["birthday"]! as Timestamp,
    height = data["height"]! as num,
    weight = data["weight"]! as num,
    country = data["country"]! as String,
    icon = data["icon"]! as String,
    onboardingResponses = data["onboardingResponses"]! as Map<String, dynamic>;

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
    };
  }
}

class Gender {
  final String _value;
  const Gender._internal(this._value);

  @override
  toString() => _value;

  static const male = Gender._internal("Male");
  static const female = Gender._internal("Female");

  static const genderList = [male, female];
}