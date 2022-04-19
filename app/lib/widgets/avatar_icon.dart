import 'package:flutter/material.dart';

class AvatarIcon extends StatelessWidget {
  const AvatarIcon({Key? key, this.radius, this.width}) : super(key: key);

  final double? radius;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: width ?? 60.0,
        width: width ?? 60.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(radius ?? 20.0)),
            image: const DecorationImage(
                image: AssetImage('assets/images/avatar.png'),
                fit: BoxFit.cover)));
  }
}
