import 'dart:developer';
import 'package:flutter/cupertino.dart' hide Page;
import 'package:flutter/material.dart' hide Page;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:hea/services/content_service.dart';
import 'package:hea/services/service_locator.dart';
import 'package:hea/models/content/page.dart';
import 'package:hea/widgets/firebase_svg.dart';
import 'package:hea/models/content/lesson.dart';

class PagesScreen extends StatefulWidget {
  final Lesson lesson;

  const PagesScreen({Key? key, required this.lesson}) : super(key: key);

  @override
  State<PagesScreen> createState() => _PagesScreenState();
}

class _PagesScreenState extends State<PagesScreen> {
  final markdownStyleSheet =
      MarkdownStyleSheet(p: const TextStyle(fontSize: 18.0));

  final PageController _cards = PageController();

  @override
  void dispose() {
    _cards.dispose();
    super.dispose();
  }

  Widget createCard(BuildContext context, Page card) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18.0, 40.0, 18.0, 40.0),
      child: Card(
          margin: const EdgeInsets.all(8.0),
          borderOnForeground: true,
          elevation: 8.0,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                      height: 200,
                      child: FirebaseSvg("content/" + card.icon).load()),
                  Flexible(
                    child: MarkdownBody(
                        data: card.text.replaceAll("<br>", "\n\n"),
                        extensionSet: md.ExtensionSet.gitHubFlavored,
                        styleSheet: markdownStyleSheet),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Widget loaded(BuildContext context, List<Page> pages) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.lesson.title),
        ),
        body: Center(
            child: Column(
          children: [
            Flexible(
              child: PageView(
                controller: _cards,
                children: pages.map((e) => createCard(context, e)).toList(),
              ),
            ),
            SmoothPageIndicator(
                controller: _cards,
                effect: SlideEffect(
                    activeDotColor: Theme.of(context).colorScheme.secondary),
                count: pages.length),
            Padding(
                padding: const EdgeInsets.all(16.0),
                child: OutlinedButton(
                    child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Call to action",
                            style: TextStyle(fontSize: 18.0))),
                    onPressed: () {
                      throw "Unimplemented";
                    }))
          ],
        )));
  }

  @override
  Widget build(BuildContext context) {
    return FutureProvider<List<Page>>(
      initialData: const [],
      create: (_) =>
          serviceLocator<ContentService>().getPages(widget.lesson.id),
      child: Consumer<List<Page>>(
          builder: (context, pages, _) => loaded(context, pages)),
      catchError: (context, error) {
        log("$error");
        log("${StackTrace.current}");
        return [];
      },
    );
  }
}
