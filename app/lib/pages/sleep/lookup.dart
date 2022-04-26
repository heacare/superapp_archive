import 'package:hea/widgets/page.dart';
import 'ch01_introduction.dart';
import 'ch02_now.dart';
import 'ch03_goals.dart';
import 'ch04_rhythm.dart';
import 'ch05_owning.dart';
import 'ch06_routine.dart';
import 'ch07_diary.dart';
import 'ch09_done.dart';

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
  PageDef(NowEnthusiasm, () => NowEnthusiasm()),
  PageDef(NowScore, () => NowScore()),
  PageDef(GoalsSetting, () => GoalsSetting()),
  PageDef(GoalsTimeToSleep, () => GoalsTimeToSleep()),
  PageDef(GoalsDoingBeforeBed, () => GoalsDoingBeforeBed()),
  PageDef(GoalsCalmingActivities, () => GoalsCalmingActivities()),
  PageDef(GoalsEmbraceAndManifest, () => GoalsEmbraceAndManifest()),
  PageDef(GoalsGettingThere, () => GoalsGettingThere()),
  PageDef(RhythmConsistency, () => RhythmConsistency()),
  PageDef(RhythmWhy, () => RhythmWhy()),
  PageDef(RhythmHow, () => RhythmHow()),
  PageDef(RhythmPeaksAndDips1, () => RhythmPeaksAndDips1()),
  PageDef(RhythmPeaksAndDips2, () => RhythmPeaksAndDips2()),
  PageDef(RhythmFeels1, () => RhythmFeels1()),
  PageDef(RhythmFeels2, () => RhythmFeels2()),
  PageDef(RhythmFeels3, () => RhythmFeels3()),
  PageDef(RhythmSettingCourseIntro, () => RhythmSettingCourseIntro()),
  PageDef(RhythmSettingCourse, () => RhythmSettingCourse()),
  PageDef(OwningRoutine, () => OwningRoutine()),
  PageDef(OwningZeitgebers, () => OwningZeitgebers()),
  PageDef(OwningRoutineActivities1, () => OwningRoutineActivities1()),
  PageDef(OwningRoutineActivities2, () => OwningRoutineActivities2()),
  PageDef(OwningRoutineActivities3, () => OwningRoutineActivities3()),
  PageDef(OwningRoutineStart, () => OwningRoutineStart()),
  PageDef(OwningTheDaySupporting, () => OwningTheDaySupporting()),
  PageDef(OwningTheDayNegative, () => OwningTheDayNegative()),
  PageDef(OwningTheDayNote, () => OwningTheDayNote()),
  PageDef(RoutineBeforeBedtime, () => RoutineBeforeBedtime()),
  PageDef(RoutineIntro, () => RoutineIntro()),
  PageDef(RoutineActivities, () => RoutineActivities()),
  PageDef(RoutineCalmingActivities1, () => RoutineCalmingActivities1()),
  PageDef(RoutineCalmingActivities2, () => RoutineCalmingActivities2()),
  PageDef(RoutineCalmingActivities3, () => RoutineCalmingActivities3()),
  PageDef(RoutineCalmingActivitiesNote, () => RoutineCalmingActivitiesNote()),
  PageDef(RoutineReminders, () => RoutineReminders()),
  PageDef(RoutineOptInGroup, () => RoutineOptInGroup()),
  PageDef(RoutineGroupInstructions, () => RoutineGroupInstructions()),
  PageDef(RoutinePledgeIntro, () => RoutinePledgeIntro()),
  PageDef(RoutinePledge, () => RoutinePledge()),
  PageDef(DiaryReminders, () => DiaryReminders()),
  PageDef(DiaryStart, () => DiaryStart()),
  PageDef(Done, () => Done()),
  PageDef(DoneIncreased, () => DoneIncreased()),
  PageDef(DoneDecreased, () => DoneDecreased()),
  PageDef(DoneContinue, () => DoneContinue()),
  PageDef(DoneWithHealer, () => DoneWithHealer()),
  PageDef(DoneWithTeam, () => DoneWithTeam()),
  PageDef(DoneEnd, () => DoneEnd()),
]);
