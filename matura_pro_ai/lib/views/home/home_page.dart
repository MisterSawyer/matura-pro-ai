import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants.dart';
import '../../core/theme_defaults.dart';
import '../../models/test/test_type.dart';
import '../../providers/account_provider.dart';
import '../../routes/app_routes.dart';

import '../../widgets/no_scrollbar.dart';
import '../../widgets/home_tile.dart';
import '../../widgets/daily_challenge_card.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  bool _alreadyRedirected = false;

  @override
  void initState() {
    super.initState();
    // Wait until first frame to possibly redirect
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final account = ref.read(accountProvider);
      if (account == null) return;

      if (!_alreadyRedirected &&
          !account.stats.placementTestTaken &&
          !account.currentTests.containsKey(TestType.placement)) {
        _alreadyRedirected = true;
        Navigator.pushReplacementNamed(context, AppRoutes.placementTest);
      }
    });
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(children: [
      SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(ThemeDefaults.padding),
          ),
          onPressed: () => {},
          child: const Text(
            "${AppStrings.lessonOfTheDay} ➤",
            overflow: TextOverflow.fade,
            softWrap: false,
            maxLines: 1,
          ),
        ),
      ),
      const SizedBox(height: 16),
    ]);
  }

  List<Widget> _buildHomeTilesSection(double buttonWidth) {
    return [
      HomeTile(
        icon: const Icon(Icons.insert_drive_file, size: 64),
        label: AppStrings.exam,
        onTap: () => Navigator.pushNamed(context, AppRoutes.placementTest),
      ),
      HomeTile(
        icon: const Icon(Icons.pages, size: 64),
        label: AppStrings.flashcards,
        onTap: () => Navigator.pushNamed(context, AppRoutes.flashcards),
      ),
      const HomeTile(icon: Icon(Icons.mic, size: 64), label: AppStrings.speaking),
      const HomeTile(icon: Icon(Icons.headset, size: 64), label: AppStrings.listening),
      const HomeTile(icon: Icon(Icons.book, size: 64), label: AppStrings.reading),
      const HomeTile(icon: Icon(Icons.edit, size: 64), label: AppStrings.writing),
      HomeTile(
        icon: const Icon(Icons.account_circle, size: 64),
        label: AppStrings.account,
        onTap: () => Navigator.pushNamed(context, AppRoutes.account),
      ),
      const HomeTile(icon: Icon(Icons.supervisor_account, size: 64), label: AppStrings.social),
      HomeTile(
        icon: const Icon(Icons.equalizer, size: 64),
        label: AppStrings.stats,
        onTap: () => Navigator.pushNamed(context, AppRoutes.stats),
      ),
      HomeTile(
        icon: const Icon(Icons.settings, size: 64),
        label: AppStrings.settings,
        onTap: () => Navigator.pushNamed(context, AppRoutes.settings),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final account = ref.watch(accountProvider);

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
                  double buttonWidth = computedWidth.clamp(minButtonWidth, maxButtonWidth);

                  return Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: constraints.maxWidth),
                      child: Column(
                        children: [
                          const SizedBox(height: 64),
                          Text(
                            '${AppStrings.hello}, ${account?.name ?? account?.username}!'.toUpperCase(),
                            style: theme.textTheme.titleLarge,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          const SizedBox(
                            width: double.infinity,
                            child: DailyChallengeCard(
                              currentStreak: 21,
                            ),
                          ),
                          const SizedBox(height: 32),
                          _buildActionButtons(context),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            child: GridView.count(
                              crossAxisCount: 2,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisSpacing: spacing,
                              mainAxisSpacing: spacing,
                              childAspectRatio: 1.0,
                              children: _buildHomeTilesSection(buttonWidth),
                            ),
                          ),
                          const SizedBox(height: 64),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
