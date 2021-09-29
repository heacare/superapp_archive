class User {
  final String id;
  final String gender;
  final String name;
  final DateTime birthday;
  final num height;
  final num weight;
  final String country;
  final String icon;
  final Map<String, String> onboardingResponses;

  num get bmi {
    return weight / (height * height);
  }

  User(this.id, this.gender, this.name, this.birthday, this.height, this.weight, this.country, this.icon, this.onboardingResponses);

  // TODO: Remove once connector is up
  User.testUser() :
    id = "id",
    gender = Gender.male.toString(),
    name = "name",
    birthday = DateTime.now(),
    height = 169,
    weight = 42.0,
    country = "Alaska",
    icon = "default_icon_id",
    onboardingResponses = {};

  User.fromJson(Map<String, dynamic> data) :
    id = data["id"]! as String,
    gender = data["gender"]! as String,
    name = data["name"]! as String,
    birthday = data["birthday"]! as DateTime,
    height = data["height"]! as num,
    weight = data["weight"]! as num,
    country = data["country"]! as String,
    icon = data["icon"]! as String,
    onboardingResponses = data["onboardingResponses"]! as Map<String, String>;

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
  static const others = Gender._internal("Others");

  static const genderList = [male, female, others];
}