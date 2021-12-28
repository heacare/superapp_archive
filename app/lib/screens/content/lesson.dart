import 'dart:developer';

import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hea/models/content/module.dart';
import 'package:hea/models/content/lesson.dart';
import 'package:hea/screens/content/page.dart';
import 'package:hea/services/content_service.dart';
import 'package:hea/services/service_locator.dart';
import 'package:hea/widgets/navigable_text.dart';

class LessonsScreen extends StatefulWidget {
  final Module module;

  const LessonsScreen({Key? key, required this.module}) : super(key: key);

  @override
  State<LessonsScreen> createState() => _LessonsScreenState();
}

class _LessonsScreenState extends State<LessonsScreen> {
  Widget loaded(BuildContext context, List<Lesson> lessons) {
    return Scaffold(
        body: ColorfulSafeArea(
            color: Theme.of(context).colorScheme.primary,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                      child: NavigableText(
                          onPressed: () => Navigator.of(context).pop(),
                          text: widget.module.title),
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 16.0)),
                  Expanded(
                      child: ListView.separated(
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(height: 8.0);
                    },
                    padding: const EdgeInsets.all(16.0),
                    itemCount: lessons.length,
                    itemBuilder: (context, index) {
                      final lesson = lessons[index];

                      return Card(
                        child: InkWell(
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      PagesScreen(lesson: lesson))),
                          child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          lesson.title,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline2!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  height: 1.0),
                                          softWrap: true,
                                        ),
                                      ),
                                      Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const SizedBox(width: 16.0),
                                            Icon(Icons.access_time_outlined,
                                                color: Colors.grey[600],
                                                size: 18.0),
                                            const SizedBox(width: 4.0),
                                            // TODO Pull from chapter model
                                            Text("5 mins",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1!
                                                    .copyWith(
                                                        height: 1.0,
                                                        color:
                                                            Colors.grey[600]))
                                          ])
                                    ],
                                  ),
                                  const SizedBox(height: 8.0),
                                  Text("Sleep 1XX",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .headline1!
                                              .color,
                                          fontWeight: FontWeight.bold))
                                ],
                              )),
                        ),
                        color: Colors.grey[200],
                      );
                    },
                  ))
                ])));
  }

  @override
  Widget build(BuildContext context) {
    return FutureProvider<List<Lesson>>(
        initialData: const [],
        create: (_) =>
            serviceLocator<ContentService>().getLessons(widget.module.id),
        child: Consumer<List<Lesson>>(
            builder: (context, lessons, _) => loaded(context, lessons)),
        catchError: (context, error) {
          log("$error");
          log("${StackTrace.current}");
          return [];
        });
  }
}
