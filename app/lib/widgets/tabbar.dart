import 'package:flutter/material.dart';

Decoration tabBarIndicatorInverse(BuildContext context) => BoxDecoration(
      border: Border(
        bottom: BorderSide(
          width: 2,
          color: Theme.of(context).colorScheme.onBackground,
        ),
      ),
    );
