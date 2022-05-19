import 'package:flutter/material.dart' hide Page;
import 'package:markdown/markdown.dart' as md;
import 'package:flutter_markdown/flutter_markdown.dart';

import 'package:hea/widgets/page.dart';
import 'package:hea/widgets/gradient_button.dart';
import 'package:hea/services/sleep_checkin_service.dart';
import 'package:hea/services/service_locator.dart';
import 'ch06_routine.dart';
import 'ch09_done.dart';

class DiaryReminders extends MarkdownPage {
  DiaryReminders({Key? key}) : super(key: key);

  @override
  final nextPage = () => DiaryRemindersTime();
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

Whether we meet our goals or not, knowing where we are with the help of a sleep diary can also help encourage progress. If you do not have sleep data that night or follow your bedtime routine at your set time, **it’s okay! we never know what life has in store for us** - just note what happened. 

Continue to the next page to set your preferred reminder timings.
""";
}

class DiaryRemindersTime extends TimePickerPage {
  DiaryRemindersTime({Key? key}) : super(key: key);

  @override
  final nextPage = () {
    SleepCheckinProgress progress =
        serviceLocator<SleepCheckinService>().getProgress();
    progress.start();
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

  bool canNext() {
    SleepCheckinProgress progress =
        serviceLocator<SleepCheckinService>().getProgress();
    return progress.allDone;
  }

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
  final prevPage = () => DiaryRemindersTime();

  @override
  final title = "Log your sleep";
  @override
  final image = Image.asset("assets/images/sleep/ch07-brain-to-paper.webp");

  @override
  final markdown = """
Your first daily sleep check-in starts tomorrow!

We’ll remind you before and after you sleep at your given times. 

When you’re done with 7 days of check-ins, come back here and continue the program. 
""";

  @override
  Widget buildPage(BuildContext context) {
    final markdownStyleSheet = MarkdownStyleSheet(
        p: Theme.of(context).textTheme.bodyText1,
        h1: Theme.of(context).textTheme.headline3);
    SleepCheckinProgress progress =
        serviceLocator<SleepCheckinService>().getProgress();

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (image != null) PageImage(image!),
          if (image != null) const SizedBox(height: 4.0),
          if (!progress.allDone && progress.day == 0)
            MarkdownBody(
                data: markdown,
                extensionSet: md.ExtensionSet.gitHubFlavored,
                styleSheet: markdownStyleSheet),
          if (!progress.allDone && progress.day > 0)
            MarkdownBody(
                data: """
**Well done!**

You managed to check in on your sleep for ${progress.dayCounter} days so far.

When you’re done with ${progress.total} days of check-ins, come back here and continue the program. 
""",
                extensionSet: md.ExtensionSet.gitHubFlavored,
                styleSheet: markdownStyleSheet),
          if (!progress.allDone)
            GradientButton(
                text: "Home",
                onPressed: () async {
                  Navigator.of(context).pop();
                }),
          if (progress.allDone)
            MarkdownBody(
                data: """
**Well done!**

You managed to check in on your sleep for ${progress.day} days so far.

Continue on to the next page
""",
                extensionSet: md.ExtensionSet.gitHubFlavored,
                styleSheet: markdownStyleSheet),
        ]);
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: title,
      nextPage: nextPage,
      prevPage: prevPage,
      hideNext: !canNext(),
      page: buildPage(context),
    );
  }
}
