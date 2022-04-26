import 'package:flutter/material.dart' hide Page;
import 'package:markdown/markdown.dart' as md;
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:hea/utils/kv_wrap.dart';
import 'package:hea/widgets/page.dart';
import 'package:hea/widgets/select_list.dart';
import 'ch02_now.dart';
import 'ch04_rhythm.dart';

class GoalsSetting extends MultipleChoicePage {
  GoalsSetting({Key? key}) : super(key: key);

  @override
  final nextPage = () => GoalsTimeToSleep();
  @override
  final prevPage = () => NowScore();

  @override
  final title = "Visualising your ideal sleep";
  @override
  final image = Image.asset("assets/images/sleep/ch03-sleeping-ideal.webp");

  @override
  final markdown = """
Our need to sleep is at a constant tug-o-war with our roles in society. Afterall, we are social creatures and depend on others to thrive. While everyone has different needs, it’s important to put yours first. 

I'd like to:
""";

  @override
  final maxChoice = 0;
  @override
  final minSelected = 1;
  @override
  final valueName = "sleep-goals";
  @override
  final List<SelectListItem<String>> choices = [
    SelectListItem(text: "Sleep more hours", value: "sleep more hours"),
    SelectListItem(
        text: "Wake up feeling more refreshed and well-rested",
        value: "wake up feeling refreshed and well-rested"),
    SelectListItem(
        text: "Feel less sleepy during the day",
        value: "feel less sleepy during the day"),
    SelectListItem(
        text: "Sleep through the night", value: "sleep through the night"),
    SelectListItem(text: "Fall asleep easier", value: "fall asleep easier"),
    SelectListItem(
        text: "Have a more consistent sleep schedule",
        value: "have a more consistent sleep schedule"),
    SelectListItem(text: "Other", value: "", other: true),
  ];
}

class GoalsTimeToSleep extends MultipleChoicePage {
  GoalsTimeToSleep({Key? key}) : super(key: key);

  @override
  final nextPage = () => GoalsDoingBeforeBed();
  @override
  final prevPage = () => GoalsSetting();

  @override
  final title = "Priorities and procrastination";
  @override
  final image = Image.asset("assets/images/sleep/ch03-now-now-now.webp");

  @override
  final markdown = """
When it is time to sleep, I
""";

  @override
  final maxChoice = 0;
  @override
  final minSelected = 1;
  @override
  final valueName = "time-to-sleep";
  @override
  final List<SelectListItem<String>> choices = [
    SelectListItem(
        text: "Still do other things", value: "still do other things"),
    SelectListItem(
        text: "Get easily distracted by other things",
        value: "get easily distracted by other things"),
    SelectListItem(
        text: "Can easily stop with my activities when it is time to go to bed",
        value:
            "can easily stop with my activities when it is time to go to bed"),
    SelectListItem(
        text: "Do not want to go to bed on time",
        value: "do not want to go to bed on time"),
    SelectListItem(
        text: "Want to go to bed on time but I just don't",
        value: "want to go to bed on time but I just don't"),
    SelectListItem(
        text: "Go to bed early if I have to get up early in the morning",
        value: "go to bed early if I have to get up early in the morning"),
    SelectListItem(
        text: "Turn off the lights at night I do it immediately",
        value: "turn off the lights at night I do it immediately"),
    SelectListItem(
        text: "Have a regular bedtime which I keep to",
        value: "have a regular bedtime which I keep to"),
  ];
}

class GoalsDoingBeforeBed extends MultipleChoicePage {
  GoalsDoingBeforeBed({Key? key}) : super(key: key);

  @override
  final nextPage = () => GoalsCalmingActivities();
  @override
  final prevPage = () => GoalsTimeToSleep();

  @override
  final title = "Priorities and procrastination";
  @override
  final image = Image.asset("assets/images/sleep/ch03-now-now-now.webp");

  @override
  final markdown = """
What do you usually end up doing instead of going to bed?
""";

  @override
  final maxChoice = 0;
  @override
  final minSelected = 1;
  @override
  final valueName = "doing-before-bed";
  @override
  final List<SelectListItem<String>> choices = activityChoices;
}

final List<SelectListItem<String>> activityChoices = [
  SelectListItem(text: "Watching TV/videos", value: "watching TV/videos"),
  SelectListItem(text: "Playing video games", value: "playing video games"),
  SelectListItem(text: "Surfing the internet", value: "surfing the internet"),
  SelectListItem(text: "Going on social media", value: "going on social media"),
  SelectListItem(
      text: "Working till the last hour", value: "working till the last hour"),
  SelectListItem(
      text: "Studying till the last hour",
      value: "studying till the last hour"),
  SelectListItem(
      text: "Chilling/chatting with others",
      value: "chilling/chatting with others"),
  SelectListItem(text: "Other", value: "", other: true),
];

class GoalsCalmingActivities extends MarkdownPage {
  GoalsCalmingActivities({Key? key}) : super(key: key);

  @override
  final nextPage = () => GoalsEmbraceAndManifest();
  @override
  final prevPage = () => GoalsDoingBeforeBed();

  @override
  final title = "Priorities and procrastination";
  @override
  final image = Image.asset("assets/images/sleep/ch03-now-now-now.webp");

  @override
  final markdown = """
Regular activities in the run-up to sleep make up your bedtime routine. A supportive routine for sleep has relaxing and calming activities, not energizing ones. More on creating a good bedtime routine later.
""";
}

class GoalsEmbraceAndManifest extends Page {
  GoalsEmbraceAndManifest({Key? key}) : super(key: key);

  @override
  final nextPage = () => GoalsGettingThere();
  @override
  final prevPage = () => GoalsCalmingActivities();

  @override
  final title = "Embrace and manifest";

  final Image? image =
      Image.asset("assets/images/sleep/ch03-baby-yoda-grogu.webp");

  Widget buildLine(BuildContext context, MarkdownStyleSheet markdownStyleSheet,
      String prefix, List<String> items) {
    String what = items.join(", ");
    return MarkdownBody(
        data: "**$prefix** $what.",
        extensionSet: md.ExtensionSet.gitHubFlavored,
        styleSheet: markdownStyleSheet);
  }

  @override
  Widget buildPage(BuildContext context) {
    final markdownStyleSheet = MarkdownStyleSheet(
        p: Theme.of(context).textTheme.bodyText1,
        h1: Theme.of(context).textTheme.headline3);
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (image != null) image!,
          if (image != null) const SizedBox(height: 4.0),
          MarkdownBody(
              data: """
Knowing and accepting where you are is the first step to making change.
""",
              extensionSet: md.ExtensionSet.gitHubFlavored,
              styleSheet: markdownStyleSheet),
          const SizedBox(height: 4.0),
          buildLine(
              context,
              markdownStyleSheet,
              "When it is time to go to bed, I",
              kvReadStringList("sleep", "time-to-sleep")),
          const SizedBox(height: 4.0),
          buildLine(
              context,
              markdownStyleSheet,
              "Instead of going to bed, I end up",
              kvReadStringList("sleep", "doing-before-bed")),
          const SizedBox(height: 4.0),
          buildLine(
              context,
              markdownStyleSheet,
              "To get better sleep from hereon, I would like to",
              kvReadStringList("sleep", "sleep-goals")),
          const SizedBox(height: 4.0),
        ]);
  }
}

// TODO: Use OpenEndedPage

class GoalsGettingThere extends MarkdownPage {
  GoalsGettingThere({Key? key}) : super(key: key);

  @override
  final nextPage = () => RhythmConsistency();
  @override
  final prevPage = () => GoalsEmbraceAndManifest();

  @override
  final title = "Priorities and procrastination";
  @override
  final image = Image.asset("assets/images/sleep/ch03-baby-yoda-grogu.webp");

  @override
  final markdown = """
So, how are we going to get there?
""";
}
