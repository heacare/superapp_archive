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

  static fromJson(Map<String, dynamic> data) {
    final user = User();
    user.id = data["id"]! as String;
    user.name = data["name"]! as String;
    user.birthday = data["birthday"]! as DateTime;
    user.height = data["height"]! as num;
    user.weight = data["weight"]! as num;
    user.country = data["country"]! as String;
    user.icon = data["icon"]! as String;
    user.onboardingResponses = data["onboardingResponses"]! as Map<String, String>;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
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