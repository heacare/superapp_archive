import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: FutureProvider<GradientProgram?>(
        initialData: null,
        create: (context) => loadGradientProgram(),
        child: Scaffold(
          body: GradientContainer(
            child: ListView.builder(
                itemCount: 100,
                itemBuilder: (_, int index) {
                  return ListTile(title: Text('item $index'));
                }),
          ),
        ),
      ),
    );
  }
}

class GradientContainer extends StatefulWidget {
  const GradientContainer({
    super.key,
    this.child,
  });

  final Widget? child;

  @override
  State<GradientContainer> createState() => _GradientContainerState();
}

class _GradientContainerState extends State<GradientContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 60));
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GradientProgram? program = Provider.of<GradientProgram?>(context);
    CustomPainter? painter;
    if (program != null) {
      painter = GradientPainter(program, _controller);
    }
    return CustomPaint(
      painter: painter,
      child: widget.child,
    );
  }
}

Future<GradientProgram> loadGradientProgram() async {
  var program = await rootBundle.load('assets/gradient.spv');
  return GradientProgram(
    await FragmentProgram.compile(
      spirv: program.buffer,
      debugPrint: true,
    ),
  );
}

class GradientProgram {
  const GradientProgram(this.main);
  final FragmentProgram main;
}

class GradientPainter extends CustomPainter {
  GradientPainter(this.program, this.t) : super(repaint: t);

  GradientProgram program;
  Animation<double> t;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.shader = program.main.shader(
      floatUniforms: Float32List.fromList([
        t.value,
      ]),
    );
    canvas.drawPaint(paint);
  }

  @override
  bool shouldRepaint(GradientPainter oldDelegate) => false;
}
