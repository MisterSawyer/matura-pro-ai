import 'package:flutter/material.dart';

import '../../core/constants.dart';

import '../../models/account.dart';
import '../../routes/app_routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Account account;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    account = ModalRoute.of(context)!.settings.arguments as Account;
  }

  Future<void> _takePlacementTest() async {
    final result = await Navigator.pushNamed(
      context,
      AppRoutes.placementTest,
      arguments: account,
    );

    if (!mounted) return;

    if (result is double) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${AppStrings.testCompleted} : ${result.toStringAsFixed(1)}%")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.home)),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              child: Text("${AppStrings.welcome} ${account.name}",
                  style: AppStyles.header),
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text(AppStrings.account),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                  context,
                  AppRoutes.account,
                  arguments: account,
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppStyles.padding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _takePlacementTest,
              child: const Text(AppStrings.takeTest),
            ),
          ],
        ),
      ),
    );
  }
}
