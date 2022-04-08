import 'package:flutter/material.dart';

import 'package:hea/widgets/page.dart';
import 'package:hea/widgets/select_list.dart';
import 'ch01_introduction.dart';

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
}

class NowMinutesFallAsleep extends MultipleChoicePage {
  NowMinutesFallAsleep({Key? key}) : super(key: key);

  @override
  final nextPage = null;
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
  final valueName = "minutes-fall-asleep";
  @override
  final List<SelectListItem<String>> choices = [
    SelectListItem(text: "15 minutes or less", value: "0"),
    SelectListItem(text: "Between 16 minutes and 30 minutes", value: "1"),
    SelectListItem(text: "Between 31 minutes and 60 minutes", value: "2"),
    SelectListItem(text: "60 minutes or more", value: "3"),
  ];
}
