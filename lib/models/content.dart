import 'package:hea/models/chapter.dart';

class Chapter {
  final num id;
  final String title;
  final List<Chapter> chapters;

  Chapter({required this.id, required this.title, required this.chapters});
}