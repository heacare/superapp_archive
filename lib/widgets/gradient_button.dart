import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  GradientButton({Key? key, required this.text, this.onPressed})
      : super(key: key);

  String? text;
  VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final text = (this.text?.isNotEmpty ?? false) ? this.text! : "";
    return SizedBox(
        height: 50.0,
        child: ElevatedButton(
            onPressed: this.onPressed,
            child: Ink(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.secondary,
                    Theme.of(context).colorScheme.primary
                  ],
                ),
                borderRadius: const BorderRadius.all(Radius.circular(15.0)),
              ),
              child: Container(
                constraints:
                    const BoxConstraints(minWidth: 88.0, minHeight: 36.0),
                alignment: Alignment.center,
                child: Text(text,
                    style: const TextStyle(
                        fontFamily: "Poppins",
                        letterSpacing: 1.0,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                        height: 1.5,
                        color: Colors.white),
                    textAlign: TextAlign.center),
              ),
            )));
  }
}
