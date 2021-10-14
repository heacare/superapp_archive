import 'package:flutter/material.dart';

const USER_ICON_DEFAULT = "https://kbowlingclub.com/wp-content/plugins/all-in-one-seo-pack/images/default-user-image.png";

class AvatarIcon extends StatelessWidget {
  AvatarIcon({Key? key, required this.icon, this.radius}) : super(key: key);

  String? icon;
  double? radius;

  @override
  Widget build(BuildContext context) {
    final icon = (this.icon?.isNotEmpty ?? false) ? this.icon! : USER_ICON_DEFAULT;
    return CircleAvatar(
        radius: radius,
        child: // TODO use CachedNetworkImage
        ClipOval(
            child:
            Image(image: NetworkImage(icon))));
  }
}
