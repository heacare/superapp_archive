import 'package:flutter/material.dart' show TimeOfDay;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:hea/services/service_locator.dart';
import 'package:hea/services/notification_service.dart';
import 'package:hea/services/sleep_checkin_service.dart';
import 'package:hea/utils/kv_wrap.dart';

// Hours
const int firstReminder = 12;
const int nextReminder = 6;
// Channel
const String channel = "sleep_content";

// Base ID
const int baseId = 100;

Future<void> scheduleSleepNotifications() async {
  String s = serviceLocator<SharedPreferences>().getString('sleep') ?? "";
  await serviceLocator<NotificationService>()
      .cancelSchedulesByChannelKey("sleep_content");
  if (s == "NowFirstThingsFirst" ||
      s == "NowTimeGoneBed" ||
      s == "NowMinutesFallAsleep" ||
      s == "NowTimeOutBed" ||
      s == "NowGetSleep") {
    // Set #2
    // Objective: user to get sleep efficiency score <take user to begin Chp 2>
    await serviceLocator<NotificationService>().showContentReminder(
        baseId + 2 * 10 + 1,
        "sleep_content",
        "Sleep quality check",
        "To begin your sleep journey, complete the sleep quality check.",
        minHoursLater: firstReminder);
    await serviceLocator<NotificationService>().showContentReminder(
        baseId + 2 * 10 + 2,
        "sleep_content",
        "Sleep quality check",
        "Are you unknowingly wasting time in bed? What is disturbing your rest?",
        minHoursLater: firstReminder + nextReminder);
    await serviceLocator<NotificationService>().showContentReminder(
        baseId + 2 * 10 + 3,
        "sleep_content",
        "Sleep quality check",
        "We miss you ☹️.  If you need some help, feel free to contact us directly.",
        minHoursLater: firstReminder + nextReminder * 2);
  } else if (s == "NowHowEfficientSleep" ||
      s == "NowHowEfficientSleep2" ||
      s == "NowDifficultySleeping" ||
      s == "NowSleepDisturbances" ||
      s == "NowTroubleSleepingWakeUp" ||
      s == "NowTroubleSleepingBathroom" ||
      s == "NowTroubleSleepingBreath" ||
      s == "NowTroubleSleepingSnore" ||
      s == "NowTroubleSleepingCold" ||
      s == "NowTroubleSleepingHot" ||
      s == "NowTroubleSleepingBadDreams" ||
      s == "NowTroubleSleepingPain" ||
      s == "NowOtherFactors" ||
      s == "NowOverallQuality" ||
      s == "NowSleepMedication" ||
      s == "NowFatigue" ||
      s == "NowScore") {
    // Set #3
    // Objective: finish baseline survey <chp 2 pg 4>
    TimeOfDay goBed = kvReadTimeOfDay("sleep", "time-go-bed") ??
        const TimeOfDay(hour: 0, minute: 0);
    TimeOfDay outBed = kvReadTimeOfDay("sleep", "time-out-bed") ??
        const TimeOfDay(hour: 0, minute: 0);
    int bedDuration = ((outBed.minute + outBed.hour * 60) -
            (goBed.minute + goBed.hour * 60)) %
        (24 * 60);
    int sleepDuration = kvReadInt("sleep", "minutes-asleep") ?? 0;
    int sleepEfficiencyPercent = ((sleepDuration / bedDuration) * 100).round();
    await serviceLocator<NotificationService>().showContentReminder(
        baseId + 3 * 10 + 1,
        "sleep_content",
        "Discovering your sleep",
        "You've scored $sleepEfficiencyPercent% on your sleep efficiency. What else can you find out about your sleep?",
        minHoursLater: firstReminder);
    await serviceLocator<NotificationService>().showContentReminder(
        baseId + 3 * 10 + 2,
        "sleep_content",
        "Discovering your sleep",
        "Complete your sleep baseline to get a better insight about your sleep.",
        minHoursLater: firstReminder + nextReminder);
    await serviceLocator<NotificationService>().showContentReminder(
        baseId + 3 * 10 + 3,
        "sleep_content",
        "Sleep quality check",
        "We miss you ☹️.  If you need some help, feel free to contact us directly.",
        minHoursLater: firstReminder + nextReminder * 2);
  } else if (s == "GoalsSetting") {
    // Set #4
    // Objective: start visualising ideal sleep <take user to Chp 3 page 1>
    int subjectiveSleepQuality =
        int.tryParse(kvReadStringList("sleep", "overall-quality")[0]) ?? 0;

    int pointsFallAsleep =
        int.tryParse(kvReadStringList("sleep", "points-fall-asleep")[0]) ?? 0;
    int howOftenAsleep30Minutes = int.tryParse(
            kvReadStringList("sleep", "how-often-asleep-30-minutes")[0]) ??
        0;
    int sleepLatency =
        ((pointsFallAsleep + howOftenAsleep30Minutes) / 2).ceil();

    TimeOfDay goBed = kvReadTimeOfDay("sleep", "time-go-bed") ??
        const TimeOfDay(hour: 0, minute: 0);
    TimeOfDay outBed = kvReadTimeOfDay("sleep", "time-out-bed") ??
        const TimeOfDay(hour: 0, minute: 0);
    int bedDuration = ((outBed.minute + outBed.hour * 60) -
            (goBed.minute + goBed.hour * 60)) %
        (24 * 60);
    int sleepDuration = kvReadInt("sleep", "minutes-asleep") ?? 0;
    int sleepEfficiencyPercent = ((sleepDuration / bedDuration) * 100).round();
    int sleepEfficiency = 0;
    if (sleepEfficiencyPercent < 65) {
      sleepEfficiency = 3;
    } else if (sleepEfficiencyPercent < 75) {
      sleepEfficiency = 2;
    } else if (sleepEfficiencyPercent < 85) {
      sleepEfficiency = 1;
    }

    const List<String> keys = [
      "how-often-wake-up",
      "how-often-bathroom",
      "how-often-breath",
      "how-often-snore",
      "how-often-cold",
      "how-often-hot",
      "how-often-bad-dreams",
      "how-often-pain",
      "how-often-other"
    ];
    int pointsDisturbance = 0;
    for (String key in keys) {
      List<String> values = kvReadStringList("sleep", key);
      if (values.length != 1) {
        continue;
      }
      pointsDisturbance += int.tryParse(values[0]) ?? 0;
    }
    int sleepDisturbances = (pointsDisturbance / keys.length).ceil();

    int sleepMedication =
        int.tryParse(kvReadStringList("sleep", "how-sleep-medication")[0]) ?? 0;

    int pointsFatigue =
        int.tryParse(kvReadStringList("sleep", "how-fatigue")[0]) ?? 0;
    int daytimeDysfunction = pointsFatigue;

    int overallScore = sleepLatency +
        sleepEfficiency +
        sleepDisturbances +
        subjectiveSleepQuality +
        sleepMedication +
        daytimeDysfunction;
    await serviceLocator<NotificationService>().showContentReminder(
        baseId + 4 * 10 + 1,
        "sleep_content",
        "Setting sleep goals",
        "Your sleep score of $overallScore and last 7 days of how you sleep have revealed how much you can improve it. Ready to set some goals?",
        minHoursLater: firstReminder);
    await serviceLocator<NotificationService>().showContentReminder(
        baseId + 4 * 10 + 2,
        "sleep_content",
        "Setting sleep goals",
        "You’ve got your sleep score and 7-day observation at baseline. Ready to set some sleep goals?",
        minHoursLater: firstReminder + nextReminder);
    await serviceLocator<NotificationService>().showContentReminder(
        baseId + 4 * 10 + 3,
        "sleep_content",
        "Setting sleep goals",
        "We miss you ☹️.  If you need some help, feel free to contact us directly.",
        minHoursLater: firstReminder + nextReminder * 2);
  } else if (s == "GoalsTimeToSleep" ||
      s == "GoalsDoingBeforeBed" ||
      s == "GoalsCalmingActivities") {
    // Set #5
    // Objective: finish Priorities and Procrastination <take user to Chp 3 page 2>
    await serviceLocator<NotificationService>().showContentReminder(
        baseId + 5 * 10 + 1,
        "sleep_content",
        "Setting sleep goals",
        "Well done on setting your sleep goals. What’s been holding you back from realising them?",
        minHoursLater: firstReminder);
    await serviceLocator<NotificationService>().showContentReminder(
        baseId + 5 * 10 + 2,
        "sleep_content",
        "Setting sleep goals",
        "What do you do before bedtime? How much do you procrastinate bedtime?",
        minHoursLater: firstReminder + nextReminder);
    await serviceLocator<NotificationService>().showContentReminder(
        baseId + 5 * 10 + 3,
        "sleep_content",
        "Setting sleep goals",
        "We miss you ☹️.  If you need some help, feel free to contact us directly.",
        minHoursLater: firstReminder + nextReminder * 2);
  } else if (s == "GoalsEmbraceAndManifest") {
    // Set #6
    // Objective: finish embrace and manifest <take user to Chp 3 page 4>
    await serviceLocator<NotificationService>().showContentReminder(
        baseId + 6 * 10 + 1,
        "sleep_content",
        "Reviewing your sleep",
        "Goals set, barriers noted. Now let’s review how you are sleeping.",
        minHoursLater: firstReminder);
    await serviceLocator<NotificationService>().showContentReminder(
        baseId + 6 * 10 + 2,
        "sleep_content",
        "Reviewing your sleep",
        "You can do this! Let’s review your sleep goals and where you are.",
        minHoursLater: firstReminder + nextReminder);
    await serviceLocator<NotificationService>().showContentReminder(
        baseId + 6 * 10 + 3,
        "sleep_content",
        "Reviewing your sleep",
        "We miss you ☹️.  If you need some help, feel free to contact us directly.",
        minHoursLater: firstReminder + nextReminder * 2);
  } else if (s == "GoalsGettingThere" ||
      s == "RhythmConsistency" ||
      s == "RhythmWhy" ||
      s == "RhythmHow" ||
      s == "RhythmPeaksAndDips1" ||
      s == "RhythmPeaksAndDips2") {
    // Set #7
    // Objective: User to finish edu content on rhythm <until Chp 4, pg 4>
    await serviceLocator<NotificationService>().showContentReminder(
        baseId + 7 * 10 + 1,
        "sleep_content",
        "Consistency is key",
        "You’re now more aware about your sleep habits and where you want to be. Next, let’s learn about rhythms and consistency.",
        minHoursLater: firstReminder);
    await serviceLocator<NotificationService>().showContentReminder(
        baseId + 7 * 10 + 2,
        "sleep_content",
        "Consistency is key",
        "Use your newly earned awareness to find your rhythm. Ready?",
        minHoursLater: firstReminder + nextReminder);
    await serviceLocator<NotificationService>().showContentReminder(
        baseId + 7 * 10 + 3,
        "sleep_content",
        "Consistency is key",
        "We miss you ☹️.  If you need some help, feel free to contact us directly.",
        minHoursLater: firstReminder + nextReminder * 2);
  } else if (s == "RhythmFeels1" ||
      s == "RhythmFeels2" ||
      s == "RhythmFeels3" ||
      s == "RhythmSettingCourseIntro" ||
      s == "RhythmSettingCourse") {
    // Set #8
    // Objective: User to finish activity: setting course of action <Chp 4, page 5>
    await serviceLocator<NotificationService>().showContentReminder(
        baseId + 8 * 10 + 1,
        "sleep_content",
        "When are you awake",
        "Now that you know more about sleep and wakefulness, when are you usually most awake or sleepy?",
        minHoursLater: firstReminder);
    await serviceLocator<NotificationService>().showContentReminder(
        baseId + 8 * 10 + 2,
        "sleep_content",
        "When are you awake",
        "Ready to identify your peaks and dips? This will help you set better sleep and wake times for you.",
        minHoursLater: firstReminder + nextReminder);
    await serviceLocator<NotificationService>().showContentReminder(
        baseId + 8 * 10 + 3,
        "sleep_content",
        "When are you awake",
        "We miss you ☹️.  If you need some help, feel free to contact us directly.",
        minHoursLater: firstReminder + nextReminder * 2);
  } else if (s == "OwningRoutine" ||
      s == "OwningZeitgebers" ||
      s == "OwningRoutineActivities1" ||
      s == "OwningRoutineActivities2" ||
      s == "OwningRoutineActivities3" ||
      s == "OwningRoutineStart" ||
      s == "OwningTheDaySupporting" ||
      s == "OwningTheDayNegative") {
    // Set #9
    // Objective: User to finish activity: what’s my current routine? <chp 5, pg 4>
    await serviceLocator<NotificationService>().showContentReminder(
        baseId + 9 * 10 + 1,
        "sleep_content",
        "Review your routine",
        "Great work on setting new sleep/wake times. Now, let’s work these times into your current habits",
        minHoursLater: firstReminder);
    await serviceLocator<NotificationService>().showContentReminder(
        baseId + 9 * 10 + 2,
        "sleep_content",
        "Review your routine",
        "Our current activities before bed can affect our sleep. Find out how you can better manage your routine",
        minHoursLater: firstReminder + nextReminder);
    await serviceLocator<NotificationService>().showContentReminder(
        baseId + 9 * 10 + 3,
        "sleep_content",
        "Review your routine",
        "We miss you ☹️.  If you need some help, feel free to contact us directly.",
        minHoursLater: firstReminder + nextReminder * 2);
  } else if (s == "OwningTheDayNote" ||
      s == "RoutineBeforeBedtime" ||
      s == "RoutineIntro" ||
      s == "RoutineActivities") {
    // Set #11
    // Objective: User finish activity:  Winding down for the day…<Chp 6, pg3>
    await serviceLocator<NotificationService>().showContentReminder(
        baseId + 11 * 10 + 1,
        "sleep_content",
        "Winding down",
        "Great work identifying your current routine and motivation. Ready to see how you can improve your wind down for sleep?",
        minHoursLater: firstReminder);
    await serviceLocator<NotificationService>().showContentReminder(
        baseId + 11 * 10 + 2,
        "sleep_content",
        "Winding down",
        "Routine helps build good habits. Having a wind-down before bedtime is important. Ready to explore new ways of winding down?",
        minHoursLater: firstReminder + nextReminder);
    await serviceLocator<NotificationService>().showContentReminder(
        baseId + 11 * 10 + 3,
        "sleep_content",
        "Understanding why",
        "We miss you ☹️.  If you need some help, feel free to contact us directly.",
        minHoursLater: firstReminder + nextReminder * 2);
  } else if (s == "RoutineCalmingActivities1" ||
      s == "RoutineCalmingActivities2" ||
      s == "RoutineCalmingActivities3" ||
      s == "RoutineCalmingActivitiesNote") {
// Set #12
// Objective: User to finish activity: planning my bedtime routine <Chp 6 pg 4>
    await serviceLocator<NotificationService>().showContentReminder(
        baseId + 12 * 10 + 1,
        "sleep_content",
        "Refining your routine",
        "Great choice of wind-down routines. Now let’s refine your current routine.",
        minHoursLater: firstReminder);
    await serviceLocator<NotificationService>().showContentReminder(
        baseId + 12 * 10 + 2,
        "sleep_content",
        "Refining your routine",
        "Finding  a new routine daunting? Don’t worry, you can start with just one new activity for it.",
        minHoursLater: firstReminder + nextReminder);
    await serviceLocator<NotificationService>().showContentReminder(
        baseId + 12 * 10 + 3,
        "sleep_content",
        "Refining your routine",
        "We miss you ☹️.  If you need some help, feel free to contact us directly.",
        minHoursLater: firstReminder + nextReminder * 2);
  } else if (s == "RoutineReminders") {
// Set #13
    await serviceLocator<NotificationService>().showContentReminder(
        baseId + 13 * 10 + 1,
        "sleep_content",
        "Winding down helps sleep",
        "So, you’d like to start winding down before bed. What time would you like to start winding down?",
        minHoursLater: firstReminder);
    await serviceLocator<NotificationService>().showContentReminder(
        baseId + 13 * 10 + 2,
        "sleep_content",
        "Winding down helps sleep",
        "You are in control of your time. Set reminders to protect your wind-down time.",
        minHoursLater: firstReminder + nextReminder);
    await serviceLocator<NotificationService>().showContentReminder(
        baseId + 13 * 10 + 3,
        "sleep_content",
        "Winding down helps sleep",
        "We miss you ☹️.  If you need some help, feel free to contact us directly.",
        minHoursLater: firstReminder + nextReminder * 2);
  } else if (s == "RoutineOptInGroup" || s == "RoutineGroupInstructions") {
// Set #14
    await serviceLocator<NotificationService>().showContentReminder(
        baseId + 14 * 10 + 1,
        "sleep_content",
        "Choose your experience",
        "Now that you have an improved bedtime routine, here are two ways to experience it.",
        minHoursLater: firstReminder);
    await serviceLocator<NotificationService>().showContentReminder(
        baseId + 14 * 10 + 2,
        "sleep_content",
        "Choose your experience",
        "Can’t decide to go alone or join a team? You can change your mind after trying it. It’s important to just get started..",
        minHoursLater: firstReminder + nextReminder);
    await serviceLocator<NotificationService>().showContentReminder(
        baseId + 14 * 10 + 3,
        "sleep_content",
        "Choose your experience",
        "We miss you ☹️.  If you need some help, feel free to contact us directly.",
        minHoursLater: firstReminder + nextReminder * 2);
  } else if (s == "RoutinePledgeIntro" || s == "RoutinePledge") {
// Set #15
    await serviceLocator<NotificationService>().showContentReminder(
        baseId + 15 * 10 + 1,
        "sleep_content",
        "Making your pledge",
        "Let’s review and make a pledge to sleep better. Sharing this can get you more support and motivate others to join you!",
        minHoursLater: firstReminder);
    await serviceLocator<NotificationService>().showContentReminder(
        baseId + 15 * 10 + 2,
        "sleep_content",
        "Making your pledge",
        "You’ve come this far, keep up the momentum! Let’s review what you’ve achieved.",
        minHoursLater: firstReminder + nextReminder);
    await serviceLocator<NotificationService>().showContentReminder(
        baseId + 15 * 10 + 3,
        "sleep_content",
        "Making your pledge",
        "We miss you ☹️.  If you need some help, feel free to contact us directly.",
        minHoursLater: firstReminder + nextReminder * 2);
  } else if (s == "DiaryReminders") {
// Set #16
    await serviceLocator<NotificationService>().showContentReminder(
        baseId + 16 * 10 + 1,
        "sleep_content",
        "Start your 7-day challenge",
        "You’ve pledged to commit to better sleep - yay! Ready to start your first 7-day challenge?",
        minHoursLater: firstReminder);
    await serviceLocator<NotificationService>().showContentReminder(
        baseId + 16 * 10 + 2,
        "sleep_content",
        "Start your 7-day challenge",
        "Your 7-day challenge awaits. Let’s personalise your reminders.",
        minHoursLater: firstReminder + nextReminder);
    await serviceLocator<NotificationService>().showContentReminder(
        baseId + 16 * 10 + 3,
        "sleep_content",
        "Start your 7-day challenge",
        "We miss you ☹️.  If you need some help, feel free to contact us directly.",
        minHoursLater: firstReminder + nextReminder * 2);
  }

  // Sleep logging reminders
  await serviceLocator<NotificationService>()
      .cancelSchedulesByChannelKey("sleep_reminders");
  TimeOfDay? routineReminderTimes =
      kvReadTimeOfDay("sleep", "routine-reminder-times");
  if (!s.startsWith("Done") && routineReminderTimes != null) {
    await serviceLocator<NotificationService>().showSimpleReminder(
      baseId + 50 * 10 + 1,
      "sleep_reminders",
      "Wind-down reminder",
      "Remember to wind-down before going to bed. Your activities are TODO",
      routineReminderTimes,
    );
  }
  TimeOfDay? diaryReminderTimes =
      kvReadTimeOfDay("sleep", "diary-reminder-times");
  SleepCheckinProgress progress =
      serviceLocator<SleepCheckinService>().getProgress();
  int day = progress.dayCounter;
  int dayTotal = progress.total;
  if (!s.startsWith("Done") &&
      diaryReminderTimes != null &&
      progress.todayDone) {
    // Set #17
    await serviceLocator<NotificationService>().showDailyReminder(
      baseId + 51 * 10 + 1,
      "sleep_reminders",
      "Daily sleep check-in",
      "Day $day of $dayTotal: How did you sleep last night?",
      diaryReminderTimes,
      payload: const {"jump_to": "sleep_checkin"},
    );
    await serviceLocator<NotificationService>().showDailyReminder(
      baseId + 51 * 10 + 2,
      "sleep_reminders",
      "Daily sleep check-in",
      "Day $day of $dayTotal: How did you sleep last night? Memory serves you better closer to your wake time.",
      TimeOfDay(
          hour: diaryReminderTimes.hour + 1, minute: diaryReminderTimes.minute),
      payload: const {"jump_to": "sleep_checkin"},
    );
    await serviceLocator<NotificationService>().showDailyReminder(
      baseId + 51 * 10 + 3,
      "sleep_reminders",
      "Daily sleep check-in",
      "Day $day of $dayTotal: Can’t recall how you slept? Skipped your sleep routine? Don’t worry, simply note what happened.",
      TimeOfDay(
          hour: diaryReminderTimes.hour + 3, minute: diaryReminderTimes.minute),
      payload: const {"jump_to": "sleep_checkin"},
    );
    await serviceLocator<NotificationService>().showDailyReminder(
      baseId + 51 * 10 + 4,
      "sleep_reminders",
      "Daily sleep check-in",
      "Day $day of $dayTotal: Can’t recall how you slept? Skipped your sleep routine? Don’t worry, simply note what happened.",
      TimeOfDay(
          hour: diaryReminderTimes.hour + 6, minute: diaryReminderTimes.minute),
      payload: const {"jump_to": "sleep_checkin"},
    );
  }
  if (s != "DoneEnd" && diaryReminderTimes != null && progress.allDone) {
    // Set #18
    await serviceLocator<NotificationService>().showContentReminder(
        baseId + 18 * 10 + 1,
        "sleep_content",
        "Daily sleep check-in",
        "You did it! What's next for you?",
        minHoursLater: firstReminder);
    await serviceLocator<NotificationService>().showContentReminder(
        baseId + 18 * 10 + 2,
        "sleep_content",
        "Daily sleep check-in",
        "Don’t give up now. You can change your routine, get an accountability boost with a team, or get a coach.",
        minHoursLater: firstReminder + nextReminder);
    await serviceLocator<NotificationService>().showContentReminder(
        baseId + 18 * 10 + 3,
        "sleep_content",
        "Daily sleep check-in",
        "We miss you ☹️.  If you need some help, feel free to contact us directly.",
        minHoursLater: firstReminder + nextReminder * 2);
  }
}
