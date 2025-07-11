import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../core/theme.dart';

import '../services/theme_notifier.dart';

import '../models/account.dart';

import '../routes/app_routes.dart';

import '../views/login/login_page.dart';
import '../views/home/home_page.dart';
import '../views/account/account_page.dart';
import '../views/placement_test/placement_test_loader_page.dart';
import '../views/stats/user_statistics_page.dart';
import '../views/flashcards/flashcard_category_selection_page.dart';
import '../views/settings/settings_page.dart';
import '../views/raindrop/raindrop_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override

  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      title: 'Matura Pro AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeNotifier.themeMode,
      initialRoute: AppRoutes.login,
      routes: {
        AppRoutes.login: (context) => const LoginPage(),
        AppRoutes.home: (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          final account = args['account'] as Account;

          return HomePage(account: account);
        },
        AppRoutes.account: (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          final account = args['account'] as Account;

          return AccountPage(account: account);
        },
        AppRoutes.placementTest: (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          final account = args['account'] as Account;
          return PlacementTestLoaderPage(
              account: account);
        },
        AppRoutes.stats: (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          final account = args['account'] as Account;

          return UserStatisticsPage(account: account);
        },
        AppRoutes.flashcards: (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          final account = args['account'] as Account;

          return FlashcardCategorySelectionPage(account: account);
        },
        AppRoutes.settings: (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          final account = args['account'] as Account;

          return SettingsPage(account: account);
        },
        AppRoutes.raindrop: (context) => const RaindropPage(),
      },
    );
  }
}
