import 'package:flutter/material.dart';

import 'package:hea/widgets/page.dart';
import 'package:hea/widgets/select_list.dart';

class IntroductionWelcome extends MarkdownPage {
  IntroductionWelcome({Key? key}) : super(key: key);

  @override
  final title = "Welcome";

  @override
  final image = null;

  @override
  final nextPage = () => IntroductionGettingToKnowYou();

  @override
  final prevPage = null;

  @override
  final markdown = """
Welcome to your first journey on Happily Ever After. We’re glad you’ve chosen to optimise your lifestyle, and to start with sleep.

Good sleep is the foundation of life. It is an essential biological process that supports the optimal functioning of our body and well being.

> As late Prof J. Allan Hobson so aptly puts it, “Sleep is of the brain, by the brain and for the brain.” 
""";
}

class IntroductionGettingToKnowYou extends MultipleChoicePage {
  IntroductionGettingToKnowYou({Key? key}) : super(key: key);

  @override
  final title = "Getting to know you";

  @override
  final image = Image.asset("assets/images/sleep/ch01-roles-in-society.gif");

  @override
  final nextPage = () => IntroductionHowTrackSleep();

  @override
  final prevPage = () => IntroductionWelcome();

  @override
  final markdown = """
Tell us a little about yourself. Choose as many as apply.
""";

  @override
  final maxChoice = 0;

  @override
  final List<SelectListItem<String>> choices = [
    SelectListItem(text: "Day Worker", value: "DayWorker"),
    SelectListItem(text: "Night shift worker", value: "NightShiftWorker"),
    SelectListItem(text: "Mixed-shift worker", value: "MixedShiftWorker"),
    SelectListItem(text: "Parent", value: "Parent"),
    SelectListItem(text: "Student", value: "Student"),
    SelectListItem(text: "Freelancer", value: "Freelancer"),
    SelectListItem(text: "Business owner", value: "BusinessOwner"),
    SelectListItem(text: "Startup founder", value: "StartupFounder"),
    SelectListItem(text: "Single", value: "Single"),
    SelectListItem(text: "Married", value: "Married"),
    SelectListItem(text: "Coupled-up", value: "CoupledUp"),
    SelectListItem(text: "Pet-owner", value: "PetOwner"),
    SelectListItem(text: "Caretaker", value: "Caretaker"),
    SelectListItem(text: "Part-time work", value: "PartTimeWork"),
    SelectListItem(text: "Hobbyist", value: "Hobbyist"),
    SelectListItem(text: "Sports team member", value: "SportsTeamMember"),
    SelectListItem(text: "Active volunteer", value: "ActiveVolunteer"),
    SelectListItem(text: "Other", value: "Other", other: true),
  ];
}

class IntroductionHowTrackSleep extends MultipleChoicePage {
  IntroductionHowTrackSleep({Key? key}) : super(key: key);

  @override
  final title = "How are you tracking your sleep?";

  @override
  final image = null;

  @override
  final nextPage = null;

  @override
  final prevPage = () => IntroductionGettingToKnowYou();

  @override
  final markdown = """
Please select the exact tool/device and model (if applicable) you’ll be using to track your sleep during this program. If ‘Other’ please specify.
""";

  @override
  final maxChoice = 1;

  @override
  final List<SelectListItem<String>> choices = [
    SelectListItem(text: "A clock and diary", value: "ClockPaper"),
    SelectListItem(text: "Apple Watch", value: "AppleWatch"),
    SelectListItem(text: "Fitbit", value: "Fitbit"),
    SelectListItem(text: "Garmin", value: "Garmin"),
    SelectListItem(text: "Apple Health Application", value: "AppleHealth"),
    SelectListItem(text: "Other", value: "Other", other: true),
  ];
}
