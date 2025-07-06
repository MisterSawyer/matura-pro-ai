import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../models/account.dart';
import '../../routes/app_routes.dart';

class MainDrawer extends StatelessWidget {
  final Account account;

  const MainDrawer({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.blue),
            child: Text(
              "${AppStrings.welcome} ${account.name}",
              style: AppStyles.header,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text(AppStrings.account),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(
                context,
                AppRoutes.account,
                arguments: 
                {
                  'account': account,
                }
              );
            },
          ),
          // Add more items here if needed
        ],
      ),
    );
  }
}