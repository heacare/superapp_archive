import 'package:flutter/material.dart';
import 'package:hea/widgets/page.dart';

class IntroductionWelcome extends MarkdownPage {
  IntroductionWelcome({Key? key}) : super(key: key);

  @override
  final title = "Welcome";

  @override
  final image = null;

  @override
  final nextPage = () => IntroductionGettingToKnowYou();

  @override
  final String markdown = """
Welcome to your first journey on Happily Ever After. We’re glad you’ve chosen to optimise your lifestyle, and to start with sleep.

Good sleep is the foundation of life. It is an essential biological process that supports the optimal functioning of our body and well being.

> As late Prof J. Allan Hobson so aptly puts it, “Sleep is of the brain, by the brain and for the brain.” 
""";
}

class IntroductionGettingToKnowYou extends MarkdownPage {
  IntroductionGettingToKnowYou({Key? key}) : super(key: key);

  @override
  final title = "Getting to know you";

  @override
  final image = Image.asset("assets/images/sleep/ch01-roles-in-society.gif");

  @override
  final nextPage = null;

  @override
  final String markdown = """
TODO
""";
}
