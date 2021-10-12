import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

const svgAssetName = "assets/svg/error.svg";

class ErrorDisplay extends StatelessWidget {

  const ErrorDisplay({Key? key}) :
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                  child: SvgPicture.asset(svgAssetName)
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Oops!", style: Theme.of(context).textTheme.headline1),
                    Text("Something broke along the way", style: Theme.of(context).textTheme.headline2)
                  ]
                )
              )
            ],
          )
        )
      )
    );
  }

}