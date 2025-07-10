import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/theme_notifier.dart';
import '../../models/account.dart';

import '../../widgets/scrollable_layout.dart';

class SettingsPage extends StatelessWidget {
  final Account account;
  const SettingsPage({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final isDark = themeNotifier.themeMode == ThemeMode.dark;

    return Scaffold(
        appBar: AppBar(),
        body: ScrollableLayout(maxWidth: 400, children: [
          Center(
              child: Text("Ustawienia",
                  style: theme.textTheme.titleLarge,
                  textAlign: TextAlign.center)),
          const SizedBox(
            height: 32,
          ),
          Center(
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                SwitchListTile(
                  title: const Text("Dark Mode"),
                  value: isDark,
                  onChanged: (value) => themeNotifier.toggleTheme(value),
                ),
              ],
            ),
          ),
        ]));
  }
}
