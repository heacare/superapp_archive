import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
            .map((s) => SelectListItem(text: s, value: s as String))
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
          child: Column(children: [
            const Text("Did you manage to wind-down before bedtime?"),
            PillSelect(
                items: const {"yes": "Yes", "partly": "Partly", "no": "No"},
                onChange: (String selection) {
                  debugPrint(selection);
                }),
            const Text("How did you do for your bedtime routine"),
            const Text("Select those that you managed to accomplish"),
            SelectList(
                items: selectedCalmActivities,
                max: 0,
                onChange: (List<String> selection) {
                  debugPrint(selection.join(","));
                }),
            const SizedBox(height: 64.0),
          ]),
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
