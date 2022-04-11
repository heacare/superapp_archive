import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:hea/utils/kv_wrap.dart';
import 'package:hea/widgets/select_list.dart';
import 'package:hea/services/service_locator.dart';
import 'package:hea/pages/sleep/lookup.dart';

typedef PageBuilder = Widget Function();

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
    PageBuilder builder = byKey[key]?.builder ?? defaultPage.builder;
    return builder;
  }
}

class BasePage extends StatelessWidget {
  const BasePage(
      {Key? key,
      required this.title,
      this.nextPage,
      this.prevPage,
      required this.page,
      this.hideNext = false})
      : super(key: key);

  final String title;
  final PageBuilder? nextPage;
  final PageBuilder? prevPage;

  final Widget page;
  final bool hideNext;

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
                                Widget prev = prevPage!();
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
          child: page,
        ),
      )),
      floatingActionButton: nextPage == null || hideNext
          ? null
          : FloatingActionButton(
              onPressed: () {
                Widget next = nextPage!();
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

abstract class Page extends StatelessWidget {
  abstract final String title;

  const Page({Key? key}) : super(key: key);

  abstract final PageBuilder? nextPage;
  abstract final PageBuilder? prevPage;

  Widget buildPage(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return BasePage(
      title: title,
      nextPage: nextPage,
      prevPage: prevPage,
      page: buildPage(context),
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

abstract class OpenEndedPage extends Page {
  abstract final String markdown;
  abstract final Image? image;

  abstract final String valueName;

  const OpenEndedPage({Key? key}) : super(key: key);

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
          TextFormField(
              initialValue: kvRead("sleep", valueName),
              onChanged: (String value) {
                kvWrite<String>("sleep", valueName, value);
              })
        ]);
  }
}

abstract class MultipleChoicePage extends StatefulWidget {
  abstract final String markdown;
  abstract final Image? image;

  abstract final int maxChoice;
  abstract final List<SelectListItem<String>> choices;
  abstract final String valueName;

  const MultipleChoicePage({Key? key}) : super(key: key);

  abstract final String title;
  abstract final PageBuilder? nextPage;
  abstract final PageBuilder? prevPage;

  @override
  State<MultipleChoicePage> createState() => MultipleChoicePageState();
}

class MultipleChoicePageState extends State<MultipleChoicePage> {
  bool hideNext = false;

  @override
  void initState() {
    super.initState();
    hideNext = kvReadStringList("sleep", widget.valueName).isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final markdownStyleSheet = MarkdownStyleSheet(
        p: Theme.of(context).textTheme.bodyText1,
        h1: Theme.of(context).textTheme.headline3);
    return BasePage(
        title: widget.title,
        nextPage: widget.nextPage,
        prevPage: widget.prevPage,
        hideNext: hideNext,
        page: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (widget.image != null) widget.image!,
              if (widget.image != null) SizedBox(height: 4.0),
              if (widget.markdown != "")
                MarkdownBody(
                    data: widget.markdown,
                    extensionSet: md.ExtensionSet.gitHubFlavored,
                    styleSheet: markdownStyleSheet),
              if (widget.markdown != "") SizedBox(height: 4.0),
              SelectList(
                  items: widget.choices,
                  max: widget.maxChoice,
                  defaultSelected: kvReadStringList("sleep", widget.valueName),
                  onChange: (List<String> c) {
                    setState(() {
                      hideNext = c.isEmpty;
                    });
                    kvWrite<List<String>>("sleep", widget.valueName, c);
                  }),
            ]));
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
  abstract final TimeOfDay defaultTime;

  const TimePickerPage({Key? key}) : super(key: key);

  @override
  Widget buildPage(BuildContext context) {
    final markdownStyleSheet = MarkdownStyleSheet(
        p: Theme.of(context).textTheme.bodyText1,
        h1: Theme.of(context).textTheme.headline3);
    TimeOfDay time = kvReadTimeOfDay("sleep", valueName) ?? defaultTime;
    TimeOfDay initialTime = time;
    kvWriteTimeOfDay("sleep", valueName, initialTime);
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
                          minutes: selectedDuration.inMinutes
                              .remainder(Duration.minutesPerHour),
                        );
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
                    initialValue: (selectedDuration.inMinutes
                            .remainder(Duration.minutesPerHour))
                        .toString(),
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
  abstract final int defaultMinutes;

  const DurationPickerPage({Key? key}) : super(key: key);

  @override
  Widget buildPage(BuildContext context) {
    final markdownStyleSheet = MarkdownStyleSheet(
        p: Theme.of(context).textTheme.bodyText1,
        h1: Theme.of(context).textTheme.headline3);
    int duration = kvReadInt("sleep", valueName) ?? defaultMinutes;
    Duration initialDuration = Duration(minutes: duration);
    kvWrite("sleep", valueName, initialDuration.inMinutes);
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
