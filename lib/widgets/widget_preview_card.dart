import 'package:flutter/material.dart';
import 'package:mixzer_app/widgets/glass_card.dart';

class WidgetPreviewCard extends StatelessWidget {
  final String nextMatch;
  final DateTime timestamp;

  const WidgetPreviewCard({super.key, required this.nextMatch, required this.timestamp});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlassCard(
      blur: 6.0,
      entranceDuration: const Duration(milliseconds: 420),
      sheen: true,
      sheenWidth: 0.36,
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Next match', style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text(nextMatch, style: theme.textTheme.headlineLarge?.copyWith(color: theme.colorScheme.onSurface, fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                Text('Updated: ${timestamp.toLocal().toIso8601String()}', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface)),
              ],
            ),
            // subtle sheen animation overlay
            Positioned.fill(
              child: IgnorePointer(
                child: AnimatedOpacity(
                  opacity: 0.07,
                  duration: const Duration(milliseconds: 1400),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.white.withAlpha(10), Colors.white.withAlpha(0)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        transform: const GradientRotation(0.4),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
