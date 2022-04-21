import 'package:flutter/material.dart' hide Page;

import 'package:hea/widgets/page.dart';
import 'ch06_routine.dart';

class DiaryReminders extends TimePickerPage {
  DiaryReminders({Key? key}) : super(key: key);

  @override
  final nextPage = () => DiaryStart();
  @override
  final prevPage = () => RoutinePledge();

  @override
  final title = "Log your sleep";
  @override
  final image = Image.asset("assets/images/sleep/ch07-brain-to-paper.jpg");

  @override
  final markdown = """
To log your commitment, you’ll be using a digital sleep diary. Keeping a record of how you’re sleeping builds deeper awareness on factors influencing sleep quality. It may reveal patterns that explain sleeping problems and how it affects your waking hours. 

Whether we meet our goals or not in this first week, knowing where we are with the help of a sleep diary can also help encourage progress. 

To help build consistency, missing a day or two with your diary will bring you back to Day One. If you did not manage to accomplish your task, that’s okay - just note what happened. You’ll receive a reminder each morning to log your sleep. What time would you like us to remind you?
""";

  @override
  final defaultTime = const TimeOfDay(hour: 9, minute: 00);
  @override
  final valueName = "diary-reminder-times";
}

class DiaryStart extends MarkdownPage {
  DiaryStart({Key? key}) : super(key: key);

  @override
  final nextPage = null;
  @override
  final prevPage = () => DiaryReminders();

  @override
  final title = "Log your sleep";
  @override
  final image = Image.asset("assets/images/sleep/ch07-brain-to-paper.jpg");

  @override
  final markdown = """
Great! We'll check in with you before and after you sleep at your given times. See you then!
""";
}
