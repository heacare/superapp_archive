  import 'package:flutter/material.dart';

import 'package:hea/screens/chapter.dart';
import 'package:hea/models/content.dart';

class ContentScreen extends StatefulWidget {
  final Content content;

  const ContentScreen({Key? key, required this.content}) : super(key: key);

  @override
  State<ContentScreen> createState() => _ContentScreenState();
}

class _ContentScreenState extends State<ContentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child:  ListView.builder(
                itemCount: widget.content.chapters.length,
                itemBuilder: (context, index) {
                  final chapter = widget.content.chapters[index];

                  return TextButton(
                      child: ListTile(
                        leading: const Icon(Icons.bookmark),
                        title: Text(chapter.title),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                ChapterScreen(chapter: chapter)));
                      });
                },
            )
        )
    );
  }
}
