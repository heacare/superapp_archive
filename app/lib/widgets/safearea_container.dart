import 'package:flutter/material.dart';

class SafeAreaContainer extends StatelessWidget {
  SafeAreaContainer({Key? key, @required this.child}) : super(key: key);

  Widget? child;

  @override
  Widget build(BuildContext context) {
    return SafeArea (
      child: LayoutBuilder (
        builder: (context, constraints) {
          return Scaffold (
            body: SingleChildScrollView (
              physics: const ClampingScrollPhysics(),
              child: SizedBox(
                height: constraints.biggest.height,
                child: Padding (
                  padding: const EdgeInsets.symmetric(horizontal: 37.0, vertical: 37.0),
                  child: this.child,
                )
              )
            )
          );
        }
      )
    );
  }
}
