import 'package:flutter/material.dart';

import '../models/account.dart';

import '../routes/app_routes.dart';

import '../views/login/login_page.dart';
import '../views/home/home_page.dart';
import '../views/account/account_page.dart';
import '../views/placement_test/placement_test_page.dart';
import '../views/placement_test/placement_test_result_page.dart';
import '../core/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Matura Pro AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      initialRoute: AppRoutes.login,
      routes: {
        AppRoutes.login: (context) => const LoginPage(),
        AppRoutes.home: (context) => const HomePage(),
        AppRoutes.account: (context) => const AccountPage(),
        AppRoutes.placementTest: (context) {
          final account = ModalRoute.of(context)!.settings.arguments as Account;
          return PlacementTestPage(account: account);
        },
        AppRoutes.placementTestResult: (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          final account = args['account'] as Account;
          final score = args['score'] as double;
          return PlacementTestResultPage(account: account, score: score);
        }
      },
    );
  }
}