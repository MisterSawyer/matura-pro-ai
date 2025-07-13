import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme.dart';
import '../providers/theme_provider.dart';

import '../routes/app_routes.dart';
import '../views/login/login_page.dart';
import '../views/home/home_page.dart';
import '../views/account/account_page.dart';
import '../views/placement_test/placement_test_loader_page.dart';
import '../views/stats/user_statistics_page.dart';
import '../views/flashcards/flashcard_category_selection_page.dart';
import '../views/settings/settings_page.dart';
import '../views/raindrop/raindrop_page.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.watch(themeNotifierProvider);
    final themeMode = themeNotifier.themeMode;

    return MaterialApp(
      title: 'Matura Pro AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      initialRoute: AppRoutes.login,
      routes: {
        AppRoutes.login: (context) => const LoginPage(),
        AppRoutes.home: (context) => const HomePage(),
        AppRoutes.account: (context) => const AccountPage(),
        AppRoutes.placementTest: (context) => const PlacementTestLoaderPage(),
        AppRoutes.stats: (context) => const UserStatisticsPage(),
        AppRoutes.flashcards: (context) => const FlashcardCategorySelectionPage(),
        AppRoutes.settings: (context) => const SettingsPage(),
        AppRoutes.raindrop: (context) => const RaindropPage(),
      },
    );
  }
}
