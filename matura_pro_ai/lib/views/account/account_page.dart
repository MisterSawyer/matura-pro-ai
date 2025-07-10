import 'package:flutter/material.dart';

import '../../core/constants.dart';

import '../../routes/app_routes.dart';
import '../../models/account.dart';

import '../../widgets/scrollable_layout.dart';

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
        color: theme.scaffoldBackgroundColor,
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
                appBar: AppBar(),
                body: ScrollableLayout(maxWidth: 400, children: [
                  Center(
                      child: Text("Konto",
                          style: theme.textTheme.titleLarge,
                          textAlign: TextAlign.center)),
                  const SizedBox(height: 32),
                  const Center(child: Icon(Icons.account_circle, size: 64)),
                  const SizedBox(height: 16),
                  Center(
                    child: Text("${AppStrings.username}: ${widget.account.username}",
                        style: theme.textTheme.headlineSmall),
                  ),
                  const SizedBox(height: 16),
                 Center(
                   child: TextField(
                        controller: _nameController,
                        focusNode: _nameFocusNode,
                        decoration:
                            const InputDecoration(labelText: AppStrings.name),
                      ),
                 ),
                  const SizedBox(height: 128),
                  Center(
                    child: TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: theme.colorScheme.errorContainer),
                      onPressed: _onLogout,
                      child: const Text(AppStrings.logout),
                    ),
                  ),
                ]))));
  }
}
