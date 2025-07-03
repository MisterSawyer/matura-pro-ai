import 'package:flutter/material.dart';

import '../../core/constants.dart';

import '../../models/account.dart';
import '../../routes/app_routes.dart';

import '../../widgets/main_drawer.dart';
import '../../widgets/three_column_layout.dart';

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
        SnackBar(
            content: Text(
                "${AppStrings.testCompleted} : ${result.toStringAsFixed(1)}%")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.home)),
      drawer: MainDrawer(account: account),
      body: Padding(
        padding: const EdgeInsets.all(AppStyles.padding),
        child: Column(children: [
          const SizedBox(height: 64,),
          Expanded(child:
          ThreeColumnLayout(
            left: const SizedBox(),
            center:  GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.2,
                  children: [
                    ElevatedButton(
                      onPressed: _takePlacementTest,
                      child: const Text(AppStrings.takeTest),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.account,
                          arguments: account,
                        );
                      },
                      child: const Text(AppStrings.account),
                    ),
                    // Add more grid buttons as needed
                  ],
                ),
            right: const SizedBox(),
          )),
        ]),
      ),
    );
  }
}
