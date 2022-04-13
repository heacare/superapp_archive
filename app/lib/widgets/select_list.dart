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

typedef SelectListOnChange<T> = Function(List<T>);

class SelectList<T> extends StatefulWidget {
  SelectList(
      {Key? key,
      required this.items,
      this.defaultSelected = const [],
      this.max = 1,
      required this.onChange})
      : super(key: key);

  List<SelectListItem<T>> items;
  List<T> defaultSelected;
  int max;
  SelectListOnChange<T> onChange;

  @override
  SelectListState<T> createState() => SelectListState<T>();
}

class SelectListState<T> extends State<SelectList<T>> {
  List<T> selected = [];

  @override
  void initState() {
    super.initState();
    widget.items = widget.items.toSet().toList(); // Deduplicate
	List<T> values = widget.items.map((item) => item.value).toList();
    selected = widget.defaultSelected.where((sel) => values.contains(sel)).toList();
  }

  Widget getButton(SelectListItem item) {
    if (selected.contains(item.value)) {
      return ElevatedButton(
        child: Text(item.other ? "Other (TODO)" : item.text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Color(0xFFFF5576),
              fontSize: 20.0,
            )),
        onPressed: () {
          setState(() {
            selected.remove(item.value);
          });
          widget.onChange(selected);
        },
        style: TextButton.styleFrom(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
            primary: Colors.black,
            backgroundColor: Color(0x33FF587A),
            elevation: 0.0),
      );
    } else {
      return ElevatedButton(
        child: Text(item.text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Color(0xFF414141),
              fontSize: 20.0,
            )),
        onPressed: () {
          setState(() {
            selected.add(item.value);
            while (widget.max != 0 && selected.length > widget.max) {
              selected.removeAt(0);
            }
          });
          widget.onChange(selected);
        },
        style: TextButton.styleFrom(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
            primary: Colors.black,
            backgroundColor: Color(0xFFF5F5F5),
            elevation: 0.0),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> buttons = widget.items
        .map((item) {
          Widget button = getButton(item);
          return [
            button,
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
