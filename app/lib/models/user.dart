import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:health/health.dart';
import 'onboarding_types.dart';

class User extends ChangeNotifier {
  String authId = "";
  String name = "";
  Gender gender = Gender.Male;
  Timestamp birthday = Timestamp.now();
  num height = 0;
  num weight = 0;
  String country = "";
  String icon = ""; // TODO: Missing icon field in backend entity
  List<HealthDataPoint> healthData = [];

  // Onboarding responses
  bool isSmoker = false;
  SmokingPacks? smokingPacksPerDay;
  num? smokingYears;
  AlcoholFrequency alcoholFreq = AlcoholFrequency.NotAtAll;
  Outlook outlook = Outlook.Positive;
  MaritalStatus maritalStatus = MaritalStatus.Single;
  String familyHistory = "";
  String birthControl = "";

  num get bmi {
    return weight / (height * height);
  }

  num get age {
    DateTime now = DateTime.now();
    DateTime birthdayDt = birthday.toDate();
    int age = now.year - birthdayDt.year;
    if (now.month < birthdayDt.month ||
        (now.month == birthdayDt.month && now.day < birthdayDt.day)) {
      age--;
    }

    return age;
  }

  User([this.authId = ""]);

  User.placeholder()
      : authId = "",
        name = "Test User",
        height = 2,
        weight = 100,
        country = "SG",
        isSmoker = true,
        smokingPacksPerDay = SmokingPacks.FivePacks,
        smokingYears = 10,
        familyHistory = "Family History",
        birthControl = "Birth Control";

  User.fromJson(Map<String, dynamic> data)
      : authId = data["authId"]! as String,
        name = data["name"]! as String,
        gender = toOnboardingType(data["gender"]!, Gender.values),
        birthday = Timestamp.fromDate(DateTime.parse(data["birthday"]!)),
        height = data["height"]!,
        weight = data["weight"]!,
        country = data["country"]! as String,
        // TODO: Missing icon field in backend entity
        icon = "",
        // TODO: Incompatible type with backend entity
        healthData = [],
        isSmoker = data["isSmoker"]! as bool,
        smokingPacksPerDay =
            toOnboardingType(data["smokingPacksPerDay"]!, SmokingPacks.values),
        smokingYears = data["smokingYears"]!,
        alcoholFreq =
            toOnboardingType(data["alcoholFreq"]!, AlcoholFrequency.values),
        outlook = toOnboardingType(data["outlook"]!, Outlook.values),
        maritalStatus =
            toOnboardingType(data["maritalStatus"]!, MaritalStatus.values),
        familyHistory = data["familyHistory"]!,
        birthControl = data["birthControl"];

  Map<String, dynamic> toJson() {
    return {
      'id': authId,
      'gender': gender,
      'name': name,
      'birthday': birthday,
      'height': height,
      'weight': weight,
      'country': country,
      'icon': icon,
      'healthData': healthData.map((e) => e.toJson()).toList()
    };
  }
}
