import 'package:hea/widgets/page.dart';
import 'ch01_introduction.dart';
import 'ch02_now.dart';
import 'ch03_goals.dart';

Lesson sleep = Lesson([
  PageDef(IntroductionWelcome, () => IntroductionWelcome()),
  PageDef(IntroductionGettingToKnowYou, () => IntroductionGettingToKnowYou()),
  PageDef(IntroductionHowTrackSleep, () => IntroductionHowTrackSleep()),
  PageDef(NowFirstThingsFirst, () => NowFirstThingsFirst()),
  PageDef(NowTimeGoneBed, () => NowTimeGoneBed()),
  PageDef(NowMinutesFallAsleep, () => NowMinutesFallAsleep()),
  PageDef(NowTimeOutBed, () => NowTimeOutBed()),
  PageDef(NowGetSleep, () => NowGetSleep()),
  PageDef(NowHowEfficientSleep, () => NowHowEfficientSleep()),
  PageDef(NowHowEfficientSleep2, () => NowHowEfficientSleep2()),
  PageDef(NowDifficultySleeping, () => NowDifficultySleeping()),
  PageDef(NowSleepDisturbances, () => NowSleepDisturbances()),
  PageDef(NowTroubleSleepingWakeUp, () => NowTroubleSleepingWakeUp()),
  PageDef(NowTroubleSleepingBathroom, () => NowTroubleSleepingBathroom()),
  PageDef(NowTroubleSleepingBreath, () => NowTroubleSleepingBreath()),
  PageDef(NowTroubleSleepingSnore, () => NowTroubleSleepingSnore()),
  PageDef(NowTroubleSleepingCold, () => NowTroubleSleepingCold()),
  PageDef(NowTroubleSleepingHot, () => NowTroubleSleepingHot()),
  PageDef(NowTroubleSleepingBadDreams, () => NowTroubleSleepingBadDreams()),
  PageDef(NowTroubleSleepingPain, () => NowTroubleSleepingPain()),
  PageDef(NowOtherFactors, () => NowOtherFactors()),
  PageDef(NowOverallQuality, () => NowOverallQuality()),
  PageDef(NowSleepMedication, () => NowSleepMedication()),
  PageDef(NowFatigue, () => NowFatigue()),
  PageDef(NowScore, () => NowScore()),
  PageDef(GoalsSleepNeeds, () => GoalsSleepNeeds()),
  PageDef(GoalsSetting, () => GoalsSetting()),
  PageDef(GoalsTimeToSleep, () => GoalsTimeToSleep()),
  PageDef(GoalsDoingBeforeBed, () => GoalsDoingBeforeBed()),
  PageDef(GoalsCalmingActivities, () => GoalsCalmingActivities()),
  PageDef(GoalsEmbraceAndManifest, () => GoalsEmbraceAndManifest()),
  PageDef(GoalsGettingThere, () => GoalsGettingThere()),
]);