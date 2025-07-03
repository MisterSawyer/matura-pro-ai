import 'package:flutter/material.dart';

class ThreeColumnLayout extends StatelessWidget {
  final Widget? left;
  final Widget center;
  final Widget? right;

  const ThreeColumnLayout({
    super.key,
    this.left,
    required this.center,
    this.right,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: left ?? const SizedBox()),
        Expanded(flex: 2, child: center),
        Expanded(child: right ?? const SizedBox()),
      ],
    );
  }
}