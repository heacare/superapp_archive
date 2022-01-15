import 'package:flutter/material.dart';

void doNothing() {}

class PillSelect<T> extends StatefulWidget {
  PillSelect({Key? key, required this.items, this.onChange = doNothing}) : super(key: key);

  Map<T, String> items;
  Function onChange;

  @override
  PillSelectState<T> createState() => PillSelectState<T>(items: items);
}

class PillSelectState<T> extends State<PillSelect<T>> {
  PillSelectState({ required this.items });

  Map<T, String> items;
  T? selected;

  @override
  void initState() {
    super.initState();

    selected = null;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = items.entries.map((entry) => Container(
      margin: const EdgeInsets.all(10.0),
      alignment: Alignment.center,
      width: 72.0,
      height: 30.0,
      decoration: BoxDecoration(
        color: selected == entry.key ? Color(0xFF5FD0F9) : Colors.grey[300],
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
      ),
      child: InkWell (
        onTap: () {
          setState((){ selected = entry.key; });
          widget.onChange(entry.key);
        },
        child: Text(entry.value,
          style: Theme.of(context).textTheme.bodyText2))))
    .toList();

    return Wrap(children: children);
  }
}
