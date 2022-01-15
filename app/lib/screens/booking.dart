import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:hea/models/healer.dart';
import 'package:hea/widgets/gradient_button.dart';
import 'package:hea/widgets/pill_select.dart';
import 'package:hea/widgets/scrolling_calendar.dart';

List<DateTime> getDates(DateTimeRange range) {
  DateTime start = DateTime(range.start.year, range.start.month, range.start.day, range.start.hour);
  DateTime end = DateTime(range.end.year, range.end.month, range.end.day, range.end.hour);

  List<DateTime> res = [];
  for(DateTime dt = start; !dt.isAfter(end); dt = dt.add(Duration(hours: 1))) {
    res.add(dt);
  }

  return res;
}

class BookingScreen extends StatefulWidget {
  BookingScreen({Key? key, required this.name, required this.healer}) : super(key: key);

  String name;
  Healer healer;

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  _BookingScreenState();
  DateTime? selectedDate;
  DateTime? selectedTime;

  @override
  void initState() {
    selectedDate = null;
    selectedTime = null;
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height - padding.top - padding.bottom;

    final Map<DateTime, int> availabilities = widget.healer.availabilities
      .map((availability) => getDates(availability.range))
      .expand((i) => i)
      .fold(Map<DateTime, int>(), (Map<DateTime, int> acc, DateTime dt) {
        DateTime k = DateUtils.dateOnly(dt);
        if (acc[k] != null) {
          acc[k] = acc[k]! + 1;
        } else  {
          acc[k] = 0;
        }

        return acc;
      });

    List<Widget> formStack = [
      Text("Book an appointment",
          style: Theme.of(context).textTheme.headline2),
      Text("Pick a time and date for your <> appointment", // TODO appointment type
          style: Theme.of(context).textTheme.headline4),
      const SizedBox(height: 24.0),
      ScrollingCalendar(available: availabilities, onChange: (DateTime dt) {
        setState(() { selectedDate = dt; });
      }),
      const SizedBox(height: 24.0),
    ];

    if (selectedDate != null) {
      final Map<DateTime, String> times = widget.healer.availabilities
        .map((availability) => getDates(availability.range))
        .expand((i) => i)
        .where((availability) => DateUtils.isSameDay(availability, selectedDate!))
        .fold(Map<DateTime, String>(), (Map<DateTime, String> acc, DateTime val) {
          acc[val] = val.hour.toString().padLeft(2, '0') + ':' + val.minute.toString().padLeft(2, '0');
          return acc;
        });

      formStack = formStack + [
        Text("Available Timeslots",
            style: Theme.of(context).textTheme.headline3),
        PillSelect(items: times, onChange: (DateTime dt) {
          setState((){ selectedTime = dt; });
        }),
        const SizedBox(height: 24.0),
      ];
    }

    Widget button;
    if (selectedTime == null) {
      button = GradientButton(
        text: "BOOK APPOINTMENT",
        firstColor: Colors.grey[500],
        secondColor: Colors.grey[600],
      );
    } else {
      button = GradientButton(
        text: "BOOK APPOINTMENT",
        onPressed: () {
          Navigator.pop(context, selectedTime);
        },
      );
    }

    formStack = formStack + [
      Text("Note that any bookings on this day are in person, and you have to visit the location of the provider.",
          style: Theme.of(context).textTheme.bodyText1),
      const SizedBox(height: 24.0),
      button,
      const SizedBox(height: 24.0),
    ];

    return Scaffold(
      body: SafeArea(child: Stack (
        children: [
          Positioned(
            top: 0,
            child: Container ( // TODO remove hardcode
              width: width,
              height: height * 0.35,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF00ABE9), Color(0xFF7FDDFF)],
                )),
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 5),
              margin: EdgeInsets.only(bottom: height * (0.35 + 0.85 - 1)),
              child: FaIcon(FontAwesomeIcons.solidMoon, color: Color(0x6CFFFFFF), size: 150.0),
          )),
          Positioned (
            bottom: 0,
            child: Container (
              width: width,
              height: height * 0.7,
              padding: const EdgeInsets.all(30.0),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
                color: Colors.grey[200]))),
          Positioned(
            top: height * 0.2,
            left: width * 0.05,
            child: Container(
              width: width * 0.9,
              height: height * 0.85,
              child: Column (
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container (
                  width: width * 0.9,
                  padding: const EdgeInsets.all(30.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[400]!,
                        blurRadius: 7,
                        offset: Offset(3, 2),
                      )
                  ]),
                  child: Column (
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container (
                        margin: const EdgeInsets.only(bottom: 10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container (
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.grey[400],
                                borderRadius: const BorderRadius.all(Radius.circular(10.0)))),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Column (
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: width * 0.9 - 30 * 2 - 50 - 10 * 2,
                                    child: Row (
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Expanded(child: Text(widget.name,
                                        style: Theme.of(context).textTheme.headline2)),
                                      Container( // TODO replace with badge
                                        width: 60.0,
                                        height: 25.0,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [Color(0xFF00ABE9), Color(0xFF7FDDFF)],
                                          ),
                                          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(widget.healer.proficiencies[0].name,
                                          style: const TextStyle(
                                            fontFamily: "Poppins",
                                            letterSpacing: 1.0,
                                            fontSize: 12.0,
                                            fontWeight: FontWeight.w500,
                                            height: 1.5,
                                            color: Colors.white))),
                                    ]
                                  )),
                                  Text(widget.healer.name,
                                    style: Theme.of(context).textTheme.bodyText2)
                                ]
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(widget.healer.description,
                        style: Theme.of(context).textTheme.bodyText2)
                    ]
                  ),
                ),
                const SizedBox(height: 24.0),
                Expanded(child: ListView(children: formStack)),
              ]
            ))
          ),
          Positioned(
            top: 5,
            left: 0,
            child: InkWell (
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.all(10.0),
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 45.0)))),
        ],
      )),
    );
  }
}
