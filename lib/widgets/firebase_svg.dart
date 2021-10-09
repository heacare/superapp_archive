import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hea/providers/storage.dart';

class FirebaseSvg {

  final String svgFilename;
  final Future<SvgPicture> cachedSvg;

  FirebaseSvg(this.svgFilename) :
    cachedSvg = Future<SvgPicture>.value(
        Storage().getFileUrl(svgFilename).then((url) => SvgPicture.network(url))
    );

  Widget load() {
    return FutureBuilder<SvgPicture>(
      future: cachedSvg,
      builder: (context, snapshot) {
        Widget child;

        if (!snapshot.hasData) {
          child = SizedBox(
            height: 64.0,
            width: 64.0,
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
              strokeWidth: 8
            )
          );
        }
        else {
          child = snapshot.data!;
        }

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: child
        );
      }
    );
  }


}