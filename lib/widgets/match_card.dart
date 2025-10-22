import 'package:flutter/material.dart';
import 'package:mixzer_app/models/match.dart' as m;
import 'package:mixzer_app/widgets/glass_card.dart';

class MatchCard extends StatefulWidget {
  final m.Match match;
  const MatchCard({super.key, required this.match});

  @override
  State<MatchCard> createState() => _MatchCardState();
}

class _MatchCardState extends State<MatchCard> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final match = widget.match;
    final isPlayed = match.homeScore != null && match.awayScore != null;
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 220),
        scale: _hover ? 1.01 : 1.0,
        child: GlassCard(
          sheen: true,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${match.homeTeam} vs ${match.awayTeam}',
                      style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800, color: theme.colorScheme.primary, shadows: _hover ? [Shadow(color: theme.colorScheme.primary.withAlpha(60), blurRadius: 8)] : null),
                    ),
                    const SizedBox(height: 6),
                    Text('${match.date.toLocal()}'.split(' ')[0], style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface)),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              // Score badge / placeholder
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary.withAlpha(34),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: theme.colorScheme.secondary.withAlpha(60)),
                  boxShadow: [
                    BoxShadow(color: theme.shadowColor.withAlpha(18), blurRadius: 8, offset: const Offset(0, 3)),
                  ],
                ),
                child: isPlayed
                    ? Text('${match.homeScore} - ${match.awayScore}', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800, color: theme.colorScheme.primary))
                    : Icon(Icons.sports_soccer, color: theme.colorScheme.primary, size: 20),
              )
            ],
          ),
        ),
      ),
    );
  }
}
