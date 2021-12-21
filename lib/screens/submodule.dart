import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:hea/screens/content.dart';

class SubmoduleScreen extends StatefulWidget {
  SubmoduleScreen(
      {Key? key,
      required this.title,
      required this.gradient1,
      required this.gradient2,
      required this.icon})
      : super(key: key);

  final String title;
  final Color gradient1;
  final Color gradient2;
  final IconData icon;

  @override
  State<SubmoduleScreen> createState() => _SubmoduleScreenState();
}

class _SubmoduleScreenState extends State<SubmoduleScreen> {
  @override
  Widget build(BuildContext context) {
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
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
              child: Column(children: <Widget>[
                SubmoduleListItem(
                    title: "Socials 101",
                    description: "12 sections • 15min",
                    leading: Container()),
              ]))),
    ]));
  }
}

class SubmoduleListItem extends StatelessWidget {
  final String title;
  final String description;
  final Widget leading;

  SubmoduleListItem(
      {Key? key,
      required this.title,
      required this.description,
      required this.leading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {},
        child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
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
                    Text(title, style: Theme.of(context).textTheme.headline3),
                    Text(description,
                        style: Theme.of(context)
                            .textTheme
                            .bodyText2
                            ?.copyWith(color: Color(0xFF707070)))
                  ])),
              FaIcon(FontAwesomeIcons.arrowRight,
                  color: Color(0xFF868686), size: 18.0),
            ])));
  }
}
