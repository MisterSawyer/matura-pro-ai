import 'package:flutter/material.dart';
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
        SnackBar(content: Text("Test completed! Score: ${result.toStringAsFixed(1)}%")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              child: Text("Welcome, ${account.name}",
                  style: const TextStyle(color: Colors.white, fontSize: 20)),
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text("Account"),
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _takePlacementTest,
              child: const Text("Take Placement Test"),
            ),
          ],
        ),
      ),
    );
  }
}
