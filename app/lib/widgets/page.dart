import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:hea/utils/kv_wrap.dart';
import 'package:hea/widgets/select_list.dart';
import 'package:hea/services/service_locator.dart';
import 'package:hea/services/logging_service.dart';
import 'package:hea/pages/sleep/lookup.dart';
import 'package:hea/pages/sleep_review/lookup.dart';
import 'package:hea/utils/sleep_notifications.dart';
import 'package:hea/utils/sleep_log.dart';

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

String? rlookup(Widget w) {
  String? s = sleep.rlookup(w.runtimeType);
  if (s != null) {
    serviceLocator<SharedPreferences>().setString('sleep', s);
    sleepLog();
    return s;
  }

  s = sleep_review.rlookup(w.runtimeType);
  if (s != null) {
    serviceLocator<SharedPreferences>().setString('sleep_review', s);
    return s;
  }

  return null;
}

class BasePage extends StatelessWidget {
  BasePage(
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
                        IconButton(
                            iconSize: 38,
                            icon: FaIcon(FontAwesomeIcons.xmark,
                                color: Theme.of(context).colorScheme.primary),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                        const SizedBox(width: 10.0),
                        Expanded(
                            child: Text(title,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 4,
                                style: Theme.of(context).textTheme.headline2)),
                        if (prevPage != null)
                          IconButton(
                              iconSize: 24,
                              icon: FaIcon(FontAwesomeIcons.arrowRotateLeft,
                                  color: Theme.of(context).colorScheme.primary),
                              onPressed: () {
                                Widget prev = prevPage!();
                                String? s = rlookup(prev);
                                debugPrint(s);
                                serviceLocator<LoggingService>()
                                    .createLog('navigate', s);
                                Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute<void>(
                                  builder: (BuildContext context) => prev,
                                ));
                                scheduleSleepNotifications();
                              }),
                      ])))),
      body: SingleChildScrollView(
          child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18.0, 0.0, 18.0, 5.0),
          child: Column(children: [
            page,
            const SizedBox(height: 64.0),
          ]),
        ),
      )),
      floatingActionButton: nextPage == null || hideNext
          ? null
          : FloatingActionButton(
              onPressed: () {
                if (hideNext) {
                  // TODO: Ensure valid before moving to the next page. Because
                  // the user can uncheck a select list and immediately press
                  // the next button, they can bypass a page without completing
                  // it, which can put the app in an undefined state. This is a
                  // FAILED attempt to fix it.
                  return;
                }
                Widget next = nextPage!();
                String? s = rlookup(next);
                debugPrint(s);
                serviceLocator<LoggingService>().createLog('navigate', s);
                sleepLog();
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

class PageImage extends StatelessWidget {
  final Widget child;
  final double? maxHeight;
  const PageImage(this.child, {this.maxHeight, Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.topCenter,
        child: Container(
          constraints: BoxConstraints(
            maxHeight: maxHeight ?? 240,
          ),
          padding: const EdgeInsets.only(bottom: 8, top: 4),
          child: child,
        ));
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
          if (image != null) PageImage(image!),
          if (image != null) const SizedBox(height: 4.0),
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
  abstract final String label;

  const OpenEndedPage({Key? key}) : super(key: key);

  @override
  Widget buildPage(BuildContext context) {
    final markdownStyleSheet = MarkdownStyleSheet(
        p: Theme.of(context).textTheme.bodyText1,
        h1: Theme.of(context).textTheme.headline3);
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (image != null) PageImage(image!),
          if (image != null) const SizedBox(height: 4.0),
          if (markdown != "")
            MarkdownBody(
                data: markdown,
                extensionSet: md.ExtensionSet.gitHubFlavored,
                styleSheet: markdownStyleSheet),
          if (markdown != "") const SizedBox(height: 4.0),
          TextFormField(
              initialValue: kvRead("sleep", valueName),
              decoration: InputDecoration(
                labelText: label,
              ),
              onChanged: (String value) {
                kvWrite<String>("sleep", valueName, value);
              })
        ]);
  }
}

typedef StringListPageBuilder = Widget Function(List<String>);

abstract class MultipleChoicePage extends StatefulWidget {
  abstract final String markdown;
  abstract final Image? image;

  abstract final int maxChoice;
  abstract final int minSelected;
  abstract final List<SelectListItem<String>> choices;
  abstract final String valueName;

  const MultipleChoicePage({Key? key}) : super(key: key);

  abstract final String title;
  abstract final PageBuilder? nextPage;
  abstract final PageBuilder? prevPage;

  @override
  State<MultipleChoicePage> createState() => MultipleChoicePageState();

  bool hasNextPageStringList() => false;
  Widget nextPageStringList(List<String> data) {
    return Container();
  }
}

class MultipleChoicePageState extends State<MultipleChoicePage> {
  bool hideNext = false;
  List<String> selected = [];
  List<String> values = [];
  SelectListItem<String>? otherItem;
  String other = "";

  bool canNext() {
    return kvReadStringList("sleep", widget.valueName).length >=
        widget.minSelected;
  }

  void skipNext() {
    if (widget.nextPage == null) {
      return;
    }
    // This is pretty bad code, duplicated from BasePage
    Widget next = widget.nextPage!();
    String? s = rlookup(next);
    debugPrint(s);
    serviceLocator<LoggingService>().createLog('navigate', s);
    sleepLog();
    Navigator.of(context).pushReplacement(MaterialPageRoute<void>(
      builder: (BuildContext context) => next,
    ));
  }

  @override
  void initState() {
    super.initState();
    hideNext = !canNext();
    values = widget.choices.map((item) => item.value).toList();
    Iterable<SelectListItem<String>> otherItems =
        widget.choices.where((sel) => sel.other);
    if (otherItems.isNotEmpty) {
      otherItem = otherItems.first;
    }
  }

  List<String> get savedValues {
    List<String> selectedWithoutOther =
        selected.where((sel) => otherItem?.value != sel).toList();
    if (other != "") {
      selectedWithoutOther.add(other);
    }
    return selectedWithoutOther;
  }

  @override
  Widget build(BuildContext context) {
    final markdownStyleSheet = MarkdownStyleSheet(
        p: Theme.of(context).textTheme.bodyText1,
        h1: Theme.of(context).textTheme.headline3);
    selected = kvReadStringList("sleep", widget.valueName);
    List<String> otherList = [];
    selected.removeWhere((sel) {
      if (values.contains(sel)) {
        return false;
      }
      otherList.add(sel);
      return true;
    });
    if (otherList.isNotEmpty && otherItem != null) {
      selected.add(otherItem!.value);
    }
    other = otherList.join(", ");
    List<String> notices = [];
    if (widget.maxChoice == 0) {
      notices.add("Select all that apply");
    }
    if (widget.maxChoice > 1) {
      notices.add("Select up to ${widget.maxChoice}");
    }
    if (otherItem != null) {
      notices.add('If "Other", please specify');
    }
    String notice = notices.join(". ");
    return BasePage(
        title: widget.title,
        nextPage: widget.hasNextPageStringList()
            ? () => widget.nextPageStringList(selected)
            : widget.nextPage,
        prevPage: widget.prevPage,
        hideNext: hideNext,
        page: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
            Widget>[
          if (widget.image != null) PageImage(widget.image!),
          if (widget.image != null) const SizedBox(height: 4.0),
          if (widget.markdown != "")
            MarkdownBody(
                data: widget.markdown,
                extensionSet: md.ExtensionSet.gitHubFlavored,
                styleSheet: markdownStyleSheet),
          if (widget.markdown != "") const SizedBox(height: 4.0),
          const SizedBox(height: 8.0),
          if (notice != "")
            Text("($notice)", style: Theme.of(context).textTheme.labelSmall),
          if (notice != "") const SizedBox(height: 4.0),
          SelectList(
              items: widget.choices,
              max: widget.maxChoice,
              defaultSelected: selected,
              defaultOther: other,
              onChange: (List<String> c) {
                List<String> prevSelected = selected;
                selected = c;
                kvWrite<List<String>>("sleep", widget.valueName, savedValues);
                setState(() {
                  hideNext = !canNext();
                });
                if (widget.maxChoice == 1 &&
                    savedValues.length == widget.minSelected &&
                    other == "" &&
                    prevSelected.isEmpty) {
                  skipNext();
                }
              },
              onChangeOther: (String c) {
                other = c;
                kvWrite<List<String>>("sleep", widget.valueName, savedValues);
                debugPrint(
                    kvReadStringList("sleep", widget.valueName).join("..."));
                setState(() {
                  hideNext = !canNext();
                });
              }),
        ]));
  }
}

typedef TimePickerBlockOnChange = Function(TimeOfDay);

class TimePickerBlock extends StatefulWidget {
  const TimePickerBlock(
      {Key? key,
      required this.defaultTime,
      this.initialTime,
      this.time,
      required this.onChange})
      : super(key: key);

  final TimeOfDay defaultTime; // Time to show in the picker dialog
  final TimeOfDay? initialTime; // Time to show at the start
  final TimeOfDay? time; // Time to always show
  final TimePickerBlockOnChange onChange;

  @override
  TimePickerBlockState createState() => TimePickerBlockState();
}

class TimePickerBlockState extends State<TimePickerBlock> {
  TimeOfDay? selectedTime;

  @override
  void initState() {
    super.initState();
    selectedTime = widget.initialTime;
  }

  Future<void> onTap(context) async {
    FocusScope.of(context).requestFocus(FocusNode());
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: widget.time ?? selectedTime ?? widget.defaultTime,
    );
    if (time != null) {
      setState(() {
        selectedTime = time;
      });
      widget.onChange(time);
    }
  }

  @override
  Widget build(BuildContext context) {
    TimeOfDay? showTime = widget.time ?? selectedTime;
    return ElevatedButton(
      onPressed: () => onTap(context),
      style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          primary: Colors.black,
          backgroundColor: const Color(0xFFEBEBEB),
          elevation: 0.0),
      child: Text(showTime != null ? showTime.format(context) : "00:00",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: showTime != null
                ? const Color(0xFF414141)
                : const Color(0xFFDDDDDD),
            fontSize: 20.0,
          )),
    );
  }
}

class TimeRangePickerBlock extends StatefulWidget {
  const TimeRangePickerBlock(
      {this.defaultStartTime = const TimeOfDay(hour: 0, minute: 0),
      this.defaultEndTime = const TimeOfDay(hour: 0, minute: 0),
      required this.valueName,
      Key? key})
      : super(key: key);

  final TimeOfDay defaultStartTime;
  final TimeOfDay defaultEndTime;
  final String valueName;

  @override
  TimeRangePickerBlockState createState() => TimeRangePickerBlockState();
}

class TimeRangePickerBlockState extends State<TimeRangePickerBlock> {
  TimeOfDayRange? selectedRange;

  @override
  void initState() {
    super.initState();
    selectedRange = kvReadTimeOfDayRange("sleep", widget.valueName);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint("timerangesave");
    if (selectedRange != null) {
      kvWriteTimeOfDayRange("sleep", widget.valueName, selectedRange!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const Text("From"),
      TimePickerBlock(
          defaultTime: widget.defaultStartTime,
          time: selectedRange?.start,
          onChange: (time) {
            setState(() {
              selectedRange = TimeOfDayRange(time, selectedRange?.end ?? time);
              debugPrint("timerangesavefrom");
              kvWriteTimeOfDayRange("sleep", widget.valueName, selectedRange!);
            });
          }),
      const Text("to"),
      TimePickerBlock(
          defaultTime: widget.defaultEndTime,
          time: selectedRange?.end,
          onChange: (time) {
            setState(() {
              selectedRange =
                  TimeOfDayRange(selectedRange?.start ?? time, time);
              debugPrint("timerangesaveto");
              kvWriteTimeOfDayRange("sleep", widget.valueName, selectedRange!);
            });
          }),
    ]);
  }
}

abstract class TimePickerPage extends StatefulWidget {
  abstract final String title;
  abstract final PageBuilder? nextPage;
  abstract final PageBuilder? prevPage;

  abstract final String markdown;
  abstract final Image? image;

  abstract final String valueName;
  abstract final TimeOfDay defaultTime;

  const TimePickerPage({Key? key}) : super(key: key);

  Future<TimeOfDay?> getInitialTime(Function(String) setAutofillMessage) async {
    return null;
  }

  String getMarkdown(BuildContext context) {
    return markdown;
  }

  @override
  TimePickerPageState createState() => TimePickerPageState();
}

class TimePickerPageState extends State<TimePickerPage> {
  TimeOfDay? time;
  bool canNext = false;
  String autofillMessage = "";

  @override
  void initState() {
    super.initState();
    time = kvReadTimeOfDay("sleep", widget.valueName);
    canNext = kvReadTimeOfDay("sleep", widget.valueName) != null;
  }

  @override
  Widget build(BuildContext context) {
    final markdownStyleSheet = MarkdownStyleSheet(
        p: Theme.of(context).textTheme.bodyText1,
        h1: Theme.of(context).textTheme.headline3);
    return FutureBuilder<TimeOfDay?>(future: widget.getInitialTime((s) {
      autofillMessage = s;
    }), builder: (context, snapshot) {
      bool wasEdited = time != snapshot.data && time != null;
      if (time == null && snapshot.data != null) {
        time = snapshot.data;
        kvWriteTimeOfDay("sleep", widget.valueName, time!);
        canNext = true;
      }
      String markdown = widget.getMarkdown(context);
      return BasePage(
          title: widget.title,
          nextPage: widget.nextPage,
          prevPage: widget.prevPage,
          hideNext: !canNext,
          page: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (widget.image != null) PageImage(widget.image!),
                if (widget.image != null) const SizedBox(height: 4.0),
                if (markdown != "")
                  MarkdownBody(
                      data: markdown,
                      extensionSet: md.ExtensionSet.gitHubFlavored,
                      styleSheet: markdownStyleSheet),
                if (markdown != "") const SizedBox(height: 4.0),
                TimePickerBlock(
                    defaultTime: widget.defaultTime,
                    time: time,
                    onChange: (time) {
                      setState(() {
                        canNext = true;
                        this.time = time;
                      });
                      kvWriteTimeOfDay("sleep", widget.valueName, time);
                    }),
                Text(!wasEdited ? autofillMessage : "",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: const Color(0xFFD15319))),
              ]));
    });
  }
}

typedef DurationPickerBlockOnChange = Function(Duration);

class DurationPickerBlock extends StatefulWidget {
  const DurationPickerBlock(
      {Key? key,
      required this.initialDuration,
      required this.onChange,
      this.minutesOnly = false})
      : super(key: key);

  final Duration? initialDuration;
  final DurationPickerBlockOnChange onChange;
  final bool minutesOnly;

  @override
  DurationPickerBlockState createState() => DurationPickerBlockState();
}

class DurationPickerBlockState extends State<DurationPickerBlock> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Duration selectedDuration = const Duration();
  Duration prevSelectedDuration = const Duration();
  Key key = UniqueKey();

  @override
  void initState() {
    super.initState();
    selectedDuration = widget.initialDuration ?? const Duration();
  }

  @override
  Widget build(BuildContext context) {
    selectedDuration = widget.initialDuration ?? const Duration();
    debugPrint("selected:$selectedDuration");
    if (selectedDuration != prevSelectedDuration) {
      key = UniqueKey();
    }
    prevSelectedDuration = selectedDuration;
    if (widget.minutesOnly) {
      return Form(
          key: _formKey,
          child: Column(children: [
            Row(children: [
              SizedBox(
                  width: 72.0,
                  child: TextFormField(
                      key: key,
                      textAlign: TextAlign.end,
                      initialValue: (selectedDuration.inMinutes).toString(),
                      onFieldSubmitted: (String value) {
                        debugPrint("submit");
                        setState(() {
                          key = UniqueKey();
                        });
                      },
                      onChanged: (String value) {
                        int minutes = int.tryParse(value) ?? 0;
                        selectedDuration = Duration(minutes: minutes);
                        widget.onChange(selectedDuration);
                      })),
              const SizedBox(width: 4.0),
              const Text('minutes'),
            ]),
          ]));
    }
    return Form(
        key: _formKey,
        child: Column(children: [
          Row(children: [
            SizedBox(
                width: 72.0,
                child: TextFormField(
                    key: key,
                    textAlign: TextAlign.end,
                    initialValue: (selectedDuration.inHours).toString(),
                    onFieldSubmitted: (String value) {
                      debugPrint("submit-hour");
                      setState(() {
                        key = UniqueKey();
                      });
                    },
                    onChanged: (String value) {
                      debugPrint(value);
                      int hours = int.tryParse(value) ?? 0;
                      selectedDuration = Duration(
                        hours: hours,
                        minutes: selectedDuration.inMinutes
                            .remainder(Duration.minutesPerHour),
                      );
                      widget.onChange(selectedDuration);
                    })),
            const SizedBox(width: 4.0),
            const Text('hours'),
          ]),
          const SizedBox(height: 4.0),
          Row(children: [
            SizedBox(
                width: 72.0,
                child: TextFormField(
                    key: key,
                    textAlign: TextAlign.end,
                    initialValue: (selectedDuration.inMinutes
                            .remainder(Duration.minutesPerHour))
                        .toString(),
                    onFieldSubmitted: (String value) {
                      debugPrint("submit-minute");
                      setState(() {
                        key = UniqueKey();
                      });
                    },
                    onChanged: (String value) {
                      debugPrint(value);
                      int minutes = int.tryParse(value) ?? 0;
                      selectedDuration = Duration(
                          hours: selectedDuration.inHours, minutes: minutes);
                      widget.onChange(selectedDuration);
                    })),
            const SizedBox(width: 4.0),
            const Text('minutes'),
          ]),
        ]));
  }
}

abstract class DurationPickerPage extends Page {
  abstract final String markdown;
  abstract final Image? image;

  abstract final String valueName;
  abstract final bool minutesOnly;

  Future<int?> getInitialMinutes(Function(String) setAutofillMessage) async {
    return null;
  }

  const DurationPickerPage({Key? key}) : super(key: key);

  @override
  Widget buildPage(BuildContext context) {
    final markdownStyleSheet = MarkdownStyleSheet(
        p: Theme.of(context).textTheme.bodyText1,
        h1: Theme.of(context).textTheme.headline3);
    int? durationMinutes = kvReadInt("sleep", valueName);
    Duration? duration =
        durationMinutes == null ? null : Duration(minutes: durationMinutes);
    String autofillMessage = "";
    return FutureBuilder<int?>(future: getInitialMinutes((s) {
      autofillMessage = s;
    }), builder: (context, snapshot) {
      bool wasEdited = duration?.inMinutes != snapshot.data && duration != null;
      if (duration == null && snapshot.data != null) {
        duration = Duration(minutes: snapshot.data!);
        debugPrint("read:$duration");
        kvWrite("sleep", valueName, duration!.inMinutes);
      }
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (image != null) PageImage(image!),
            if (image != null) const SizedBox(height: 4.0),
            if (markdown != "")
              MarkdownBody(
                  data: markdown,
                  extensionSet: md.ExtensionSet.gitHubFlavored,
                  styleSheet: markdownStyleSheet),
            if (markdown != "") const SizedBox(height: 4.0),
            DurationPickerBlock(
                initialDuration: duration,
                minutesOnly: minutesOnly,
                onChange: (duration) {
                  debugPrint("set:$duration");
                  kvWrite("sleep", valueName, duration.inMinutes);
                }),
            Text(!wasEdited ? autofillMessage : "",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: const Color(0xFFD15319))),
          ]);
    });
  }
}
