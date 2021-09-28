import 'package:firebase_database/firebase_database.dart';

const databaseUrl = "https://happily-ever-after-4b2fe-default-rtdb.asia-southeast1.firebasedatabase.app";

class OnboardingTemplate {

  static Map<String, OnboardingTemplate>? _templates;

  final String title;
  final String? subtitle;
  final String? imageId;
  final List<OnboardingTemplateInput> inputs;
  final List<OnboardingTemplateOption> options;
  final String? text;

  OnboardingTemplate(this.title, this.subtitle, this.imageId, this.inputs,
      this.options, this.text);

  OnboardingTemplate.fromJson(Map<String, dynamic> json) :
      title = json["title"],
      subtitle = json["subtitle"],
      imageId = json["imageId"],
      inputs = List<OnboardingTemplateInput>.from(
          (json["inputs"] ?? []).map(
              (input) => OnboardingTemplateInput.fromJson(Map<String, dynamic>.from(input))
          )
      ),
      options = List<OnboardingTemplateOption>.from(
          json["options"].map(
              (option) => OnboardingTemplateOption.fromJson(Map<String, dynamic>.from(option))
          )
      ),
      text = json["text"];

  static Future<Map<String, OnboardingTemplate>> fetchTemplates() async {

    if (_templates == null) {
      // Fetch from Firebase
      // TODO: Why the hell do I have to hardcode this? google-services.json doesn't provide the proper region URL for whatever reason
      final ref = FirebaseDatabase(databaseURL: databaseUrl).reference().child("templates");
      await ref.get().then(
        (DataSnapshot data) {
          var mappedData = Map<String, dynamic>.from(data.value).map((key, value) =>
            MapEntry(key, OnboardingTemplate.fromJson(Map<String, dynamic>.from(value)))
          );

          _templates = mappedData;
        },
        onError: (error) => print("Error connecting to Firebase Database: $error")
      );
    }

    return _templates!;
  }
}

class OnboardingTemplateInput {
  final String text;
  final String type;

  OnboardingTemplateInput(this.text, this.type);

  OnboardingTemplateInput.fromJson(Map<String, dynamic> json) :
      text = json["text"],
      type = json["type"];
}

class OnboardingTemplateOption {
  final String text;
  final String nextTemplate;

  OnboardingTemplateOption(this.text, this.nextTemplate);

  OnboardingTemplateOption.fromJson(Map<String, dynamic> json) :
        text = json["text"],
        nextTemplate = json["nextTemplate"];
}
