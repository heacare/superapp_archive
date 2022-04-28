import 'package:flutter/material.dart' hide Page;

import 'package:hea/widgets/page.dart';
import 'package:hea/services/sleep_checkin_service.dart';
import 'package:hea/services/service_locator.dart';
import 'ch06_routine.dart';
import 'ch09_done.dart';

class DiaryReminders extends TimePickerPage {
  DiaryReminders({Key? key}) : super(key: key);

  @override
  final nextPage = () {
    SleepCheckinProgress progress =
        serviceLocator<SleepCheckinService>().getProgress();
    progress.start();
    return DiaryStart();
  };
  @override
  final prevPage = () => RoutinePledge();

  @override
  final title = "What is a sleep diary?";
  @override
  final image = Image.asset("assets/images/sleep/ch07-brain-to-paper.webp");

  @override
  final markdown = """
You had a taste of logging your sleep before starting the intervention. But why is it important?

Keeping a record of how you’re sleeping builds deeper awareness on factors influencing sleep quality. It may reveal patterns that explain sleeping problems and how it affects your waking hours. 

Whether we meet our goals or not, knowing where we are with the help of a sleep diary can also help encourage progress. If you do not have sleep data that night or follow your bedtime routine at your set time, it’s okay! we never know what life has in store for us - just note what happened. 

You’ll receive reminders at your preferred time to log your sleep. 

> Tip: The closer to your wake time, the more accurately you’ll remember how you slept.”

**What time would you like us to remind you?**
""";

  @override
  final defaultTime = const TimeOfDay(hour: 9, minute: 00);
  @override
  final valueName = "diary-reminder-times";
}

class DiaryStart extends MarkdownPage {
  DiaryStart({Key? key}) : super(key: key);

  @override
  final nextPage = () {
    SleepCheckinProgress progress =
        serviceLocator<SleepCheckinService>().getProgress();
    if (progress.allDone) {
      return Done();
    }
    return DiaryStart();
  };
  @override
  final prevPage = () => DiaryReminders();

  @override
  final title = "Log your sleep";
  @override
  final image = Image.asset("assets/images/sleep/ch07-brain-to-paper.webp");

  @override
  final markdown = """
Great! We'll check in with you before and after you sleep at your given times. See you then!

When you're done with 7 days of daily check-ins, come back here and continue the program.
""";
}
