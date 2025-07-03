import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../routes/app_routes.dart';
import '../../models/account.dart';

import '../../controllers/register_controller.dart';
import '../../widgets/three_column_layout.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late Account account;
  late TextEditingController _nameController;
  late FocusNode _nameFocusNode;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    account = ModalRoute.of(context)!.settings.arguments as Account;
    _nameController = TextEditingController(text: account.name);
    _nameFocusNode = FocusNode();
    _nameFocusNode.addListener(() {
      if (!_nameFocusNode.hasFocus) {
        _onSave();
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  void _onSave() {
    if(account.name == _nameController.text)return;
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
    return PopScope(
        canPop: true,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) {
            _onSave(); // Save only if pop is actually happening
          }
        },
        child: Scaffold(
          appBar: AppBar(title: const Text(AppStrings.account)),
          body: Padding(
              padding: const EdgeInsets.all(AppStyles.padding),
              child: ThreeColumnLayout(
                left: const SizedBox(),
                center: Column(
                  children: [
                    Text("${AppStrings.email}: ${account.email}",
                        style: AppStyles.paragraph),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _nameController,
                      focusNode: _nameFocusNode,
                      decoration:
                          const InputDecoration(labelText: AppStrings.name),
                    ),
                    const SizedBox(height: 16),
                    Text(
                        "${AppStrings.lastTest}: ${account.lastPlacementTestResult.toStringAsFixed(1)}%",
                        style: AppStyles.paragraph),
                    const SizedBox(height: 64),
                    ElevatedButton(
                      onPressed: _onLogout,
                      child: const Text(AppStrings.logout),
                    ),
                  ],
                ),
                right: const SizedBox(),
              )),
        ));
  }
}
