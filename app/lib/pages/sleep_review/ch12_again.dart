import 'package:flutter/material.dart' hide Page;
import 'package:markdown/markdown.dart' as md;
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:hea/utils/kv_wrap.dart';
import 'package:hea/widgets/page.dart';
import 'package:hea/widgets/select_list.dart';
import 'package:hea/widgets/gradient_button.dart';
import 'package:hea/services/service_locator.dart';
import 'package:hea/services/health_service.dart';

class ReviewIntroduction extends MarkdownPage {
  ReviewIntroduction({Key? key}) : super(key: key);

  @override
  final nextPage = () => ReviewPracticing();
  @override
  final prevPage = null;

  @override
  final title = "Hello again!";
  @override
  final image = null;

  @override
  final markdown = """
It has been 30 days since the intervention ended. Let’s check-in on how you’re doing. This time, we ask that you reflect on your sleep for the past 14 days. 
""";
}

class ReviewPracticing extends MultipleChoicePage {
  ReviewPracticing({Key? key}) : super(key: key);

  @override
  final nextPage = null;
  @override
  final prevPage = () => ReviewIntroduction();

  @override
  final title = "Are you still practising your sleep routine?";
  @override
  final image = null;

  @override
  final markdown = """""";

  @override
  final maxChoice = 1;
  @override
  final minSelected = 1;
  @override
  final valueName = "review-still-practising";
  @override
  final List<SelectListItem<String>> choices = [
    SelectListItem(text: "Yes", value: "yes"),
    SelectListItem(text: "Some", value: "some"),
    SelectListItem(text: "No", value: "no"),
  ];

  @override
  bool hasNextPageStringList() => true;
  @override
  Widget nextPageStringList(List<String> data) {
    String choice = data[0];
    if (choice == "yes") {
      return ReviewPracticingYes();
    } else if (choice == "some") {
      return ReviewPracticingSome();
    } else if (choice == "no") {
      return ReviewPracticingNo();
    }
    return ReviewPracticing();
  }
}

class ReviewPracticingYes extends OpenEndedPage {
  ReviewPracticingYes({Key? key}) : super(key: key);

  @override
  final nextPage = () => ReviewGoals();
  @override
  final prevPage = () => ReviewPracticing();

  @override
  final title = "What have you been doing consistently?";
  @override
  final image = null;

  @override
  final markdown = """""";

  @override
  final valueName = "review-still-practising-yes";
  @override
  final label = "I have been...";
}

class ReviewPracticingNo extends OpenEndedPage {
  ReviewPracticingNo({Key? key}) : super(key: key);

  @override
  final nextPage = () => ReviewGoals();
  @override
  final prevPage = () => ReviewPracticing();

  @override
  final title = "Why have you not been practising?";
  @override
  final image = null;

  @override
  final markdown = """""";

  @override
  final valueName = "review-still-practising-no";
  @override
  final label = "It is...";
}

class ReviewPracticingSome extends OpenEndedPage {
  ReviewPracticingSome({Key? key}) : super(key: key);

  @override
  final nextPage = () => ReviewGoals();
  @override
  final prevPage = () => ReviewPracticing();

  @override
  final title = "If some, what did you discover?";
  @override
  final image = null;

  @override
  final markdown = """""";

  @override
  final valueName = "review-still-practising-some";
  @override
  final label = "I felt that...";
}

class ReviewGoals extends MultipleChoicePage {
  ReviewGoals({Key? key}) : super(key: key);

  @override
  final nextPage = () {
    List<String> otherHealthAspects =
        kvReadStringList("sleep", "other-health-aspects");
    if (otherHealthAspects.isEmpty) {
      return ReviewTimeGoneBed();
    }
    return ReviewOtherHealthAspects();
  };
  @override
  final prevPage = () {
    String? choice = kvRead<String>("sleep", "review-still-practising");
    if (choice == "yes") {
      return ReviewPracticingYes();
    } else if (choice == "some") {
      return ReviewPracticingSome();
    } else if (choice == "no") {
      return ReviewPracticingNo();
    }
    return ReviewPracticing();
  };

  @override
  final title = "Sleep goals";
  @override
  final image = Image.asset("assets/images/sleep/ch03-sleeping-ideal.webp");

  @override
  final markdown = """
These were the sleep goals you picked to pursue. Which of these sleep goals are you still pursuing?
""";

  @override
  final maxChoice = 0;
  @override
  final minSelected = 1;
  @override
  final valueName = "review-goals";
  @override
  List<SelectListItem<String>> get choices {
    return kvReadStringList("sleep", "sleep-goals")
        .map((s) => SelectListItem(text: s, value: s))
        .toList();
  }
}

class ReviewOtherHealthAspects extends StatefulWidget {
  ReviewOtherHealthAspects({Key? key}) : super(key: key);

  final PageBuilder? nextPage = () => ReviewTimeGoneBed();
  final PageBuilder? prevPage = () => ReviewGoals();

  final title = "Embrace and manifest";

  @override
  State<ReviewOtherHealthAspects> createState() =>
      ReviewOtherHealthAspectsState();
}

class ReviewOtherHealthAspectsState extends State<ReviewOtherHealthAspects> {
  double meal = 2;
  bool hideNext = false;

  @override
  void initState() {
    super.initState();
    meal = kvRead<double>("sleep", "review-diet") ?? 2;
    kvWrite("sleep", "review-diet", meal);
  }

  canNext(List<String> otherHealthAspects) {
    if (otherHealthAspects.contains("stress") &&
        kvReadStringList("sleep", "review-stress").isEmpty) {
      return false;
    }
    if (otherHealthAspects.contains("exercise") &&
        kvReadStringList("sleep", "review-exercise").isEmpty) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final markdownStyleSheet = MarkdownStyleSheet(
        p: Theme.of(context).textTheme.bodyText1,
        h1: Theme.of(context).textTheme.headline3);
    List<String> otherHealthAspects =
        kvReadStringList("sleep", "other-health-aspects");
    bool stress = false;
    bool diet = false;
    bool exercise = false;
    if (otherHealthAspects.contains("stress")) {
      stress = true;
    }
    if (otherHealthAspects.contains("diet")) {
      diet = true;
    }
    if (otherHealthAspects.contains("exercise")) {
      exercise = true;
    }

    hideNext = !canNext(otherHealthAspects);
    debugPrint("render other health aspects");

    return BasePage(
        title: widget.title,
        nextPage: widget.nextPage,
        prevPage: widget.prevPage,
        hideNext: hideNext,
        page: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
            Widget>[
          if (stress)
            Text(
                "How often did you go to bed feeling stressed in the last 14 days?",
                style: Theme.of(context).textTheme.titleLarge),
          if (stress)
            SelectList(
                items: [
                  SelectListItem(text: "Almost never", value: "0"),
                  SelectListItem(text: "Less than once a week", value: "1"),
                  SelectListItem(text: "2 to 3 times a week", value: "2"),
                  SelectListItem(text: "More than 3 times a week", value: "3"),
                  SelectListItem(text: "Almost everyday", value: "4"),
                ],
                max: 1,
                defaultSelected: kvReadStringList("sleep", "review-stress"),
                onChange: (List<String> c) {
                  kvWrite<List<String>>("sleep", "review-stress", c);
                  setState(() {
                    hideNext = !canNext(otherHealthAspects);
                  });
                }),
          if (stress) const SizedBox(height: 64.0),
          if (diet)
            Text(
                "How did you feel about your meal choices in the last 14 days?",
                style: Theme.of(context).textTheme.titleLarge),
          if (diet)
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Very dissatisfied"),
                  Text("Very satisfied"),
                ]),
          if (diet)
            Slider(
              value: meal,
              max: 4,
              divisions: 4,
              onChanged: (double value) {
                setState(() {
                  meal = value;
                });
                kvWrite("sleep", "review-diet", value);
              },
            ),
          if (diet) const SizedBox(height: 64.0),
          if (exercise)
            Text("How often did you exercise in the last 14 days?",
                style: Theme.of(context).textTheme.titleLarge),
          if (exercise)
            SelectList(
                items: [
                  SelectListItem(text: "Not at all", value: "0"),
                  SelectListItem(text: "1-2 times a week", value: "1"),
                  SelectListItem(text: "3-4 times a week", value: "2"),
                  SelectListItem(text: "5-7 times a week", value: "3"),
                ],
                max: 1,
                defaultSelected: kvReadStringList("sleep", "review-exercise"),
                onChange: (List<String> c) {
                  kvWrite<List<String>>("sleep", "review-exercise", c);
                  setState(() {
                    hideNext = !canNext(otherHealthAspects);
                  });
                }),
          if (exercise) const SizedBox(height: 64.0),
        ]));
  }
}

class ReviewTimeGoneBed extends TimePickerPage {
  ReviewTimeGoneBed({Key? key}) : super(key: key);

  @override
  final nextPage = () => ReviewMinutesFallAsleep();
  @override
  final prevPage = null;

  @override
  final title = "In the past month";
  @override
  final image = null;

  @override
  final markdown = "When have you usually gone to bed?";

  @override
  final valueName = "review-time-go-bed";
  @override
  final defaultTime = const TimeOfDay(hour: 23, minute: 00);
  @override
  Future<TimeOfDay?> getInitialTime(Function(String) setAutofillMessage) async {
    SleepAutofill? sleep =
        await serviceLocator<HealthService>().autofillRead30Day();
    if (sleep != null && sleep.inBed != null) {
      setAutofillMessage(
          "For those connected to your health app, we’ve managed to pull some data from your device from the last 30 days. You may edit the fields if you don’t think the numbers are accurate. Sometimes our devices think they know us better than ourselves ;)");
      return TimeOfDay.fromDateTime(sleep.inBed!);
    }
    setAutofillMessage("Please provide your best estimate");
    return null;
  }
}

class ReviewMinutesFallAsleep extends DurationPickerPage {
  ReviewMinutesFallAsleep({Key? key}) : super(key: key);

  @override
  final nextPage = () => ReviewTimeOutBed();
  @override
  final prevPage = () => ReviewTimeGoneBed();

  @override
  final title = "In the past month";
  @override
  final image = null;

  @override
  final markdown = """
How many minutes does it usually take you to fall asleep?
""";

  @override
  final valueName = "review-sleep-latency";
  @override
  final minutesOnly = true;
  @override
  Future<int?> getInitialMinutes(Function(String) setAutofillMessage) async {
    SleepAutofill? sleep =
        await serviceLocator<HealthService>().autofillRead30Day();
    if (sleep != null && sleep.sleepLatencyMinutes > 0) {
      setAutofillMessage("Was autofilled using data from the last 30 days");
      return sleep.sleepLatencyMinutes;
    }
    setAutofillMessage("Please provide your best estimate");
    return null;
  }
}

class ReviewTimeOutBed extends TimePickerPage {
  ReviewTimeOutBed({Key? key}) : super(key: key);

  @override
  final nextPage = () => ReviewGetSleep();
  @override
  final prevPage = () => ReviewMinutesFallAsleep();

  @override
  final title = "In the past month";
  @override
  final image = null;

  @override
  final markdown = """
When have you usually gotten out of bed?
""";

  @override
  final valueName = "review-time-out-bed";
  @override
  final defaultTime = const TimeOfDay(hour: 7, minute: 00);
  @override
  Future<TimeOfDay?> getInitialTime(Function(String) setAutofillMessage) async {
    SleepAutofill? sleep =
        await serviceLocator<HealthService>().autofillRead30Day();
    if (sleep != null && sleep.awake != null) {
      setAutofillMessage("Was autofilled using data from the last 30 days");
      return TimeOfDay.fromDateTime(sleep.awake!);
    }
    setAutofillMessage("Please provide your best estimate");
    return null;
  }
}

class ReviewGetSleep extends DurationPickerPage {
  ReviewGetSleep({Key? key}) : super(key: key);

  @override
  final nextPage = () => ReviewDifficultySleeping();
  @override
  final prevPage = () => ReviewTimeOutBed();

  @override
  final title = "In the past month";
  @override
  final image = null;

  @override
  final markdown = """
On average, how many actual hours of sleep do you get at night?
*(This differs from the number of hours you spend in bed.)*
""";

  @override
  final valueName = "review-minutes-asleep";
  @override
  final minutesOnly = false;
  @override
  Future<int?> getInitialMinutes(Function(String) setAutofillMessage) async {
    SleepAutofill? sleep =
        await serviceLocator<HealthService>().autofillRead30Day();
    if (sleep != null && sleep.sleepMinutes > 0) {
      setAutofillMessage("Was autofilled using data from the last 30 days");
      return sleep.sleepMinutes;
    }
    setAutofillMessage("Please provide your best estimate");
    return null;
  }
}

class ReviewDifficultySleeping extends MultipleChoicePage {
  ReviewDifficultySleeping({Key? key}) : super(key: key);

  @override
  final nextPage = () => ReviewSleepDisturbances();
  @override
  final prevPage = () => ReviewGetSleep();

  @override
  final title = "In the past month";
  @override
  final image = Image.asset("assets/images/sleep/ch02-porucz-sleepy.webp");

  @override
  final markdown = """
How often were you unable to fall asleep within 30 minutes?
""";

  @override
  final maxChoice = 1;
  @override
  final minSelected = 1;
  @override
  final valueName = "review-how-often-asleep-30-minutes";
  @override
  final List<SelectListItem<String>> choices = [
    SelectListItem(text: "Not during the past month", value: "0"),
    SelectListItem(text: "Less than once a week", value: "1"),
    SelectListItem(text: "Once or twice a week", value: "2"),
    SelectListItem(text: "Three or more times a week", value: "3"),
  ];
}

class ReviewSleepDisturbances extends MarkdownPage {
  ReviewSleepDisturbances({Key? key}) : super(key: key);

  @override
  final nextPage = () => ReviewTroubleSleepingWakeUp();
  @override
  final prevPage = () => ReviewDifficultySleeping();

  @override
  final title = "Sleep disturbances";
  @override
  final image = Image.asset("assets/images/sleep/ch02-insomnia-sleepy.webp");

  @override
  final markdown = """
The next few questions will need you to recall when your sleep has been disturbed. It is a disturbance only if you’re not able to fall back to sleep easily, or if it affects the quality of your sleep.
""";
}

class ReviewTroubleSleepingWakeUp extends MultipleChoicePage {
  ReviewTroubleSleepingWakeUp({Key? key}) : super(key: key);

  @override
  final nextPage = () => ReviewTroubleSleepingBathroom();
  @override
  final prevPage = () => ReviewSleepDisturbances();

  @override
  final title = "Sleep disturbances";
  @override
  final image = Image.asset("assets/images/sleep/ch02-insomnia-sleepy.webp");

  @override
  final markdown = """
How often have you had trouble sleeping because you woke up in the middle of the night?
""";

  @override
  final maxChoice = 1;
  @override
  final minSelected = 1;
  @override
  final valueName = "review-how-often-wake-up";
  @override
  final List<SelectListItem<String>> choices = [
    SelectListItem(text: "Not during the past month", value: "0"),
    SelectListItem(text: "Less than once a week", value: "1"),
    SelectListItem(text: "Once or twice a week", value: "2"),
    SelectListItem(text: "Three or more times a week", value: "3"),
  ];
}

class ReviewTroubleSleepingBathroom extends MultipleChoicePage {
  ReviewTroubleSleepingBathroom({Key? key}) : super(key: key);

  @override
  final nextPage = () => ReviewTroubleSleepingBreath();
  @override
  final prevPage = () => ReviewTroubleSleepingWakeUp();

  @override
  final title = "Sleep disturbances";
  @override
  final image = Image.asset("assets/images/sleep/ch02-insomnia-sleepy.webp");

  @override
  final markdown = """
How often have you had trouble sleeping because you got up to use the bathroom?
""";

  @override
  final maxChoice = 1;
  @override
  final minSelected = 1;
  @override
  final valueName = "review-how-often-bathroom";
  @override
  final List<SelectListItem<String>> choices = [
    SelectListItem(text: "Not during the past month", value: "0"),
    SelectListItem(text: "Less than once a week", value: "1"),
    SelectListItem(text: "Once or twice a week", value: "2"),
    SelectListItem(text: "Three or more times a week", value: "3"),
  ];
}

class ReviewTroubleSleepingBreath extends MultipleChoicePage {
  ReviewTroubleSleepingBreath({Key? key}) : super(key: key);

  @override
  final nextPage = () => ReviewTroubleSleepingSnore();
  @override
  final prevPage = () => ReviewTroubleSleepingBathroom();

  @override
  final title = "Sleep disturbances";
  @override
  final image = Image.asset("assets/images/sleep/ch02-snoring-continues.webp");

  @override
  final markdown = """
How often have you had trouble sleeping because you couldn’t breathe comfortably?
""";

  @override
  final maxChoice = 1;
  @override
  final minSelected = 1;
  @override
  final valueName = "review-how-often-breath";
  @override
  final List<SelectListItem<String>> choices = [
    SelectListItem(text: "Not during the past month", value: "0"),
    SelectListItem(text: "Less than once a week", value: "1"),
    SelectListItem(text: "Once or twice a week", value: "2"),
    SelectListItem(text: "Three or more times a week", value: "3"),
  ];
}

class ReviewTroubleSleepingSnore extends MultipleChoicePage {
  ReviewTroubleSleepingSnore({Key? key}) : super(key: key);

  @override
  final nextPage = () => ReviewTroubleSleepingCold();
  @override
  final prevPage = () => ReviewTroubleSleepingBreath();

  @override
  final title = "Sleep disturbances";
  @override
  final image = Image.asset("assets/images/sleep/ch02-snoring-continues.webp");

  @override
  final markdown = """
How often have you had trouble sleeping because you snored?
""";

  @override
  final maxChoice = 1;
  @override
  final minSelected = 1;
  @override
  final valueName = "review-how-often-snore";
  @override
  final List<SelectListItem<String>> choices = [
    SelectListItem(text: "Not during the past month", value: "0"),
    SelectListItem(text: "Less than once a week", value: "1"),
    SelectListItem(text: "Once or twice a week", value: "2"),
    SelectListItem(text: "Three or more times a week", value: "3"),
  ];
}

class ReviewTroubleSleepingCold extends MultipleChoicePage {
  ReviewTroubleSleepingCold({Key? key}) : super(key: key);

  @override
  final nextPage = () => ReviewTroubleSleepingHot();
  @override
  final prevPage = () => ReviewTroubleSleepingSnore();

  @override
  final title = "Sleep disturbances";
  @override
  final image = Image.asset("assets/images/sleep/ch02-monster-under-bed.webp");

  @override
  final markdown = """
How often have you had trouble sleeping because you felt too cold?
""";

  @override
  final maxChoice = 1;
  @override
  final minSelected = 1;
  @override
  final valueName = "review-how-often-cold";
  @override
  final List<SelectListItem<String>> choices = [
    SelectListItem(text: "Not during the past month", value: "0"),
    SelectListItem(text: "Less than once a week", value: "1"),
    SelectListItem(text: "Once or twice a week", value: "2"),
    SelectListItem(text: "Three or more times a week", value: "3"),
  ];
}

class ReviewTroubleSleepingHot extends MultipleChoicePage {
  ReviewTroubleSleepingHot({Key? key}) : super(key: key);

  @override
  final nextPage = () => ReviewTroubleSleepingBadDreams();
  @override
  final prevPage = () => ReviewTroubleSleepingCold();

  @override
  final title = "Sleep disturbances";
  @override
  final image = Image.asset("assets/images/sleep/ch02-monster-under-bed.webp");

  @override
  final markdown = """
How often have you had trouble sleeping because you felt too hot?
""";

  @override
  final maxChoice = 1;
  @override
  final minSelected = 1;
  @override
  final valueName = "review-how-often-hot";
  @override
  final List<SelectListItem<String>> choices = [
    SelectListItem(text: "Not during the past month", value: "0"),
    SelectListItem(text: "Less than once a week", value: "1"),
    SelectListItem(text: "Once or twice a week", value: "2"),
    SelectListItem(text: "Three or more times a week", value: "3"),
  ];
}

class ReviewTroubleSleepingBadDreams extends MultipleChoicePage {
  ReviewTroubleSleepingBadDreams({Key? key}) : super(key: key);

  @override
  final nextPage = () => ReviewTroubleSleepingPain();
  @override
  final prevPage = () => ReviewTroubleSleepingHot();

  @override
  final title = "Sleep disturbances";
  @override
  final image = Image.asset("assets/images/sleep/ch02-monster-under-bed.webp");

  @override
  final markdown = """
How often have you had trouble sleeping because you had bad dreams?
""";

  @override
  final maxChoice = 1;
  @override
  final minSelected = 1;
  @override
  final valueName = "review-how-often-bad-dreams";
  @override
  final List<SelectListItem<String>> choices = [
    SelectListItem(text: "Not during the past month", value: "0"),
    SelectListItem(text: "Less than once a week", value: "1"),
    SelectListItem(text: "Once or twice a week", value: "2"),
    SelectListItem(text: "Three or more times a week", value: "3"),
  ];
}

class ReviewTroubleSleepingPain extends MultipleChoicePage {
  ReviewTroubleSleepingPain({Key? key}) : super(key: key);

  @override
  final nextPage = () => ReviewOtherFactors();
  @override
  final prevPage = () => ReviewTroubleSleepingBadDreams();

  @override
  final title = "Sleep disturbances";
  @override
  final image = Image.asset("assets/images/sleep/ch02-monster-under-bed.webp");

  @override
  final markdown = """
How often have you had trouble sleeping because you had pain?
""";

  @override
  final maxChoice = 1;
  @override
  final minSelected = 1;
  @override
  final valueName = "review-how-often-pain";
  @override
  final List<SelectListItem<String>> choices = [
    SelectListItem(text: "Not during the past month", value: "0"),
    SelectListItem(text: "Less than once a week", value: "1"),
    SelectListItem(text: "Once or twice a week", value: "2"),
    SelectListItem(text: "Three or more times a week", value: "3"),
  ];
}

class ReviewOtherFactors extends Page {
  ReviewOtherFactors({Key? key}) : super(key: key);

  @override
  final nextPage = () => ReviewOverallQuality();
  @override
  final prevPage = () => ReviewTroubleSleepingPain();

  @override
  final title = "Other sleep disturbances";
  final image =
      Image.asset("assets/images/sleep/ch02-wake-up-are-you-awake.webp");

  @override
  Widget buildPage(BuildContext context) {
    final markdownStyleSheet = MarkdownStyleSheet(
        p: Theme.of(context).textTheme.bodyText1,
        h1: Theme.of(context).textTheme.headline3);
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          PageImage(image),
          const SizedBox(height: 4.0),
          if (markdown != "")
            MarkdownBody(
                data: markdown,
                extensionSet: md.ExtensionSet.gitHubFlavored,
                styleSheet: markdownStyleSheet),
          if (markdown != "") const SizedBox(height: 4.0),
          TextFormField(
              initialValue: kvRead("sleep", "$valueName-reason"),
              decoration: const InputDecoration(
                labelText: "Type the other factor(s) here",
              ),
              onChanged: (String value) {
                kvWrite<String>("sleep", "$valueName-reason", value);
              }),
          if (markdown2 != "")
            MarkdownBody(
                data: markdown2,
                extensionSet: md.ExtensionSet.gitHubFlavored,
                styleSheet: markdownStyleSheet),
          if (markdown2 != "") const SizedBox(height: 4.0),
          SelectList(
              items: choices,
              max: maxChoice,
              defaultSelected: kvReadStringList("sleep", valueName),
              onChange: (List<String> c) {
                kvWrite<List<String>>("sleep", valueName, c);
              }),
        ]);
  }

  final markdown = """
What other factors might have disturbed your sleep?
""";

  final markdown2 = """
How often during the past month have you had trouble sleeping because of this?
""";

  final maxChoice = 1;
  final valueName = "review-how-often-other";
  final List<SelectListItem<String>> choices = [
    SelectListItem(text: "Not during the past month", value: "0"),
    SelectListItem(text: "Less than once a week", value: "1"),
    SelectListItem(text: "Once or twice a week", value: "2"),
    SelectListItem(text: "Three or more times a week", value: "3"),
  ];
}

class ReviewOverallQuality extends MultipleChoicePage {
  ReviewOverallQuality({Key? key}) : super(key: key);

  @override
  final nextPage = () => ReviewSleepMedication();
  @override
  final prevPage = () => ReviewOtherFactors();

  @override
  final title = "Overall sleep quality";
  @override
  final image = Image.asset("assets/images/sleep/ch02-did-you-sleep-well.webp");

  @override
  final markdown = """
During the past month, how would you rate your sleep quality overall?
""";

  @override
  final maxChoice = 1;
  @override
  final minSelected = 1;
  @override
  final valueName = "review-overall-quality";
  @override
  final List<SelectListItem<String>> choices = [
    SelectListItem(text: "Very good", value: "0"),
    SelectListItem(text: "Fairly good", value: "1"),
    SelectListItem(text: "Fairly bad", value: "2"),
    SelectListItem(text: "Very bad", value: "3"),
  ];
}

class ReviewSleepMedication extends MultipleChoicePage {
  ReviewSleepMedication({Key? key}) : super(key: key);

  @override
  final nextPage = () => ReviewFatigue();
  @override
  final prevPage = () => ReviewOverallQuality();

  @override
  final title = "Sleep disturbances";
  @override
  final image =
      Image.asset("assets/images/sleep/ch02-ambien-sleeping-pills.webp");

  @override
  final markdown = """
During the past month, how often have you taken medicine (prescribed or “over the counter”) to help you sleep?
""";

  @override
  final maxChoice = 1;
  @override
  final minSelected = 1;
  @override
  final valueName = "review-how-sleep-medication";
  @override
  final List<SelectListItem<String>> choices = [
    SelectListItem(text: "Not during the past month", value: "0"),
    SelectListItem(text: "Less than once a week", value: "1"),
    SelectListItem(text: "Once or twice a week", value: "2"),
    SelectListItem(text: "Three or more times a week", value: "3"),
  ];
}

class ReviewFatigue extends MultipleChoicePage {
  ReviewFatigue({Key? key}) : super(key: key);

  @override
  final nextPage = () => ReviewEnthusiasm();
  @override
  final prevPage = () => ReviewSleepMedication();

  @override
  final title = "Fatigue, energy and enthusiasm";
  @override
  final image = Image.asset("assets/images/sleep/ch02-clapping-sleeping.webp");

  @override
  final markdown = """
During the past month...

How often have you had trouble staying awake while working/studying, eating, watching TV/radio, in a public setting (cinema, classroom, workplace), engaging in social activity or driving/operating machinery?
""";

  @override
  final maxChoice = 1;
  @override
  final minSelected = 1;
  @override
  final valueName = "review-how-fatigue";
  @override
  final List<SelectListItem<String>> choices = [
    SelectListItem(text: "Not during the past month", value: "0"),
    SelectListItem(text: "Less than once a week", value: "1"),
    SelectListItem(text: "Once or twice a week", value: "2"),
    SelectListItem(text: "Three or more times a week", value: "3"),
  ];
}

class ReviewEnthusiasm extends MultipleChoicePage {
  ReviewEnthusiasm({Key? key}) : super(key: key);

  @override
  final nextPage = () => ReviewScore();
  @override
  final prevPage = () => ReviewFatigue();

  @override
  final title = "Fatigue, energy and enthusiasm";
  @override
  final image = Image.asset("assets/images/sleep/ch02-clapping-sleeping.webp");

  @override
  final markdown = """
During the past month, how much of a problem has it been for you to keep up enough enthusiasm to get things done?
""";

  @override
  final maxChoice = 1;
  @override
  final minSelected = 1;
  @override
  final valueName = "review-how-enthusiasm";
  @override
  final List<SelectListItem<String>> choices = [
    SelectListItem(text: "Not during the past month", value: "0"),
    SelectListItem(text: "Less than once a week", value: "1"),
    SelectListItem(text: "Once or twice a week", value: "2"),
    SelectListItem(text: "Three or more times a week", value: "3"),
  ];
}

class ReviewScore extends Page {
  ReviewScore({Key? key}) : super(key: key);

  @override
  final nextPage = () => ReviewEnd();
  @override
  final prevPage = () => ReviewEnthusiasm();

  @override
  final title = "How's your sleep score?";
  final Image? image = Image.asset("assets/images/sleep/ch02-boss-gatsby.webp");

  @override
  Widget buildPage(BuildContext context) {
    final markdownStyleSheet = MarkdownStyleSheet(
        p: Theme.of(context).textTheme.bodyText1,
        h1: Theme.of(context).textTheme.headline3);
    int subjectiveSleepQuality =
        int.tryParse(kvReadStringList("sleep", "review-overall-quality")[0]) ??
            0;

    int fallAsleep = kvRead<int>("sleep", "review-sleep-latency") ?? 0;
    int pointsFallAsleep = 0;
    if (fallAsleep > 60) {
      pointsFallAsleep = 3;
    } else if (fallAsleep > 30) {
      pointsFallAsleep = 2;
    } else if (fallAsleep > 15) {
      pointsFallAsleep = 1;
    }
    int howOftenAsleep30Minutes = int.tryParse(kvReadStringList(
            "sleep", "review-how-often-asleep-30-minutes")[0]) ??
        0;
    int sleepLatency =
        ((pointsFallAsleep + howOftenAsleep30Minutes) / 2).ceil();

    int sleepTimeMinutes = kvReadInt("sleep", "review-minutes-asleep") ?? 0;
    Duration sleepTime = Duration(minutes: sleepTimeMinutes);
    String sleepTimeText =
        "${sleepTime.inHours} hours ${sleepTime.inMinutes.remainder(Duration.minutesPerHour)} minutes";

    TimeOfDay goBed = kvReadTimeOfDay("sleep", "review-time-go-bed") ??
        const TimeOfDay(hour: 0, minute: 0);
    TimeOfDay outBed = kvReadTimeOfDay("sleep", "review-time-out-bed") ??
        const TimeOfDay(hour: 0, minute: 0);
    int bedDuration = ((outBed.minute + outBed.hour * 60) -
            (goBed.minute + goBed.hour * 60)) %
        (24 * 60);
    int sleepDuration = kvReadInt("sleep", "review-minutes-asleep") ?? 0;
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

    int sleepMedication = int.tryParse(
            kvReadStringList("sleep", "review-how-sleep-medication")[0]) ??
        0;

    int pointsFatigue =
        int.tryParse(kvReadStringList("sleep", "review-how-fatigue")[0]) ?? 0;
    int pointsEnthusiasm =
        int.tryParse(kvReadStringList("sleep", "review-how-enthusiasm")[0]) ??
            0;
    int daytimeDysfunction = pointsFatigue + pointsEnthusiasm;

    int overallScore = sleepLatency +
        sleepEfficiency +
        sleepDisturbances +
        subjectiveSleepQuality +
        sleepMedication +
        daytimeDysfunction;
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (image != null) PageImage(image!),
          if (image != null) const SizedBox(height: 4.0),
          Center(
            child: Text(
              "Great work reflecting on your sleep. You have a sleep score of:",
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ),
          Center(
            child: Text(
              "$overallScore",
              style: Theme.of(context).textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
          ),
          Center(
            child: Text(
              "The lower the score, the better your sleep quality. The breakdown below gives you clarity on which area of your sleep to improve.",
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 8),
          MarkdownBody(
              data: """
| Areas of your sleep | # of issues |
|-|-|
| Sleep quality | $subjectiveSleepQuality |
| Sleep latency | $sleepLatency |
| Sleep duration | $sleepTimeText |
| Sleep efficiency | $sleepEfficiency |
| Sleep disturbances | $sleepDisturbances |
| Sleep medication dependency | $sleepMedication |
| Energy / Enthusiasm | $daytimeDysfunction |
| **Total** | $overallScore |
""",
              extensionSet: md.ExtensionSet.gitHubFlavored,
              styleSheet: markdownStyleSheet),
        ]);
  }
}

class ReviewEnd extends MarkdownPage {
  ReviewEnd({Key? key}) : super(key: key);

  @override
  final nextPage = null;
  @override
  final prevPage = () => ReviewScore();

  @override
  final title = "Check-in completed";
  @override
  final image = null;

  @override
  final markdown = """
Thank you so much for coming back 30 days later to finish taking part in our pilot test.
""";

  @override
  Widget buildPage(BuildContext context) {
    final markdownStyleSheet = MarkdownStyleSheet(
        p: Theme.of(context).textTheme.bodyText1,
        h1: Theme.of(context).textTheme.headline3);
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (image != null) PageImage(image!),
          if (image != null) const SizedBox(height: 4.0),
          MarkdownBody(
              data: markdown,
              extensionSet: md.ExtensionSet.gitHubFlavored,
              styleSheet: markdownStyleSheet),
          GradientButton(
              text: "Done",
              onPressed: () async {
                kvWrite<bool>("sleep", "review-done", true);
                Navigator.of(context).pop();
              }),
        ]);
  }
}
