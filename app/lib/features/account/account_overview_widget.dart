import 'package:flutter/material.dart';
import 'package:provider/provider.dart' show Provider;

import '../../navigator.dart' show ForceRTL;
import '../../widgets/gradient.dart' show gradient;
import 'account.dart' show Account;
import 'edit_screen.dart' show EditPage;

Route _editRouteBuilder(context, arguments) => MaterialPageRoute(
      builder: (context) => const ForceRTL(EditPage()),
    );

class AccountOverview extends StatelessWidget {
  const AccountOverview({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    Account account = Provider.of<Account>(context);

    return Container(
      decoration: gradient(context),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            account.metadata.name ?? '',
            style: textTheme.titleLarge!.copyWith(
              color: colorScheme.onPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            child: const Text('Edit profile'),
            onPressed: () async {
              // TODO(serverwentdown): Consider using a dialog on larger screens
              Navigator.of(context).restorablePush(_editRouteBuilder);
            },
          ),
        ],
      ),
    );
  }
}