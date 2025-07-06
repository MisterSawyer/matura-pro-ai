import 'package:flutter/material.dart';

import '../../core/constants.dart';

import '../../models/account.dart';
import '../../routes/app_routes.dart';

import '../../widgets/main_drawer.dart';
import '../../widgets/three_column_layout.dart';
import '../../widgets/carousel.dart';
import '../../widgets/no_scrollbar.dart';
import '../../widgets/daily_challenge_card.dart';

import '../../controllers/register_controller.dart';

class HomePage extends StatefulWidget {
  final Account account;

  const HomePage({super.key, required this.account});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> _takePlacementTest() async {
    final result =
        await Navigator.pushNamed(context, AppRoutes.test, arguments: {
      'account': widget.account,
      'path': AppAssets.placementQuestions,
      'label': AppStrings.placementTest,
      'onSubmit': (score) => RegisterController.updateLastPlacementTestResult(
          widget.account.username, score)
    });

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
        drawer: MainDrawer(account: widget.account),
        body: Padding(
            padding: const EdgeInsets.all(AppStyles.padding),
            child: ScrollConfiguration(
                behavior: NoScrollbarBehavior(),
                child: SingleChildScrollView(
                    child: Column(children: [
                  // carousel
                  const Center(
                      child: Carousel(objects: [
                    {'name': 'Temp0', 'icon': Icons.science_outlined},
                    {'name': 'Temp1', 'icon': Icons.science_outlined},
                    {'name': 'Temp2', 'icon': Icons.science_outlined},
                    {'name': 'Temp3', 'icon': Icons.science_outlined},
                  ])),

                  const SizedBox(
                    height: 64,
                  ),

                  // grid of buttons
                  ThreeColumnLayout(
                    left: const SizedBox(),
                    center: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
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
                              arguments: {'account': widget.account},
                            );
                          },
                          child: const Text(AppStrings.account),
                        ),
                        DailyChallengeCard(
                          currentStreak:
                              5, // Replace with actual state logic later
                          onTap: () {
                            // Example: Navigate to a mini test screen or show dialog
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Starting today's challenge!")),
                            );
                          },
                        ),
                        ElevatedButton(
                          onPressed: () => {},
                          child: const Text("TEMP1"),
                        ),
                        ElevatedButton(
                          onPressed: () => {},
                          child: const Text("TEMP2"),
                        ),
                        ElevatedButton(
                          onPressed: () => {},
                          child: const Text("TEMP3"),
                        )
                      ],
                    ),
                    right: const SizedBox(),
                  )
                ])))));
  }
}
