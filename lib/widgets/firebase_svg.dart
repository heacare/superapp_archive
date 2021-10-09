import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hea/providers/storage.dart';

class FirebaseSvg {

  final String svgFilename;

  FirebaseSvg(this.svgFilename);

  load() {
    return FutureBuilder<String>(
      future: Storage().getFileUrl(svgFilename),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SizedBox(
            height: 64.0,
            width: 64.0,
            child: CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
              strokeWidth: 8
            )
          );
        }

        return SvgPicture.network(snapshot.data!);
      }
    );
  }


}