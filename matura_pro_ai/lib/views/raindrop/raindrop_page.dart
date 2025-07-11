import 'package:flutter/material.dart';
import '../../models/raindrop_word.dart';
import '../../services/raindrop_loader.dart';
import '../../widgets/scrollable_layout.dart';

class RaindropPage extends StatelessWidget {
  const RaindropPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FutureBuilder<RaindropWord>(
      future: loadRaindropWord(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        final word = snapshot.data!;
        return Scaffold(
          appBar: AppBar(),
          body: ScrollableLayout(
            maxWidth: 400,
            children: [
              Center(
                child: Text(
                  "Raindrop",
                  style: theme.textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 64),

              Center(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        "🗓 ${word.date}",
                        style: theme.textTheme.labelLarge,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        word.word.toUpperCase(),
                        style: theme.textTheme.headlineLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        word.definition,
                        style: theme.textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      if (word.example.isNotEmpty)
                        Text(
                          "\"${word.example}\"",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 64),
            ],
          ),
        );
      },
    );
  }
}
