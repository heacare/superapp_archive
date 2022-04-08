import 'package:hea/widgets/page.dart';
import 'ch01_introduction.dart';
import 'ch02_now.dart';

Lesson sleep = Lesson([
  // This does not control the order
  PageDef(IntroductionWelcome, () => IntroductionWelcome()),
  PageDef(IntroductionGettingToKnowYou, () => IntroductionGettingToKnowYou()),
  PageDef(IntroductionHowTrackSleep, () => IntroductionHowTrackSleep()),
  PageDef(NowFirstThingsFirst, () => NowFirstThingsFirst()),
  PageDef(NowTimeGoneBed, () => NowTimeGoneBed()),
  PageDef(NowMinutesFallAsleep, () => NowMinutesFallAsleep()),
]);
