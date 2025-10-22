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
                  Theme.of(context).colorScheme.primary.withOpacity(0.18),
                  Theme.of(context).scaffoldBackgroundColor.withOpacity(0.0),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
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
