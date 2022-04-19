// ignore_for_file: constant_identifier_names

import 'package:flutter/foundation.dart';

enum AlcoholFrequency {
  NotAtAll,
  OnceAMonth,
  OnceAWeek,
  FewTimesAWeek,
  Everyday
}

enum Gender { Male, Female, Others }

enum Outlook { Positive, Negative, Soulless }

enum MaritalStatus { Single, Married, Widowed, Divorced }

enum SmokingPacks { LessOnePack, OneToTwoPacks, ThreeToFivePacks, FivePacks }

T toOnboardingType<T>(String str, Iterable<T> values) {
  return values.firstWhere((e) => describeEnum(e!) == str);
}
