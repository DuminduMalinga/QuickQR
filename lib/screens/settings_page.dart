import 'package:flutter/material.dart';

import '../models/app_settings.dart';
import '../widgets/responsive.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ResponsiveList(
        vertical: 8,
        minHorizontal: 0,
        children: [
          ValueListenableBuilder<ThemeMode>(
            valueListenable: themeMode,
            builder: (context, mode, _) => SwitchListTile(
              secondary: const Icon(Icons.dark_mode_outlined),
              title: const Text('Dark theme'),
              value: mode == ThemeMode.dark,
              onChanged: (on) =>
                  themeMode.value = on ? ThemeMode.dark : ThemeMode.light,
            ),
          ),
          ValueListenableBuilder<bool>(
            valueListenable: saveHistory,
            builder: (context, on, _) => SwitchListTile(
              secondary: const Icon(Icons.history_rounded),
              title: const Text('Save generated codes'),
              subtitle: const Text('Keep new codes in your history'),
              value: on,
              onChanged: (v) => saveHistory.value = v,
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline_rounded),
            title: const Text('About QuickQr'),
            onTap: () => showAboutDialog(
              context: context,
              applicationName: 'QuickQr',
              applicationVersion: '1.0.0',
              children: const [Text('Create, save and share QR codes.')],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy'),
            onTap: () => showDialog<void>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Privacy'),
                content: const Text(
                  'QuickQr works on your device. The text you encode is not '
                  'uploaded or collected.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
