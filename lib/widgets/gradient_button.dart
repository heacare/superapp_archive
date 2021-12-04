import 'package:flutter/material.dart';

const USER_ICON_DEFAULT = "https://kbowlingclub.com/wp-content/plugins/all-in-one-seo-pack/images/default-user-image.png";

class GradientButton extends StatelessWidget {
  GradientButton({Key? key, required this.text, this.onPressed}) : super(key: key);

  String? text;
  VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final text = (this.text?.isNotEmpty ?? false) ? this.text! : "";
    return SizedBox (
      height: 50.0,
      child: ElevatedButton (
        onPressed: this.onPressed,
        child: Ink (
          decoration: BoxDecoration (
            gradient: LinearGradient (
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [ Theme.of(context).colorScheme.secondary, Theme.of(context).colorScheme.primary ],
            ),
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
          child: Container (
              constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0),
              alignment: Alignment.center,
              child: Text(
                text,
                style: TextStyle(fontFamily: "Poppins", fontSize: 20.0, fontWeight: FontWeight.bold, height: 1.5, color: Colors.white),
                textAlign: TextAlign.center
              ),
          ),
        )
      )
    );
  }
}
