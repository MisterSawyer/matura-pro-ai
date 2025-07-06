import 'package:flutter/material.dart';

import '../models/account.dart';

import '../routes/app_routes.dart';

import '../views/login/login_page.dart';
import '../views/home/home_page.dart';
import '../views/account/account_page.dart';
import '../views/test/test_page.dart';
import '../views/test/test_result_page.dart';
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
        AppRoutes.test: (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          final account = args['account'] as Account;
          final path = args['path'] as String;
          final label = args['label'] as String;
          final onSubmit = args['onSubmit'] as Function(double);
          return TestPage(
              account: account, path: path, label: label, onSubmit: onSubmit);
        },
        AppRoutes.testResult: (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          final account = args['account'] as Account;
          final score = args['score'] as double;
          return TestResultPage(account: account, score: score);
        }
      },
    );
  }
}
