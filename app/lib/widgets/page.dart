import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:hea/widgets/select_list.dart';
import 'package:hea/widgets/gradient_button.dart';
import 'package:hea/services/service_locator.dart';
import 'package:hea/pages/sleep/lookup.dart';

abstract class Page extends StatelessWidget {
  abstract final String title;

  const Page({Key? key}) : super(key: key);

  abstract final PageBuilder? nextPage;
  abstract final PageBuilder? prevPage;

  Widget buildPage(BuildContext context);

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
                            icon: const FaIcon(FontAwesomeIcons.times,
                                color: Color(0xFF00ABE9)),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                        SizedBox(width: 10.0),
                        Expanded(
                            child: Text(title,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: Theme.of(context).textTheme.headline1)),
                        if (prevPage != null)
                          IconButton(
                              iconSize: 24,
                              icon: const FaIcon(FontAwesomeIcons.undo,
                                  color: Color(0xFF00ABE9)),
                              onPressed: () {
                                Page prev = prevPage!();
                                String? s = sleep.rlookup(prev.runtimeType);
                                print(s);
                                if (s != null) {
                                  serviceLocator<SharedPreferences>()
                                      .setString('sleep', s);
                                }
                                Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute<void>(
                                  builder: (BuildContext context) => prev,
                                ));
                              }),
                      ])))),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(18.0, 0.0, 18.0, 5.0),
        child: SingleChildScrollView(
          child: buildPage(context),
        ),
      )),
      floatingActionButton: nextPage == null
          ? null
          : FloatingActionButton(
              onPressed: () {
                Page next = nextPage!();
                String? s = sleep.rlookup(next.runtimeType);
                print(s);
                if (s != null) {
                  serviceLocator<SharedPreferences>().setString('sleep', s);
                }
                Navigator.of(context).pushReplacement(MaterialPageRoute<void>(
                  builder: (BuildContext context) => next,
                ));
              },
              tooltip: 'Next',
              backgroundColor: Color(0xFF00ABE9),
              child: Icon(FontAwesomeIcons.arrowRight,
                  color: Theme.of(context).colorScheme.onPrimary),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

abstract class MarkdownPage extends Page {
  abstract final String markdown;
  abstract final Image? image;

  const MarkdownPage({Key? key}) : super(key: key);

  @override
  Widget buildPage(BuildContext context) {
    final markdownStyleSheet = MarkdownStyleSheet(
        p: Theme.of(context).textTheme.bodyText1,
        h1: Theme.of(context).textTheme.headline3);
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (image != null) image!,
          if (image != null) SizedBox(height: 4.0),
          MarkdownBody(
              data: markdown,
              extensionSet: md.ExtensionSet.gitHubFlavored,
              styleSheet: markdownStyleSheet),
        ]);
  }
}

abstract class MultipleChoicePage extends Page {
  abstract final String markdown;
  abstract final Image? image;

  abstract final int maxChoice;
  abstract final List<SelectListItem<String>> choices;

  const MultipleChoicePage({Key? key}) : super(key: key);

  @override
  Widget buildPage(BuildContext context) {
    final markdownStyleSheet = MarkdownStyleSheet(
        p: Theme.of(context).textTheme.bodyText1,
        h1: Theme.of(context).textTheme.headline3);
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (image != null) image!,
          if (image != null) SizedBox(height: 4.0),
          if (markdown != "")
            MarkdownBody(
                data: markdown,
                extensionSet: md.ExtensionSet.gitHubFlavored,
                styleSheet: markdownStyleSheet),
          if (markdown != "") SizedBox(height: 4.0),
          SelectList(
              items: choices,
              max: maxChoice,
              onChange: (List<String> c) {
                // TODO: Save value
                print(c);
              }),
        ]);
  }
}
