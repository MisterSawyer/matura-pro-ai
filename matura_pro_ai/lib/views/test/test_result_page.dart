import 'package:flutter/material.dart';

import '../../core/constants.dart';

import '../../models/account.dart';

import '../../widgets/three_column_layout.dart';

class TestResultPage extends StatelessWidget {
  final Account account;
  final double score;

  const TestResultPage({
    super.key,
    required this.account,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.testResult)),
      body: Padding(
          padding: const EdgeInsets.all(AppStyles.padding),
          child: ThreeColumnLayout(
            left: const SizedBox(),
            center: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("${AppStrings.wellDone}, ${account.name}!",
                    style: AppStyles.subHeader),
                const SizedBox(height: 20),
                Text("${AppStrings.testResult}: ${score.toStringAsFixed(1)}%",
                    style: AppStyles.subHeader),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context, score);
                  },
                  child: const Text(AppStrings.backHome),
                ),
              ],
            ),
            right: const SizedBox(),
          )),
    );
  }
}
