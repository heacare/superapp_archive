import 'package:flutter/material.dart';

import '../../widgets/screen.dart' show Screen, listViewPaddingTB;

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(final BuildContext context) => const Scaffold(
        body: OnboardingScreen(),
      );
}

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(final BuildContext context) => const Screen(
        child: Center(
          child: Text('Test'),
        ),
      );
}
