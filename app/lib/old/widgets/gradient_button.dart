import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  const GradientButton(
      {Key? key,
      required this.text,
      this.onPressed,
      this.firstColor,
      this.secondColor,
      this.noGradient = false})
      : super(key: key);

  final String text;
  final VoidCallback? onPressed;
  final bool noGradient;

  final Color? firstColor;
  final Color? secondColor;

  @override
  Widget build(BuildContext context) {
    final a = firstColor ?? Theme.of(context).colorScheme.secondary;
    final b = secondColor ?? Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          gradient: noGradient
              ? null
              : LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [a, b],
                ),
          color: noGradient ? const Color(0xFFEBEBEB) : null,
          borderRadius: const BorderRadius.all(Radius.circular(15.0)),
        ),
        child: Text(text.toUpperCase(),
            style: TextStyle(
                fontFamily: "Poppins",
                letterSpacing: 1.0,
                fontSize: 20.0,
                fontWeight: FontWeight.w600,
                height: 1.5,
                color: noGradient ? Colors.black : Colors.white),
            textAlign: TextAlign.center),
      ),
    );
  }
}
