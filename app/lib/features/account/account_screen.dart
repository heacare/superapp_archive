import 'package:flutter/material.dart';

import '../../main.dart' show compat;
import '../../old/screens/profile.dart' as old;
import '../../widgets/screen.dart' show Screen;
import 'account_overview_widget.dart' show AccountOverview;
import 'wallet_overview_widget.dart' show WalletOverview;

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(final BuildContext context) => const Screen(
        children: [
          AccountOverview(),
          WalletOverview(),
          if (compat != 'disabled') SizedBox(height: 32),
          if (compat != 'disabled')
            Padding(
              padding: EdgeInsets.all(16),
              child: old.ProfileScreen(disableScaffold: true),
            ),
        ],
      );
}
