import 'package:flutter/material.dart';
import '../../core/theme_defaults.dart';

import '../../widgets/no_scrollbar.dart';

class ScrollableLayout extends StatelessWidget {
  final double maxWidth;
  final List<Widget> children;
  const ScrollableLayout(
      {super.key, required this.maxWidth, required this.children});

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: NoScrollbarBehavior(),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(ThemeDefaults.padding),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
