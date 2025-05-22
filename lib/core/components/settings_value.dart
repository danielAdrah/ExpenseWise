import 'package:flutter/material.dart';

// ignore: must_be_immutable
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
                  color: Theme.of(context).colorScheme.inversePrimary,
                  size: 27,
                ),
                const SizedBox(width: 8),
                Text(name,
                    style: TextStyle(
                      fontFamily: 'Arvo',
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    )),
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
