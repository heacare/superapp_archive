import 'content_card.dart';

class Chapter {
  final String title;
  final String icon; // TODO url or data?
  final List<ContentCard> content; // in Markdown format
  final String callToAction;

  Chapter({required this.title, required this.icon, required this.content, required this.callToAction});

  Chapter.fromJson(Map<String, dynamic> json) :
      this(
        title: json["title"]! as String,
        icon: json["icon"]! as String,
        content: (json["content"]! as List<dynamic>).map((e) => ContentCard.fromJson(e)).toList(),
        callToAction: json["callToAction"]! as String
      );

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'icon': icon,
      'content': content.map((e) => e.toJson()).toList(),
      'callToAction': callToAction,
    };
  }
}