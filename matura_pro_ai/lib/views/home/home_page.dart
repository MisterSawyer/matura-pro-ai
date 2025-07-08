import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../core/theme_defaults.dart';

import '../../models/account.dart';
import '../../routes/app_routes.dart';

import '../../widgets/no_scrollbar.dart';
import '../../widgets/daily_challenge_card.dart';

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

  @override
  void initState() {
    super.initState();
    //Wait until the first frame is rendered before navigating
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!widget.account.stats.placementTestTaken) {
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.placementTest,
          arguments: {
            'account': widget.account,
            'path': AppAssets.placementTest,
            'label': AppStrings.placementTest,
            'onSubmit': (double score) {
              // optionally handle score here
            }
          },
        );
      }
    });
  }

  List<Widget> _buildHomeTilesSection(double buttonWidth) {
    final theme = Theme.of(context);

    return [
      for (var i = 0; i < 10; i++)
        InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(16),
          child: Ink(
            padding: const EdgeInsets.all(ThemeDefaults.padding),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 12),
                Text('⏳', style: TextStyle(fontSize: 32)),
                SizedBox(height: 12)
              ],
            ),
          ),
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: theme.scaffoldBackgroundColor,
      child: Scaffold(
          body: Padding(
              padding: const EdgeInsets.all(ThemeDefaults.padding),
              child: ScrollConfiguration(
                  behavior: NoScrollbarBehavior(),
                  child: SingleChildScrollView(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final totalWidth = constraints.maxWidth;
                        const spacing = 32.0;
                        const minButtonWidth = 160.0;
                        const maxButtonWidth = 256.0;

                        double computedWidth = (totalWidth - spacing) / 2;
                        double buttonWidth =
                            computedWidth.clamp(minButtonWidth, maxButtonWidth);

                        return Center(
                          child: ConstrainedBox(
                            constraints:
                                BoxConstraints(maxWidth: constraints.maxWidth),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 64,
                                ),
                                Text(
                                  'Czesc, ${widget.account.name}!'
                                      .toUpperCase(),
                                  style: theme.textTheme.titleLarge,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: DailyChallengeCard(
                                    currentStreak: 21,
                                    onTap: () {},
                                  ),
                                ),
                                const SizedBox(
                                  height: ThemeDefaults.padding,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.all(
                                          ThemeDefaults.padding),
                                    ),
                                    onPressed: () {
                                      // DAILY LESSON
                                    },
                                    child: Text(
                                      "START ➤",
                                      style:
                                          theme.textTheme.titleLarge!.copyWith(
                                        color: theme.scaffoldBackgroundColor,
                                      ),
                                      overflow: TextOverflow.fade,
                                      softWrap: false,
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 32,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.all(
                                          ThemeDefaults.padding),
                                    ),
                                    onPressed: () {
                                      // DAILY LESSON
                                    },
                                    child: Text(
                                      "RAINDROP",
                                      style:
                                          theme.textTheme.titleLarge!.copyWith(
                                        color: theme.scaffoldBackgroundColor,
                                      ),
                                      overflow: TextOverflow.fade,
                                      softWrap: false,
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 32,
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: GridView.count(
                                    crossAxisCount: 2,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    crossAxisSpacing: spacing,
                                    mainAxisSpacing: spacing,
                                    childAspectRatio: 1.0,
                                    children: [
                                      for (var item in _buildHomeTilesSection(
                                          buttonWidth))
                                        item,
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  height: 64,
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
