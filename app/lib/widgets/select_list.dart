import 'package:flutter/material.dart';

class SelectListItem<T> {
  SelectListItem(
      {required this.text,
      required this.value,
      this.other = false,
      this.otherMultiple = false});

  String text;
  T value;
  bool other;
  bool otherMultiple; // requires other to be true
}

typedef SelectListOnChange<T> = void Function(List<T>);
typedef SelectListOtherOnChange<T> = void Function(String);

class SelectList<T> extends StatefulWidget {
  const SelectList(
      {Key? key,
      required this.items,
      this.defaultSelected = const [],
      this.max = 1,
      required this.onChange,
      this.defaultOther,
      this.onChangeOther})
      : super(key: key);

  final List<SelectListItem<T>> items;
  final List<T> defaultSelected;
  final int max;
  final SelectListOnChange<T> onChange;
  final String? defaultOther;
  final SelectListOtherOnChange<T>? onChangeOther;

  @override
  SelectListState<T> createState() => SelectListState<T>();
}

class SelectListState<T> extends State<SelectList<T>> {
  List<T> selected = [];
  List<T> values = [];

  @override
  void initState() {
    super.initState();
    values = widget.items.map((item) => item.value).toList();
    debugPrint(widget.defaultSelected.toString());
// If there's no "other" option, drop the other values
    selected = List<T>.from(
        widget.defaultSelected.where((sel) => values.contains(sel)));
  }

  Widget getButton(BuildContext context, bool select, SelectListItem<T> item) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          if (select) {
            selected.remove(item.value);
            if (item.other && widget.onChangeOther != null) {
              widget.onChangeOther!("");
            }
          } else {
            selected.add(item.value);
            while (widget.max != 0 && selected.length > widget.max) {
              selected.removeAt(0);
            }
          }
        });
        widget.onChange(selected);
      },
      style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
          primary: Colors.black,
          backgroundColor: select
              ? Theme.of(context).colorScheme.primary.withAlpha(0x50)
              : const Color(0xFFEBEBEB),
          elevation: 0.0),
      child: Text(item.text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: select
                ? Theme.of(context).colorScheme.primary
                : const Color(0xFF414141),
            fontSize: 18.0,
          )),
    );
  }

  Widget getOther(BuildContext context, SelectListItem<T> item) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      const SizedBox(height: 11.0),
      TextFormField(
          decoration:
              const InputDecoration(labelText: "Type your own choice here"),
          initialValue: widget.defaultOther,
          onChanged: (String value) {
            if (widget.onChangeOther != null) {
              widget.onChangeOther!(value);
            }
          }),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> buttons = widget.items
        .map((item) {
          bool select = selected.contains(item.value);
          Widget button = getButton(context, select, item);
          return [
            button,
            if (select && item.other) getOther(context, item),
            const SizedBox(height: 11.0),
          ];
        })
        .expand((i) => i)
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: buttons,
    );
  }
}
