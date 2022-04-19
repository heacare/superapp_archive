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
        .map((entry) => Container(
            margin: const EdgeInsets.all(10.0),
            alignment: Alignment.center,
            width: 72.0,
            height: 30.0,
            decoration: BoxDecoration(
              color: selected == entry.key
                  ? const Color(0xFF5FD0F9)
                  : Colors.grey[300],
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            ),
            child: InkWell(
                onTap: () {
                  setState(() {
                    selected = entry.key;
                  });
                  widget.onChange(entry.key);
                },
                child: Text(entry.value,
                    style: Theme.of(context).textTheme.bodyText2))))
        .toList();

    return Wrap(children: children);
  }
}
