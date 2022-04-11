import 'package:flutter/material.dart' hide Page;

import 'package:hea/widgets/page.dart';
import 'package:hea/widgets/select_list.dart';
import 'ch02_now.dart';

class GoalsSleepNeeds extends MarkdownPage {
  GoalsSleepNeeds({Key? key}) : super(key: key);

  @override
  final nextPage = () => GoalsSetting();
  @override
  final prevPage = () => NowScore();

  @override
  final title = "Your sleep needs";
  @override
  final image =
      Image.asset("assets/images/sleep/ch03-i-really-need-it.gif");

  @override
  final markdown = """
By now, you’ve begun to gain a better understanding of sleep.

In this chapter, we’ll build your sleep profile.
""";
}

class GoalsSetting extends MultipleChoicePage {
  GoalsSetting({Key? key}) : super(key: key);

  @override
  final nextPage = null;
  @override
  final prevPage = () => GoalsSleepNeeds();

  @override
  final title = "Visualising your ideal sleep";
  @override
  final image =
      Image.asset("assets/images/sleep/ch03-sleeping-ideal.jpg");

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
    SelectListItem(text: "Wake up feeling more refreshed and well-rested", value: "refreshed and well-rested"),
    SelectListItem(text: "Feel less sleepy during the day", value: "less sleepy during the day"),
    SelectListItem(text: "Sleep through the night", value: "sleep through the night"),
    SelectListItem(text: "Fall asleep easier", value: "fall asleep easier"),
    SelectListItem(text: "Have a more consistent sleep schedule", value: "more consistent sleep schedule"),
    SelectListItem(text: "Other", value: "", other: true),
  ];
}
