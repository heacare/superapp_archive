import 'package:flutter/material.dart';
import 'package:hea/models/healer.dart';
import 'package:hea/widgets/avatar_icon.dart';

class HealerCard extends StatelessWidget {
  Healer healer;
  VoidCallback? onTap;

  HealerCard({Key? key, required this.healer, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(15.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5), //color of shadow
                  blurRadius: 5, // blur radius
                  offset: const Offset(0, 2), // changes position of shadow
                )
              ],
            ),
            padding: EdgeInsets.all(20.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(children: <Widget>[
                    AvatarIcon(),
                    SizedBox(width: 15.0),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text("Sleep Clinic",
                              style: Theme.of(context).textTheme.headline2),
                          Text(healer.name,
                              style: Theme.of(context).textTheme.bodyText1),
                        ])
                  ]),
                  SizedBox(height: 15.0),
                  Text(healer.description,
                      style: Theme.of(context).textTheme.bodyText2),
                ])));
  }
}
