import 'package:flutter/material.dart';

import '../../routes/app_routes.dart';
import '../../models/account.dart';

import '../../controllers/register_controller.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late Account account;
  late TextEditingController _nameController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    account = ModalRoute.of(context)!.settings.arguments as Account;
    _nameController = TextEditingController(text: account.name);
  }

  void _onSave() {
    setState(() {
      account.name = _nameController.text;
      RegisterController.updateName(account.email, account.name);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Name updated successfully")),
    );
  }

  void _onLogout() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Account")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Email: ${account.email}", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _onSave,
              child: const Text("Save Name"),
            ),
            Text("Last Placement Test: ${account.lastPlacementTestResult.toStringAsFixed(1)}%", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _onLogout,
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}