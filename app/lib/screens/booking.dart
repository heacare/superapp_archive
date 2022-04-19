import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:hea/models/healer.dart';
import 'package:hea/widgets/gradient_button.dart';
import 'package:hea/widgets/pill_select.dart';
import 'package:hea/widgets/scrolling_calendar.dart';
import 'package:hea/widgets/healer_card.dart';
import 'package:hea/services/service_locator.dart';
import 'package:hea/services/healer_service.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({Key? key, required this.name, required this.healer})
      : super(key: key);

  final String name;
  final Healer healer;

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  _BookingScreenState();
  DateTime? selectedDate;
  DateTime? selectedTime;

  @override
  void initState() {
    super.initState();
    selectedDate = null;
    selectedTime = null;
  }

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.of(context).padding;
    final width = MediaQuery.of(context).size.width;
    final height =
        MediaQuery.of(context).size.height - padding.top - padding.bottom;

    final Map<DateTime, int> availabilities = widget.healer.availabilities
        .map((availability) => availability.range.start)
        .fold(<DateTime, int>{}, (Map<DateTime, int> acc, DateTime dt) {
      DateTime k = DateUtils.dateOnly(dt);
      if (acc[k] != null) {
        acc[k] = acc[k]! + 1;
      } else {
        acc[k] = 1;
      }

      return acc;
    });

    List<Widget> formStack = [
      Text("Book an appointment", style: Theme.of(context).textTheme.headline2),
      const SizedBox(height: 8.0),
      Text("Pick a time and date for your appointment",
          style: Theme.of(context).textTheme.headline4),
      const SizedBox(height: 24.0),
      ScrollingCalendar(
          available: availabilities,
          onChange: (DateTime dt) {
            setState(() {
              selectedDate = dt;
            });
          }),
      const SizedBox(height: 24.0),
    ];

    if (selectedDate != null) {
      final Map<DateTime, String> times = widget.healer.availabilities
          .map((availability) => availability.range.start)
          .where((availability) =>
              DateUtils.isSameDay(availability, selectedDate!))
          .fold(<DateTime, String>{},
              (Map<DateTime, String> acc, DateTime val) {
        acc[val] = val.hour.toString().padLeft(2, '0') +
            ':' +
            val.minute.toString().padLeft(2, '0');
        return acc;
      });

      formStack = formStack +
          [
            Text("Available Timeslots",
                style: Theme.of(context).textTheme.headline3),
            PillSelect(
                items: times,
                onChange: (DateTime dt) {
                  setState(() {
                    selectedTime = dt;
                  });
                }),
            const SizedBox(height: 24.0),
          ];
    }

    Widget button;
    if (selectedTime == null) {
      button = GradientButton(
        text: "BOOK APPOINTMENT",
        firstColor: Colors.grey[300],
        secondColor: Colors.grey[300],
      );
    } else {
      button = GradientButton(
        text: "BOOK APPOINTMENT",
        onPressed: () async {
          var dtr = DateTimeRange(
              start: selectedTime!,
              end: selectedTime!.add(const Duration(hours: 1)));
          var slot = Availability(range: dtr, isHouseVisit: true);
          await serviceLocator<HealerService>().bookHealerAvailability(slot);
        },
      );
    }

    formStack = formStack +
        [
          Text(
              "Note that any bookings on this day are in person, and you have to visit the location of the provider.",
              style: Theme.of(context).textTheme.bodyText2),
          const SizedBox(height: 24.0),
          button,
          const SizedBox(height: 24.0),
        ];

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
              top: 0,
              child: Container(
                // TODO remove hardcode
                width: width,
                height: height * 0.3,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF00ABE9), Color(0xFF7FDDFF)],
                )),
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 5),
                margin: EdgeInsets.only(bottom: height * (0.35 + 0.85 - 1)),
                child: const FaIcon(FontAwesomeIcons.solidMoon,
                    color: Color(0x6CFFFFFF), size: 150.0),
              )),
          Positioned(
              bottom: 0,
              child: Container(
                  width: width,
                  height: height * 0.83,
                  padding: const EdgeInsets.all(30.0),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0)),
                      color: Colors.white))),
          Positioned(
              top: height * 0.2,
              left: width * 0.05,
              child: SizedBox(
                  width: width * 0.9,
                  height: height * 0.85,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        HealerCard(healer: widget.healer),
                        const SizedBox(height: 24.0),
                        Expanded(
                            child: ListView(
                                padding: const EdgeInsets.all(0.0),
                                children: formStack)),
                      ]))),
          Positioned(
              top: 5,
              left: 0,
              child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: SafeArea(
                      child: Container(
                          margin: const EdgeInsets.only(left: 10.0),
                          child: const Icon(Icons.arrow_back,
                              color: Colors.white, size: 45.0))))),
        ],
      ),
    );
  }
}
