import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SpendingLimitCard extends StatelessWidget {
  final String limitCategory;
  final double totalAmount;
  final double spendAmount;
  final double remainedAmount;

  const SpendingLimitCard({
    required this.limitCategory,
    required this.totalAmount,
    required this.spendAmount,
    required this.remainedAmount,
  });

  @override
  Widget build(BuildContext context) {
    final remaining = totalAmount - spendAmount;
    final progress = (spendAmount / totalAmount).clamp(0.0, 1.0);
    final theme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: theme.onSecondaryContainer, // Improved inner container color
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: theme.onInverseSurface,
                child: _getCategoryIcon(limitCategory, theme),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(limitCategory,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          color: theme.inversePrimary,
                        )),
                    Text(
                      'You spent \$${spendAmount.toStringAsFixed(0)}',
                      style: TextStyle(
                        color: theme.inversePrimary,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('\$${totalAmount.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        color: theme.inversePrimary,
                      )),
                  Text('\$${remaining.toStringAsFixed(0)} left to spend',
                      style: const TextStyle(fontSize: 12)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: theme.onInverseSurface,
            valueColor: AlwaysStoppedAnimation(theme.primary),
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _getCategoryIcon(String category, ColorScheme theme) {
    switch (category.toLowerCase()) {
      case 'food':
        return Icon(Icons.restaurant, color: theme.primary);
      case 'transportation':
        return Icon(CupertinoIcons.car_detailed, color: theme.primary);
      case 'utilities':
        return Icon(CupertinoIcons.wrench, color: theme.primary);
      case 'housing':
        return Icon(Icons.home, color: theme.primary);
      case 'shopping':
        return Icon(CupertinoIcons.bag_fill, color: theme.primary);
      case 'healthcare':
        return Icon(Icons.monitor_heart, color: theme.primary);
      case 'education':
        return Icon(CupertinoIcons.lab_flask, color: theme.primary);
      default:
        return Icon(Icons.category, color: theme.primary);
    }
  }
}
