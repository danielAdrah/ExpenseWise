import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyListTile extends StatefulWidget {
  final String type;
  final String title;
  final String price;
  final DateTime date;

  const MyListTile({
    super.key,
    required this.type,
    required this.title,
    required this.price,
    required this.date,
  });

  @override
  State<MyListTile> createState() => _MyListTileState();
}

class _MyListTileState extends State<MyListTile> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withOpacity(0.08)
                : Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: isDark
                    ? Colors.white.withOpacity(0.15)
                    : Colors.white.withOpacity(0.1)),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.black.withOpacity(0.25)
                    : Colors.black.withOpacity(0.15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ListTile(
            leading:

                //     Icon(
                //   Icons.fastfood_outlined,
                //   size: 33,
                //   color: Theme.of(context).colorScheme.inversePrimary,
                // ),
                CircleAvatar(
              backgroundColor:
                  // TColor.secondaryG,
                  theme.primary,
              radius: 25,
              child: _getCategoryIcon(widget.type, theme),
            ),
            title: Text(
              widget.title,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              '${widget.date.day}/${widget.date.month}/${widget.date.year}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.inversePrimary,
                fontFamily: 'Arvo',
                fontSize: 13,
              ),
            ),
            trailing: Column(
              children: [
                const SizedBox(height: 10),
                Text(
                  widget.type,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontFamily: 'Poppins',
                    fontSize: 13,
                  ),
                ),
                Text(
                  '\$${widget.price}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontFamily: 'Arvo',
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            textColor: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
      ),
    );
  }

  Widget _getCategoryIcon(String category, ColorScheme theme) {
    switch (category.toLowerCase()) {
      case 'food':
        return const Icon(Icons.restaurant, color: Colors.white);
      case 'transportation':
        return const Icon(CupertinoIcons.car_detailed, color: Colors.white);
      case 'utilities':
        return const Icon(CupertinoIcons.wrench, color: Colors.white);
      case 'housing':
        return const Icon(Icons.home, color: Colors.white);
      case 'shopping':
        return const Icon(CupertinoIcons.bag_fill, color: Colors.white);
      case 'healthcare':
        return const Icon(Icons.monitor_heart, color: Colors.white);
      case 'education':
        return const Icon(CupertinoIcons.lab_flask, color: Colors.white);
      default:
        return const Icon(Icons.category, color: Colors.white);
    }
  }
}
