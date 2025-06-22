// ignore_for_file: unused_element

import 'dart:ui';

import 'package:flutter/material.dart';

class BlurCard extends StatelessWidget {
  final Widget child;
  final bool isMaxedOut;
  
  const BlurCard({
    required this.child,
    this.isMaxedOut = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isMaxedOut
                ? (isDark 
                    ? Colors.red.withOpacity(0.08) 
                    : Colors.red.withOpacity(0.05))
                : (isDark
                    ? Colors.white.withOpacity(0.08)
                    : Colors.white.withOpacity(0.7)),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
                color: isMaxedOut
                    ? Colors.red.withOpacity(0.3)
                    : (isDark
                        ? Colors.white.withOpacity(0.15)
                        : Colors.white.withOpacity(0.1))),
            boxShadow: [
              BoxShadow(
                color: isMaxedOut
                    ? Colors.red.withOpacity(0.2)
                    : (isDark
                        ? Colors.black.withOpacity(0.25)
                        : Colors.black.withOpacity(0.15)),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
