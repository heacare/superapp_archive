import 'package:flutter/material.dart';

class AvatarIcon extends StatelessWidget {
  AvatarIcon({Key? key, this.radius, this.width}) : super(key: key);

  double? radius;
  double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: width ?? 60.0,
        width: width ?? 60.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(radius ?? 20.0)),
            image: DecorationImage(
                image: const AssetImage('assets/images/avatar.png'),
                fit: BoxFit.cover)));
  }
}
