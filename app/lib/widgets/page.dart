import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hea/utils/sleep_notifications.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:hea/utils/kv_wrap.dart';
import 'package:hea/widgets/select_list.dart';
import 'package:hea/services/service_locator.dart';
import 'package:hea/services/logging_service.dart';
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
    scheduleSleepNotifications();
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
                        Container(
                            //alignment: AlignmentDirectional.topCenter,
                            child: IconButton(
                                iconSize: 38,
                                icon: FaIcon(FontAwesomeIcons.times,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                })),
                        SizedBox(width: 10.0),
                        Expanded(
                            child: Text(title,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 4,
                                style: Theme.of(context).textTheme.headline1)),
                        if (prevPage != null)
                          Container(
                              //alignment: AlignmentDirectional.topCenter,
                              child: IconButton(
                                  iconSize: 24,
                                  icon: FaIcon(FontAwesomeIcons.undo,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                  onPressed: () {
                                    Widget prev = prevPage!();
                                    String? s = sleep.rlookup(prev.runtimeType);
                                    debugPrint(s);
                                    if (s != null) {
                                      serviceLocator<SharedPreferences>()
                                          .setString('sleep', s);
                                    }
                                    serviceLocator<LoggingService>()
                                        .createLog('navigate', s);
                                    serviceLocator<LoggingService>()
                                        .createLog('sleep', kvDump("sleep"));
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute<void>(
                                      builder: (BuildContext context) => prev,
                                    ));
                                    scheduleSleepNotifications();
                                  })),
                      ])))),
      body: SingleChildScrollView(
          child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18.0, 0.0, 18.0, 5.0),
          child: Column(children: [
            page,
            SizedBox(height: 64.0),
          ]),
        ),
      )),
      floatingActionButton: nextPage == null || hideNext
          ? null
          : FloatingActionButton(
              onPressed: () {
                Widget next = nextPage!();
                String? s = sleep.rlookup(next.runtimeType);
                debugPrint(s);
                if (s != null) {
                  serviceLocator<SharedPreferences>().setString('sleep', s);
                }
                serviceLocator<LoggingService>().createLog('navigate', s);
                serviceLocator<LoggingService>()
                    .createLog('sleep', kvDump("sleep"));
                Navigator.of(context).pushReplacement(MaterialPageRoute<void>(
                  builder: (BuildContext context) => next,
                ));
              },
              tooltip: 'Next',
              backgroundColor: Theme.of(context).colorScheme.primary,
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
  final int? minSelected = null;
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

  bool canNext() {
    int minLength = widget.minSelected ?? 1;
    return kvReadStringList("sleep", widget.valueName).length >= minLength;
  }

  @override
  void initState() {
    super.initState();
    hideNext = !canNext();
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
                    kvWrite<List<String>>("sleep", widget.valueName, c);
                    setState(() {
                      hideNext = !canNext();
                    });
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
    FocusScope.of(context).requestFocus(FocusNode());
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
    return ElevatedButton(
      child: Text(selectedTime.format(context),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Color(0xFF414141),
            fontSize: 20.0,
          )),
      onPressed: () => onTap(context),
      style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          primary: Colors.black,
          backgroundColor: Color(0xFFF5F5F5),
          elevation: 0.0),
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
    TimeOfDay initialTime = kvReadTimeOfDay("sleep", valueName) ?? defaultTime;
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
            SizedBox(width: 4.0),
            Text('hours'),
          ]),
          SizedBox(height: 4.0),
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
            SizedBox(width: 4.0),
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
