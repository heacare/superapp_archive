import 'package:flutter/material.dart' hide Page;
import 'package:markdown/markdown.dart' as md;
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:hea/utils/kv_wrap.dart';
import 'package:hea/widgets/page.dart';
import 'package:hea/widgets/select_list.dart';
import 'ch02_now.dart';
import 'ch04_rhythm.dart';

class GoalsSleepNeeds extends MarkdownPage {
  GoalsSleepNeeds({Key? key}) : super(key: key);

  @override
  final nextPage = () => GoalsSetting();
  @override
  final prevPage = () => NowScore();

  @override
  final title = "Your sleep needs";
  @override
  final image = Image.asset("assets/images/sleep/ch03-i-really-need-it.gif");

  @override
  final markdown = """
By now, you’ve begun to gain a better understanding of sleep.

In this chapter, we’ll build your sleep profile.
""";
}

class GoalsSetting extends MultipleChoicePage {
  GoalsSetting({Key? key}) : super(key: key);

  @override
  final nextPage = () => GoalsTimeToSleep();
  @override
  final prevPage = () => GoalsSleepNeeds();

  @override
  final title = "Visualising your ideal sleep";
  @override
  final image = Image.asset("assets/images/sleep/ch03-sleeping-ideal.jpg");

  @override
  final markdown = """
Our need to sleep is at a constant tug-o-war with our roles in society. Afterall, we are social creatures and depend on others to thrive. While everyone has different needs, it’s important to put yours first. 

I'd like to:
""";

  @override
  final maxChoice = 0;
  @override
  final valueName = "sleep-goals";
  @override
  final List<SelectListItem<String>> choices = [
    SelectListItem(text: "Sleep more hours", value: "more hours"),
    SelectListItem(
        text: "Wake up feeling more refreshed and well-rested",
        value: "refreshed and well-rested"),
    SelectListItem(
        text: "Feel less sleepy during the day",
        value: "less sleepy during the day"),
    SelectListItem(
        text: "Sleep through the night", value: "sleep through the night"),
    SelectListItem(text: "Fall asleep easier", value: "fall asleep easier"),
    SelectListItem(
        text: "Have a more consistent sleep schedule",
        value: "more consistent sleep schedule"),
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
  final image = Image.asset("assets/images/sleep/ch03-now-now-now.gif");

  @override
  final markdown = """
When it is time to sleep, I
""";

  @override
  final maxChoice = 0;
  @override
  final valueName = "time-to-sleep";
  @override
  final List<SelectListItem<String>> choices = [
    SelectListItem(
        text: "Still do other things", value: "Still do other things"),
    SelectListItem(
        text: "Get easily distracted by other things",
        value: "Get easily distracted by other things"),
    SelectListItem(
        text: "Can easily stop with my activities when it is time to go to bed",
        value:
            "Can easily stop with my activities when it is time to go to bed"),
    SelectListItem(
        text: "Do not want to go to bed on time",
        value: "Do not want to go to bed on time"),
    SelectListItem(
        text: "Want to go to bed on time but I just don't",
        value: "Want to go to bed on time but I just don't"),
    SelectListItem(
        text: "Go to bed early if I have to get up early in the morning",
        value: "Go to bed early if I have to get up early in the morning"),
    SelectListItem(
        text: "Turn off the lights at night I do it immediately",
        value: "Turn off the lights at night I do it immediately"),
    SelectListItem(
        text: "Have a regular bedtime which I keep to",
        value: "Have a regular bedtime which I keep to"),
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
  final image = Image.asset("assets/images/sleep/ch03-now-now-now.gif");

  @override
  final markdown = """
What do you usually end up doing instead of going to bed?
""";

  @override
  final maxChoice = 0;
  @override
  final valueName = "doing-before-bed";
  @override
  final List<SelectListItem<String>> choices = activityChoices;
}

final List<SelectListItem<String>> activityChoices = [
  SelectListItem(text: "Watching TV/videos", value: "Watching TV/videos"),
  SelectListItem(text: "Playing video games", value: "Playing video games"),
  SelectListItem(text: "Surfing the internet", value: "Surfing the internet"),
  SelectListItem(
      text: "Going on social media content ",
      value: "Going on social media content "),
  SelectListItem(
      text: "Working till the last hour", value: "Working till the last hour"),
  SelectListItem(
      text: "Studying till the last hour",
      value: "Studying till the last hour"),
  SelectListItem(
      text: "Chilling/chatting with others",
      value: "Chilling/chatting with others"),
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
  final image = Image.asset("assets/images/sleep/ch03-now-now-now.gif");

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
      Image.asset("assets/images/sleep/ch03-baby-yoda-grogu.gif");

  Widget buildLine(BuildContext context, String valueName, String prefix) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            prefix + "",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          TextFormField(
              maxLines: null,
              initialValue: kvRead("sleep", valueName),
              onChanged: (String value) {
                kvWrite<String>("sleep", valueName, value);
              })
        ]));
    /*
    return TextFormField(
        maxLines: null,
        decoration: InputDecoration(
          prefix: Text(prefix + " "),
        ),
        initialValue: kvRead("sleep", valueName),
        onChanged: (String value) {
          kvWrite<String>("sleep", valueName, value);
        });
	*/
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
          if (image != null) SizedBox(height: 4.0),
          MarkdownBody(
              data: """
Knowing and accepting where you are is the first step to making change.
""",
              extensionSet: md.ExtensionSet.gitHubFlavored,
              styleSheet: markdownStyleSheet),
          SizedBox(height: 4.0),
          buildLine(context, "bedtime", "When it is time to go to bed, I"),
          SizedBox(height: 4.0),
          buildLine(context, "bedtime-end-up-doing",
              "Instead of going to bed, I end up"),
          SizedBox(height: 4.0),
          buildLine(context, "would-like-to",
              "To get better sleep from hereon, I would like to"),
          SizedBox(height: 4.0),
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
  final image = Image.asset("assets/images/sleep/ch03-now-now-now.gif");

  @override
  final markdown = """
So, how are we going to get there?
""";
}
