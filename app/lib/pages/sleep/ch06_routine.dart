import 'package:flutter/material.dart' hide Page;
import 'package:markdown/markdown.dart' as md;
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:hea/utils/kv_wrap.dart';
import 'package:hea/widgets/page.dart';
import 'package:hea/widgets/select_list.dart';
import 'ch05_owning.dart';
import 'ch07_diary.dart';

class RoutineBeforeBedtime extends MarkdownPage {
  RoutineBeforeBedtime({Key? key}) : super(key: key);

  @override
  final nextPage = () => RoutineIntro();
  @override
  final prevPage = () => OwningTheDayNote();

  @override
  final title = "Before 'bedtime', there is 'get ready for bedtime'";
  @override
  final image = Image.asset("assets/images/sleep/ch06-fake-sleep.webp");

  @override
  final markdown = """
Before you sleep, the brain’s sleep-wake mechanism is already releasing chemicals that **prepare your body for sleep**. Use this buffering period to mentally and physically separate yourself from activities that might keep you awake. 

This means stopping any stressful or stimulating work, worries and daytime drama. Mindful practices can help with this. 

You can set a 'get ready for bedtime’ reminder. This is not the time you get into bed to sleep. This is a winding down period. It can start from as early as sunset to some minutes before bed. 
""";
}

class RoutineIntro extends MarkdownPage {
  RoutineIntro({Key? key}) : super(key: key);

  @override
  final nextPage = () => RoutineActivities();
  @override
  final prevPage = () => RoutineBeforeBedtime();

  @override
  final title = "Activity: Winding down for the day";
  @override
  final image = Image.asset("assets/images/sleep/ch06-time-to-wind-down.webp");

  @override
  final markdown = """
Knowing your goals and obstacles to sleep, create a routine that works for you in the time you have before bed. 

It is tempting to try many things, but sometimes less is more. Focus on small easy-to-do actions that help to keep you motivated. 
""";
}

class RoutineActivities extends MultipleChoicePage {
  RoutineActivities({Key? key}) : super(key: key);

  @override
  final nextPage = () => RoutineCalmingActivities1();
  @override
  final prevPage = () => RoutineIntro();

  @override
  final title = "Activity: Winding down for the day";
  @override
  final image = null;

  @override
  final markdown = """
Here’s a list of possible actions for your routine. New to a bedtime routine? Start with one thing, and add another when you get comfortable with that.

Check as many as you wish to include in your routine:
""";

  @override
  final maxChoice = 0;
  @override
  final minSelected = 1;
  @override
  final valueName = "included-activities";
  @override
  final List<SelectListItem<String>> choices = calmActivityChoices;
}

final List<SelectListItem<String>> calmActivityChoices = [
  SelectListItem(
      text: "Dimming lights shortly after sunset",
      value: "Dimming lights shortly after sunset"),
  SelectListItem(
      text: "Setting up your sleep space to prepare for sleep",
      value: "Setting up your sleep space to prepare for sleep"),
  SelectListItem(
      text: "Hiding wake-promoting items (laptops, game consoles, books, etc.)",
      value:
          "Hiding wake-promoting items (laptops, game consoles, books, etc.)"),
  SelectListItem(
      text: "Silencing notifications and hiding phone from view",
      value: "Silencing notifications and hiding phone from view"),
  SelectListItem(
      text: "Having a warm shower/bath", value: "Having a warm shower/bath"),
  SelectListItem(
      text: "Journaling to declutter the mind",
      value: "Journaling to declutter the mind"),
  SelectListItem(text: "Relaxing stretches", value: "Relaxing stretches"),
  SelectListItem(
      text: "Practicing gentle yoga", value: "Practicing gentle yoga"),
  SelectListItem(text: "Breathing exercises", value: "Breathing exercises"),
  SelectListItem(text: "Meditating", value: "Meditating"),
  SelectListItem(text: "Other", value: "", other: true, otherMultiple: true),
];

abstract class RoutineCalmingActivities extends Page {
  const RoutineCalmingActivities({Key? key}) : super(key: key);

  abstract final Image? image;
  abstract final String markdown;

  abstract final String valueNameRemoveDefault;
  abstract final String valueNameRemove;
  abstract final String valueNameAddDefault;
  abstract final String valueNameAdd;

  /*
  bool canNext() {
    if (kvReadStringList("sleep", valueNameRemove).isEmpty) {
      return false;
    }
    if (kvReadStringList("sleep", valueNameAdd).isEmpty) {
      return false;
    }
    return true;
  }
  */

  @override
  Widget buildPage(BuildContext context) {
    final markdownStyleSheet = MarkdownStyleSheet(
        p: Theme.of(context).textTheme.bodyText1,
        h1: Theme.of(context).textTheme.headline3);
    var defaultSelectedRemove = kvReadStringList("sleep", valueNameRemove);
    /*
    if (defaultSelectedRemove.isEmpty) {
      defaultSelectedRemove = kvReadStringList("sleep", valueNameRemoveDefault);
    }
	*/
    List<SelectListItem<String>> selectedActivities =
        kvReadStringList("sleep", valueNameRemoveDefault)
            .map((s) => SelectListItem(text: s, value: s))
            .toList();
    var defaultSelectedAdd = kvReadStringList("sleep", valueNameAdd);
    /*
    if (defaultSelectedAdd.isEmpty) {
      defaultSelectedAdd = kvReadStringList("sleep", valueNameAddDefault);
    }
	*/
    List<SelectListItem<String>> selectedCalmActivities =
        kvReadStringList("sleep", valueNameAddDefault)
            .map((s) => SelectListItem(text: s, value: s))
            .toList();
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (image != null) image!,
          if (image != null) const SizedBox(height: 4.0),
          MarkdownBody(
              data: markdown,
              extensionSet: md.ExtensionSet.gitHubFlavored,
              styleSheet: markdownStyleSheet),
          const SizedBox(height: 8.0),
          Text(
            "I'd like to remove these",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SelectList(
              items: selectedActivities,
              max: 0,
              defaultSelected: defaultSelectedRemove,
              onChange: (List<String> c) {
                kvWrite<List<String>>("sleep", valueNameRemove, c);
              }),
          const SizedBox(height: 8.0),
          Text(
            "I'd like to add these",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SelectList(
              items: selectedCalmActivities,
              max: 0,
              defaultSelected: defaultSelectedAdd,
              onChange: (List<String> c) {
                kvWrite<List<String>>("sleep", valueNameAdd, c);
              }),
        ]);
  }
}

class RoutineCalmingActivities1 extends RoutineCalmingActivities {
  RoutineCalmingActivities1({Key? key}) : super(key: key);

  @override
  final nextPage = () => RoutineCalmingActivities2();
  @override
  final prevPage = () => RoutineActivities();

  @override
  final title = "Activity: Winding down for the day";

  @override
  final image = null;

  @override
  final valueNameRemoveDefault = "routine-60m";
  @override
  final valueNameRemove = "routine-remove-60m";
  @override
  final valueNameAddDefault = "included-activities";
  @override
  final valueNameAdd = "routine-add-60m";

  @override
  final markdown = """
Routine is a habit. You make your habits and your habits make you. Let’s see how you can remove/swap activating items for more calming ones.

**1 hour before bedtime**
""";
}

class RoutineCalmingActivities2 extends RoutineCalmingActivities {
  RoutineCalmingActivities2({Key? key}) : super(key: key);

  @override
  final nextPage = () => RoutineCalmingActivities3();
  @override
  final prevPage = () => RoutineCalmingActivities1();

  @override
  final title = "Activity: Winding down for the day";

  @override
  final image = null;

  @override
  final valueNameRemoveDefault = "routine-30m";
  @override
  final valueNameRemove = "routine-remove-30m";
  @override
  final valueNameAddDefault = "included-activities";
  @override
  final valueNameAdd = "routine-add-30m";

  @override
  final markdown = """
Routine is a habit. You make your habits and your habits make you. Let’s see how you can remove/swap activating items for more calming ones.

**30 minutes before bedtime**
""";
}

class RoutineCalmingActivities3 extends RoutineCalmingActivities {
  RoutineCalmingActivities3({Key? key}) : super(key: key);

  @override
  final nextPage = () => RoutineCalmingActivitiesNote();
  @override
  final prevPage = () => RoutineCalmingActivities2();

  @override
  final title = "Activity: Winding down for the day";

  @override
  final image = null;

  @override
  final valueNameRemoveDefault = "routine-15m";
  @override
  final valueNameRemove = "routine-remove-15m";
  @override
  final valueNameAddDefault = "included-activities";
  @override
  final valueNameAdd = "routine-add-15m";

  @override
  final markdown = """
Routine is a habit. You make your habits and your habits make you. Let’s see how you can remove/swap activating items for more calming ones.

**15 minutes before bedtime**
""";
}

class RoutineCalmingActivitiesNote extends MarkdownPage {
  RoutineCalmingActivitiesNote({Key? key}) : super(key: key);

  @override
  final nextPage = () => RoutineReminders();
  @override
  final prevPage = () => RoutineCalmingActivities3();

  @override
  final title = "Activity: Winding down for the day";
  @override
  final image = Image.asset("assets/images/sleep/ch06-time-to-wind-down.webp");

  @override
  final markdown = """
Test out your bedtime routine for a week. You can always fine tune it to work better for you. 
""";
}

// Chapter 7

class RoutineReminders extends TimePickerPage {
  RoutineReminders({Key? key}) : super(key: key);

  @override
  final nextPage = () => RoutineOptInGroup();
  @override
  final prevPage = () => RoutineCalmingActivitiesNote();

  @override
  final title = "Let's help with reminders";
  @override
  final image = Image.asset("assets/images/sleep/ch06-reminder-self-care.webp");

  @override
  final markdown = """
Remember, consistency is key. Winding down at the same time before bed signals your body to prepare for sleep. We’re here to help by sending you a daily reminder. 

Noting that you wish to start winding down at least <1 hour / 30 mins / 15 mins> before bed.  When would you like to be reminded to start winding down for sleep? 
""";

  @override
  final defaultTime = const TimeOfDay(hour: 22, minute: 00);
  @override
  final valueName = "routine-reminder-times";
}

class RoutineOptInGroup extends MultipleChoicePage {
  RoutineOptInGroup({Key? key}) : super(key: key);

  @override
  final nextPage = () {
    String g = kvReadStringList("sleep", "opt-in-group")[0];
    if (g == "yes") {
      return RoutineGroupInstructions();
    }
    return RoutinePledgeIntro();
  };
  @override
  final prevPage = () => RoutineReminders();

  @override
  final title = "Want to improve your sleep with others like you?";
  @override
  final image = Image.asset("assets/images/sleep/ch06-bus-buddies-omori.webp");

  @override
  final markdown = """
> “If you want to go fast, go alone. If you want to go far, go together.”
> African Proverb

Haven’t we all started and stopped, even with the best intentions? There’s nothing like hanging out with a supportive group cheering you on to success. 

Opt in for group challenges. Your sleep profile will help us to match you with the best sleep buddies to help keep you accountable on this journey. 

You’ll be added into a chat group of up to four people with one of our HEAlers.
""";

  @override
  final maxChoice = 1;
  @override
  final minSelected = 1;
  @override
  final valueName = "opt-in-group";
  @override
  final List<SelectListItem<String>> choices = [
    SelectListItem(text: "Join others", value: "yes"),
    SelectListItem(text: "Go on it alone", value: "no"),
  ];
}

class RoutineGroupInstructions extends MultipleChoicePage {
  RoutineGroupInstructions({Key? key}) : super(key: key);

  @override
  final nextPage = () => RoutinePledgeIntro();
  @override
  final prevPage = () => RoutineOptInGroup();

  @override
  final title = "Join sleep buddies";
  @override
  final image = null;

  @override
  final markdown = """
$groupInstructions
""";

  @override
  final maxChoice = 1;
  @override
  final minSelected = 1;
  @override
  final valueName = "group-accept";
  @override
  final List<SelectListItem<String>> choices = [
    SelectListItem(text: "Agree", value: "yes"),
    SelectListItem(text: "Cancel", value: "no"),
  ];
}

String groupInstructions = """
You’ve chosen to be part of a team. Wonderful! Humans are social creatures. Having encouraging sleep buddies can make a huge difference.

To keep things cosy, a team will never have more than 4 people. You can leave your team whenever. New sleep buddies may also join if a spot opens. 

We’ll be matching you with the best sleep buddies based on your sleep profile, goals and challenges on WhatsApp/Telegram.

Meanwhile, to create a safe environment for all sleep buddies, please read and agree to the following community practices to proceed: 

# Rules of Engagement 

1. Keep it relevant, constructive and inclusive
2. No hate speech or bullying
3. Be respectful of different opinions
4. Refrain from giving medical advice
5. Do help to moderate discussions
6. Refrain from promotion or solicitation of products or services
""";

class RoutinePledgeIntro extends MarkdownPage {
  RoutinePledgeIntro({Key? key}) : super(key: key);

  @override
  final nextPage = () => RoutinePledge();
  @override
  final prevPage = () => RoutineOptInGroup();

  @override
  final title = "Activity: My commitment to sleep";
  @override
  final image = Image.asset("assets/images/sleep/ch06-my-sleep-pledge.webp");

  @override
  final markdown = """
Over the next week, we’ll help you commit to a routine to improve your sleep. Review your pledge and choose one thing to start practising for the next 7 days.

#tip: Inform your friends, family and co-workers of your intention to sleep better. This can help create support for you. Who knows, they might be keen to improve their sleep too.
""";
}

class RoutinePledge extends StatefulWidget {
  final PageBuilder? nextPage = () => DiaryReminders();
  final PageBuilder? prevPage = () => RoutinePledgeIntro();

  final String title = "Activity: My commitment to sleep";
  final Image? image =
      Image.asset("assets/images/sleep/ch06-my-sleep-pledge.webp");

  final int maxChoice = 1;
  final int? minSelected = null;

  RoutinePledge({Key? key}) : super(key: key);

  @override
  State<RoutinePledge> createState() => RoutinePledgeState();
}

class RoutinePledgeState extends State<RoutinePledge> {
  bool hideNext = false;

  bool canNext() {
    int minLength = widget.minSelected ?? 1;
    return kvReadStringList("sleep", "commit-habit").length >= minLength;
  }

  @override
  void initState() {
    super.initState();
    hideNext = !canNext();
  }

  @override
  Widget build(BuildContext context) {
    final markdownStyleSheet = MarkdownStyleSheet(
        p: Theme.of(context).textTheme.bodyText1,
        h1: Theme.of(context).textTheme.headline3);
    List<String> goals = kvReadStringList("sleep", "sleep-goals");
    String goalsText = formatList(goals);

    TimeOfDay goalsWakeTime = kvReadTimeOfDay("sleep", "goals-wake-time") ??
        const TimeOfDay(hour: 0, minute: 0);
    String goalsWakeTimeText = goalsWakeTime.format(context);
    TimeOfDay goalsSleepTime = kvReadTimeOfDay("sleep", "goals-sleep-time") ??
        const TimeOfDay(hour: 0, minute: 0);
    String goalsSleepTimeText = goalsSleepTime.format(context);
    List<String> doingBeforeBed = kvReadStringList("sleep", "doing-before-bed");
    String doingBeforeBedText = formatList(doingBeforeBed);

    int sleepForMinutes = ((goalsWakeTime.minute + goalsWakeTime.hour * 60) -
            (goalsSleepTime.minute + goalsSleepTime.hour * 60)) %
        (24 * 60);
    Duration sleepFor = Duration(minutes: sleepForMinutes);
    String goalsSleepDurationText =
        "${sleepFor.inHours} hours and ${sleepFor.inMinutes.remainder(Duration.minutesPerHour)} minutes";

    List<String> includedActivities =
        kvReadStringList("sleep", "included-activities");
    List<SelectListItem<String>> selectedActivities = includedActivities
        .map((s) => SelectListItem(text: s, value: s))
        .toList();
    return BasePage(
        title: widget.title,
        nextPage: widget.nextPage,
        prevPage: widget.prevPage,
        hideNext: hideNext,
        page: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (widget.image != null) widget.image!,
              if (widget.image != null) const SizedBox(height: 4.0),
              MarkdownBody(
                  data: """
I'd like to $goalsText

My desired sleep duration is $goalsSleepDurationText. If I'd like to wake up by $goalsWakeTimeText, I should be sleeping by $goalsSleepTimeText.

I've identified $doingBeforeBedText as obstacles from reaching my goals.
""",
                  extensionSet: md.ExtensionSet.gitHubFlavored,
                  styleSheet: markdownStyleSheet),
              const SizedBox(height: 4.0),
              MarkdownBody(
                  data: """
**To start sleeping better, I am going to commit to doing one of the following over the next 7 days:**
""",
                  extensionSet: md.ExtensionSet.gitHubFlavored,
                  styleSheet: markdownStyleSheet),
              const SizedBox(height: 4.0),
              SelectList(
                  items: selectedActivities,
                  max: 1,
                  defaultSelected: kvReadStringList("sleep", "commit-habit"),
                  onChange: (List<String> c) {
                    kvWrite<List<String>>("sleep", "commit-habit", c);
                    setState(() {
                      hideNext = !canNext();
                    });
                  }),
            ]));
  }
}

String formatList(List<String> l) {
  String text = "";
  for (int i = 0; i < l.length; i++) {
    String item = l[i];
    if (i == l.length - 1) {
      text += " and ";
    } else if (i > 0) {
      text += ", ";
    }
    text += item;
  }
  return text;
}
