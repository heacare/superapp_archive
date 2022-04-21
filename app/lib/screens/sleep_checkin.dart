import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  String didWindDown = "yes";

  @override
  Widget build(BuildContext context) {
    List<SelectListItem<String>> selectedCalmActivities =
        kvReadStringList("sleep", "included-activities")
            .map((s) => SelectListItem(text: s, value: s))
            .toList();
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
                            child: Text("Sleep check-in",
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
                  onChange: (String selection) {
                    debugPrint(selection);
                  }),
              const SizedBox(height: 64.0),
              Text("How did you do for your bedtime routine",
                  style: Theme.of(context).textTheme.titleLarge),
              const Text("Select those that you managed to accomplish"),
              SelectList(
                  items: selectedCalmActivities,
                  max: 0,
                  onChange: (List<String> selection) {
                    debugPrint(selection.join(","));
                  }),
              const SizedBox(height: 64.0),
              Text(
                  "Did you have any unexpected interruptions to wind-down or any insights to your sleep?",
                  style: Theme.of(context).textTheme.titleLarge),
              TextFormField(onChanged: (String value) {
                debugPrint(value);
              }),
              const SizedBox(height: 64.0),
              Text("What time did you get into bed?",
                  style: Theme.of(context).textTheme.titleLarge),
              const Text("Note: This is not the time you fell asleep."),
              TimePickerBlock(
                  initialTime: const TimeOfDay(hour: 20, minute: 0),
                  onChange: (TimeOfDay value) {
                    debugPrint(value.toString());
                  }),
              const SizedBox(height: 64.0),
              Text("What time did you fall asleep?",
                  style: Theme.of(context).textTheme.titleLarge),
              TimePickerBlock(
                  initialTime: const TimeOfDay(hour: 20, minute: 30),
                  onChange: (TimeOfDay value) {
                    debugPrint(value.toString());
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
                value: 0,
                max: 4,
                divisions: 4,
                onChanged: (double value) {
                  debugPrint(value.toString());
                },
              ),
              const SizedBox(height: 64.0),
              Text("What time did you get out of bed?",
                  style: Theme.of(context).textTheme.titleLarge),
              const Text("Note: This is not necessarily the time you woke up."),
              TimePickerBlock(
                  initialTime: const TimeOfDay(hour: 20, minute: 30),
                  onChange: (TimeOfDay value) {
                    debugPrint(value.toString());
                  }),
              const SizedBox(height: 64.0),
              Text("You slept: N hours",
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center),
              const Text(
                  "Note: This is different from the amount of time you spent in bed"),
              const SizedBox(height: 64.0),
              Text(
                  "How easily did you shift from sleep to feeling fully awake?",
                  style: Theme.of(context).textTheme.titleLarge),
              Row(children: const [
                Text("Easy"),
                Text("Difficult"),
              ], mainAxisAlignment: MainAxisAlignment.spaceBetween),
              Slider(
                value: 0,
                max: 4,
                divisions: 4,
                onChanged: (double value) {
                  debugPrint(value.toString());
                },
              ),
              const SizedBox(height: 64.0),
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
        ),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop();
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
