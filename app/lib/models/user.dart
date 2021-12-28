import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:health/health.dart';
import 'onboarding_types.dart';

class User extends ChangeNotifier {
  String authId = "";
  String icon = ""; // TODO: Missing icon field in backend entity
  String name = "";
  Gender gender = Gender.Male;
  DateTime birthday = DateTime.now();
  num height = 0;
  num weight = 0;
  String country = "";
  List<HealthDataPoint> healthData = [];

  // Onboarding responses
  bool isSmoker = false;

  // TODO Smoking is broken for old onboarding
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
    int age = now.year - birthday.year;
    if (now.month < birthday.month ||
        (now.month == birthday.month && now.day < birthday.day)) {
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
        // TODO: Missing icon field in backend entity
        icon = "",
        name = data["name"]! as String,
        gender = toOnboardingType(data["gender"]!, Gender.values),
        birthday = DateTime.parse(data["birthday"]!),
        height = data["height"]!,
        weight = data["weight"]!,
        country = data["country"]! as String,
        // TODO: Incompatible type with backend entity
        healthData = [],
        isSmoker = data["isSmoker"]! as bool,
        alcoholFreq =
            toOnboardingType(data["alcoholFreq"]!, AlcoholFrequency.values),
        outlook = toOnboardingType(data["outlook"]!, Outlook.values),
        maritalStatus =
            toOnboardingType(data["maritalStatus"]!, MaritalStatus.values),
        familyHistory = data["familyHistory"]!,
        birthControl = data["birthControl"]! {
    // Only guaranteed to be non-null for a smoker
    if (isSmoker) {
      smokingPacksPerDay =
          toOnboardingType(data["smokingPacksPerDay"]!, SmokingPacks.values);
      smokingYears = data["smokingYears"]!;
    }
  }

  Map<String, dynamic> toJson() {
    var json = {
      'authId': authId,
      'name': name,
      // TODO: Missing icon field in backend entity
      // 'icon': icon,
      'gender': describeEnum(gender),
      'birthday': birthday.toIso8601String(),
      'height': height,
      'weight': weight,
      'country': country,
      'healthData': healthData.map((e) => e.toJson()).toList(),
      'isSmoker': isSmoker,
      'smoking': null,
      'alcoholFreq': describeEnum(alcoholFreq),
      'outlook': describeEnum(outlook),
      'maritalStatus': describeEnum(maritalStatus),
      'familyHistory': familyHistory,
      'birthControl': birthControl
    };
    if (isSmoker) {
      json.update('smoking',
          (_) => {'packsPerDay': smokingPacksPerDay, "years": smokingYears});
    }

    return json;
  }
}
