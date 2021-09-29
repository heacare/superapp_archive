import 'package:cloud_firestore/cloud_firestore.dart';

const databaseUrl = "https://happily-ever-after-4b2fe-default-rtdb.asia-southeast1.firebasedatabase.app";
const templateCollection = "templates";

typedef OnboardingTemplateMap = Map<String, OnboardingTemplate>;

class OnboardingTemplate {

  static OnboardingTemplateMap? _templates;

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

  static Future<OnboardingTemplateMap> fetchTemplates() async {

    if (_templates == null) {
      // Fetch from Firebase
      final templates = FirebaseFirestore.instance
          .collection(templateCollection)
          .withConverter<OnboardingTemplate>(
            fromFirestore: (snapshot, _) => OnboardingTemplate.fromJson(Map<String, dynamic>.from(snapshot.data()!)),
            // TODO: Not really needed since we shouldn't be writing any templates
            toFirestore: (template, _) => {}
          );

      await templates.get().then(
          (value) => _templates = Map.unmodifiable({ for (var doc in value.docs) doc.id: doc.data() }),
          onError: (error) => print("Error connecting to Firestore: $error")
      );

    }

    return _templates!;
  }
}

class OnboardingTemplateInput {
  final String text;
  final String type;
  final String varName;

  OnboardingTemplateInput(this.text, this.type, this.varName);

  OnboardingTemplateInput.fromJson(Map<String, dynamic> json) :
      text = json["text"],
      type = json["type"],
      varName = json["varName"];
}

class OnboardingTemplateOption {
  final String text;
  final String nextTemplate;

  OnboardingTemplateOption(this.text, this.nextTemplate);

  OnboardingTemplateOption.fromJson(Map<String, dynamic> json) :
        text = json["text"],
        nextTemplate = json["nextTemplate"];
}
