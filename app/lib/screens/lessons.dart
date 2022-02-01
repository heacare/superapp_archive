import 'dart:developer';

import 'package:flutter/material.dart' hide Page;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'package:hea/screens/lesson.dart';
import 'package:hea/models/content/module.dart';
import 'package:hea/models/content/lesson.dart';
import 'package:hea/models/content/page.dart';

import 'package:hea/services/content_service.dart';
import 'package:hea/services/service_locator.dart';

class LessonsScreen extends StatefulWidget {
  LessonsScreen(
      {Key? key,
      required this.title,
      required this.gradient1,
      required this.gradient2,
      required this.icon,
      required this.module})
      : super(key: key);

  final String title;
  final Color gradient1;
  final Color gradient2;
  final IconData icon;
  final Module module;

  @override
  State<LessonsScreen> createState() => _LessonsScreenState();
}

class _LessonsScreenState extends State<LessonsScreen> {
  @override
  Widget build(BuildContext context) {
    final lessonListView = FutureProvider<List<Lesson>>(
        initialData: const [],
        create: (_) =>
            serviceLocator<ContentService>().getLessons(widget.module.id),
        child: Consumer<List<Lesson>>(builder: (context, lessons, _) {
          return ListView.separated(
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(height: 8.0);
              },
              padding: const EdgeInsets.all(16.0),
              itemCount: lessons.length,
              itemBuilder: (context, index) {
                final lesson = lessons[index];
                return LessonListItem(
                    gradient1: widget.gradient1,
                    gradient2: widget.gradient2,
                    lesson: lesson);
              });
        }),
        catchError: (context, error) {
          log("$error");
          log("${StackTrace.current}");
          return [];
        });

    return Scaffold(
        body: Stack(children: <Widget>[
      Container(
          width: double.infinity,
          height: 300.0,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  widget.gradient1,
                  widget.gradient2,
                ]),
          ),
          child: Stack(children: <Widget>[
            Align(
                alignment: Alignment.bottomRight,
                child:
                    FaIcon(widget.icon, size: 200, color: Color(0x4DFFFFFF))),
            SafeArea(
                child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          IconButton(
                              iconSize: 38,
                              icon: FaIcon(FontAwesomeIcons.arrowLeft,
                                  color: Colors.white),
                              onPressed: () {
                                Navigator.of(context).pop();
                              }),
                          const SizedBox(height: 10.0),
                          Text("Learn about:",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline2
                                  ?.copyWith(color: Colors.white)),
                          const SizedBox(height: 5.0),
                          Text(widget.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1
                                  ?.copyWith(
                                      fontSize: 44.0, color: Colors.white)),
                        ]))),
          ])),
      Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 270),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(30.0)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5), //color of shadow
                blurRadius: 5, // blur radius
                offset: const Offset(0, 2), // changes position of shadow
              )
            ],
          ),
          child: lessonListView),
    ]));
  }
}

class LessonListItem extends StatelessWidget {
  final Lesson lesson;

  final Color gradient1;
  final Color gradient2;

  LessonListItem(
      {Key? key,
      required this.gradient1,
      required this.gradient2,
      required this.lesson})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureProvider<List<Page>>(
        initialData: const [],
        create: (_) => serviceLocator<ContentService>().getPages(lesson.id),
        child: Consumer<List<Page>>(builder: (context, pages, _) {
          return GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => LessonScreen(
                      lesson: lesson,
                      pages: pages,
                      gradient1: gradient1,
                      gradient2: gradient2))),
              child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 20.0),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFAFAFA),
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  child: Row(children: <Widget>[
                    Container(
                        margin: const EdgeInsets.only(right: 15.0),
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(16.0)),
                            color: Color(0x19000000))),
                    Expanded(
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                          Text(lesson.title,
                              style: Theme.of(context).textTheme.headline3),
                          Text("${pages.length} sections",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  ?.copyWith(color: Color(0xFF707070)))
                        ])),
                    const FaIcon(FontAwesomeIcons.arrowRight,
                        color: Color(0xFF868686), size: 18.0),
                  ])));
        }));
  }
}
