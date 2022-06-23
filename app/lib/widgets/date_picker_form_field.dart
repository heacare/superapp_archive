import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

class DatePickerFormField extends StatefulWidget {
  DatePickerFormField(
      {super.key,
      this.initialValue,
      required this.decoration,
      required this.onSaved});

  final DateTime? initialValue;
  final InputDecoration decoration;
  final void Function(DateTime) onSaved;

  @override
  State<DatePickerFormField> createState() => _DatePickerFormFieldState();
}

class _DatePickerFormFieldState extends State<DatePickerFormField> {
  final TextEditingController _controller = TextEditingController();
  DateTime? _date = null;

  void setDate(DateTime? date) {
    _date = date;
    if (_date == null) {
      _controller.clear();
    } else {
      String locale = Localizations.localeOf(context).toLanguageTag();
      _controller.text = DateFormat.yMMMMd(locale).format(_date!);
    }
  }

  @override
  void initState() {
    super.initState();
    setDate(widget.initialValue);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      keyboardType: TextInputType.none,
      decoration: widget.decoration,
      readOnly: true,
      onTap: () async {
        DateTime now = DateTime.now();
        // Give the user a rough date in the past to start from
        DateTime initialDate = DateTime(now.year - 28);
        if (_date != null) {
          initialDate = _date!;
        }
        // Pick a reasonable date range to allow
        DateTime firstDate = DateTime(now.year - 200);
        DateTime lastDate = now;

        // Show the picker
        DateTime? date = await showDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: firstDate,
          lastDate: lastDate,
        );
        if (date != null) {
          setDate(date);
        }
      },
      onSaved: (value) {
        // Parse
      },
    );
  }
}
