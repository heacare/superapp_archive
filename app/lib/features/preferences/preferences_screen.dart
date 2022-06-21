import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart' show PackageInfo;
import 'package:provider/provider.dart' show Provider;

import '../../system/url_launcher.dart' show launchUrl, LaunchMode;
import 'preferences.dart';
import 'preferences_widgets.dart';

class PreferencesPage extends StatelessWidget {
  const PreferencesPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          centerTitle: true,
        ),
        body: const PreferencesScreen(),
      );
}

class PreferencesScreen extends StatelessWidget {
  const PreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> items = _buildGroups(context);
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        child: ListView.separated(
          padding: MediaQuery.of(context)
              .padding
              .add(const EdgeInsets.only(bottom: 16)),
          itemCount: items.length,
          itemBuilder: (context, index) => items[index],
          separatorBuilder: (context, index) => const SizedBox(height: 8),
        ),
      ),
    );
  }

  List<Widget> _buildGroups(BuildContext context) {
    Preferences preferences = Provider.of<Preferences>(context);

    return [
      PreferenceGroup(
        title: 'Display',
        items: [
          PreferenceChoice<ThemeMode>(
            label: 'Theme',
            choices: _themeModeChoices,
            value: preferences.themeMode,
            onChanged: (value) {
              preferences.setThemeMode(value);
            },
          ),
          if (kDebugMode)
            PreferenceSwitch(
              label: 'Force RTL',
              value: preferences.forceRTL,
              onChanged: (value) {
                preferences.setForceRTL(value);
              },
            ),
        ],
      ),
      PreferenceGroup(
        title: 'Privacy',
        items: [
          PreferenceSwitch(
            label: 'Data collection',
            description:
                'We make extensive use of your data to allow our HEAlers to guide you through your journey',
            value: preferences.consentTelemetryInterim,
            onChanged: (value) {
              preferences.setConsentTelemetryInterim(value);
            },
          ),
          PreferenceInfo(
            label: 'Privacy policy',
            onTap: () async {
              await launchUrl(_privacyPolicyUrl, context: context);
            },
          ),
        ],
      ),
      PreferenceGroup(
        title: 'About',
        items: [
          PreferenceInfo(
            label: 'Feedback',
            value: _feedbackEmail,
            onTap: () async {
              await launchUrl(
                _feedbackUrl,
                mode: LaunchMode.externalNonBrowserApplication,
              );
            },
            onLongPress: () async {
              var data = const ClipboardData(text: _feedbackEmail);
              await Clipboard.setData(data);
            },
          ),
          PreferenceInfo(
            label: 'Source code',
            onTap: () async {
              await launchUrl(_sourceUrl, context: context);
            },
          ),
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              String version = 'Loading';
              if (snapshot.data != null) {
                version =
                    '${snapshot.data!.version}+${snapshot.data!.buildNumber}';
              }
              return PreferenceInfo(
                label: 'Version',
                value: version,
              );
            },
          ),
          PreferenceInfo(
            label: 'Open-source licenses',
            onTap: () async {
              showLicensePage(context: context);
            },
          ),
        ],
      ),
    ];
  }
}

const List<PreferenceChoiceItem<ThemeMode>> _themeModeChoices = [
  PreferenceChoiceItem(
    value: ThemeMode.system,
    label: 'System',
  ),
  PreferenceChoiceItem(
    value: ThemeMode.light,
    label: 'Light',
  ),
  PreferenceChoiceItem(
    value: ThemeMode.dark,
    label: 'Dark',
  ),
];

final Uri _privacyPolicyUrl = Uri.parse('https://hea.care/privacy');
final Uri _sourceUrl = Uri.parse('https://github.com/heacare/hea');
//final Uri _websiteUrl = Uri.parse('https://hea.care');
const String _feedbackEmail = 'hello@hea.care';
final Uri _feedbackUrl = Uri.parse('mailto:$_feedbackEmail');
