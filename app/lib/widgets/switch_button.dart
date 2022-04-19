import 'package:flutter/material.dart';

Color selectedColor = Colors.white;
Color nonselectedColor = Colors.black;

class SwitchButton extends StatefulWidget {
  SwitchButton({Key? key, this.selected = false, required this.onChange})
      : super(key: key);

  bool selected;
  Function onChange;

  @override
  SwitchButtonState createState() => SwitchButtonState();
}

class SwitchButtonState extends State<SwitchButton> {
  Color aColor = selectedColor;
  Color bColor = nonselectedColor;
  double xAlign = 1.0;

  @override
  void initState() {
    super.initState();

    xAlign = 1;
    aColor = selectedColor;
    bColor = nonselectedColor;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = 50.0;

    if (widget.selected) {
      xAlign = -1;
      aColor = selectedColor;
      bColor = nonselectedColor;
    } else {
      xAlign = 1;

      aColor = nonselectedColor;
      bColor = selectedColor;
    }

    BoxDecoration selectedDecoration = BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Theme.of(context).colorScheme.secondary,
          Theme.of(context).colorScheme.primary
        ],
      ),
      borderRadius: const BorderRadius.all(
        Radius.circular(15.0),
      ),
    );

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: const BorderRadius.all(Radius.circular(15.0)),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            alignment: Alignment(xAlign, 0),
            duration: const Duration(milliseconds: 300),
            child: Container(
              width: width * 0.5,
              height: height,
              decoration: selectedDecoration,
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                widget.selected = true;
                widget.onChange(widget.selected);
              });
            },
            child: Align(
              alignment: const Alignment(-1, 0),
              child: Container(
                width: width * 0.5,
                color: Colors.transparent,
                alignment: Alignment.center,
                child: Text(
                  'YES',
                  style: TextStyle(
                    color: aColor,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                widget.selected = false;
                widget.onChange(widget.selected);
              });
            },
            child: Align(
              alignment: const Alignment(1, 0),
              child: Container(
                width: width * 0.5,
                color: Colors.transparent,
                alignment: Alignment.center,
                child: Text(
                  'NO',
                  style: TextStyle(
                    color: bColor,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
