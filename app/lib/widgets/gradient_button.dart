import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  const GradientButton(
      {Key? key,
      required this.text,
      this.onPressed,
      this.firstColor,
      this.secondColor})
      : super(key: key);

  final String text;
  final VoidCallback? onPressed;

  final Color? firstColor;
  final Color? secondColor;

  @override
  Widget build(BuildContext context) {
    final a = firstColor ?? Theme.of(context).colorScheme.secondary;
    final b = secondColor ?? Theme.of(context).colorScheme.primary;

    return SizedBox(
        height: 50.0,
        child: GestureDetector(
          onTap: onPressed,
          child: Container(
            constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [a, b],
              ),
              borderRadius: const BorderRadius.all(Radius.circular(15.0)),
            ),
            child: Text(text.toUpperCase(),
                style: const TextStyle(
                    fontFamily: "Poppins",
                    letterSpacing: 1.0,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                    color: Colors.white),
                textAlign: TextAlign.center),
          ),
        ));
  }
}
