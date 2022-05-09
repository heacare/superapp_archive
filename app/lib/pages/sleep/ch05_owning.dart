import 'package:flutter/material.dart' hide Page;

import 'package:hea/widgets/page.dart';
import 'package:hea/widgets/select_list.dart';
import 'ch03_goals.dart';
import 'ch04_rhythm.dart';
import 'ch06_routine.dart';

class OwningRoutine extends MarkdownPage {
  OwningRoutine({Key? key}) : super(key: key);

  @override
  final nextPage = () => OwningZeitgebers();
  @override
  final prevPage = () => RhythmSettingCourse();

  @override
  final title = "Rhythm is life and routine";
  @override
  final image = Image.asset("assets/images/sleep/ch05-daily-routine.webp");

  @override
  final markdown = """
Bedtime routines are **regular actions** done every night that **signal** winding down for sleep.

Light, temperature, meals, social activities and exercise are examples of cues that **influence** our **circadian rhythm** by inducing wakefulness or sleepiness. 

Dimming the lights or taking a warm bath/shower before bed are some relaxing actions we can do regularly to **cue our biological clock for bedtime**.
""";
}

class OwningZeitgebers extends MarkdownPage {
  OwningZeitgebers({Key? key}) : super(key: key);

  @override
  final nextPage = () => OwningRoutineActivities1();
  @override
  final prevPage = () => OwningRoutine();

  @override
  final title = "Zeitgebers";
  @override
  final image =
      Image.asset("assets/images/sleep/ch05-cim-circadian-clock-kyoung.webp");

  @override
  final markdown = """
External timing cues are known as ‘Zeitgebers’. In German ‘Zeit’ means ‘**time**’ and ‘geber’ means ‘**giver**’.

Regular exposure to zeitgebers acutely **activates** or **inhibits** the level of **hormones** and **neurotransmitters** that affect mental and behavioural changes for alertness, metabolism, recovery and growth.

**Let’s check in on your current sleep habits** - a.k.a. your ‘sleep hygiene’. Tweaking it can be a game changer.
""";
}

class OwningRoutineActivities1 extends MultipleChoicePage {
  OwningRoutineActivities1({Key? key}) : super(key: key);

  @override
  final nextPage = () => OwningRoutineActivities2();
  @override
  final prevPage = () => OwningZeitgebers();

  @override
  final title = "Existing routine";
  @override
  final image = null;

  @override
  final markdown = """
What do you usually do, up to an hour before bedtime could contribute to forming your bedtime routine and affect your quality of sleep.

Select the activities that you usually do before bed under each time section accordingly.

1 hour before bedtime, I usually find myself:
""";

  @override
  final maxChoice = 0;
  @override
  final minSelected = 1;
  @override
  final valueName = "routine-60m";
  @override
  final List<SelectListItem<String>> choices = activityChoices;
}

class OwningRoutineActivities2 extends MultipleChoicePage {
  OwningRoutineActivities2({Key? key}) : super(key: key);

  @override
  final nextPage = () => OwningRoutineActivities3();
  @override
  final prevPage = () => OwningRoutineActivities1();

  @override
  final title = "Existing routine";
  @override
  final image = null;

  @override
  final markdown = """
What do you usually do, up to an hour before bedtime could contribute to forming your bedtime routine and affect your quality of sleep.

Select the activities that you usually do before bed under each time section accordingly.

30 minutes before bedtime, I usually find myself:
""";

  @override
  final maxChoice = 0;
  @override
  final minSelected = 1;
  @override
  final valueName = "routine-30m";
  @override
  final List<SelectListItem<String>> choices = activityChoices;
}

class OwningRoutineActivities3 extends MultipleChoicePage {
  OwningRoutineActivities3({Key? key}) : super(key: key);

  @override
  final nextPage = () => OwningRoutineStart();
  @override
  final prevPage = () => OwningRoutineActivities2();

  @override
  final title = "Existing routine";
  @override
  final image = null;

  @override
  final markdown = """
What do you usually do, up to an hour before bedtime could contribute to forming your bedtime routine and affect your quality of sleep.

Select the activities that you usually do before bed under each time section accordingly.

15 minutes before bedtime, I usually find myself:
""";

  @override
  final maxChoice = 0;
  @override
  final minSelected = 1;
  @override
  final valueName = "routine-15m";
  @override
  final List<SelectListItem<String>> choices = activityChoices;
}

class OwningRoutineStart extends MarkdownPage {
  OwningRoutineStart({Key? key}) : super(key: key);

  @override
  final nextPage = () => OwningTheDaySupporting();
  @override
  final prevPage = () => OwningRoutineActivities3();

  @override
  final title = "Setting a routine";
  @override
  final image = null;

  @override
  final markdown = """
What you do during the day may also be helping or ‘sabo-ing’ (disrupting) your sleep! Let’s do a quick awareness check on this next. 
""";
}

class OwningTheDaySupporting extends MultipleChoicePage {
  OwningTheDaySupporting({Key? key}) : super(key: key);

  @override
  final nextPage = () => OwningTheDayNegative();
  @override
  final prevPage = () => OwningRoutineStart();

  @override
  final title = "Activity: What else could be affecting your sleep?";
  @override
  final image = Image.asset("assets/images/sleep/ch05-checkpoint.webp");

  @override
  final markdown = """
Which of these applies to you? Check all that applies.

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
  final title = "Activity: What else could be affecting your sleep?";
  @override
  final image = Image.asset("assets/images/sleep/ch05-checkpoint.webp");

  @override
  final markdown = """
Which of these applies to you? Check all that applies.

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
  final nextPage = () => RoutineBeforeBedtime();
  @override
  final prevPage = () => OwningTheDayNegative();

  @override
  final title = "What's your why";
  @override
  final image = null;

  @override
  final markdown = """
Now that you are aware of the need for good sleep lets use our understanding of the Circadian Rhythm and Zeitgebers to a bedtime routine. 
""";
}
