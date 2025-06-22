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

    // Check if limit is maxed out
    final bool isMaxedOut = spendAmount >= totalAmount;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        // Change background color for maxed-out limits
        color: isMaxedOut
            ? Colors.red.withOpacity(0.1) // Red tint for maxed-out limits
            : theme.onSecondaryContainer,
        borderRadius: BorderRadius.circular(16),
        // Add a border for maxed-out limits
        border: isMaxedOut
            ? Border.all(color: Colors.red.withOpacity(0.5), width: 1.5)
            : null,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              // Category icon with different background for maxed-out limits
              CircleAvatar(
                backgroundColor: isMaxedOut
                    ? Colors.red.withOpacity(0.2)
                    : theme.onInverseSurface,
                child: _getCategoryIcon(limitCategory, theme, isMaxedOut),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(limitCategory,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              // Smaller font size for Transportation
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              color: isMaxedOut
                                  ? Colors.red
                                  : theme.inversePrimary,
                            )),
                        // Add a badge for maxed-out limits
                        if (isMaxedOut) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 1.4),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'Done',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      'You spent \$${spendAmount.toStringAsFixed(0)}',
                      style: TextStyle(
                        // Smaller font size for Transportation
                        fontSize: 14,
                        color: isMaxedOut
                            ? Colors.red.shade700
                            : theme.inversePrimary,
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
                        color: isMaxedOut ? Colors.red : theme.inversePrimary,
                      )),
                  Text(
                    isMaxedOut
                        ? 'Exceeded by \$${(-remaining).toStringAsFixed(0)}'
                        : '\$${remaining.toStringAsFixed(0)} left to spend',
                    style: TextStyle(
                      fontSize: 12,
                      color: isMaxedOut ? Colors.red : null,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Progress bar with different colors for maxed-out limits
          LinearProgressIndicator(
            value: progress,
            minHeight: 6,
            backgroundColor: isMaxedOut
                ? Colors.red.withOpacity(0.2)
                : theme.onInverseSurface,
            valueColor: AlwaysStoppedAnimation(
              isMaxedOut ? Colors.red : theme.primary,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _getCategoryIcon(String category, ColorScheme theme, bool isMaxedOut) {
    final iconColor = isMaxedOut ? Colors.red : theme.primary;

    switch (category.toLowerCase()) {
      case 'food':
        return Icon(Icons.restaurant, color: iconColor);
      case 'transport':
        return Icon(CupertinoIcons.car_detailed, color: iconColor);
      case 'utilities':
        return Icon(Icons.power, color: iconColor);
      case 'housing':
        return Icon(Icons.home, color: iconColor);
      case 'shopping':
        return Icon(CupertinoIcons.bag_fill, color: iconColor);
      case 'healthcare':
        return Icon(Icons.monitor_heart, color: iconColor);
      case 'education':
        return Icon(Icons.school, color: iconColor);
      default:
        return Icon(Icons.category, color: iconColor);
    }
  }
}
