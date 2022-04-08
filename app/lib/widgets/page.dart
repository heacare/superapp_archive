import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hea/utils/kv_wrap.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:hea/widgets/select_list.dart';
import 'package:hea/services/service_locator.dart';
import 'package:hea/pages/sleep/lookup.dart';

typedef PageBuilder = Page Function();

class PageDef {
  final PageBuilder builder;
  final Type t;
  PageDef(this.t, this.builder);
}

class Lesson {
  Map<String, PageDef> byKey = {};
  Map<Type, String> byType = {};
  PageDef defaultPage;

  Lesson(List<PageDef> pages) : defaultPage = pages[0] {
    for (var page in pages) {
      byKey[page.t.toString()] = page;
      byType[page.t] = page.t.toString();
    }
  }
  String? rlookup(Type t) {
    return byType[t];
  }

  PageBuilder lookup(String? key) {
    PageBuilder? builder = byKey[key]?.builder;
    if (builder == null) {
      return defaultPage.builder;
    }
    return builder;
  }
}

abstract class Page extends StatelessWidget {
  abstract final String title;

  const Page({Key? key}) : super(key: key);

  abstract final PageBuilder? nextPage;
  abstract final PageBuilder? prevPage;

  Widget buildPage(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(150),
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
                            icon: const FaIcon(FontAwesomeIcons.times,
                                color: Color(0xFF00ABE9)),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                        SizedBox(width: 10.0),
                        Expanded(
                            child: Text(title,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: Theme.of(context).textTheme.headline1)),
                        if (prevPage != null)
                          IconButton(
                              iconSize: 24,
                              icon: const FaIcon(FontAwesomeIcons.undo,
                                  color: Color(0xFF00ABE9)),
                              onPressed: () {
                                Page prev = prevPage!();
                                String? s = sleep.rlookup(prev.runtimeType);
                                print(s);
                                if (s != null) {
                                  serviceLocator<SharedPreferences>()
                                      .setString('sleep', s);
                                }
                                Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute<void>(
                                  builder: (BuildContext context) => prev,
                                ));
                              }),
                      ])))),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(18.0, 0.0, 18.0, 5.0),
        child: SingleChildScrollView(
          child: buildPage(context),
        ),
      )),
      floatingActionButton: nextPage == null
          ? null
          : FloatingActionButton(
              onPressed: () {
                Page next = nextPage!();
                String? s = sleep.rlookup(next.runtimeType);
                print(s);
                if (s != null) {
                  serviceLocator<SharedPreferences>().setString('sleep', s);
                }
                Navigator.of(context).pushReplacement(MaterialPageRoute<void>(
                  builder: (BuildContext context) => next,
                ));
              },
              tooltip: 'Next',
              backgroundColor: Color(0xFF00ABE9),
              child: Icon(FontAwesomeIcons.arrowRight,
                  color: Theme.of(context).colorScheme.onPrimary),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

abstract class MarkdownPage extends Page {
  abstract final String markdown;
  abstract final Image? image;

  const MarkdownPage({Key? key}) : super(key: key);

  @override
  Widget buildPage(BuildContext context) {
    final markdownStyleSheet = MarkdownStyleSheet(
        p: Theme.of(context).textTheme.bodyText1,
        h1: Theme.of(context).textTheme.headline3);
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (image != null) image!,
          if (image != null) SizedBox(height: 4.0),
          MarkdownBody(
              data: markdown,
              extensionSet: md.ExtensionSet.gitHubFlavored,
              styleSheet: markdownStyleSheet),
        ]);
  }
}

abstract class MultipleChoicePage extends Page {
  abstract final String markdown;
  abstract final Image? image;

  abstract final int maxChoice;
  abstract final List<SelectListItem<String>> choices;
  abstract final String valueName;

  const MultipleChoicePage({Key? key}) : super(key: key);

  @override
  Widget buildPage(BuildContext context) {
    final markdownStyleSheet = MarkdownStyleSheet(
        p: Theme.of(context).textTheme.bodyText1,
        h1: Theme.of(context).textTheme.headline3);
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (image != null) image!,
          if (image != null) SizedBox(height: 4.0),
          if (markdown != "")
            MarkdownBody(
                data: markdown,
                extensionSet: md.ExtensionSet.gitHubFlavored,
                styleSheet: markdownStyleSheet),
          if (markdown != "") SizedBox(height: 4.0),
          SelectList(
              items: choices,
              max: maxChoice,
              defaultSelected: kvReadStringList("sleep", valueName),
              onChange: (List<String> c) {
                // TODO: Save value
                print(c);
                kvWrite<List<String>>("sleep", valueName, c);
              }),
        ]);
  }
}

typedef TimePickerBlockOnChange = Function(TimeOfDay);

class TimePickerBlock extends StatefulWidget {
  TimePickerBlock({Key? key, required this.initialTime, required this.onChange})
      : super(key: key);

  TimeOfDay initialTime;
  TimePickerBlockOnChange onChange;

  @override
  TimePickerBlockState createState() => TimePickerBlockState();
}

class TimePickerBlockState extends State<TimePickerBlock> {
  TimeOfDay selectedTime = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    selectedTime = widget.initialTime;
  }

  Future<void> onTap(context) async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (time != null) {
      setState(() {
        selectedTime = time;
      });
      widget.onChange(selectedTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(context),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(selectedTime.format(context)),
      ),
    );
  }
}

abstract class TimePickerPage extends Page {
  abstract final String markdown;
  abstract final Image? image;

  abstract final String valueName;

  const TimePickerPage({Key? key}) : super(key: key);

  @override
  Widget buildPage(BuildContext context) {
    final markdownStyleSheet = MarkdownStyleSheet(
        p: Theme.of(context).textTheme.bodyText1,
        h1: Theme.of(context).textTheme.headline3);
    TimeOfDay? time = kvReadTimeOfDay("sleep", valueName);
    if (time == null) {
      time = TimeOfDay(hour: 22, minute: 00);
    }
    TimeOfDay initialTime = time;
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (image != null) image!,
          if (image != null) SizedBox(height: 4.0),
          if (markdown != "")
            MarkdownBody(
                data: markdown,
                extensionSet: md.ExtensionSet.gitHubFlavored,
                styleSheet: markdownStyleSheet),
          if (markdown != "") SizedBox(height: 4.0),
          TimePickerBlock(
              initialTime: initialTime,
              onChange: (time) => kvWriteTimeOfDay("sleep", valueName, time)),
        ]);
  }
}

typedef DurationPickerBlockOnChange = Function(Duration);

class DurationPickerBlock extends StatefulWidget {
  DurationPickerBlock(
      {Key? key, required this.initialDuration, required this.onChange})
      : super(key: key);

  Duration initialDuration;
  DurationPickerBlockOnChange onChange;

  @override
  DurationPickerBlockState createState() => DurationPickerBlockState();
}

class DurationPickerBlockState extends State<DurationPickerBlock> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Duration selectedDuration = Duration();

  @override
  void initState() {
    super.initState();
    selectedDuration = widget.initialDuration;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(children: [
          Row(children: [
            Container(
                width: 72.0,
                child: TextFormField(
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.end,
                    initialValue: (selectedDuration.inHours).toString(),
                    onChanged: (String value) {
                      int hours = int.tryParse(value) ?? 0;
                      setState(() {
                        selectedDuration = Duration(
                            hours: hours,
                            minutes: selectedDuration.inMinutes % 60);
                      });
                      widget.onChange(selectedDuration);
                    })),
            Text('hours'),
          ]),
          Row(children: [
            Container(
                width: 72.0,
                child: TextFormField(
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.end,
                    initialValue: (selectedDuration.inMinutes % 60).toString(),
                    onChanged: (String value) {
                      int minutes = int.tryParse(value) ?? 0;
                      setState(() {
                        selectedDuration = Duration(
                            hours: selectedDuration.inHours, minutes: minutes);
                      });
                      widget.onChange(selectedDuration);
                    })),
            Text('minutes'),
          ]),
        ]));
  }
}

abstract class DurationPickerPage extends Page {
  abstract final String markdown;
  abstract final Image? image;

  abstract final String valueName;

  const DurationPickerPage({Key? key}) : super(key: key);

  @override
  Widget buildPage(BuildContext context) {
    final markdownStyleSheet = MarkdownStyleSheet(
        p: Theme.of(context).textTheme.bodyText1,
        h1: Theme.of(context).textTheme.headline3);
    int? duration = kvReadInt("sleep", valueName);
    if (duration == null) {
      duration = 8 * 60;
    }
    Duration initialDuration = Duration(minutes: duration);
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (image != null) image!,
          if (image != null) SizedBox(height: 4.0),
          if (markdown != "")
            MarkdownBody(
                data: markdown,
                extensionSet: md.ExtensionSet.gitHubFlavored,
                styleSheet: markdownStyleSheet),
          if (markdown != "") SizedBox(height: 4.0),
          DurationPickerBlock(
              initialDuration: initialDuration,
              onChange: (duration) =>
                  kvWrite("sleep", valueName, duration.inMinutes)),
        ]);
  }
}
