import 'package:flutter/foundation.dart';

void licensesInitialize() {
  LicenseRegistry.addLicense(() => Stream<LicenseEntry>.value(
        const LicenseEntryWithLineBreaks(
          ['health', 'wallet_connect'],
          '''
Includes changes made by Happily Ever After''',
        ),
      ),);
}
