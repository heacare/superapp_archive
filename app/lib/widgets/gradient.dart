import 'package:flutter/material.dart';

// TODO(serverwentdown): Recreate the shader for the gradient
Decoration gradient(final BuildContext context) => const BoxDecoration(
      image: DecorationImage(
        image: ExactAssetImage('assets/brand/gradient_static.png'),
        fit: BoxFit.cover,
      ),
    );
