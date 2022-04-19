import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:markdown/markdown.dart' as md;
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:hea/models/content/page.dart';
import 'package:hea/models/content/lesson.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class LessonScreen extends StatefulWidget {
  final Lesson lesson;
  final List<Page> pages;
  final Color gradient1;
  final Color gradient2;

  const LessonScreen(
      {Key? key,
      required this.lesson,
      required this.pages,
      required this.gradient1,
      required this.gradient2})
      : super(key: key);

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  final PageController _pages = PageController();

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  Widget createPage(BuildContext context, Page card) {
    final markdownStyleSheet = MarkdownStyleSheet(
        p: Theme.of(context).textTheme.bodyText1,
        h1: Theme.of(context).textTheme.headline3);

    return Padding(
      padding: const EdgeInsets.fromLTRB(18.0, 0.0, 18.0, 5.0),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: MarkdownBody(
                    data: card.text,
                    extensionSet: md.ExtensionSet.gitHubFlavored,
                    styleSheet: markdownStyleSheet),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(150),
            child: SafeArea(
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          IconButton(
                              iconSize: 38,
                              icon: FaIcon(FontAwesomeIcons.arrowLeft,
                                  color: widget.gradient1),
                              onPressed: () {
                                Navigator.of(context).pop();
                              }),
                          const SizedBox(width: 10.0),
                          Expanded(
                              child: Text(widget.lesson.title,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style:
                                      Theme.of(context).textTheme.headline1)),
                        ])))),
        body: SafeArea(
            child: Column(
          children: [
            Flexible(
              child: PageView(
                controller: _pages,
                children:
                    widget.pages.map((e) => createPage(context, e)).toList(),
              ),
            ),
            SmoothPageIndicator(
                controller: _pages,
                effect: ExpandingDotsEffect(
                    activeDotColor: widget.gradient1,
                    dotColor: const Color(0xFFF0F0F0)),
                count: widget.pages.length),
          ],
        )));
  }
}
