import 'package:flutter/material.dart';

class IconGradientButton extends StatelessWidget {
  const IconGradientButton({
    Key? key,
    required this.title,
    required this.text,
    required this.icon,
    this.onPressed,
    this.firstColor,
    this.secondColor,
    this.iconColor,
  }) : super(key: key);

  final String? title;
  final String? text;
  final Widget? icon;
  final VoidCallback? onPressed;

  final Color? firstColor;
  final Color? secondColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final title = (this.title?.isNotEmpty ?? false) ? this.title! : "";
    final text = (this.text?.isNotEmpty ?? false) ? this.text! : "";

    final a = firstColor ?? Theme.of(context).colorScheme.secondary;
    final b = secondColor ?? Theme.of(context).colorScheme.primary;

    final iconColour = iconColor ?? Theme.of(context).colorScheme.primary;

    return ElevatedButton(
        onPressed: onPressed,
        child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [a, b],
              ),
              borderRadius: const BorderRadius.all(Radius.circular(15.0)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 50.0,
                    height: 50.0,
                    child: Ink(
                      decoration: BoxDecoration(
                        color: iconColour,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(11.0)),
                      ),
                      child: Center(child: icon!),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(left: 11.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3
                                  ?.copyWith(color: const Color(0xFFFFFFFF))),
                          Text(text,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2
                                  ?.copyWith(color: const Color(0xFFFFFFFF)))
                        ],
                      )),
                ],
              ),
            )));
  }
}
