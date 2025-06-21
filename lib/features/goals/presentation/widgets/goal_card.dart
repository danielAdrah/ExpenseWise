import 'dart:ui';
import 'package:flutter/material.dart';
// import 'package:percent_indicator/linear_percent_indicator.dart';

class GoalCard extends StatelessWidget {
  final String img;
  final double width;
  final double height;
  final String goalName;
  final String current;
  final String finalBalance;
  final String date;
  final double progress;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final Object tag;

  const GoalCard({
    super.key,
    required this.img,
    required this.width,
    required this.height,
    required this.goalName,
    required this.current,
    required this.finalBalance,
    required this.date,
    required this.progress,
    required this.onTap,
    required this.onDelete,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: const EdgeInsets.all(16),
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
            child: Column(
              children: [
                Row(
                  children: [
                    Hero(
                      tag: tag,
                      child: Image.asset(
                        img,
                        width: 50,
                        height: 50,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  goalName,
                                  style: TextStyle(
                                    color: theme.inversePrimary,
                                    fontFamily: 'Poppins',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete_outline,
                                  color: theme.inversePrimary.withOpacity(0.7),
                                  size: 20,
                                ),
                                onPressed: onDelete,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Deadline: $date",
                            style: TextStyle(
                              color: theme.inversePrimary.withOpacity(0.7),
                              fontFamily: 'Poppins',
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // LinearPercentIndicator(
                //   lineHeight: 8.0,
                //   percent: progress,
                //   backgroundColor: TColor.primary.withOpacity(0.2),
                //   progressColor: TColor.primary,
                //   barRadius: const Radius.circular(4),
                //   padding: EdgeInsets.zero,
                //   animation: true,
                //   animationDuration: 1000,
                // ),
                // const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "\$$current",
                      style: TextStyle(
                        color: theme.inversePrimary,
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "\$$finalBalance",
                      style: TextStyle(
                        color: theme.inversePrimary,
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
