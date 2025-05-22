import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Text(
      title,
      style: TextStyle(
          color: theme.onPrimary,
          fontFamily: "Poppins",
          fontSize: 15,
          fontWeight: FontWeight.w600),
    );
  }
}
