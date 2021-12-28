import 'package:flutter/material.dart';
import 'package:hea/widgets/gradient_button.dart';

class SelectListItem {
  SelectListItem({ required this.text, required this.value });

  String text;
  String value;
}

class SelectList extends StatefulWidget {
  SelectList({Key? key, required this.items, required this.onChange})
      : super(key: key);

  List<SelectListItem> items;
  Function onChange;

  @override
  SelectListState createState() => SelectListState();
}

class SelectListState extends State<SelectList> {
  String selected = "";

  @override
  void initState() {
    widget.items = widget.items.toSet().toList(); // Deduplicate
    selected = widget.items[0].value;
  }

  Widget getButton(SelectListItem item) {
    if (item.value == selected) {
      return GradientButton(
        text: item.text,
        onPressed: () {
          setState(() { selected = item.value; });
          widget.onChange(selected);
        },
      );
    } else {
      return SizedBox(
        height: 50.0,
        child: ElevatedButton(
          child: Text(item.text),
          onPressed: () {
            setState(() { selected = item.value; });
            widget.onChange(selected);
          },
          style: TextButton.styleFrom(
              primary: Colors.black,
              backgroundColor: Colors.grey[100],
              elevation: 0.0),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> buttons = widget.items.map((item) {
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
