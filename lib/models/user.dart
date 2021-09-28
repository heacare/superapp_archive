class User {
  late String id;
  late String name;
  late DateTime birthday;
  late num height;
  late num weight;
  late String country;
  late String icon;
  late Map<String, String> onboardingResponses;

  num get bmi {
    return weight / (height * height);
  }
}