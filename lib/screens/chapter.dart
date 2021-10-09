import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:hea/models/chapter.dart';

class ChapterScreen extends StatelessWidget {
  final Chapter chapter;

  const ChapterScreen({required this.chapter});

  @override
  Widget build(BuildContext context) {
    var markdownStyleSheet =
        MarkdownStyleSheet(p: const TextStyle(fontSize: 16.0));

    return Scaffold(
        appBar: AppBar(
          title: Text(chapter.title),
        ),
        body: Center(
            child: Column(
          children: [
            Flexible(
                child: Markdown(
                    data: chapter.content.replaceAll("<br>", "\n\n"),
                    extensionSet: md.ExtensionSet.gitHubFlavored,
                    styleSheet: markdownStyleSheet)),
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: OutlinedButton(
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(chapter.callToAction, style: const TextStyle(fontSize: 18.0))),
                    onPressed: () {
                      throw "Unimplemented";
                    }))
          ],
        )));
  }
}
