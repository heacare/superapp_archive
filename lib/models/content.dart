import 'package:hea/models/chapter.dart';

class Content {
  final num id;
  final String title;
  final String icon;
  final List<Chapter> chapters;

  Content({required this.id, required this.title, required this.icon, required this.chapters});

  Content.fromJson(Map<String, dynamic> json, String id) :
      this(
          id: num.parse(id),
          title: json["title"]! as String,
          icon: json["icon"]! as String,
          chapters: json["subchapters"].map((e) => Chapter.fromJson(e)).toList()
      );

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'icon': icon,
      'chapters': chapters.map((c) => c.toJson()).toList()
    };
  }
}