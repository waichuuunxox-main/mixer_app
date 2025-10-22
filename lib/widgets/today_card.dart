import 'package:flutter/material.dart';
import 'package:mixzer_app/models/match.dart' as m;
import 'package:mixzer_app/widgets/glass_card.dart';

class TodayCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final List<m.Match> matches;

  const TodayCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.matches = const [],
  });

  @override
  State<TodayCard> createState() => _TodayCardState();
}

class _TodayCardState extends State<TodayCard> {
  bool _hover = false;

  bool _isPlayed(m.Match match) =>
      match.homeScore != null && match.awayScore != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 180),
        scale: _hover ? 1.01 : 1.0,
        child: GlassCard(
          sheen: true,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    shadows: _hover
                        ? [
                            Shadow(
                              color: theme.colorScheme.primary.withAlpha(50),
                              blurRadius: 8,
                            ),
                          ]
                        : null,
                  ),
                ),
                const SizedBox(height: 10),
                if (widget.matches.isEmpty) ...[
                  Text(
                    widget.subtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ] else ...[
                  ...widget.matches.map(
                    (m.Match match) => Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${match.homeTeam} vs ${match.awayTeam}',
                              style: theme.textTheme.bodyLarge,
                            ),
                          ),
                          Text(
                            _isPlayed(match)
                                ? '${match.homeScore}-${match.awayScore}'
                                : 'TBD',
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
