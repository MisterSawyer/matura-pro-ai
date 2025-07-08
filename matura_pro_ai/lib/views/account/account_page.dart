import 'package:flutter/material.dart';

import '../../core/theme_defaults.dart';
import '../../core/constants.dart';

import '../../routes/app_routes.dart';
import '../../models/account.dart';

import '../../widgets/three_column_layout.dart';

class AccountPage extends StatefulWidget {
  final Account account;

  const AccountPage({super.key, required this.account});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late TextEditingController _nameController;
  late FocusNode _nameFocusNode;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _nameController = TextEditingController(text: widget.account.name);
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
    if (widget.account.name == _nameController.text) return;
    setState(() {
      widget.account.setName(_nameController.text);
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
    final theme = Theme.of(context);
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      width: double.infinity,
      height: double.infinity,
      child: PopScope(
          canPop: true,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) {
              _onSave(); // Save only if pop is actually happening
            }
          },
          child: Scaffold(
            appBar: AppBar(title: const Text(AppStrings.account)),
            body: Padding(
                padding: const EdgeInsets.all(ThemeDefaults.padding),
                child: ThreeColumnLayout(
                  left: const SizedBox(),
                  center: Column(
                    children: [
                      const SizedBox(height: 32),
                      const Icon(Icons.account_circle, size: 64),
                      const SizedBox(height: 16),
                      Text("${AppStrings.username}: ${widget.account.username}",
                          style: theme.textTheme.headlineSmall),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _nameController,
                        focusNode: _nameFocusNode,
                        decoration:
                            const InputDecoration(labelText: AppStrings.name),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(ThemeDefaults.padding),
                        margin: const EdgeInsets.symmetric(vertical: 24),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context).colorScheme.primary),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Results", style: theme.textTheme.titleLarge),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                      const SizedBox(height: 128),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(Colors.red),
                        ),
                        onPressed: _onLogout,
                        child: const Text(AppStrings.logout),
                      ),
                    ],
                  ),
                  right: const SizedBox(),
                )),
          )),
    );
  }
}
