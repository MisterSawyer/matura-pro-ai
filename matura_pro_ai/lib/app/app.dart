import 'package:flutter/material.dart';

import '../core/theme.dart';

import '../models/account.dart';

import '../routes/app_routes.dart';

import '../views/login/login_page.dart';
import '../views/home/home_page.dart';
import '../views/account/account_page.dart';
import '../views/placement_test/placement_test_page.dart';

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
          return PlacementTestPage(
              account: account);
        },
      },
    );
  }
}
