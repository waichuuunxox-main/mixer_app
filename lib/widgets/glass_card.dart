import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:mixzer_app/theme/macos_tahoe_theme.dart';

class GlassCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final double? blur; // if provided and >0, enable backdrop blur; if null, use platform default
  final Duration entranceDuration;
  final bool sheen;
  final Duration sheenDuration;
  final double sheenWidth; // fraction of width

  const GlassCard({super.key, required this.child, this.padding, this.borderRadius, this.blur = 0.0, this.entranceDuration = const Duration(milliseconds: 360), this.sheen = false, this.sheenDuration = const Duration(milliseconds: 1400), this.sheenWidth = 0.22});

  @override
  State<GlassCard> createState() => _GlassCardState();
}

class _GlassCardState extends State<GlassCard> with TickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final AnimationController _glowCtrl;
  AnimationController? _sheenCtrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.entranceDuration);
    _ctrl.forward();
    _glowCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1400))..repeat(reverse: true);
    if (widget.sheen) {
      _sheenCtrl = AnimationController(vsync: this, duration: widget.sheenDuration)..repeat();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _glowCtrl.dispose();
    _sheenCtrl?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // read glam tokens if available
    final glam = MacosTahoeTheme.glamTokensOf(context);
    final Color gradientStart = glam.gradientStart.withAlpha(24);
    final Color gradientEnd = glam.gradientEnd.withAlpha(14);
    // determine platform default blur: use 6.0 on macOS, 0 on others when blur not explicitly set
    final defaultBlur = Theme.of(context).platform == TargetPlatform.macOS ? 6.0 : 0.0;
    final effectiveBlur = (widget.blur == null) ? defaultBlur : (widget.blur ?? 0.0);
    final radius = widget.borderRadius ?? BorderRadius.circular(14);

    return FadeTransition(
      opacity: CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
      child: ScaleTransition(
        scale: Tween(begin: 0.992, end: 1.0).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut)),
        child: AnimatedBuilder(
          animation: _glowCtrl,
          builder: (context, child) {
            final glamLocal = MacosTahoeTheme.glamTokensOf(context);
            final glowStrength = (glamLocal.glowIntensity * (0.6 + 0.4 * _glowCtrl.value));
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: radius,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [gradientStart, gradientEnd],
                ),
                border: Border.all(color: Colors.white.withAlpha(16)),
                boxShadow: [
                  // base shadow
                  BoxShadow(color: theme.shadowColor.withAlpha(14), blurRadius: 18, offset: const Offset(0, 8)),
                  // subtle glow using glam color
                  BoxShadow(color: glamLocal.glowColor.withAlpha((glowStrength * 255).clamp(0, 255).toInt()), blurRadius: 28, spreadRadius: 1),
                ],
              ),
              child: ClipRRect(
                borderRadius: radius,
                child: Stack(
                  children: [
                    if ((effectiveBlur) > 0)
                      Positioned.fill(
                        child: BackdropFilter(
                          filter: ui.ImageFilter.blur(sigmaX: effectiveBlur, sigmaY: effectiveBlur),
                          child: Container(color: Colors.transparent),
                        ),
                      ),
                    // sheen moving highlight
                    if (widget.sheen && _sheenCtrl != null)
                      Positioned.fill(
                        child: IgnorePointer(
                          child: AnimatedBuilder(
                            animation: _sheenCtrl!,
                            builder: (context, child) {
                              final t = (_sheenCtrl!.value * 2) - 1.0; // -1..1
                              // position via Align alignment x from -1.3..1.3
                              final pos = Alignment(t * 1.3, 0);
                              return Align(
                                alignment: pos,
                                child: FractionallySizedBox(
                                  widthFactor: widget.sheenWidth,
                                  child: Container(
                                    height: double.infinity,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Colors.white.withAlpha(80),
                                          Colors.white.withAlpha(10),
                                          Colors.white.withAlpha(0),
                                        ],
                                        stops: const [0.0, 0.4, 1.0],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    Padding(
                      padding: widget.padding ?? const EdgeInsets.all(14),
                      child: widget.child,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
