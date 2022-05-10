import 'package:flutter/material.dart';

doNothing(a) {}

class PillSelect<T> extends StatefulWidget {
  const PillSelect({Key? key, required this.items, this.onChange = doNothing})
      : super(key: key);

  final Map<T, String> items;
  final void Function(T) onChange;

  @override
  PillSelectState<T> createState() => PillSelectState<T>();
}

class PillSelectState<T> extends State<PillSelect<T>> {
  PillSelectState();

  Map<T, String> items = {};
  T? selected;

  @override
  void initState() {
    super.initState();
    items = widget.items;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = items.entries
        .map((entry) => ElevatedButton(
            onPressed: () {
              setState(() {
                selected = entry.key;
              });
              widget.onChange(entry.key);
            },
            style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 16.0),
                primary: Colors.black,
                backgroundColor: selected == entry.key
                    ? Theme.of(context).colorScheme.primary.withAlpha(0x50)
                    : const Color(0xFFEBEBEB),
                elevation: 0.0),
            child: Text(entry.value,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: selected == entry.key
                      ? Theme.of(context).colorScheme.primary
                      : const Color(0xFF414141),
                  fontSize: 18.0,
                ))))
        .toList();

    return Wrap(children: children, spacing: 8);
  }
}
