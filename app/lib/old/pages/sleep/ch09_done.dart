import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../widgets/page.dart';
import '../../widgets/select_list.dart';
import '../../widgets/gradient_button.dart';
import '../../services/sleep_checkin_service.dart';
import '../../services/user_service.dart';
import '../../models/user.dart';
import '../../services/service_locator.dart';
import '../../services/logging_service.dart';
import '../../utils/kv_wrap.dart';
import 'ch07_diary.dart';
import 'ch05_owning.dart';
import 'ch06_routine.dart';

class Done extends StatelessWidget {
  Done({Key? key}) : super(key: key);

  final prevPage = () => DiaryStart();

  final title = "Well done";

  @override
  Widget build(BuildContext context) {
    final markdownStyleSheet = MarkdownStyleSheet(
        p: Theme.of(context).textTheme.bodyText1,
        h1: Theme.of(context).textTheme.headline3);

    TimeOfDay goBed = kvReadTimeOfDay("sleep", "time-go-bed") ??
        const TimeOfDay(hour: 0, minute: 0);
    TimeOfDay outBed = kvReadTimeOfDay("sleep", "time-out-bed") ??
        const TimeOfDay(hour: 0, minute: 0);
    int bedDuration = ((outBed.minute + outBed.hour * 60) -
            (goBed.minute + goBed.hour * 60)) %
        (24 * 60);
    int sleepDuration = kvReadInt("sleep", "minutes-asleep") ?? 0;
    int sleepEfficiencyPercent = ((sleepDuration / bedDuration) * 100).round();

    int baseline = sleepEfficiencyPercent;

    // Last 7 days
    Iterable<SleepCheckinData> list =
        serviceLocator<SleepCheckinService>().storageRead().take(7);
    double sleepEfficiencyWeek = 0;
    int days = 0;
    for (SleepCheckinData data in list) {
      if (data.timeOutBed == null || data.timeGoBed == null) {
        continue;
      }
      int bedDuration =
          ((data.timeOutBed!.minute + data.timeOutBed!.hour * 60) -
                  (data.timeGoBed!.minute + data.timeGoBed!.hour * 60)) %
              (24 * 60);
      int sleepDuration = ((data.timeOutBed!.minute +
                  data.timeOutBed!.hour * 60) -
              (data.timeAsleepBed!.minute + data.timeAsleepBed!.hour * 60)) %
          (24 * 60);
      sleepEfficiencyWeek += sleepDuration / bedDuration;
      days += 1;
    }
    double avg = (sleepEfficiencyWeek / days);
    if (!avg.isFinite) {
      avg = 0;
    }
    int weekAverage = (avg * 100).round();

    String changed = "remained the same";
    if (weekAverage < baseline) {
      changed = "decreased";
    } else if (weekAverage > baseline) {
      changed = "increased";
    }

    return BasePage(
        title: title,
        nextPage: changed == "decreased"
            ? () => DoneDecreased()
            : () => DoneIncreased(),
        prevPage: prevPage,
        page: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              PageImage(changed == "decreased"
                  ? Image.asset("assets/images/sleep/ch09-keep-it-going.webp")
                  : Image.asset("assets/images/sleep/ch09-you-did-great.webp")),
              MarkdownBody(
                  data: """
Based on your self-reported results for the last 7 days, your sleep efficiency $changed from $baseline% to $weekAverage%.
""",
                  extensionSet: md.ExtensionSet.gitHubFlavored,
                  styleSheet: markdownStyleSheet),
            ]));
  }
}

class DoneIncreased extends MultipleChoicePage {
  DoneIncreased({Key? key}) : super(key: key);

  @override
  final nextPage = () => DoneContinue();
  @override
  final prevPage = () => Done();

  @override
  final title = "You did great";
  @override
  final image = Image.asset("assets/images/sleep/ch09-you-did-great.webp");

  @override
  final markdown = """
You spent more quality time in bed. Keep up the good work! 

**How did you feel about your sleep during the past week?**
""";

  @override
  final maxChoice = 1;
  @override
  final minSelected = 1;
  @override
  final valueName = "feel-past-week-sleep";
  @override
  final List<SelectListItem<String>> choices = [
    SelectListItem(text: "Very good", value: "0"),
    SelectListItem(text: "Fairly good", value: "1"),
    SelectListItem(text: "Fairly bad", value: "2"),
    SelectListItem(text: "Very bad", value: "3"),
  ];
}

class DoneDecreased extends MultipleChoicePage {
  DoneDecreased({Key? key}) : super(key: key);

  @override
  final nextPage = () => DoneContinue();
  @override
  final prevPage = () => Done();

  @override
  final title = "Keep it going";
  @override
  final image = Image.asset("assets/images/sleep/ch09-keep-it-going.webp");

  @override
  final markdown = """
Looks like the current routine may not be the best for you. Other reasons that could be affecting your sleep are daytime events, environmental factors, social elements or an unexpected change. 

The good news is, over time, you will get better at recognising what works or does not work for you. 

Most importantly, how did you feel about your sleep during the past week?
""";

  @override
  final maxChoice = 1;
  @override
  final minSelected = 1;
  @override
  final valueName = "feel-past-week-sleep";
  @override
  final List<SelectListItem<String>> choices = [
    SelectListItem(text: "Very good", value: "0"),
    SelectListItem(text: "Fairly good", value: "1"),
    SelectListItem(text: "Fairly bad", value: "2"),
    SelectListItem(text: "Very bad", value: "3"),
  ];
}

class DoneContinue extends MultipleChoicePage {
  DoneContinue({Key? key}) : super(key: key);

  @override
  final nextPage = null;
  @override
  final prevPage = null;

  @override
  final title = "Keep it going";
  @override
  final image = Image.asset("assets/images/sleep/ch09-keep-it-going.webp");

  @override
  final markdown = """
Would you like to try again or change your routine? 
""";

  @override
  final maxChoice = 1;
  @override
  final minSelected = 1;
  @override
  final valueName = "continue-action";
  @override
  final List<SelectListItem<String>> choices = [
    SelectListItem(
        text: "Continue intervention for another 7 days",
        value: "more-checkin"),
    SelectListItem(text: "Change my routine", value: "change-routine"),
    SelectListItem(
        text: "Try same routine with a HEAler",
        value: "more-checkin-with-healer"),
    SelectListItem(
        text: "Change routine with a HEAler",
        value: "change-routine-with-healer"),
    SelectListItem(
        text: "Continue intervention for another 7 days with a team",
        value: "more-checkin-with-team"),
    SelectListItem(
        text: "Change my routine with a team",
        value: "change-routine-with-team"),
    SelectListItem(text: "I would like to end this program now", value: "end"),
  ];

  @override
  bool hasNextPageStringList() => true;
  @override
  Widget nextPageStringList(List<String> data) {
    String choice = data[0];
    if (choice.startsWith("more-checkin") ||
        choice.startsWith("change-routine")) {
      serviceLocator<SleepCheckinService>().extend(7);
    }
    if (choice.endsWith("with-healer")) {
      return DoneWithHealer();
    } else if (choice.endsWith("with-team")) {
      return DoneWithTeam();
    }
    return continuePage(choice);
  }
}

class DoneWithHealer extends MarkdownPage {
  DoneWithHealer({Key? key}) : super(key: key);

  @override
  final nextPage = () => continuePage(null);
  @override
  final prevPage = null;

  @override
  final title = "Get healer help";
  @override
  final image = null;

  @override
  final markdown = """
We'll let a sleep coach know you need help, and they'll get in contact with you shortly. In the meantime, you can continue with what you can
""";
}

class DoneWithTeam extends MultipleChoicePage {
  DoneWithTeam({Key? key}) : super(key: key);

  @override
  final nextPage = () => continuePage(null);
  @override
  final prevPage = null;

  @override
  final title = "Get team help";
  @override
  final image = null;

  @override
  final markdown = """
After reading the following, you can continue the program while we connect you to a team.

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

Widget continuePage(String? choice) {
  choice ??= kvReadStringList("sleep", "continue-action")[0];
  choice!;
  if (choice.startsWith("more-checkin")) {
    return DiaryStart();
  } else if (choice.startsWith("change-routine")) {
    return OwningRoutineActivities1();
  }
  assert(choice == "end");
  return DoneEnd();
}

class DoneEnd extends MarkdownPage {
  DoneEnd({Key? key}) : super(key: key);

  @override
  final nextPage = null;
  @override
  final prevPage = () => DoneContinue();

  @override
  final title = "Program completed";
  @override
  final image = null;

  @override
  final markdown = """
Thank you so much for taking part in our pilot test. We’ll be checking-in with you again in a month’s time, through the app and via email. By the way, how did it go for you?

Please do fill up the following survey form to let us know that you have completed the program.
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
              text: "Complete Program",
              onPressed: () async {
                Navigator.of(context).pop();
                User user =
                    await serviceLocator<UserService>().getCurrentUser();
                Uri uri =
                    Uri.parse('https://flourishea.typeform.com/to/a8UHkaNd');
                if (kDebugMode) {
                  uri =
                      Uri.parse('https://flourishea.typeform.com/to/T7NdL2JC');
                }
                uri = uri.replace(queryParameters: {"user": user.authId});
                await launch(uri.toString());
                serviceLocator<LoggingService>().createLog("open-survey", true);
              }),
        ]);
  }
}
