import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NavigableText extends StatelessWidget {

  final onPressed;
  final String text;

  const NavigableText({Key? key, required this.onPressed, required this.text}) :
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const BackButtonIcon(),
          iconSize: 36.0,
          color: Theme.of(context).colorScheme.primary,
          padding: const EdgeInsets.all(0.0),
          splashRadius: 24.0,
          constraints: const BoxConstraints(),
          onPressed: onPressed,
        ),
        const SizedBox(width: 16.0),
        Text(
            text,
            style: Theme.of(context).textTheme.headline1
        ),
      ]
    );
  }

}