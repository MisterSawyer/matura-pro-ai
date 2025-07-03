import 'package:flutter/material.dart';

import '../../core/constants.dart';
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
      const SnackBar(content: Text(AppStrings.nameUpdateSucess)),
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
      appBar: AppBar(title: const Text(AppStrings.account)),
      body: Padding(
        padding: const EdgeInsets.all(AppStyles.padding),
        child: Column(
          children: [
            Text("${AppStrings.email}: ${account.email}", style: AppStyles.paragraph),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: AppStrings.name),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _onSave,
              child: const Text(AppStrings.saveName),
            ),
            const SizedBox(height: 16),
            Text("${AppStrings.lastTest}: ${account.lastPlacementTestResult.toStringAsFixed(1)}%", style: AppStyles.paragraph),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _onLogout,
              child: const Text(AppStrings.logout),
            ),
          ],
        ),
      ),
    );
  }
}