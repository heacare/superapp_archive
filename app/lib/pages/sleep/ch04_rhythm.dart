import 'package:flutter/material.dart' hide Page;

import 'package:hea/widgets/page.dart';
import 'ch03_goals.dart';
import 'ch05_owning.dart';

class RhythmConsistency extends MarkdownPage {
  RhythmConsistency({Key? key}) : super(key: key);

  @override
  final nextPage = () => RhythmWhy();
  @override
  final prevPage = () => GoalsGettingThere();

  @override
  final title = "Consistency is key";
  @override
  final image = Image.asset("assets/images/sleep/ch04-consistency-is-key.png");

  @override
  final markdown = """
Based on your sleep goals, we hear you. It is a complex two-way relationship between sleep and the things we do from the time we wake up.

If you can’t change everything, that’s okay. Focus on small things first so it's easier to be consistent.

Why is it important to be consistent? It’s about falling in step with life’s rhythms.
""";
}

class RhythmWhy extends MarkdownPage {
  RhythmWhy({Key? key}) : super(key: key);

  @override
  final nextPage = () => RhythmHow();
  @override
  final prevPage = () => RhythmConsistency();

  @override
  final title = "It's all about rhythm";
  @override
  final image = Image.asset("assets/images/sleep/ch04-hannah-mumby.gif");

  @override
  final markdown = """
All living things have one thing in common - rhythm. This rhythm is closely tied to the rotation of Earth, cycles of the moon and the rise and fall of the sun. 

This rhythm, also known as the biological clock, is also **highly personal**. It differs across individuals, depending on genetics, personality and environmental cues. 

Understanding how our body responds to the environment can help us work with this rhythm. Being aligned with it helps us to **reduce negative effects on our immediate wellbeing** and long-term health. 
""";
}

class RhythmHow extends MarkdownPage {
  RhythmHow({Key? key}) : super(key: key);

  @override
  final nextPage = () => RhythmPeaksAndDips1();
  @override
  final prevPage = () => RhythmWhy();

  @override
  final title = "The circadian clock";
  @override
  final image = Image.asset("assets/images/sleep/ch04-digg-body-clock.gif");

  @override
  final markdown = """
These biological clocks regulate physiological and chemical changes in our body. The timing of these changes is synchronised by our **Circadian Rhythm** - a central pacemaker controlled by an internal master clock in the brain, the suprachiasmatic nucleus. 

Our sleep-wake cycle, body temperature changes and hormone secretions need to synchronise to carry out essential bodily functions effectively. 

Let’s see what affects this rhythm.
""";
}

class RhythmPeaksAndDips1 extends MarkdownPage {
  RhythmPeaksAndDips1({Key? key}) : super(key: key);

  @override
  final nextPage = () => RhythmPeaksAndDips2();
  @override
  final prevPage = () => RhythmHow();

  @override
  final title = "Peaks and dips";
  @override
  final image = Image.asset("assets/images/sleep/ch04-two-process-model.webp");

  @override
  final markdown = """
Ever wondered why you are sometimes so productive, or why your energy slumps around midday when your brain seems to switch off? 

Our energy levels are determined by the sleep-wake cycle. This is a dance of two processes, our circadian or wake drive, and our sleep drive. 

The circadian cycle affects both sleep and wakefulness. Our internal pacemaker does this by regulating body temperature and chemical processes 24 hours a day, and other functions.
""";
}

class RhythmPeaksAndDips2 extends MarkdownPage {
  RhythmPeaksAndDips2({Key? key}) : super(key: key);

  @override
  final nextPage = () => OwningRoutine();
  @override
  final prevPage = () => RhythmPeaksAndDips1();

  @override
  final title = "Peaks and dips";
  @override
  final image = Image.asset("assets/images/sleep/ch04-two-process-model.webp");

  @override
  final markdown = """
The sleep drive, on the other hand, is a process that works to stabilise our biological systems for optimal survival amidst changing conditions.

The interplay of these two processes creates peaks of high energy and dips of low energy across our day. 

When these peaks and dips will happen depend on our sleep and wake times - a highly personal choice by each of us.
""";
}
