import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgLogo extends StatelessWidget {
  const SvgLogo({
    super.key,
    required this.assetName,
    required this.placeholder,
    required this.height,
    required this.aspectRatio,
    this.color,
  });

  final String assetName;
  final String placeholder;
  final double height;
  final double aspectRatio;
  final Color? color;

  @override
  Widget build(BuildContext context) => SvgPicture.asset(
        'assets/integrations/walletconnect-banner.svg',
        width: aspectRatio * height,
        height: height,
        color: color ?? Theme.of(context).colorScheme.onPrimary,
        placeholderBuilder: (context) => SizedBox(
          width: aspectRatio * height,
          height: height,
          child: Center(child: Text(placeholder)),
        ),
      );
}
