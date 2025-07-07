import 'package:flutter/material.dart';

import '../../core/constants.dart';

import '../../models/account.dart';
import '../../routes/app_routes.dart';

import '../../widgets/main_drawer.dart';
import '../../widgets/carousel.dart';
import '../../widgets/no_scrollbar.dart';
import '../../widgets/daily_challenge_card.dart';
import '../../widgets/summary_card.dart';

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

  List<Widget> _buildHomeTilesSection0(double buttonWidth) {
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
      for (var i = 0; i < 2; i++)
        InkWell(
          onTap: () {},
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

  List<Widget> _buildHomeTilesSection1(double buttonWidth) {
    final theme = Theme.of(context);

    return [
      for (var i = 0; i < 4; i++)
        InkWell(
          onTap: () {},
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

    return Container(
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
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final totalWidth = constraints.maxWidth;
                        const spacing = 16.0;
                        const minButtonWidth = 160.0;
                        const maxButtonWidth = 256.0;

                        double computedWidth = (totalWidth - spacing) / 2;
                        double buttonWidth =
                            computedWidth.clamp(minButtonWidth, maxButtonWidth);

                        return Center(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                                maxWidth: constraints.maxWidth),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: AppStyles.padding),
                                  child: Image.asset(
                                    'assets/images/logo.png',
                                    width: 256,
                                    height: 128,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                const SizedBox(
                                  height: 32,
                                ),

                                SizedBox(
                                  width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: AppStyles.padding),
                                    child: SummaryCard(
                                      icon: Icons.bar_chart,
                                      title: 'Last Test Score',
                                      value:
                                          '${widget.account.lastPlacementTestResult.toStringAsFixed(1)}%',
                                      subtitle: 'Placement Test',
                                      onTap: () {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  "Go to test history (not implemented yet).")),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 64,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: Wrap(
                                    alignment: WrapAlignment.center,
                                    spacing: spacing,
                                    runSpacing: spacing,
                                    children: [
                                      for (var item in _buildHomeTilesSection0(
                                          buttonWidth))
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
                                const SizedBox(
                                  height: 64,
                                ),
                                // carousel
                                const SizedBox(
                                  width: double.infinity,
                                  child: Center(
                                      child: Carousel(objects: [
                                    {
                                      'name': 'Temp0',
                                      'icon': Icons.science_outlined
                                    },
                                    {
                                      'name': 'Temp1',
                                      'icon': Icons.science_outlined
                                    },
                                    {
                                      'name': 'Temp2',
                                      'icon': Icons.science_outlined
                                    },
                                    {
                                      'name': 'Temp3',
                                      'icon': Icons.science_outlined
                                    },
                                  ])),
                                ),
                                const SizedBox(
                                  height: 64,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: Wrap(
                                    alignment: WrapAlignment.center,
                                    spacing: spacing,
                                    runSpacing: spacing,
                                    children: [
                                      for (var item in _buildHomeTilesSection1(
                                          buttonWidth))
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
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )))),
    );
  }
}
