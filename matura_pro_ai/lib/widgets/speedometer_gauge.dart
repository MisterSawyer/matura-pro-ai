import 'package:flutter/material.dart';
import 'dart:math';

class SpeedometerGauge extends StatefulWidget {
  final double value; // 0–100

  const SpeedometerGauge({super.key, required this.value});

  @override
  State<SpeedometerGauge> createState() => _SpeedometerGaugeState();
}

class _SpeedometerGaugeState extends State<SpeedometerGauge>
    with SingleTickerProviderStateMixin {
  double animatedValue = 0.0;

  @override
  void initState() {
    super.initState();

    // Delay animation until after first layout is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        animatedValue = widget.value.clamp(0, 100);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: animatedValue),
      duration: const Duration(seconds: 2),
      curve: Curves.easeOutCubic,
      builder: (context, value, _) {
        return CustomPaint(
          size: const Size(200, 100),
          painter: _SpeedometerPainter(value : value, theme : theme),
        );
      },
    );
  }
}

class _SpeedometerPainter extends CustomPainter {
  final double value;
  final ThemeData theme;

  _SpeedometerPainter({required this.value, required this.theme});

  @override
  void paint(Canvas canvas, Size size) {

    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2;

    final baseRect = Rect.fromCircle(center: center, radius: radius);
    final startAngle = pi;
    final sweepAngle = pi * (value / 100);

    final backgroundPaint = Paint()
      ..color = theme.colorScheme.secondaryContainer
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12;

    final progressPaint = Paint()
      ..color = theme.primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    final needlePaint = Paint()
      ..color = theme.primaryColor
      ..strokeWidth = 4;

    // Draw background arc
    canvas.drawArc(baseRect, startAngle, pi, false, backgroundPaint);

    // Draw progress arc
    canvas.drawArc(baseRect, startAngle, sweepAngle, false, progressPaint);

    // Draw needle
    final needleAngle = startAngle + sweepAngle;
    final needleLength = radius - 12;
    final needleEnd = Offset(
      center.dx + needleLength * cos(needleAngle),
      center.dy + needleLength * sin(needleAngle),
    );

    canvas.drawLine(center, needleEnd, needlePaint);
    canvas.drawCircle(center, 6, Paint()..color = theme.colorScheme.secondaryContainer);

    // Draw text
    final textPainter = TextPainter(
      text: TextSpan(
        text: "${value.toStringAsFixed(1)}%",
        style: theme.textTheme.headlineSmall,
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(center.dx - textPainter.width / 2, center.dy - radius + 12),
    );
  }

  @override
  bool shouldRepaint(covariant _SpeedometerPainter oldDelegate) {
    return oldDelegate.value != value;
  }
}
