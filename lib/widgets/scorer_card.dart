import 'package:flutter/material.dart';
import 'package:mixzer_app/models/player.dart';
import 'package:mixzer_app/widgets/glass_card.dart';

class ScorerCard extends StatefulWidget {
  final Player player;
  const ScorerCard({super.key, required this.player});

  @override
  State<ScorerCard> createState() => _ScorerCardState();
}

class _ScorerCardState extends State<ScorerCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final player = widget.player;

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 200),
        scale: _hover ? 1.02 : 1.0,
        child: GlassCard(
          sheen: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                CircleAvatar(radius: 24, backgroundColor: theme.colorScheme.primary.withAlpha(44), child: Text(player.name.substring(0,1), style: TextStyle(color: theme.colorScheme.onPrimary))),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(player.name, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800, color: theme.colorScheme.primary, shadows: _hover ? [Shadow(color: theme.colorScheme.primary.withAlpha(70), blurRadius: 10)] : null)),
                      const SizedBox(height: 4),
                      Text(player.team, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface)),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(color: theme.colorScheme.secondary.withAlpha(36), borderRadius: BorderRadius.circular(10), border: Border.all(color: theme.colorScheme.secondary.withAlpha(56))),
                  child: Text('${player.goals}', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
