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
We often struggle to prioritise creating our ideal sleep. How do we make it easier?

Recognise that regular activities before sleep make up our bedtime routine. Relaxing and calming activities support good sleep. 

We'll start with little changes first to make it easy to be consistent.

Consistency helps us to dance in step with life’s rhythms.
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
Living things are tied to the rhythm of the Earth’s rotation, moon’s cycles, and transitions between day and night. 

This rhythm drives biological clocks.

People respond differently to it depending on genetics, personality and environmental cues.

Aligning with this rhythm helps improve our well-being and health, especially over the long-term.
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
  final nextPage = () => RhythmSettingCourseIntro();
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

class RhythmSettingCourseIntro extends Page {
  RhythmSettingCourseIntro({Key? key}) : super(key: key);

  @override
  final nextPage = () => RhythmSettingCourse();
  @override
  final prevPage = () => RhythmPeaksAndDips2();

  @override
  final title = "Finding my rhythm";
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
          PageImage(image, maxHeight: 160),
          const SizedBox(height: 4.0),
          MarkdownBody(
              data: """
When in the day do you usually feel your best?
""",
              extensionSet: md.ExtensionSet.gitHubFlavored,
              styleSheet: markdownStyleSheet),
          const SizedBox(height: 4.0),
          const TimeRangePickerBlock(valueName: "feel-best-range"),
          const SizedBox(height: 4.0),
          MarkdownBody(
              data: """
When in the middle of your day do you feel least productive?
""",
              extensionSet: md.ExtensionSet.gitHubFlavored,
              styleSheet: markdownStyleSheet),
          const SizedBox(height: 4.0),
          const TimeRangePickerBlock(valueName: "feel-least-productive-range"),
          const SizedBox(height: 4.0),
          MarkdownBody(
              data: """
When towards the end of your day you feel sleepy?
""",
              extensionSet: md.ExtensionSet.gitHubFlavored,
              styleSheet: markdownStyleSheet),
          const SizedBox(height: 4.0),
          const TimeRangePickerBlock(valueName: "feel-sleepy-range"),
          const SizedBox(height: 4.0),
          MarkdownBody(
              data: """
How you’re currently sleeping:

- Usually go to bed at: **${goBed.format(context)}**
- Usually get out of bed at: **${outBed.format(context)}**
- Average sleep duration: **$sleepTimeText**
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

  final title = "Setting the course of action";

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

  @override
  void initState() {
    super.initState();
    wakeTime = kvReadTimeOfDay("sleep", "goals-wake-time");
    sleepTime = kvReadTimeOfDay("sleep", "goals-sleep-time");
  }

  Widget buildTime(BuildContext context, String valueName,
      TimeOfDay defaultTime, TimeOfDay? initialTime, String prefix) {
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

  bool canNext() {
    if (wakeTime == null || sleepTime == null) {
      return false;
    }
    return true;
  }

  Widget buildPage(BuildContext context) {
    final markdownStyleSheet = MarkdownStyleSheet(
        p: Theme.of(context).textTheme.bodyText1,
        h1: Theme.of(context).textTheme.headline3);
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (widget.image != null) PageImage(widget.image!, maxHeight: 160),
          if (widget.image != null) const SizedBox(height: 4.0),
          MarkdownBody(
              data: """
When your energy peaks and dips depend on when you wake and sleep. Our brain needs time to orchestrate a series of body processes for wakefulness and sleep.

Setting some time-specific goals for waking and sleeping helps.
""",
              extensionSet: md.ExtensionSet.gitHubFlavored,
              styleSheet: markdownStyleSheet),
          const SizedBox(height: 4.0),
          buildTime(
              context,
              "goals-wake-time",
              const TimeOfDay(hour: 0, minute: 0),
              wakeTime,
              "I would like to wake up by"),
          const SizedBox(height: 4.0),
          buildTime(
              context,
              "goals-sleep-time",
              const TimeOfDay(hour: 0, minute: 0),
              sleepTime,
              "This means I would need to sleep by"),
          const SizedBox(height: 4.0),
          MarkdownBody(
              data: """
To get **$sleepFor** of sleep.

#tip: Taking small do-able steps helps create successful habits. If you wish to sleep earlier/later, aim to shift it by 15 to 30 minutes.

---

**How are we going to get you there?**

It starts with a bedtime routine of calming, wind-down activities.
""",
              extensionSet: md.ExtensionSet.gitHubFlavored,
              styleSheet: markdownStyleSheet),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: widget.title,
      nextPage: widget.nextPage,
      prevPage: widget.prevPage,
      hideNext: !canNext(),
      page: buildPage(context),
    );
  }
}
