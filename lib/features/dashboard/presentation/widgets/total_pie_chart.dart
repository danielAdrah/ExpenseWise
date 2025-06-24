import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class InteractivePieChart extends StatefulWidget {
  final List<Map<String, dynamic>> expenseData;
  final Function(String?) onCategorySelected;
  final String? selectedCategory;

  const InteractivePieChart({
    Key? key,
    required this.expenseData,
    required this.onCategorySelected,
    this.selectedCategory,
  }) : super(key: key);

  @override
  State<InteractivePieChart> createState() => _InteractivePieChartState();
}

class _InteractivePieChartState extends State<InteractivePieChart> {
  int touchedIndex = -1;

  // Category colors map with visually distinct, accessible colors
  final Map<String, Color> categoryColors = {
    'Transport': const Color(0xFFFF9800), // Vibrant Orange
    'Food': const Color(0xFF2196F3), // Bright Blue
    'Utilities': const Color(0xFF4CAF50), // Green
    'Housing': const Color(0xFF9C27B0), // Purple
    'Shopping': const Color(0xFFE91E63), // Pink
    'HealthCare': const Color(0xFF00BCD4), // Cyan
    'Education': const Color(0xFFFF5252), // Red
  };

  @override
  Widget build(BuildContext context) {
    // Group expenses by category and calculate totals
    final Map<String, double> categoryTotals = {};
    double totalExpenses = 0;

    for (var expense in widget.expenseData) {
      final category = expense['category'] as String;
      final price = (expense['price'] as num).toDouble();
      final quantity = (expense['quantity'] as num? ?? 1).toDouble();
      final total = price * quantity;

      categoryTotals[category] = (categoryTotals[category] ?? 0) + total;
      totalExpenses += total;
    }

    // Filter out categories with zero expenses
    final nonZeroCategories =
        categoryTotals.entries.where((entry) => entry.value > 0).toList();

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 180,
              width: 180,
              child: FadeInDown(
                delay: const Duration(milliseconds: 400),
                child: PieChart(
                  PieChartData(
                    pieTouchData: PieTouchData(
                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                        // Handle touch events with single tap
                        setState(() {
                          if (!event.isInterestedForInteractions ||
                              pieTouchResponse == null ||
                              pieTouchResponse.touchedSection == null) {
                            touchedIndex = -1;
                            return;
                          }

                          touchedIndex = pieTouchResponse
                              .touchedSection!.touchedSectionIndex;

                          // Get the category name for the touched section
                          if (touchedIndex >= 0 &&
                              touchedIndex < nonZeroCategories.length) {
                            final selectedCategory =
                                nonZeroCategories[touchedIndex].key;

                            // Toggle selection - if already selected, clear it
                            if (widget.selectedCategory == selectedCategory) {
                              widget.onCategorySelected(null);
                            } else {
                              widget.onCategorySelected(selectedCategory);
                            }
                          }
                        });
                      },
                    ),
                    startDegreeOffset: 100,
                    centerSpaceRadius: 75,
                    sectionsSpace: 6,
                    sections: nonZeroCategories.isEmpty
                        ? [
                            // Show empty state if no data
                            PieChartSectionData(
                              color: Colors.grey.withOpacity(0.3),
                              value: 100,
                              title: '',
                              radius: 35,
                              titleStyle: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                fontFamily: "Poppins",
                              ),
                            )
                          ]
                        : List.generate(nonZeroCategories.length, (i) {
                            final isSelected = widget.selectedCategory ==
                                nonZeroCategories[i].key;
                            final isTouched = i == touchedIndex;
                            final double fontSize =
                                (isTouched || isSelected) ? 15 : 14;
                            final double radius =
                                (isTouched || isSelected) ? 40 : 35;
                            final entry = nonZeroCategories[i];

                            // Calculate percentage
                            final percentage = totalExpenses > 0
                                ? (entry.value / totalExpenses * 100).round()
                                : 0;

                            return PieChartSectionData(
                              color: categoryColors[entry.key] ?? Colors.grey,
                              value: entry.value,
                              title: '$percentage%',
                              titleStyle: TextStyle(
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                fontFamily: "Poppins",
                              ),
                              radius: radius,
                              titlePositionPercentageOffset: 0.5,
                              borderSide: isSelected && !isTouched
                                  ? BorderSide(color: Colors.white, width: 2)
                                  : BorderSide.none,
                            );
                          }),
                  ),
                ),
              ),
            ),
            ZoomInDown(
              delay: const Duration(milliseconds: 500),
              child: Text(
                "Expenses",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontFamily: 'Arvo',
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 40),
        // Legend
        Wrap(
          spacing: 10,
          runSpacing: 8,
          children: nonZeroCategories.isEmpty
              ? [
                  ZoomIn(
                    delay: const Duration(milliseconds: 800),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 6,
                          backgroundColor: Colors.grey.withOpacity(0.3),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "No expenses found",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontFamily: 'Poppins',
                          ),
                        )
                      ],
                    ),
                  )
                ]
              : List.generate(nonZeroCategories.length, (i) {
                  final category = nonZeroCategories[i].key;
                  final isSelected = widget.selectedCategory == category;
                  final percentage = totalExpenses > 0
                      ? (nonZeroCategories[i].value / totalExpenses * 100)
                          .round()
                      : 0;

                  return ZoomIn(
                    delay: const Duration(milliseconds: 800),
                    child: GestureDetector(
                      onTap: () {
                        // Toggle selection on tap
                        if (isSelected) {
                          widget.onCategorySelected(
                              null); // Clear filter if already selected
                        } else {
                          widget.onCategorySelected(category); // Apply filter
                        }
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 6,
                            backgroundColor:
                                categoryColors[category] ?? Colors.grey,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            category,
                            style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                              fontFamily: 'Poppins',
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                              decoration:
                                  isSelected ? TextDecoration.underline : null,
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }),
        )
      ],
    );
  }
}
