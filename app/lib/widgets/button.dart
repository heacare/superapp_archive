import 'package:flutter/material.dart';

ButtonStyle buttonStylePrimary(BuildContext context) =>
    ElevatedButton.styleFrom(
      onPrimary: Theme.of(context).colorScheme.onPrimary,
      primary: Theme.of(context).colorScheme.primary,
    ).copyWith(
      elevation: ButtonStyleButton.allOrNull(0),
    );

ButtonStyle buttonStylePrimaryLarge(BuildContext context) =>
    buttonStylePrimary(context).copyWith(
      minimumSize: ButtonStyleButton.allOrNull(const Size(160, 64)),
    );