import 'package:firebase_database/firebase_database.dart';

class OnboardingTemplate {

  static List<OnboardingTemplate>? _templates;

  final String title;
  final String? subtitle;
  final String? imageId;
  final List<OnboardingTemplateInput> inputs;
  final List<OnboardingTemplateOption> options;
  final String? text;

  OnboardingTemplate(this.title, this.subtitle, this.imageId, this.inputs,
      this.options, this.text);

  static List<OnboardingTemplate> fetchTemplates() {

    if (_templates == null) {
      // Fetch from Firebase
      final ref = FirebaseDatabase.instance.reference();
      ref.once().then((data) => print("data = ${data}"));
      ref.child("test").push().set("1111");
      // _templates = List.unmodifiable([1,2,3]);
      return [];
    }

    return _templates!;
  }
}

class OnboardingTemplateInput {
  final Map<String, String> text;
  final Map<String, String> type;

  OnboardingTemplateInput(this.text, this.type);
}

class OnboardingTemplateOption {
  final Map<String, String> text;
  final Map<String, String> nextTemplate;

  OnboardingTemplateOption(this.text, this.nextTemplate);
}
