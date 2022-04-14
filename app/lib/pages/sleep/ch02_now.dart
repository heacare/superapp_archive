import 'package:flutter/material.dart' hide Page;
import 'package:markdown/markdown.dart' as md;
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:hea/utils/kv_wrap.dart';
import 'package:hea/widgets/page.dart';
import 'package:hea/widgets/select_list.dart';
import 'ch01_introduction.dart';
import 'ch03_goals.dart';

class NowFirstThingsFirst extends MarkdownPage {
  NowFirstThingsFirst({Key? key}) : super(key: key);

  @override
  final nextPage = () => NowTimeGoneBed();
  @override
  final prevPage = () => IntroductionHowTrackSleep();

  @override
  final title = "First things first";
  @override
  final image =
      Image.asset("assets/images/sleep/ch02-how-do-you-sleep-sam-smith.gif");

  @override
  final markdown = """
Before we begin our journey to better sleep, how have you been sleeping in the last 30 days?

Let’s find out your sleep score. We will take you on a reflective process to help you become more aware of your own sleep. Your sleep score will be helpful to show how your sleep improves later. There are 20 questions in this process. Start by getting comfortable. If you need more time, pause and continue later. There’s no need to rush.

Let’s begin.
""";
}

class NowTimeGoneBed extends TimePickerPage {
  NowTimeGoneBed({Key? key}) : super(key: key);

  @override
  final nextPage = () => NowMinutesFallAsleep();
  @override
  final prevPage = () => NowFirstThingsFirst();

  @override
  final title = "In the past month";
  @override
  final image = null;

  @override
  final markdown = "When have you usually gone to bed?";

  @override
  final valueName = "time-go-bed";
  @override
  final defaultTime = TimeOfDay(hour: 23, minute: 00);
}

class NowMinutesFallAsleep extends MultipleChoicePage {
  NowMinutesFallAsleep({Key? key}) : super(key: key);

  @override
  final nextPage = () => NowTimeOutBed();
  @override
  final prevPage = () => NowTimeGoneBed();

  @override
  final title = "In the past month";
  @override
  final image = null;

  @override
  final markdown = """
How many minutes does it usually take you to fall asleep?
""";

  @override
  final maxChoice = 1;
  @override
  final valueName = "points-fall-asleep";
  @override
  final List<SelectListItem<String>> choices = [
    SelectListItem(text: "15 minutes or less", value: "0"),
    SelectListItem(text: "Between 16 minutes and 30 minutes", value: "1"),
    SelectListItem(text: "Between 31 minutes and 60 minutes", value: "2"),
    SelectListItem(text: "60 minutes or more", value: "3"),
  ];
}

class NowTimeOutBed extends TimePickerPage {
  NowTimeOutBed({Key? key}) : super(key: key);

  @override
  final nextPage = () => NowGetSleep();
  @override
  final prevPage = () => NowMinutesFallAsleep();

  @override
  final title = "In the past month";
  @override
  final image = null;

  @override
  final markdown = "When have you usually gotten out of bed?";

  @override
  final valueName = "time-out-bed";
  @override
  final defaultTime = TimeOfDay(hour: 7, minute: 00);
}

class NowGetSleep extends DurationPickerPage {
  NowGetSleep({Key? key}) : super(key: key);

  @override
  final nextPage = () => NowHowEfficientSleep();
  @override
  final prevPage = () => NowTimeOutBed();

  @override
  final title = "In the past month";
  @override
  final image = null;

  @override
  final markdown = """
On average, how many hours of sleep do you get at night?
(*This differs from the number of hours you spend in bed.*)
""";

  @override
  final valueName = "minutes-asleep";
  @override
  final defaultMinutes = 8 * 60;
}

class NowHowEfficientSleep extends Page {
  NowHowEfficientSleep({Key? key}) : super(key: key);

  @override
  final nextPage = () => NowHowEfficientSleep2();
  @override
  final prevPage = () => NowGetSleep();

  @override
  final title = "How efficient is your sleep?";
  final image = Image.asset("assets/images/sleep/ch02-good-morning.gif");

  @override
  Widget buildPage(BuildContext context) {
    final markdownStyleSheet = MarkdownStyleSheet(
        p: Theme.of(context).textTheme.bodyText1,
        h1: Theme.of(context).textTheme.headline3);
    TimeOfDay goBed = kvReadTimeOfDay("sleep", "time-go-bed") ??
        TimeOfDay(hour: 0, minute: 0);
    TimeOfDay outBed = kvReadTimeOfDay("sleep", "time-out-bed") ??
        TimeOfDay(hour: 0, minute: 0);
    int bedDuration = ((outBed.minute + outBed.hour * 60) -
            (goBed.minute + goBed.hour * 60)) %
        (24 * 60);
    int sleepDuration = kvReadInt("sleep", "minutes-asleep") ?? 0;
    int sleepEfficiencyPercent = ((sleepDuration / bedDuration) * 100).round();
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (image != null) image,
          if (image != null) SizedBox(height: 4.0),
          MarkdownBody(
              data: """
Here's a sneak insight!

Your avergae sleep efficiency is
""",
              extensionSet: md.ExtensionSet.gitHubFlavored,
              styleSheet: markdownStyleSheet),
          Center(
            child: Text(
              "$sleepEfficiencyPercent%",
              style: Theme.of(context).textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
          ),
          MarkdownBody(
              data: """
A sleep efficiency of 85% and above is considered in the healthy range.

Being aware of how much quality time you’re actually spending in bed can help you sleep smarter and get more time to do things you love (unless staying in bed is actually one!)

Many of us try to catch up on our sleep during the weekends. This actually sets up a vicious cycle of recurring sleep debt and fatigue during the week.
""",
              extensionSet: md.ExtensionSet.gitHubFlavored,
              styleSheet: markdownStyleSheet),
        ]);
  }
}

class NowHowEfficientSleep2 extends MarkdownPage {
  NowHowEfficientSleep2({Key? key}) : super(key: key);

  @override
  final nextPage = () => NowDifficultySleeping();
  @override
  final prevPage = () => NowHowEfficientSleep();

  @override
  final title = "How efficient is your sleep?";
  final image = Image.asset("assets/images/sleep/ch02-good-morning.gif");

  @override
  final markdown = """
Contrary to popular belief, sleeping less isn’t a sign of being productive.

What most fail to recognise is that this “skill” is only celebrated by a handful of successful and famous people. What we don’t know are how they manage this, the underlying health conditions that follow, or irreversible consequences that happen later.
""";
}

class NowDifficultySleeping extends MultipleChoicePage {
  NowDifficultySleeping({Key? key}) : super(key: key);

  @override
  final nextPage = () => NowSleepDisturbances();
  @override
  final prevPage = () => NowHowEfficientSleep2();

  @override
  final title = "In the past month";
  @override
  final image = null;

  @override
  final markdown = """
How often were you unable to fall asleep within 30 minutes?
""";

  @override
  final maxChoice = 1;
  @override
  final valueName = "how-often-asleep-30-minutes";
  @override
  final List<SelectListItem<String>> choices = [
    SelectListItem(text: "Not during the past month", value: "0"),
    SelectListItem(text: "Less than once a week", value: "1"),
    SelectListItem(text: "Once or twice a week", value: "2"),
    SelectListItem(text: "Three or more times a week", value: "3"),
  ];
}

class NowSleepDisturbances extends MarkdownPage {
  NowSleepDisturbances({Key? key}) : super(key: key);

  @override
  final nextPage = () => NowTroubleSleepingWakeUp();
  @override
  final prevPage = () => NowDifficultySleeping();

  @override
  final title = "Sleep disturbances";
  @override
  final image = Image.asset("assets/images/sleep/ch02-insomnia-sleepy.gif");

  @override
  final markdown = """
The next few questions will need you to recall when your sleep has been disturbed. It is a disturbance only if you’re not able to fall back to sleep easily, or if it affects the quality of your sleep.
""";
}

class NowTroubleSleepingWakeUp extends MultipleChoicePage {
  NowTroubleSleepingWakeUp({Key? key}) : super(key: key);

  @override
  final nextPage = () => NowTroubleSleepingBathroom();
  @override
  final prevPage = () => NowSleepDisturbances();

  @override
  final title = "Sleep disturbances";
  @override
  final image = null;

  @override
  final markdown = """
How often have you had trouble sleeping because you woke up in the middle of the night?
""";

  @override
  final maxChoice = 1;
  @override
  final valueName = "how-often-wake-up";
  @override
  final List<SelectListItem<String>> choices = [
    SelectListItem(text: "Not during the past month", value: "0"),
    SelectListItem(text: "Less than once a week", value: "1"),
    SelectListItem(text: "Once or twice a week", value: "2"),
    SelectListItem(text: "Three or more times a week", value: "3"),
  ];
}

class NowTroubleSleepingBathroom extends MultipleChoicePage {
  NowTroubleSleepingBathroom({Key? key}) : super(key: key);

  @override
  final nextPage = () => NowTroubleSleepingBreath();
  @override
  final prevPage = () => NowTroubleSleepingWakeUp();

  @override
  final title = "Sleep disturbances";
  @override
  final image = null;

  @override
  final markdown = """
How often have you had trouble sleeping because you got up to use the bathroom?
""";

  @override
  final maxChoice = 1;
  @override
  final valueName = "how-often-bathroom";
  @override
  final List<SelectListItem<String>> choices = [
    SelectListItem(text: "Not during the past month", value: "0"),
    SelectListItem(text: "Less than once a week", value: "1"),
    SelectListItem(text: "Once or twice a week", value: "2"),
    SelectListItem(text: "Three or more times a week", value: "3"),
  ];
}

class NowTroubleSleepingBreath extends MultipleChoicePage {
  NowTroubleSleepingBreath({Key? key}) : super(key: key);

  @override
  final nextPage = () => NowTroubleSleepingSnore();
  @override
  final prevPage = () => NowTroubleSleepingBathroom();

  @override
  final title = "Sleep disturbances";
  @override
  final image = null;

  @override
  final markdown = """
How often have you had trouble sleeping because you couldn’t breathe comfortably?
""";

  @override
  final maxChoice = 1;
  @override
  final valueName = "how-often-breath";
  @override
  final List<SelectListItem<String>> choices = [
    SelectListItem(text: "Not during the past month", value: "0"),
    SelectListItem(text: "Less than once a week", value: "1"),
    SelectListItem(text: "Once or twice a week", value: "2"),
    SelectListItem(text: "Three or more times a week", value: "3"),
  ];
}

class NowTroubleSleepingSnore extends MultipleChoicePage {
  NowTroubleSleepingSnore({Key? key}) : super(key: key);

  @override
  final nextPage = () => NowTroubleSleepingCold();
  @override
  final prevPage = () => NowTroubleSleepingBreath();

  @override
  final title = "Sleep disturbances";
  @override
  final image = null;

  @override
  final markdown = """
How often have you had trouble sleeping because you snored?
""";

  @override
  final maxChoice = 1;
  @override
  final valueName = "how-often-snore";
  @override
  final List<SelectListItem<String>> choices = [
    SelectListItem(text: "Not during the past month", value: "0"),
    SelectListItem(text: "Less than once a week", value: "1"),
    SelectListItem(text: "Once or twice a week", value: "2"),
    SelectListItem(text: "Three or more times a week", value: "3"),
  ];
}

class NowTroubleSleepingCold extends MultipleChoicePage {
  NowTroubleSleepingCold({Key? key}) : super(key: key);

  @override
  final nextPage = () => NowTroubleSleepingHot();
  @override
  final prevPage = () => NowTroubleSleepingSnore();

  @override
  final title = "Sleep disturbances";
  @override
  final image = Image.asset("assets/images/sleep/ch02-monster-under-bed.jpg");

  @override
  final markdown = """
How often have you had trouble sleeping because you felt too cold?
""";

  @override
  final maxChoice = 1;
  @override
  final valueName = "how-often-cold";
  @override
  final List<SelectListItem<String>> choices = [
    SelectListItem(text: "Not during the past month", value: "0"),
    SelectListItem(text: "Less than once a week", value: "1"),
    SelectListItem(text: "Once or twice a week", value: "2"),
    SelectListItem(text: "Three or more times a week", value: "3"),
  ];
}

class NowTroubleSleepingHot extends MultipleChoicePage {
  NowTroubleSleepingHot({Key? key}) : super(key: key);

  @override
  final nextPage = () => NowTroubleSleepingBadDreams();
  @override
  final prevPage = () => NowTroubleSleepingCold();

  @override
  final title = "Sleep disturbances";
  @override
  final image = Image.asset("assets/images/sleep/ch02-monster-under-bed.jpg");

  @override
  final markdown = """
How often have you had trouble sleeping because you felt too hot?
""";

  @override
  final maxChoice = 1;
  @override
  final valueName = "how-often-hot";
  @override
  final List<SelectListItem<String>> choices = [
    SelectListItem(text: "Not during the past month", value: "0"),
    SelectListItem(text: "Less than once a week", value: "1"),
    SelectListItem(text: "Once or twice a week", value: "2"),
    SelectListItem(text: "Three or more times a week", value: "3"),
  ];
}

class NowTroubleSleepingBadDreams extends MultipleChoicePage {
  NowTroubleSleepingBadDreams({Key? key}) : super(key: key);

  @override
  final nextPage = () => NowTroubleSleepingPain();
  @override
  final prevPage = () => NowTroubleSleepingHot();

  @override
  final title = "Sleep disturbances";
  @override
  final image = Image.asset("assets/images/sleep/ch02-monster-under-bed.jpg");

  @override
  final markdown = """
How often have you had trouble sleeping because you had bad dreams?
""";

  @override
  final maxChoice = 1;
  @override
  final valueName = "how-often-bad-dreams";
  @override
  final List<SelectListItem<String>> choices = [
    SelectListItem(text: "Not during the past month", value: "0"),
    SelectListItem(text: "Less than once a week", value: "1"),
    SelectListItem(text: "Once or twice a week", value: "2"),
    SelectListItem(text: "Three or more times a week", value: "3"),
  ];
}

class NowTroubleSleepingPain extends MultipleChoicePage {
  NowTroubleSleepingPain({Key? key}) : super(key: key);

  @override
  final nextPage = () => NowOtherFactors();
  @override
  final prevPage = () => NowTroubleSleepingBadDreams();

  @override
  final title = "Sleep disturbances";
  @override
  final image = Image.asset("assets/images/sleep/ch02-monster-under-bed.jpg");

  @override
  final markdown = """
How often have you had trouble sleeping because you had pain?
""";

  @override
  final maxChoice = 1;
  @override
  final valueName = "how-often-pain";
  @override
  final List<SelectListItem<String>> choices = [
    SelectListItem(text: "Not during the past month", value: "0"),
    SelectListItem(text: "Less than once a week", value: "1"),
    SelectListItem(text: "Once or twice a week", value: "2"),
    SelectListItem(text: "Three or more times a week", value: "3"),
  ];
}

class NowOtherFactors extends Page {
  NowOtherFactors({Key? key}) : super(key: key);

  @override
  final nextPage = () => NowOverallQuality();
  @override
  final prevPage = () => NowTroubleSleepingPain();

  @override
  final title = "Other sleep disturbances";
  @override
  final image =
      Image.asset("assets/images/sleep/ch02-wake-up-are-you-awake.gif");

  @override
  Widget buildPage(BuildContext context) {
    final markdownStyleSheet = MarkdownStyleSheet(
        p: Theme.of(context).textTheme.bodyText1,
        h1: Theme.of(context).textTheme.headline3);
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (image != null) image,
          if (image != null) SizedBox(height: 4.0),
          if (markdown != "")
            MarkdownBody(
                data: markdown,
                extensionSet: md.ExtensionSet.gitHubFlavored,
                styleSheet: markdownStyleSheet),
          if (markdown != "") SizedBox(height: 4.0),
          TextFormField(
              initialValue: kvRead("sleep", valueName + "-reason"),
              onChanged: (String value) {
                kvWrite<String>("sleep", valueName + "-reason", value);
              }),
          if (markdown2 != "")
            MarkdownBody(
                data: markdown2,
                extensionSet: md.ExtensionSet.gitHubFlavored,
                styleSheet: markdownStyleSheet),
          if (markdown2 != "") SizedBox(height: 4.0),
          SelectList(
              items: choices,
              max: maxChoice,
              defaultSelected: kvReadStringList("sleep", valueName),
              onChange: (List<String> c) {
                // TODO: Save value
                print(c);
                kvWrite<List<String>>("sleep", valueName, c);
              }),
        ]);
  }

  @override
  final markdown = """
What other factors might have disturbed your sleep?
""";

  @override
  final markdown2 = """
How often during the past month have you had trouble sleeping because of this?
""";

  @override
  final maxChoice = 1;
  @override
  final valueName = "how-often-other";
  @override
  final List<SelectListItem<String>> choices = [
    SelectListItem(text: "Not during the past month", value: "0"),
    SelectListItem(text: "Less than once a week", value: "1"),
    SelectListItem(text: "Once or twice a week", value: "2"),
    SelectListItem(text: "Three or more times a week", value: "3"),
  ];
}

class NowOverallQuality extends MultipleChoicePage {
  NowOverallQuality({Key? key}) : super(key: key);

  @override
  final nextPage = () => NowSleepMedication();
  @override
  final prevPage = () => NowOtherFactors();

  @override
  final title = "Overall sleep quality";
  @override
  final image = Image.asset("assets/images/sleep/ch02-did-you-sleep-well.gif");

  @override
  final markdown = """
During the past month, how would you rate your sleep quality overall?
""";

  @override
  final maxChoice = 1;
  @override
  final valueName = "overall-quality";
  @override
  final List<SelectListItem<String>> choices = [
    SelectListItem(text: "Very good", value: "0"),
    SelectListItem(text: "Fairly good", value: "1"),
    SelectListItem(text: "Fairly bad", value: "2"),
    SelectListItem(text: "Very bad", value: "3"),
  ];
}

class NowSleepMedication extends MultipleChoicePage {
  NowSleepMedication({Key? key}) : super(key: key);

  @override
  final nextPage = () => NowFatigue();
  @override
  final prevPage = () => NowOverallQuality();

  @override
  final title = "Sleep disturbances";
  @override
  final image =
      Image.asset("assets/images/sleep/ch02-ambien-sleeping-pills.gif");

  @override
  final markdown = """
During the past month, how often have you taken medicine (prescribed or “over the counter”) to help you sleep?
""";

  @override
  final maxChoice = 1;
  @override
  final valueName = "how-sleep-medication";
  @override
  final List<SelectListItem<String>> choices = [
    SelectListItem(text: "Not during the past month", value: "0"),
    SelectListItem(text: "Less than once a week", value: "1"),
    SelectListItem(text: "Once or twice a week", value: "2"),
    SelectListItem(text: "Three or more times a week", value: "3"),
  ];
}

class NowFatigue extends MultipleChoicePage {
  NowFatigue({Key? key}) : super(key: key);

  @override
  final nextPage = () => NowScore();
  @override
  final prevPage = () => NowSleepMedication();

  @override
  final title = "Fatigue, energy and enthusiasm";
  @override
  final image = Image.asset("assets/images/sleep/ch02-clapping-sleeping.gif");

  @override
  final markdown = """
During the past month...

How often have you had trouble staying awake while working/studying, eating, watching TV/radio, in a public setting (cinema, classroom, workplace), engaging in social activity or driving/operating machinery?
""";

  @override
  final maxChoice = 1;
  @override
  final valueName = "how-fatigue";
  @override
  final List<SelectListItem<String>> choices = [
    SelectListItem(text: "Never", value: "0"),
    SelectListItem(text: "Once or twice", value: "1"),
    SelectListItem(text: "Once or twice each week", value: "2"),
    SelectListItem(text: "Three or more times each week", value: "3"),
  ];
}

class NowScore extends Page {
  NowScore({Key? key}) : super(key: key);

  @override
  final nextPage = () => GoalsSleepNeeds();
  @override
  final prevPage = () => NowFatigue();

  @override
  final title = "How's your sleep score?";
  final Image? image = Image.asset("assets/images/sleep/ch02-boss-gatsby.gif");

  @override
  Widget buildPage(BuildContext context) {
    final markdownStyleSheet = MarkdownStyleSheet(
        p: Theme.of(context).textTheme.bodyText1,
        h1: Theme.of(context).textTheme.headline3);
    int subjectiveSleepQuality =
        int.tryParse(kvReadStringList("sleep", "overall-quality")[0]) ?? 0;

    int pointsFallAsleep =
        int.tryParse(kvReadStringList("sleep", "points-fall-asleep")[0]) ?? 0;
    int howOftenAsleep30Minutes = int.tryParse(
            kvReadStringList("sleep", "how-often-asleep-30-minutes")[0]) ??
        0;
    int sleepLatency =
        ((pointsFallAsleep + howOftenAsleep30Minutes) / 2).ceil();

    int sleepTimeMinutes = kvReadInt("sleep", "minutes-asleep") ?? 0;
    Duration sleepTime = Duration(minutes: sleepTimeMinutes);
    String sleepTimeText =
        "${sleepTime.inHours} hours ${sleepTime.inMinutes.remainder(Duration.minutesPerHour)} minutes";

    TimeOfDay goBed = kvReadTimeOfDay("sleep", "time-go-bed") ??
        TimeOfDay(hour: 0, minute: 0);
    TimeOfDay outBed = kvReadTimeOfDay("sleep", "time-out-bed") ??
        TimeOfDay(hour: 0, minute: 0);
    int bedDuration = ((outBed.minute + outBed.hour * 60) -
            (goBed.minute + goBed.hour * 60)) %
        (24 * 60);
    int sleepDuration = kvReadInt("sleep", "minutes-asleep") ?? 0;
    int sleepEfficiencyPercent = ((sleepDuration / bedDuration) * 100).round();
    int sleepEfficiency = 0;
    if (sleepEfficiencyPercent < 65) {
      sleepEfficiency = 3;
    } else if (sleepEfficiencyPercent < 75) {
      sleepEfficiency = 2;
    } else if (sleepEfficiencyPercent < 85) {
      sleepEfficiency = 1;
    }

    const List<String> keys = [
      "how-often-wake-up",
      "how-often-bathroom",
      "how-often-breath",
      "how-often-snore",
      "how-often-cold",
      "how-often-hot",
      "how-often-bad-dreams",
      "how-often-pain",
      "how-often-other"
    ];
    int pointsDisturbance = 0;
    for (String key in keys) {
      List<String> values = kvReadStringList("sleep", key);
      if (values.length != 1) {
        continue;
      }
      pointsDisturbance += int.tryParse(values[0]) ?? 0;
    }
    int sleepDisturbances = (pointsDisturbance / keys.length).ceil();

    int sleepMedication =
        int.tryParse(kvReadStringList("sleep", "how-sleep-medication")[0]) ?? 0;

    int pointsFatigue =
        int.tryParse(kvReadStringList("sleep", "how-fatigue")[0]) ?? 0;
    int daytimeDysfunction = pointsFatigue;

    int overallScore = sleepLatency +
        sleepEfficiency +
        sleepDisturbances +
        subjectiveSleepQuality +
        sleepMedication +
        daytimeDysfunction;
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (image != null) image!,
          if (image != null) SizedBox(height: 4.0),
          Center(
            child: Text(
              "$overallScore",
              style: Theme.of(context).textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
          ),
          MarkdownBody(
              data: """
Wonderful work diving into your sleep. Here’s how your score adds up. We hope the breakdown gives a clearer picture on which area of sleep you can improve.

| Areas of your sleep | Score |
|-|-|
| How do you feel about your sleep (Subjective Sleep Quality) | $subjectiveSleepQuality |
| Average time taken to fall asleep (Sleep latency) | $sleepLatency |
| Average sleep time | $sleepTimeText |
| How efficiently you’re sleeping (Sleep Efficiency) | $sleepEfficiency |
| How often your sleep is disturbed (Sleep Disturbances) | $sleepDisturbances |
| Dependency of sleep medication | $sleepMedication |
| Energy and enthusiasm when you’re awake (Daytime Dysfunction) | $daytimeDysfunction |
| Total Sleep Quality score | $overallScore |
""",
              extensionSet: md.ExtensionSet.gitHubFlavored,
              styleSheet: markdownStyleSheet),
        ]);
  }
}