import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants.dart';
import '../../providers/theme_provider.dart';

import '../../widgets/scrollable_layout.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final themeNotifier = ref.watch(themeNotifierProvider);
    final isDark = themeNotifier.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(),
      body: ScrollableLayout(
        maxWidth: 400,
        children: [
          Center(
            child: Text(
              AppStrings.settings,
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          Center(
            child: ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                SwitchListTile(
                  title: const Text(AppStrings.darkMode),
                  value: isDark,
                  onChanged: (value) {
                    ref.read(themeNotifierProvider.notifier).toggleTheme(value);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
