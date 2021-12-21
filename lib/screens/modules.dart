import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:hea/models/content.dart';
import 'package:hea/data/content_repo.dart';
import 'package:hea/screens/content.dart';
import 'package:hea/screens/submodule.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

final contents = ContentRepo();

class ContentsScreen extends StatefulWidget {
  const ContentsScreen({Key? key}) : super(key: key);

  @override
  State<ContentsScreen> createState() => _ContentsScreenState();
}

class _ContentsScreenState extends State<ContentsScreen> {
  @override
  Widget build(BuildContext context) {
    final contentListView = StreamBuilder<QuerySnapshot<Content>>(
        stream: contents.getAll(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("An error occured");
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.requireData;
          return Expanded(
              child: ListView.separated(
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(height: 8.0);
                  },
                  padding: const EdgeInsets.all(16.0),
                  itemCount: data.size,
                  itemBuilder: (context, index) {
                    final content = data.docs[index].data();

                    return Card(
                      child: InkWell(
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) =>
                                    ContentScreen(content: content))),
                        child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                        child: Text(content.title,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline2!
                                                .copyWith(
                                                    fontWeight:
                                                        FontWeight.bold))),
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
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          borderRadius:
                                              BorderRadius.circular(16.0)),
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
        });

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
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ModuleListItem(
                      title: "Sleep and Recovery",
                      description:
                          "Learn about the benefits and howtos of a good night of sleep",
                      gradient1: const Color(0xFF00ABE9),
                      gradient2: const Color(0xFF7FDDFF),
                      icon: FontAwesomeIcons.solidMoon),
                  const SizedBox(height: 10.0),
                  ModuleListItem(
                      title: "Psychosocial Health",
                      description:
                          "Bad social habits can cause a decrease in well-being",
                      gradient1: const Color(0xFFFFC498),
                      gradient2: const Color(0xFFFF7A60),
                      icon: FontAwesomeIcons.peopleArrows)
                ])));
  }
}

class ModuleListItem extends StatelessWidget {
  final String title;
  final String description;
  final Color gradient1;
  final Color gradient2;
  final IconData icon;

  ModuleListItem(
      {Key? key,
      required this.title,
      required this.description,
      required this.gradient1,
      required this.gradient2,
      required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SubmoduleScreen(
                title: title,
                gradient1: gradient1,
                gradient2: gradient2,
                icon: icon))),
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
