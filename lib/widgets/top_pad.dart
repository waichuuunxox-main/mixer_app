import 'dart:ui';

import 'package:flutter/material.dart';

/// A small decorative top pad that adds a subtle gradient, blur and sheen
/// behind the system status bar area to visually anchor the app's header.
class TopPad extends StatelessWidget {
  final double extraHeight;

  const TopPad({super.key, this.extraHeight = 8});

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    final height = top + extraHeight;

    return SizedBox(
      height: height,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Theme.of(context).colorScheme.primary.withAlpha((0.18 * 255).round()),
                  Theme.of(context).scaffoldBackgroundColor.withAlpha((0.0 * 255).round()),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha((0.06 * 255).round()),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
