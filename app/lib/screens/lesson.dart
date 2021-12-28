import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:hea/models/content_card.dart';
import 'package:hea/widgets/firebase_svg.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:hea/models/chapter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class LessonScreen extends StatefulWidget {
  final Chapter chapter;
  final Color gradient1;
  final Color gradient2;

  const LessonScreen(
      {Key? key,
      required this.chapter,
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

  Widget createPage(BuildContext context, ContentCard card) {
    final markdownStyleSheet =
        MarkdownStyleSheet(p: Theme.of(context).textTheme.bodyText1);

    return Padding(
      padding: const EdgeInsets.fromLTRB(18.0, 0.0, 18.0, 5.0),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 300,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: Color(0xFFF0F0F0)),
              ),
              SizedBox(height: 30.0),
              Flexible(
                child: MarkdownBody(
                    data: card.text.replaceAll("<br>", "\n\n"),
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
                          SizedBox(width: 10.0),
                          Expanded(
                              child: Text(widget.chapter.title,
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
                children: widget.chapter.content
                    .map((e) => createPage(context, e))
                    .toList(),
              ),
            ),
            SmoothPageIndicator(
                controller: _pages,
                effect: ExpandingDotsEffect(
                    activeDotColor: widget.gradient1,
                    dotColor: Color(0xFFF0F0F0)),
                count: widget.chapter.content.length),
          ],
        )));
  }
}
