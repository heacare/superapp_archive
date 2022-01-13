import 'package:flutter/material.dart';

const USER_ICON_DEFAULT =
    "https://images.unsplash.com/photo-1579202673506-ca3ce28943ef";

class AvatarIcon extends StatelessWidget {
  AvatarIcon({Key? key, this.icon, this.radius, this.width}) : super(key: key);

  String? icon;
  double? radius;
  double? width;

  @override
  Widget build(BuildContext context) {
    final icon =
        (this.icon?.isNotEmpty ?? false) ? this.icon! : USER_ICON_DEFAULT;
    return Container(
        height: width ?? 60.0,
        width: width ?? 60.0,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(radius ?? 20.0)),
            image:
                DecorationImage(image: NetworkImage(icon), fit: BoxFit.cover)));
  }
}
