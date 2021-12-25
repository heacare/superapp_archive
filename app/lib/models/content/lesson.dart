class Lesson {
  final int id;
  final int lessonOrder;
  final String icon;
  final String title;

  // TODO: Can be removed after integration with new UI
  final String callToAction;

  Lesson.fromJson(Map<String, dynamic> json)
      : id = int.parse(json["id"]!),
        lessonOrder = int.parse(json["unitOrder"]),
        icon = json["icon"]!,
        title = json["title"]!,
        callToAction = "Remove this";
}
