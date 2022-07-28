import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show LogicalKeyboardKey, RawKeyUpEvent;
import 'package:flutter_gen/gen_l10n/app_localizations.dart'
    show AppLocalizations;
import 'package:intl/intl.dart' show DateFormat;

class DatePickerFormField extends StatefulWidget {
  const DatePickerFormField({
    super.key,
    this.initialValue,
    required this.decoration,
    this.onSaved,
    this.validator,
    this.format = DateFormat.YEAR_NUM_MONTH_DAY,
    this.showHintText = false,
  });

  final DateTime? initialValue;
  final InputDecoration decoration;
  final FormFieldSetter<DateTime>? onSaved;
  final FormFieldValidator<DateTime>? validator;
  final String format;
  final bool showHintText;

  @override
  State<DatePickerFormField> createState() => _DatePickerFormFieldState();
}

class _DatePickerFormFieldState extends State<DatePickerFormField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  DateTime? _date;

  @override
  void initState() {
    super.initState();
    _date = widget.initialValue;
    _focusNode.onKey = (final FocusNode node, final RawKeyEvent event) {
      if (event is RawKeyUpEvent) {
        if (event.logicalKey == LogicalKeyboardKey.enter ||
            event.logicalKey == LogicalKeyboardKey.space) {
          _showDatePicker();
          return KeyEventResult.handled;
        }
      }
      return KeyEventResult.ignored;
    };
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateText();
  }

  void _updateText() {
    if (_date == null) {
      _controller.text = '';
      return;
    }
    final String locale = Localizations.localeOf(context).toLanguageTag();
    _controller.text = DateFormat(widget.format, locale).format(_date!);
  }

  Future<void> _showDatePicker() async {
    final DateTime now = DateTime.now();
    // Give the user a rough date in the past to start from
    DateTime initialDate = DateTime(now.year - 28);
    if (_date != null) {
      initialDate = _date!;
    }
    // Pick a reasonable date range to allow
    final DateTime firstDate = DateTime(now.year - 200);
    final DateTime lastDate = now;

    // Show the picker
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (date == null) {
      // The picker was cancelled
      return;
    }
    // Not calling setState because a rebuild is not needed, only an update to the TextFormField value
    _date = date;
    _updateText();
  }

  @override
  Widget build(final BuildContext context) {
    final String? hintText = _dateHint(context, widget.format);
    return TextFormField(
      controller: _controller,
      focusNode: _focusNode,
      decoration: widget.showHintText
          ? widget.decoration.copyWith(
              hintText: hintText,
            )
          : widget.decoration,
      keyboardType: TextInputType.none,
      readOnly: true,
      onTap: _showDatePicker,
      onSaved: (final String? value) => widget.onSaved?.call(_date),
      validator: (final String? value) => widget.validator?.call(_date),
    );
  }
}

String? _dateHint(final BuildContext context, final String format) {
  switch (format) {
    case 'yMd':
      return AppLocalizations.of(context)!.dateHintyMd;
  }
  return null;
}
