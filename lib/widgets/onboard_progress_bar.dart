import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OnboardProgressBar extends StatefulWidget {
  final int numStages;

  OnboardProgressBar({Key? key, required this.numStages}) :
    super(key: key);

  @override
  State<StatefulWidget> createState() => OnboardProgressBarState();
}

class OnboardProgressBarState extends State<OnboardProgressBar>
    with SingleTickerProviderStateMixin {

  var _atStage = 0;
  var _percentage = 0.0;

  late AnimationController _controller;
  late Animation<double> _animation;
  late Tween<double> _tween;

  final _textKey = GlobalKey();

  nextStage() {
    _atStage++;

    _percentage = _atStage/widget.numStages;
    _tween.begin = _tween.end;
    _controller.reset();
    _tween.end = _percentage;
    _controller.forward();
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this
    );

    _tween = Tween(begin: _percentage, end: _percentage);
    _animation = _tween.animate(
      CurvedAnimation(
        curve: Curves.easeInOut,
        parent: _controller
      )
    );
  }

  @override
  Widget build(BuildContext context) {

    if (_percentage == 0) {
      return const SizedBox(height: 36.0);
    }

    return AnimatedBuilder(
      animation: _animation,
      builder: (BuildContext context, Widget? child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            LinearProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
              backgroundColor: Colors.transparent,
              minHeight: 36.0,
              value: _animation.value,
            ),
            Align(
              alignment: AlignmentGeometry.lerp(Alignment.centerLeft, Alignment.centerRight, _animation.value)!,
              child: FractionalTranslation(
                translation: Offset(_animation.value, 0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child:
                  Text(
                      (_percentage * 100).toStringAsFixed(0) + "%",
                      key: _textKey,
                      style: TextStyle(
                          height: 1.0,
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: Theme.of(context).textTheme.headline1!.fontFamily,
                          color: Theme.of(context).colorScheme.primary
                      )
                  )
                )
              )
            )
          ]
        );
      },
    );
  }
}
