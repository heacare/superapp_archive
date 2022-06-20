import 'package:flutter/material.dart';

import 'package:qr_flutter/qr_flutter.dart' show QrImage;

class QrCode extends StatelessWidget {
  const QrCode(this.data, {super.key});

  final String data;

  @override
  Widget build(BuildContext context) => FittedBox(
        child: SizedBox(
          width: 360,
          height: 360,
          child: QrImage(
            foregroundColor: Theme.of(context).colorScheme.onBackground,
            data: data,
          ),
        ),
      );
}

class QrCodeDialog extends StatelessWidget {
  const QrCodeDialog({super.key, this.data, this.child});

  final String? data;
  final Widget? child;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
        // TODO(serverwentdown): Can we limit the height of the widget to be
        // the height of the QR code + the height of the child
        constraints: const BoxConstraints(maxHeight: 340),
        child: Column(
          children: [
            if (data != null)
              Expanded(
                child: QrCode(data!),
              ),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: child,
            ),
          ],
        ),
      );
}
