import 'package:flutter/material.dart' hide Page;

import 'package:hea/widgets/page.dart';
import 'ch04_rhythm.dart';

class OwningRoutine extends MarkdownPage {
  OwningRoutine({Key? key}) : super(key: key);

  @override
  final nextPage = () => OwningRoutine();
  @override
  final prevPage = () => RhythmPeaksAndDips2();

  @override
  final title = "Rhythm is Life and routine";
  @override
  final image = Image.asset("assets/images/sleep/ch05-daily-routine.gif");

  @override
  final markdown = """
In this chapter, we discover the importance of routine and how it can help align you with your circadian rhythm to improve sleep. We start by checking in on your current sleep habits - a.k.a. your ‘sleep hygiene’. It might not sound fancy, but it can have game changing effects.

Bedtime routines are **regular actions** you take before sleep every night to **signal winding down for sleep**. For example, dimming lights, doing something relaxing such as taking a warm bath/shower before bed.

Such signalling actions act like **timing cues** to influence our biological clock. They are highly dependent on our routine.
""";
}
