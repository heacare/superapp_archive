import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import 'package:hea/services/notification_service.dart';
import 'package:hea/services/service_locator.dart';
import 'package:hea/services/sleep_checkin_service.dart';
import 'package:hea/services/health_service.dart';
import 'package:hea/utils/sleep_notifications.dart';
import 'package:hea/widgets/page.dart';
import 'package:hea/widgets/pill_select.dart';
import 'package:hea/widgets/select_list.dart';
import 'package:hea/utils/kv_wrap.dart';

class SleepCheckin extends StatefulWidget {
  const SleepCheckin({Key? key}) : super(key: key);

  @override
  SleepCheckinState createState() => SleepCheckinState();
}

class SleepCheckinState extends State<SleepCheckin> {
  SleepCheckinData data = SleepCheckinData();
  String? autofillMessage;

  @override
  Widget build(BuildContext context) {
    List<SelectListItem<String>> selectedCalmActivities =
        kvReadStringList("sleep", "included-activities")
            .map((s) => SelectListItem(text: s, value: s))
            .toList();
    SleepCheckinProgress progress =
        serviceLocator<SleepCheckinService>().getProgress();
    () async {
      SleepAutofill? sleepAutofill =
          await serviceLocator<HealthService>().autofillRead1Day();
      if (sleepAutofill == null) {
        return;
      }
      DateTime lastNight =
          sleepAutofill.awake.subtract(const Duration(days: 1));
      String date = DateFormat.yMd().format(lastNight);
      setState(() {
        if (sleepAutofill.inBed != null) {
          data.timeGoBed = TimeOfDay.fromDateTime(sleepAutofill.inBed!);
        }
        if (sleepAutofill.asleep != null) {
          data.timeAsleepBed = TimeOfDay.fromDateTime(sleepAutofill.asleep!);
        }
        data.timeOutBed = TimeOfDay.fromDateTime(sleepAutofill.awake);
        autofillMessage = "Data has been autofilled from last night ($date)";
      });
    }();
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(154),
          child: SafeArea(
              child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                            iconSize: 38,
                            icon: FaIcon(FontAwesomeIcons.times,
                                color: Theme.of(context).colorScheme.primary),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                        const SizedBox(width: 10.0),
                        Expanded(
                            child: Text(
                                "Sleep check-in day ${progress.dayCounter} of ${progress.total}",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 4,
                                style: Theme.of(context).textTheme.headline2)),
                      ])))),
      body: SingleChildScrollView(
          child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18.0, 0.0, 18.0, 5.0),
          child: Column(
            children: [
              const Text("(WORK-IN-PROGRESS)"),
              Text("Did you manage to wind-down before bedtime?",
                  style: Theme.of(context).textTheme.titleLarge),
              PillSelect(
                  items: const {"yes": "Yes", "partly": "Partly", "no": "No"},
                  onChange: (String value) {
                    data.didWindDown = value;
                  }),
              const SizedBox(height: 64.0),
              Text("How did you do for your bedtime routine",
                  style: Theme.of(context).textTheme.titleLarge),
              const Text("Select those that you managed to accomplish"),
              SelectList(
                  items: selectedCalmActivities,
                  defaultSelected: data.didCalmActivities,
                  max: 0,
                  onChange: (List<String> value) {
                    data.didCalmActivities = value;
                  }),
              const SizedBox(height: 64.0),
              Text(
                  "Did you have any unexpected interruptions to wind-down or any insights to your sleep?",
                  style: Theme.of(context).textTheme.titleLarge),
              TextFormField(
                  initialValue: data.interruptions,
                  onChanged: (String value) {
                    data.interruptions = value;
                  }),
              const SizedBox(height: 64.0),
              Text("What time did you get into bed?",
                  style: Theme.of(context).textTheme.titleLarge),
              const Text("Note: This is not the time you fell asleep."),
              TimePickerBlock(
                  initialTime: data.timeGoBed,
                  onChange: (TimeOfDay value) {
                    data.timeGoBed = value;
                  }),
              const SizedBox(height: 64.0),
              Text("What time did you fall asleep?",
                  style: Theme.of(context).textTheme.titleLarge),
              TimePickerBlock(
                  initialTime: data.timeAsleepBed,
                  onChange: (TimeOfDay value) {
                    data.timeAsleepBed = value;
                  }),
              const Text("(Time taken to fall asleep: N minutes)"),
              const SizedBox(height: 64.0),
              Text("How easy did you fall asleep?",
                  style: Theme.of(context).textTheme.titleLarge),
              Row(children: const [
                Text("Not easy"),
                Text("Very easy"),
              ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
              Slider(
                value: data.easyAsleep.toDouble(),
                max: 4,
                divisions: 4,
                onChanged: (double value) {
                  setState(() {
                    data.easyAsleep = value.toInt();
                  });
                },
              ),
              const SizedBox(height: 64.0),
              Text("What time did you get out of bed?",
                  style: Theme.of(context).textTheme.titleLarge),
              const Text("Note: This is not necessarily the time you woke up."),
              TimePickerBlock(
                  initialTime: data.timeOutBed,
                  onChange: (TimeOfDay value) {
                    data.timeOutBed = value;
                  }),
              const SizedBox(height: 64.0),
              Text("You slept: N hours",
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center),
              const Text(
                  "Note: This is different from the amount of time you spent in bed"),
              const SizedBox(height: 64.0),
              Text(
                  "How easily did you shift from feeling groggy after waking to feeling fully awake?",
                  style: Theme.of(context).textTheme.titleLarge),
              Row(children: const [
                Text("Easy"),
                Text("Difficult"),
              ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
              Slider(
                value: data.easyWake.toDouble(),
                max: 4,
                divisions: 4,
                onChanged: (double value) {
                  setState(() {
                    data.easyWake = value.toInt();
                  });
                },
              ),
              const SizedBox(height: 64.0),
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
        ),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await serviceLocator<SleepCheckinService>().add(data);
          Navigator.of(context).pop();
          scheduleSleepNotifications();
          if (progress.allDone) {
            // Set #18
            await serviceLocator<NotificationService>().showContentReminder(
                100 + 18 * 10 + 1,
                "sleep_content",
                "Daily sleep check-in",
                "You did it! What's next for you?",
                minHoursLater: 0);
          }
        },
        tooltip: 'Done',
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(FontAwesomeIcons.check,
            color: Theme.of(context).colorScheme.onPrimary),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
