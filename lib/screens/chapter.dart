import 'package:flutter/material.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:hea/models/chapter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ChapterScreen extends StatefulWidget {
  final Chapter chapter;

  const ChapterScreen({required this.chapter});

  @override
  State<ChapterScreen> createState() => _ChapterScreenState();
}

class _ChapterScreenState extends State<ChapterScreen> {
  final markdownStyleSheet =
      MarkdownStyleSheet(p: const TextStyle(fontSize: 24.0));

  final PageController _cards = PageController();

  @override
  void dispose() {
    _cards.dispose();
    super.dispose();
  }

  Widget createCard(BuildContext context, String content) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 60.0, 8.0, 60.0),
      child: Card(
          margin: const EdgeInsets.all(8.0),
          borderOnForeground: true,
          elevation: 8.0,
          child: Markdown(
              data: content.replaceAll("<br>", "\n\n"),
              extensionSet: md.ExtensionSet.gitHubFlavored,
              styleSheet: markdownStyleSheet)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.chapter.title),
        ),
        body: Center(
            child: Column(
          children: [
            Flexible(
              child: PageView(
                controller: _cards,
                children: widget.chapter.content
                    .map((e) => createCard(context, e))
                    .toList(),
              ),
            ),
            SmoothPageIndicator(
                controller: _cards, count: widget.chapter.content.length),
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: OutlinedButton(
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(widget.chapter.callToAction,
                            style: const TextStyle(fontSize: 18.0))),
                    onPressed: () {
                      throw "Unimplemented";
                    }))
          ],
        )));
  }
}
