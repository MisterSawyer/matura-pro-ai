import 'package:flutter/material.dart';

import '../../core/theme_defaults.dart';

import '../../models/account.dart';
import '../../routes/app_routes.dart';

import '../../widgets/no_scrollbar.dart';
import '../../widgets/home_tile.dart';
import '../../widgets/daily_challenge_card.dart';

class HomePage extends StatefulWidget {
  final Account account;

  const HomePage({super.key, required this.account});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _alreadyRedirected = false;

  @override
  void initState() {
    super.initState();
    //Wait until the first frame is rendered before navigating
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_alreadyRedirected &&!widget.account.stats.placementTestTaken) {
        _alreadyRedirected = true;
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.placementTest,
          arguments: {
            'account': widget.account,
          },
        );
      }
    });
  }

  List<Widget> _buildHomeTilesSection(double buttonWidth) {
    return [
      HomeTile(
        icon: const Icon(Icons.insert_drive_file, size: 64),
        label: 'Matura',
        onTap: () => Navigator.pushNamed(context, AppRoutes.placementTest,
            arguments: {'account': widget.account}),
      ),
      HomeTile(
        icon: const Icon(Icons.pages, size: 64),
        label: 'Fiszki',
        onTap: () => Navigator.pushNamed(context, AppRoutes.flashcards,
            arguments: {'account': widget.account}),
      ),
      HomeTile(
        icon: const Icon(Icons.mic, size: 64),
        label: 'Mówienie',
        onTap: () => {},
      ),
      HomeTile(
        icon: const Icon(Icons.headset, size: 64),
        label: 'Słuchanie',
        onTap: () => {},
      ),
      HomeTile(
        icon: const Icon(Icons.book, size: 64),
        label: 'Czytanie',
        onTap: () => {},
      ),
      HomeTile(
        icon: const Icon(Icons.edit, size: 64),
        label: 'Pisanie',
        onTap: () => {},
      ),
      HomeTile(
        icon: const Icon(Icons.account_circle, size: 64),
        label: 'Konto',
        onTap: () => Navigator.pushNamed(context, AppRoutes.account,
            arguments: {'account': widget.account}),
      ),
      HomeTile(
        icon: const Icon(Icons.supervisor_account, size: 64),
        label: 'Social',
        onTap: () => {},
      ),
      HomeTile(
        icon: const Icon(Icons.equalizer, size: 64),
        label: 'Stats',
        onTap: () => Navigator.pushNamed(context, AppRoutes.stats,
            arguments: {'account': widget.account}),
      ),
      HomeTile(
        icon: const Icon(Icons.settings, size: 64),
        label: 'Ustawienia',
        onTap: () => Navigator.pushNamed(context, AppRoutes.settings,
            arguments: {'account': widget.account}),
      )
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
                                    child: const Text(
                                      "START ➤",
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
                                    child: const Text(
                                      "RAINDROP",
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
