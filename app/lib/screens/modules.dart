import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hea/models/content/module.dart';
import 'package:hea/screens/lessons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hea/services/content_service.dart';
import 'package:hea/services/service_locator.dart';
import 'package:provider/provider.dart';

class ModulesScreen extends StatefulWidget {
  const ModulesScreen({Key? key}) : super(key: key);

  @override
  State<ModulesScreen> createState() => _ModulesScreenState();
}

class _ModulesScreenState extends State<ModulesScreen> {
  @override
  Widget build(BuildContext context) {
    final moduleListView = FutureProvider<List<Module>>(
      initialData: const [],
      create: (_) => serviceLocator<ContentService>().getModules(),
      child: Consumer<List<Module>>(builder: (context, modules, _) {
        return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ModuleListItem(
                  title: "Sleep and Recovery",
                  description:
                      "Learn about the benefits and howtos of a good night of sleep",
                  gradient1: const Color(0xFF00ABE9),
                  gradient2: const Color(0xFF7FDDFF),
                  icon: FontAwesomeIcons.solidMoon,
                  module: modules[0]),
              const SizedBox(height: 10.0),
              ModuleListItem(
                  title: "Psychosocial Health",
                  description:
                      "Bad social habits can cause a decrease in well-being",
                  gradient1: const Color(0xFFFFC498),
                  gradient2: const Color(0xFFFF7A60),
                  icon: FontAwesomeIcons.peopleArrows,
                  module: modules[1])
            ]);
      }),
      catchError: (context, error) {
        log("$error");
        log("${StackTrace.current}");
        return [];
      },
    );

    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(150),
            child: SafeArea(
                child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 30.0),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                Text("Modules",
                                    style:
                                        Theme.of(context).textTheme.headline1),
                                Text("Learn something new!",
                                    style:
                                        Theme.of(context).textTheme.headline4),
                              ])),
                          Container(
                              height: 60.0,
                              width: 60.0,
                              decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          "https://images.unsplash.com/photo-1579202673506-ca3ce28943ef"),
                                      fit: BoxFit.cover))),
                        ])))),
        body: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
            child: moduleListView));
  }
}

class ModuleListItem extends StatelessWidget {
  final String title;
  final String description;
  final Color gradient1;
  final Color gradient2;
  final IconData icon;
  final Module module;

  ModuleListItem(
      {Key? key,
      required this.title,
      required this.description,
      required this.gradient1,
      required this.gradient2,
      required this.icon,
      required this.module})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => LessonsScreen(
                title: title,
                gradient1: gradient1,
                gradient2: gradient2,
                icon: icon,
                module: module))),
        child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
            decoration: const BoxDecoration(
              color: Color(0xFFF5F5F5),
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            child: Row(children: <Widget>[
              Container(
                  margin: const EdgeInsets.only(right: 15.0),
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          gradient1,
                          gradient2,
                        ]),
                  ),
                  child: Center(child: FaIcon(icon, color: Colors.white))),
              Expanded(
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                    Text(title, style: Theme.of(context).textTheme.headline3),
                    const SizedBox(height: 5.0),
                    Text(description,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            ?.copyWith(color: Color(0xFF707070)))
                  ])),
            ])));
  }
}
