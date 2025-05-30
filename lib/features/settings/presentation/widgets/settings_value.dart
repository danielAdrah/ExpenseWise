// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../../../../core/theme/app_color.dart';

class SettingsValue extends StatelessWidget {
  final String name;
  final IconData icon;
  Widget? child;
  void Function()? onTap2;
  SettingsValue({
    super.key,
    required this.name,
    required this.icon,
    required this.child,
    required this.onTap2,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: TColor.white,
                ),
                const SizedBox(width: 8),
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleMedium,
                  // TextStyle(
                  //   color: TColor.white,
                  // ),
                ),
              ],
            ),
            InkWell(
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
