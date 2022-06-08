import 'package:flutter/material.dart';

class PreferencesPage extends StatelessWidget {
  const PreferencesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
      ),
      body: const PreferencesScreen(),
    );
  }
}

class PreferencesScreen extends StatelessWidget {
  const PreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Group(
          title: "Display",
          items: [
            _Switch(
              label: MaterialLocalizations.of(context)
                  .formatCompactDate(DateTime.now()),
              value: true,
              onChanged: (bool value) {},
            )
          ],
        ),
      ],
    );
  }
}

class _Group extends StatelessWidget {
  const _Group({required this.title, required this.items});

  final String title;
  final List<Widget> items;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        children: [Text(title, style: Theme.of(context).textTheme.titleSmall)],
      ),
      ...items,
    ]);
  }
}

class _Switch extends StatelessWidget {
  const _Switch(
      {required this.label,
      this.description,
      required this.value,
      required this.onChanged});

  final String label;
  final String? description;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.bodyLarge),
              if (description != null)
                Text(description!,
                    style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
