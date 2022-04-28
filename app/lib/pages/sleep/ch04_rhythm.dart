import 'package:flutter/material.dart' hide Page;
import 'package:markdown/markdown.dart' as md;
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:hea/utils/kv_wrap.dart';
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
  final image = Image.asset("assets/images/sleep/ch04-consistency-is-key.webp");

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
  final image = Image.asset("assets/images/sleep/ch04-hannah-mumby.webp");

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
  final image = Image.asset("assets/images/sleep/ch04-digg-body-clock.webp");

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
  final nextPage = () => RhythmFeels1();
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

class RhythmFeels1 extends Page {
  RhythmFeels1({Key? key}) : super(key: key);

  @override
  final nextPage = () => RhythmFeels2();
  @override
  final prevPage = () => RhythmPeaksAndDips2();

  @override
  final title = "Setting the course of action";
  final image = Image.asset("assets/images/sleep/ch04-action.webp");

  final markdown = """
When in the day do you usually feel your best?
""";

  @override
  Widget buildPage(BuildContext context) {
    final markdownStyleSheet = MarkdownStyleSheet(
        p: Theme.of(context).textTheme.bodyText1,
        h1: Theme.of(context).textTheme.headline3);
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          image,
          const SizedBox(height: 4.0),
          if (markdown != "")
            MarkdownBody(
                data: markdown,
                extensionSet: md.ExtensionSet.gitHubFlavored,
                styleSheet: markdownStyleSheet),
          if (markdown != "") const SizedBox(height: 4.0),
          const TimeRangePickerBlock(valueName: "feel-best-range"),
        ]);
  }
}

class RhythmFeels2 extends Page {
  RhythmFeels2({Key? key}) : super(key: key);

  @override
  final nextPage = () => RhythmFeels3();
  @override
  final prevPage = () => RhythmFeels1();

  @override
  final title = "Setting the course of action";
  final image = Image.asset("assets/images/sleep/ch04-action.webp");

  final markdown = """
When in the middle of your day do you feel least productive?
""";

  @override
  Widget buildPage(BuildContext context) {
    final markdownStyleSheet = MarkdownStyleSheet(
        p: Theme.of(context).textTheme.bodyText1,
        h1: Theme.of(context).textTheme.headline3);
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          image,
          const SizedBox(height: 4.0),
          if (markdown != "")
            MarkdownBody(
                data: markdown,
                extensionSet: md.ExtensionSet.gitHubFlavored,
                styleSheet: markdownStyleSheet),
          if (markdown != "") const SizedBox(height: 4.0),
          const TimeRangePickerBlock(valueName: "feel-least-productive-range"),
        ]);
  }
}

class RhythmFeels3 extends Page {
  RhythmFeels3({Key? key}) : super(key: key);

  @override
  final nextPage = () => RhythmSettingCourseIntro();
  @override
  final prevPage = () => RhythmFeels2();

  @override
  final title = "Setting the course of action";
  final image = Image.asset("assets/images/sleep/ch04-action.webp");

  final markdown = """
When towards the end of your day you feel sleepy?
""";

  @override
  Widget buildPage(BuildContext context) {
    final markdownStyleSheet = MarkdownStyleSheet(
        p: Theme.of(context).textTheme.bodyText1,
        h1: Theme.of(context).textTheme.headline3);
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          image,
          const SizedBox(height: 4.0),
          if (markdown != "")
            MarkdownBody(
                data: markdown,
                extensionSet: md.ExtensionSet.gitHubFlavored,
                styleSheet: markdownStyleSheet),
          if (markdown != "") const SizedBox(height: 4.0),
          const TimeRangePickerBlock(valueName: "feel-sleepy-range"),
        ]);
  }
}

class RhythmSettingCourseIntro extends Page {
  RhythmSettingCourseIntro({Key? key}) : super(key: key);

  @override
  final nextPage = () => RhythmSettingCourse();
  @override
  final prevPage = () => RhythmFeels3();

  @override
  final title = "Activity: Setting the course of action";
  final image = Image.asset("assets/images/sleep/ch04-action.webp");

  @override
  Widget buildPage(BuildContext context) {
    final markdownStyleSheet = MarkdownStyleSheet(
        p: Theme.of(context).textTheme.bodyText1,
        h1: Theme.of(context).textTheme.headline3);
    TimeOfDay goBed = kvReadTimeOfDay("sleep", "time-go-bed") ??
        const TimeOfDay(hour: 0, minute: 0);
    TimeOfDay outBed = kvReadTimeOfDay("sleep", "time-out-bed") ??
        const TimeOfDay(hour: 0, minute: 0);
    int sleepTimeMinutes = kvReadInt("sleep", "minutes-asleep") ?? 0;
    Duration sleepTime = Duration(minutes: sleepTimeMinutes);
    String sleepTimeText =
        "${sleepTime.inHours} hours ${sleepTime.inMinutes.remainder(Duration.minutesPerHour)} minutes";
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          image,
          const SizedBox(height: 4.0),
          MarkdownBody(
              data: """
Your body needs time to shift gears to prepare for sleep. The brain has to orchestrate sleep. A series of physiological bodily functions need to take place in the right sequence.

Let’s review how you’re currently sleeping:

- Usually go to bed at: ${goBed.format(context)}
- Usually get out of bed at: ${outBed.format(context)}
- Average sleep duration: $sleepTimeText
""",
              extensionSet: md.ExtensionSet.gitHubFlavored,
              styleSheet: markdownStyleSheet),
          const SizedBox(height: 4.0),
        ]);
  }
}

class RhythmSettingCourse extends StatefulWidget {
  RhythmSettingCourse({Key? key}) : super(key: key);

  final nextPage = () => OwningRoutine();
  final prevPage = () => RhythmSettingCourseIntro();

  final title = "Let's review";

  final Image? image = Image.asset("assets/images/sleep/ch04-action.webp");

  @override
  RhythmSettingCourseState createState() => RhythmSettingCourseState();
}

class RhythmSettingCourseState extends State<RhythmSettingCourse> {
  TimeOfDay? wakeTime;
  TimeOfDay? sleepTime;

  Widget buildDuration(BuildContext context, String valueName,
      int defaultDuration, String prefix) {
    int duration = kvReadInt("sleep", valueName) ?? defaultDuration;
    Duration initialDuration = Duration(minutes: duration);
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            prefix + "",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          DurationPickerBlock(
              initialDuration: initialDuration,
              onChange: (duration) =>
                  kvWrite("sleep", valueName, duration.inMinutes)),
        ]));
  }

  Widget buildTime(BuildContext context, String valueName,
      TimeOfDay defaultTime, String prefix) {
    TimeOfDay? initialTime = kvReadTimeOfDay("sleep", valueName);
    if (valueName == "goals-wake-time") {
      wakeTime = initialTime;
    }
    if (valueName == "goals-sleep-time") {
      sleepTime = initialTime;
    }
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            prefix + "",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          TimePickerBlock(
              defaultTime: defaultTime,
              initialTime: initialTime,
              onChange: (time) {
                kvWriteTimeOfDay("sleep", valueName, time);
                setState(() {
                  if (valueName == "goals-wake-time") {
                    wakeTime = time;
                  }
                  if (valueName == "goals-sleep-time") {
                    sleepTime = time;
                  }
                });
              }),
        ]));
  }

  String get sleepFor {
    if (wakeTime == null || sleepTime == null) {
      return "unknown";
    }
    int sleepForMinutes = ((wakeTime!.minute + wakeTime!.hour * 60) -
            (sleepTime!.minute + sleepTime!.hour * 60)) %
        (24 * 60);
    Duration sleepFor = Duration(minutes: sleepForMinutes);
    return "${sleepFor.inHours} hours ${sleepFor.inMinutes.remainder(Duration.minutesPerHour)} minutes";
  }

  Widget buildPage(BuildContext context) {
    final markdownStyleSheet = MarkdownStyleSheet(
        p: Theme.of(context).textTheme.bodyText1,
        h1: Theme.of(context).textTheme.headline3);
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (widget.image != null) widget.image!,
          if (widget.image != null) const SizedBox(height: 4.0),
          MarkdownBody(
              data: """
Now, let’s set some specific goals:

Remember, when your peaks and dips happen depends on your wake and sleep times.

A key to forming successful habits is taking small do-able steps. For example, if your average sleep time is 6 hours, aim to increase it by 15 to 30 minutes
""",
              extensionSet: md.ExtensionSet.gitHubFlavored,
              styleSheet: markdownStyleSheet),
          const SizedBox(height: 4.0),
          buildTime(
              context,
              "goals-wake-time",
              const TimeOfDay(hour: 0, minute: 0),
              "I would like to wake up by"),
          const SizedBox(height: 4.0),
          buildTime(
              context,
              "goals-sleep-time",
              const TimeOfDay(hour: 0, minute: 0),
              "This means I would need to sleep by"),
          const SizedBox(height: 4.0),
          MarkdownBody(
              data: """
Based on these times, I will be sleeping for **$sleepFor**

--- 

**So how are we going to get you there?**

It starts with a calming wind-down routine, otherwise known as a bedtime routine.
""",
              extensionSet: md.ExtensionSet.gitHubFlavored,
              styleSheet: markdownStyleSheet),
        ]);
    // TODO: Read default responses
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: widget.title,
      nextPage: widget.nextPage,
      prevPage: widget.prevPage,
      page: buildPage(context),
    );
  }
}
