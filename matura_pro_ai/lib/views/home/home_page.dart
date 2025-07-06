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

  List<Widget> _buildHomeTiles(double buttonWidth) {
    final theme = Theme.of(context);

    return [
      InkWell(
        onTap: _takePlacementTest,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          padding: const EdgeInsets.all(AppStyles.padding),
          decoration: BoxDecoration(
            color: theme.colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('📝', style: TextStyle(fontSize: 32)),
              const SizedBox(height: 12),
              Text(
                AppStrings.takeTest,
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8)
            ],
          ),
        ),
      ),
      DailyChallengeCard(
        currentStreak: 5,
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Starting today's challenge!")),
          );
        },
      ),
      for (var i = 0; i < 4; i++)
              InkWell(
        onTap: (){},
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          padding: const EdgeInsets.all(AppStyles.padding),
          decoration: BoxDecoration(
            color: theme.colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('⏳', style: TextStyle(fontSize: 32)),
              const SizedBox(height: 12),
              Text(
                "template $i",
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8)
            ],
          ),
        ),
      ),
    ];
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
    final theme = Theme.of(context);

    return SafeArea(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: theme.scaffoldBackgroundColor,
        child: Scaffold(
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
                        center: LayoutBuilder(
                          builder: (context, constraints) {
                            final totalWidth = constraints.maxWidth;
                            const spacing = 16.0;
                            const minButtonWidth = 160.0;
                            const maxButtonWidth = 220.0;

                            double computedWidth = (totalWidth - spacing) / 2;
                            double buttonWidth = computedWidth.clamp(
                                minButtonWidth, maxButtonWidth);

                            return Center(
                              child: ConstrainedBox(
                                constraints:
                                    const BoxConstraints(maxWidth: 500),
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: spacing,
                                  runSpacing: spacing,
                                  children: [
                                    for (var item
                                        in _buildHomeTiles(buttonWidth))
                                      SizedBox(
                                        width: buttonWidth,
                                        child: AspectRatio(
                                          aspectRatio: 1,
                                          child: item,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        right: const SizedBox(),
                      )
                    ]))))),
      ),
    );
  }
}
