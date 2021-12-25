import 'package:hea/models/user.dart';
import 'onboarding_types.dart';

// Conditional logic for advancing some templates
Map<String, Function(User)> customNextTemplate = {
  "smoking_1": (user) {
    if (user.gender == Gender.Female) {
      if (user.age > 30) {
        return "smoking_3";
      }
      else {
        return "smoking_2";
      }
    }
    else {
      return _smoking3(user);
    }
  },
  "smoking_3": _smoking3,
  "smoking_4": _smoking4
};

_smoking3(user) {
  if (user.age < 40) {
    return "smoking_4";
  }
  else {
    return _smoking4(user);
  }
}

_smoking4(user) {
  if (user.age > 60) {
    return "smoking_5";
  }
  else {
    return "alcohol_0";
  }
}