import 'package:flutter/material.dart' hide Page;
import 'package:markdown/markdown.dart' as md;
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:hea/utils/kv_wrap.dart';
import 'package:hea/widgets/page.dart';
import 'package:hea/widgets/select_list.dart';
import 'ch03_goals.dart';
import 'ch04_rhythm.dart';

class OwningRoutine extends MarkdownPage {
  OwningRoutine({Key? key}) : super(key: key);

  @override
  final nextPage = () => OwningZeitgebers();
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

class OwningZeitgebers extends MarkdownPage {
  OwningZeitgebers({Key? key}) : super(key: key);

  @override
  final nextPage = () => OwningSettingCourseIntro();
  @override
  final prevPage = () => OwningRoutine();

  @override
  final title = "Zeitgebers";
  @override
  final image =
      Image.asset("assets/images/sleep/ch05-cim-circadian-clock-kyoung.tif");

  @override
  final markdown = """
Light, temperature, meals, social activities and exercise are examples of external cues that influence our circadian rhythm by inducing wakefulness or sleepiness.

These external timing cues are known as ‘Zeitgebers’ - in German ‘Zeit’ means ‘time’ and ‘geber’ means ‘giver’. 

Regular exposure to zeitgebers acutely affects the activation or inhibition of hormones and neurotransmitters. 

Exposure to these cues encourage mental and behavioural changes that support alertness, metabolism, recovery and growth.
""";
}

class OwningSettingCourseIntro extends MarkdownPage {
  OwningSettingCourseIntro({Key? key}) : super(key: key);

  @override
  final nextPage = () => OwningSettingCourse();
  @override
  final prevPage = () => OwningZeitgebers();

  @override
  final title = "Activity: Setting the course of action";
  @override
  final image = Image.asset("assets/images/sleep/ch05-action.jpg");

  @override
  final markdown = """
Your body needs time to shift gears to prepare for sleep. The brain has to orchestrate sleep. A series of physiological bodily functions need to take place in the right sequence.

Let’s review how you’re currently sleeping:

- Usually go to bed at: TODO
- Usually get out of bed at: TODO
- Average sleep duration: TODO
""";
}

class OwningSettingCourse extends Page {
  OwningSettingCourse({Key? key}) : super(key: key);

  @override
  final nextPage = () => OwningHaveRoutine();
  @override
  final prevPage = () => OwningSettingCourseIntro();

  @override
  final title = "Let's review";

  final Image? image = Image.asset("assets/images/sleep/ch05-action.jpg");

  Widget buildDuration(BuildContext context, String valueName,
      int defaultDuration, String prefix) {
    int duration = kvReadInt("sleep", valueName) ?? defaultDuration;
    Duration initialDuration = Duration(minutes: duration);
    return Container(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
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
    TimeOfDay initialTime = kvReadTimeOfDay("sleep", valueName) ?? defaultTime;
    return Container(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            prefix + "",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          TimePickerBlock(
              initialTime: initialTime,
              onChange: (time) => kvWriteTimeOfDay("sleep", valueName, time)),
        ]));
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
Now, let’s set some specific goals:

A key to forming successful habits is taking small do-able steps. For example, if your average sleep time is 6 hours, aim to increase it by 15 to 30 minutes
""",
              extensionSet: md.ExtensionSet.gitHubFlavored,
              styleSheet: markdownStyleSheet),
          SizedBox(height: 4.0),
          buildDuration(context, "goals-sleep-duration", 0,
              "I would like to sleep for at least"),
          SizedBox(height: 4.0),
          buildTime(context, "goals-wake-time", TimeOfDay(hour: 0, minute: 0),
              "I would like to wake up by"),
          SizedBox(height: 4.0),
          buildTime(context, "goals-sleep-time", TimeOfDay(hour: 0, minute: 0),
              "This means I would need to sleep by"),
          SizedBox(height: 4.0),
          MarkdownBody(
              data: """
**So how are we going to get you there?**

It starts with a calming wind-down routine, otherwise known as a bedtime routine.
""",
              extensionSet: md.ExtensionSet.gitHubFlavored,
              styleSheet: markdownStyleSheet),
        ]);
    // TODO: Read default responses
  }
}

class OwningHaveRoutine extends MultipleChoicePage {
  OwningHaveRoutine({Key? key}) : super(key: key);

  @override
  final nextPage = () {
    String choice = kvReadStringList("sleep", "have-routine")[0];
    if (choice == "yes") {
      return OwniningRoutineActivities1();
    }
    return OwningRoutineStart();
  };
  @override
  final prevPage = () => OwningSettingCourse();

  @override
  final title = "Setting a routine";
  @override
  final image = null;

  @override
  final markdown = """
Do you have a bedtime routine?
""";

  @override
  final maxChoice = 1;
  @override
  final valueName = "have-routine";
  @override
  final List<SelectListItem<String>> choices = [
    SelectListItem(text: "Yes", value: "yes"),
    SelectListItem(text: "No", value: "no"),
  ];
}

class OwniningRoutineActivities1 extends MultipleChoicePage {
  OwniningRoutineActivities1({Key? key}) : super(key: key);

  @override
  final nextPage = () => OwniningRoutineActivities2();
  @override
  final prevPage = () => OwningHaveRoutine();

  @override
  final title = "Setting a routine";
  @override
  final image = null;

  @override
  final markdown = """
How does your routine look like before bedtime? Let’s review. 

Select the appropriate habits that happen under each time section accordingly. If none, leave blank.

1 hour before bedtime
""";

  @override
  final maxChoice = 0;
  @override
  final valueName = "routine-60m";
  @override
  final List<SelectListItem<String>> choices = activityChoices;
}

class OwniningRoutineActivities2 extends MultipleChoicePage {
  OwniningRoutineActivities2({Key? key}) : super(key: key);

  @override
  final nextPage = () => OwniningRoutineActivities3();
  @override
  final prevPage = () => OwniningRoutineActivities1();

  @override
  final title = "Setting a routine";
  @override
  final image = null;

  @override
  final markdown = """
How does your routine look like before bedtime? Let’s review. 

Select the appropriate habits that happen under each time section accordingly. If none, leave blank.

30 minutes before bedtime
""";

  @override
  final maxChoice = 0;
  @override
  final valueName = "routine-30m";
  @override
  final List<SelectListItem<String>> choices = activityChoices;
}

class OwniningRoutineActivities3 extends MultipleChoicePage {
  OwniningRoutineActivities3({Key? key}) : super(key: key);

  @override
  final nextPage = () => OwningStarter();
  @override
  final prevPage = () => OwniningRoutineActivities2();

  @override
  final title = "Setting a routine";
  @override
  final image = null;

  @override
  final markdown = """
How does your routine look like before bedtime? Let’s review. 

Select the appropriate habits that happen under each time section accordingly. If none, leave blank.

15 minutes before bedtime
""";

  @override
  final maxChoice = 0;
  @override
  final valueName = "routine-15m";
  @override
  final List<SelectListItem<String>> choices = activityChoices;
}

class OwningRoutineStart extends MarkdownPage {
  OwningRoutineStart({Key? key}) : super(key: key);

  @override
  final nextPage = () => OwningStarter();
  @override
  final prevPage = () => OwningHaveRoutine();

  @override
  final title = "Setting a routine";
  @override
  final image = null;

  @override
  final markdown = """
Let's see how we can start now
""";
}

class OwningStarter extends MarkdownPage {
  OwningStarter({Key? key}) : super(key: key);

  @override
  final nextPage = () => OwningBeforeBedtime();
  @override
  final prevPage = () {
    String choice = kvReadStringList("sleep", "have-routine")[0];
    if (choice == "yes") {
      return OwniningRoutineActivities3();
    }
    return OwningRoutineStart();
  };

  @override
  final title = "Routine is a habit";
  @override
  final image = Image.asset("assets/images/sleep/ch05-ok-right.gif");

  @override
  final markdown = """
  We are going to use our understanding of the Circadian Rhythm and Zeitgebers to form/improve your bedtime routine. 

You make your habits and your habits make you. 
""";
  // TODO: Conditional formatting
}

class OwningBeforeBedtime extends MarkdownPage {
  OwningBeforeBedtime({Key? key}) : super(key: key);

  @override
  final nextPage = () => OwningTheDaySupporting();
  @override
  final prevPage = () => OwningStarter();

  @override
  final title = "Before 'bedtime', there is 'get ready for bedtime'";
  @override
  final image = Image.asset("assets/images/sleep/ch05-fake-sleep.gif");

  @override
  final markdown = """
Before you sleep, the brain’s sleep-wake mechanism is already releasing chemicals that prepare your body for sleep. Use this buffering period to mentally and physically separate yourself from activities that might keep you awake. 

This means stopping any stressful or stimulating work, worries and daytime drama. Mindful practices can help with this. 

You can set a 'get ready for bedtime’ reminder. This is not the time you get into bed to sleep. This is a winding down period. It can start from as early as sunset to some minutes before bed. 
""";
}

class OwningTheDaySupporting extends MultipleChoicePage {
  OwningTheDaySupporting({Key? key}) : super(key: key);

  @override
  final nextPage = () => OwningTheDayNegative();
  @override
  final prevPage = () => OwningBeforeBedtime();

  @override
  final title = "What else are you doing in the day";
  @override
  final image = null;

  @override
  final markdown = """
What you do during the day may also be helping or ‘sabo-ing’ (disrupting) your sleep!

Check all that applies to you

Things that support sleep:
""";

  @override
  final maxChoice = 0;
  @override
  final minSelected = 0;
  @override
  final valueName = "daytime-supporting";
  @override
  final List<SelectListItem<String>> choices = [
    SelectListItem(
        text: "Getting direct sunlight within 1 hour of waking up",
        value: "sunlight-within-1h"),
    SelectListItem(text: "Exercising regularly", value: "regular-exercise"),
    SelectListItem(
        text: "Waking up at the same time every day", value: "regular-wakeup"),
  ];
}

class OwningTheDayNegative extends MultipleChoicePage {
  OwningTheDayNegative({Key? key}) : super(key: key);

  @override
  final nextPage = () => OwningTheDayNote();
  @override
  final prevPage = () => OwningTheDaySupporting();

  @override
  final title = "What else are you doing in the day";
  @override
  final image = null;

  @override
  final markdown = """
What you do during the day may also be helping or ‘sabo-ing’ (disrupting) your sleep!

Check all that applies to you

Things that may 'sabo' sleep:
""";

  @override
  final maxChoice = 0;
  @override
  final minSelected = 0;
  @override
  final valueName = "daytime-negative";
  @override
  final List<SelectListItem<String>> choices = [
    SelectListItem(
        text: "High-intensity exercise close to bedtime",
        value: "late-exercise"),
    SelectListItem(
        text: "Having a full meal close to bedtime", value: "late-full-meal"),
    SelectListItem(
        text: "Drinking too much water close to bedtime",
        value: "late-too-much-water"),
    SelectListItem(
        text:
            "Smoking cigarettes or ingesting other nicotine products 4 hours before bedtime",
        value: "late-smoking"),
    SelectListItem(
        text: "Having coffee or other caffeinated food/beverages after 2 pm",
        value: "late-caffeine"),
    SelectListItem(text: "Sleeping with pet in the room", value: "with-pet"),
  ];
}

class OwningTheDayNote extends MarkdownPage {
  OwningTheDayNote({Key? key}) : super(key: key);

  @override
  final nextPage = () => OwningWhy();
  @override
  final prevPage = () => OwningTheDayNegative();

  @override
  final title = "What else are you doing in the day";
  @override
  final image = null;

  @override
  final markdown = """
Now that you are aware of the need for good sleep and what could be tripping it up, what’s your reason for getting your sleep right?
""";
}

class OwningWhy extends OpenEndedPage {
  OwningWhy({Key? key}) : super(key: key);

  @override
  final nextPage = () => OwningWhatsNext();
  @override
  final prevPage = () => OwningTheDayNote();

  @override
  final title = "What's your why";
  @override
  final image = Image.asset("assets/images/sleep/ch05-think-want-get-it.gif");

  @override
  final markdown = """
What’s your motivation? A clear  “why” will help you keep going, and to pick yourself up when you stumble. 

List the reasons why better sleep is desirable for you. State these reasons in positive terms. e.g. “I aim to level up at work”, not “I don’t want to be fired from my job.”

Why I want to sleep better:
""";

  @override
  final valueName = "why-sleep-better";
}

class OwningWhatsNext extends MarkdownPage {
  OwningWhatsNext({Key? key}) : super(key: key);

  @override
  final nextPage = null;
  @override
  final prevPage = () => OwningWhy();

  @override
  final title = "What else are you doing in the day";
  @override
  final image = null;

  @override
  final markdown = """
Now that you know your why, what’s next?
""";
}
