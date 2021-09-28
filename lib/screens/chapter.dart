import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:hea/models/chapter.dart';

class ChapterScreen extends StatelessWidget {
  final Chapter chapter;

  const ChapterScreen({ required this.chapter });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(chapter.title),
        ),
        body: Center(
          child: Column(
            children: [
              Flexible(
                child: Markdown(data: chapter.content)
              ),
              TextButton(child: Text(chapter.callToAction), onPressed: () {
                throw "Unimplemented";
              })
            ],
          )
        )
    );
  }

}