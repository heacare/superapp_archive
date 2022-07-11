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
      themeMode: ThemeMode.light,
      theme: ThemeData.from(
        colorScheme: const ColorScheme.dark(),
        useMaterial3: true,
      ),
      home: FutureProvider<GradientProgram?>(
        initialData: null,
        create: (context) => loadGradientProgram(),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            title: Image.asset("assets/logo_white.png", height: 48),
            centerTitle: true,
          ),
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
    _controller = AnimationController(
        vsync: this, duration: const Duration(seconds: 120));
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("build");
    GradientProgram? program = Provider.of<GradientProgram?>(context);
    CustomPainter? painter;
    if (program != null) {
      painter = GradientPainter(
        program: program,
        animation: _controller,
      );
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
  GradientPainter(
      {required this.program, required this.animation, this.scale = 1.0})
      : super(repaint: animation);

  GradientProgram program;
  Animation<double> animation;
  double scale;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    double s = (1000 + size.width + size.height) / 1600 * scale;
    debugPrint("$s");
    paint.shader = program.main.shader(
      floatUniforms: Float32List.fromList([
        animation.value,
        s,
      ]),
    );
    canvas.drawPaint(paint);
  }

  @override
  bool shouldRepaint(GradientPainter oldDelegate) => false;
}
