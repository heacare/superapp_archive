import 'dart:developer';

import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';

import 'package:hea/models/content/module.dart';
import 'package:hea/screens/content/lesson.dart';
import 'package:hea/services/content_service.dart';
import 'package:hea/services/service_locator.dart';
import 'package:provider/provider.dart';

class ModulesScreen extends StatefulWidget {
  const ModulesScreen({Key? key}) : super(key: key);

  @override
  State<ModulesScreen> createState() => _ModulesScreenState();
}

class _ModulesScreenState extends State<ModulesScreen> {
  Widget loaded(BuildContext context, List<Module> modules) {

    return Expanded(
        child: ListView.separated(
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(height: 8.0);
            },
            padding: const EdgeInsets.all(16.0),
            itemCount: modules.length,
            itemBuilder: (context, index) {
              final module = modules[index];

              return Card(
                child: InkWell(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => LessonsScreen(module: module))),
                  child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                  child: Text(module.title,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline2!
                                          .copyWith(
                                              fontWeight: FontWeight.bold))),
                              const SizedBox(width: 16.0),
                              Container(
                                child: const Padding(
                                    child: Text("+5 years",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                            height: 1.0)),
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 16.0)),
                                decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    borderRadius: BorderRadius.circular(16.0)),
                              )
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          // TODO Pull from content model
                          const Text("Lorem Ipsum")
                        ],
                      )),
                ),
                color: Colors.grey[200],
              );
            }));
  }

  @override
  Widget build(BuildContext context) {
    final moduleListView = FutureProvider<List<Module>>(
      initialData: const [],
      create: (_) => serviceLocator<ContentService>().getModules(),
      child: Consumer<List<Module>>(
        builder: (context, modules, _) => loaded(context, modules)
      ),
      catchError: (context, error) {
        log("$error");
        log("${StackTrace.current}");
        return [];
      },
    );

    return Scaffold(
        body: ColorfulSafeArea(
            color: Theme.of(context).colorScheme.primary,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                      child: Text("Content",
                          style: Theme.of(context).textTheme.headline1),
                      padding: const EdgeInsets.symmetric(
                          vertical: 16.0, horizontal: 16.0)),
                  moduleListView
                ])));
  }
}
