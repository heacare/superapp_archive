import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';

import 'package:provider/provider.dart' show Provider;

import '../../navigator.dart' show ForceRTL;
import '../../widgets/list_tile_centered.dart';
import 'preferences.dart';

class PreferencesPage extends StatelessWidget {
  const PreferencesPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          centerTitle: true,
        ),
        body: const Align(
          alignment: AlignmentDirectional.topCenter,
          child: PreferencesScreen(),
        ),
      );
}

class PreferencesScreen extends StatelessWidget {
  const PreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) => Container(
        constraints: const BoxConstraints.expand(width: 640),
        child: Column(
          children: _buildGroups(context),
        ),
      );

  List<Widget> _buildGroups(BuildContext context) {
    Preferences preferences = Provider.of<Preferences>(context);

    return [
      _Group(
        title: 'Display',
        items: [
          _Choice<ThemeMode>(
            label: 'Theme',
            choices: _themeModeChoices,
            value: preferences.themeMode,
            onChanged: (value) {
              preferences.setThemeMode(value);
            },
          ),
          if (kDebugMode)
            _Switch(
              label: 'Force RTL',
              value: preferences.forceRTL,
              onChanged: (value) {
                preferences.setForceRTL(value);
              },
            ),
        ],
      ),
      _Group(
        title: 'Privacy',
        items: [
          _Switch(
            label: 'Data collection',
            description:
                'We make extensive use of your data to allow our HEAlers to guide you through your journey',
            value: preferences.consentTelemetryInterim,
            onChanged: (value) {
              preferences.setConsentTelemetryInterim(value);
            },
          ),
        ],
      ),
    ];
  }
}

class _Group extends StatelessWidget {
  const _Group({required this.title, required this.items});

  final String title;
  final List<Widget> items;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
              ),
            ],
          ),
          Card(
            clipBehavior: Clip.antiAlias,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) => items[index],
              separatorBuilder: (context, index) =>
                  const Divider(indent: 16, endIndent: 16, height: 0),
            ),
          ),
        ],
      );
}

class _ItemTemplate extends StatelessWidget {
  const _ItemTemplate({
    required this.label,
    this.description,
    required this.child,
    this.onTap,
  });

  final String label;
  final String? description;
  final Widget child;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) => ListTileCentered(
        onTap: onTap,
        title: Text(label),
        subtitle: description == null ? null : Text(description!),
        trailing: child,
        minVerticalPadding: 16,
      );
}

class _Switch extends StatelessWidget {
  const _Switch({
    required this.label,
    this.description,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final String? description;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => _ItemTemplate(
        label: label,
        description: description,
        child: Switch.adaptive(
          value: value,
          onChanged: onChanged,
        ),
        onTap: () {
          onChanged(!value);
        },
      );
}

class _Choice<T> extends StatelessWidget {
  const _Choice({
    required this.label,
    this.description,
    required this.choices,
    required this.value,
    required this.onChanged,
  }) : assert(choices.length > 0);

  final String label;
  final String? description;
  final List<_ChoiceItem<T>> choices;
  final T value;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    _ChoiceItem<T> selected = choices.firstWhere(
      (choice) => choice.value == value,
      orElse: () => choices[0],
    );

    return _ItemTemplate(
      label: label,
      description: description,
      child: Text(selected.label, style: Theme.of(context).textTheme.bodyLarge),
      onTap: () async {
        T? value = await showModalBottomSheet<T?>(
          context: context,
          builder: (context) => ForceRTL(
            _ChoiceModal<T>(
              label: label,
              choices: choices,
              selected: selected,
            ),
          ),
        );
        if (value != null) {
          onChanged(value);
        }
      },
    );
  }
}

class _ChoiceModal<T> extends StatefulWidget {
  const _ChoiceModal({
    required this.label,
    required this.choices,
    required this.selected,
  });

  final String label;
  final List<_ChoiceItem<T>> choices;
  final _ChoiceItem<T> selected;

  @override
  State<_ChoiceModal<T>> createState() => _ChoiceModalState<T>();
}

class _ChoiceModalState<T> extends State<_ChoiceModal<T>> {
  T? value;

  @override
  void initState() {
    super.initState();
    value = widget.selected.value;
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Row(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Text(
                  widget.label,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: widget.choices.length,
              itemBuilder: _buildListItem,
              separatorBuilder: (context, index) =>
                  const Divider(indent: 64, endIndent: 16, height: 0),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
              ),
            ],
          ),
        ],
      );

  Widget _buildListItem(BuildContext context, int index) {
    _ChoiceItem choice = widget.choices[index];

    return ListTileCentered(
      title: Text(choice.label),
      leading: Radio<T>(
        value: choice.value,
        groupValue: value,
        onChanged: (newValue) {
          setState(() {
            value = newValue as T;
          });
          Navigator.of(context).pop(value);
        },
      ),
      minVerticalPadding: 16,
    );
  }
}

class _ChoiceItem<T> {
  const _ChoiceItem({required this.value, required this.label});

  final T value;
  final String label;
}

const List<_ChoiceItem<ThemeMode>> _themeModeChoices = [
  _ChoiceItem(
    value: ThemeMode.system,
    label: 'System',
  ),
  _ChoiceItem(
    value: ThemeMode.light,
    label: 'Light',
  ),
  _ChoiceItem(
    value: ThemeMode.dark,
    label: 'Dark',
  ),
];
