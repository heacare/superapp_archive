import 'package:flutter/material.dart';

import '../../widgets/page.dart';
import '../../widgets/select_list.dart';
import 'ch02_now.dart';

class IntroductionWelcome extends MarkdownPage {
  IntroductionWelcome({Key? key}) : super(key: key);

  @override
  final nextPage = () => IntroductionGettingToKnowYou();
  @override
  final prevPage = null;

  @override
  final title = "Welcome";
  @override
  final image = Image.asset("assets/images/sleep/ch01-brain-buddies.webp");

  @override
  final markdown = """
Welcome to your first journey on Happily Ever After. We’re glad you’ve chosen to optimise your lifestyle, and to start with sleep.

Good sleep is the foundation of life. It is an essential biological process that supports the optimal functioning of our body and well being.

> As late Prof J. Allan Hobson so aptly puts it, “Sleep is of the brain, by the brain and for the brain.” 

**Important**: This sleep intervention experience aims to help individuals build awareness and good habits around sleep. It is not a treatment for any sleep disorder. If you are not sure, please check with your doctor if you can take part.
""";
}

class IntroductionGettingToKnowYou extends MultipleChoicePage {
  IntroductionGettingToKnowYou({Key? key}) : super(key: key);

  @override
  final nextPage = () => IntroductionHowTrackHealth();
  @override
  final prevPage = () => IntroductionWelcome();

  @override
  final title = "Getting to know you";
  @override
  final image = Image.asset("assets/images/sleep/ch01-roles-in-society.gif");

  @override
  final markdown = """
Tell us a little about yourself. Choose as many as apply.
""";

  @override
  final maxChoice = 0;
  @override
  final minSelected = 1;
  @override
  final valueName = "person";
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
    SelectListItem(text: "Other", value: "", other: true),
  ];
}

class IntroductionHowTrackHealth extends MultipleChoicePage {
  IntroductionHowTrackHealth({Key? key}) : super(key: key);

  @override
  final nextPage = () => IntroductionHowTrackSleep();
  @override
  final prevPage = () => IntroductionGettingToKnowYou();

  @override
  final title = "How are you tracking sleep and health?";
  @override
  final image = null;

  @override
  final markdown = """
Which of these other health aspects would you like to improve on?

> Tip: You can skip questions by pressing the next button if none apply to you.
""";

  @override
  final maxChoice = 0;
  @override
  final minSelected = 0;
  @override
  final valueName = "other-health-aspects";
  @override
  final List<SelectListItem<String>> choices = [
    SelectListItem(text: "Stress", value: "stress"),
    SelectListItem(text: "Diet", value: "diet"),
    SelectListItem(text: "Exercise", value: "exercise"),
  ];
}

class IntroductionHowTrackSleep extends MultipleChoicePage {
  IntroductionHowTrackSleep({Key? key}) : super(key: key);

  @override
  final nextPage = () => IntroductionHowTrackSleep2();
  @override
  final prevPage = () => IntroductionHowTrackHealth();

  @override
  final title = "How are you tracking sleep and health?";
  @override
  final image = null;

  @override
  final markdown = """
Which tools/devices are you using to track your sleep and health during this program? 
""";

  @override
  final maxChoice = 0;
  @override
  final minSelected = 0;
  @override
  final valueName = "tracking-tool";
  @override
  final List<SelectListItem<String>> choices = [
    SelectListItem(text: "Apple Watch", value: "AppleWatch"),
    SelectListItem(text: "Garmin", value: "Garmin"),
    SelectListItem(text: "Fitbit", value: "Fitbit"),
    SelectListItem(text: "Oura Ring", value: "Oura Ring"),
    SelectListItem(text: "Whoop", value: "Whoop"),
    SelectListItem(text: "Withings", value: "Withings"),
    SelectListItem(text: "Apple Health (App)", value: "AppleHealth"),
    SelectListItem(text: "Google Fit (App)", value: "GoogleFit"),
    SelectListItem(text: "Pen and paper", value: "PenPaper"),
    SelectListItem(text: "Other", value: "", other: true),
  ];
}

class IntroductionHowTrackSleep2 extends OpenEndedPage {
  IntroductionHowTrackSleep2({Key? key}) : super(key: key);

  @override
  final nextPage = () => NowFirstThingsFirst();
  @override
  final prevPage = () => IntroductionHowTrackSleep();

  @override
  final title = "How are you tracking sleep and health?";
  @override
  final image = null;

  @override
  final markdown = """
If you're using a wearable or device, let us know the model of your device. This
helps us make better decisions based on the model.

For example:
- Apple Watch Series 7
- Apple Watch SE
- Garmin venu sq
- Garmin vivosmart 5
- Fitbit charge 5
- Fitbit luxe
""";

  @override
  final valueName = "tracking-tool-model";
  @override
  final label = "Enter your device model";
}
