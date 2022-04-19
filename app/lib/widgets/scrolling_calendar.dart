import 'dart:core';
import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

final _monthNames = [
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December"
];
String getMonthName(int month) {
  if (month > 12 || month < 1) {
    return "";
  }

  return _monthNames[month - 1];
}

final _abbreviatedDayNames = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
String getAbbreviatedDayName(int day) {
  if (day > 7 || day < 1) {
    return "";
  }

  return _abbreviatedDayNames[day - 1];
}

bool equivalentDayHour(DateTime a, DateTime b) {
  return a.year == b.year &&
      a.month == b.month &&
      a.day == b.day &&
      a.hour == b.hour;
}

List<DateTime> generateMonth(DateTime seed) {
  final lastDay = DateUtils.getDaysInMonth(seed.year, seed.month);
  return List.generate(lastDay - seed.day + 1,
      (i) => DateTime(seed.year, seed.month, i + seed.day));
}

class ScrollingCalendarItem extends StatelessWidget {
  const ScrollingCalendarItem(
      {Key? key,
      required this.date,
      required this.available,
      required this.selected})
      : super(key: key);

  final DateTime date;
  final int available;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    Border? border;
    if (selected) {
      border = Border.all(width: 3.0, color: const Color(0xFF5FD0F9));
    }

    final card = Container(
        margin: const EdgeInsets.only(left: 10.0, right: 10.0),
        padding: const EdgeInsets.all(30.0),
        decoration: BoxDecoration(
            border: border,
            borderRadius: const BorderRadius.all(Radius.circular(20.0)),
            color: Colors.grey[200]),
        child: Column(children: [
          Text(getAbbreviatedDayName(date.weekday),
              style: Theme.of(context).textTheme.headline4),
          Text(date.day.toString().padLeft(2, '0'),
              style: Theme.of(context).textTheme.headline3)
        ]));

    final badge = Container(
      width: 25,
      height: 25,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Color(0xFF5FD0F9),
        borderRadius: BorderRadius.all(Radius.circular(12.5)),
      ),
      child: Text(available.toString(),
          style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
              height: 1.2,
              color: Colors.white)),
    );

    List<Widget> children = [card];
    if (available > 0) {
      children.add(Positioned(top: -12.5, right: 0, child: badge));
    }

    return Stack(
      clipBehavior: Clip.none,
      children: children,
    );
  }
}

doNothing(a) {}

class ScrollingCalendar extends StatefulWidget {
  const ScrollingCalendar(
      {Key? key, required this.available, this.onChange = doNothing})
      : super(key: key);

  final Map<DateTime, int> available;
  final Function(DateTime) onChange;

  @override
  _ScrollingCalendarState createState() => _ScrollingCalendarState();
}

class _ScrollingCalendarState extends State<ScrollingCalendar> {
  DateTime? selectedDate;

  int currentMonth = 0;
  int currentYear = 0;

  Map<DateTime, int> available = {};
  List<DateTime> dates = [];
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    selectedDate = null;
    available = widget.available;

    final current = DateTime.now();
    currentMonth = current.month;
    currentYear = current.year;

    dates = generateMonth(current);

    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        if (mounted) {
          List<DateTime> newDates = generateMonth(
              DateUtils.addMonthsToMonthDate(
                  DateTime(currentYear, currentMonth, 1), 1));
          setState(() {
            dates = dates + newDates;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(getMonthName(currentMonth) + " " + currentYear.toString(),
            style: Theme.of(context).textTheme.headline4),
        const SizedBox(height: 8.0),
        SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            child: Container(
                margin: const EdgeInsets.only(top: 12.5),
                child: Row(
                    children: dates
                        .map((dt) => VisibilityDetector(
                              key: Key(dt.toString()),
                              onVisibilityChanged: (info) {
                                if (mounted) {
                                  setState(() {
                                    currentMonth = dt.month;
                                    currentYear = dt.year;
                                  });
                                }
                              },
                              child: InkWell(
                                onTap: () {
                                  if (available[dt] != null) {
                                    setState(() {
                                      selectedDate = dt;
                                    });
                                    widget.onChange(DateUtils.dateOnly(dt));
                                  }
                                },
                                child: ScrollingCalendarItem(
                                    date: dt,
                                    available: available[dt] ?? 0,
                                    selected: (selectedDate ??
                                            dt.add(const Duration(days: 1))) ==
                                        dt),
                              ),
                            ))
                        .toList()))),
      ],
    );
  }
}
