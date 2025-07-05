// ignore_for_file: avoid_print

import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';

class SubPireChart extends StatefulWidget {
  final String mainCategory;

  const SubPireChart({
    Key? key,
    required this.mainCategory,
  }) : super(key: key);

  @override
  State<SubPireChart> createState() => _SubPireChartState();
}

class _SubPireChartState extends State<SubPireChart> {
  int touchedIndex = -1;
  String? selectedCategory;
  bool isLoading = true;
  Map<String, double> subcategoryTotals = {};
  final GetStorage storage = GetStorage();

  @override
  void initState() {
    super.initState();
    fetchSubcategoryExpenses();
  }

  // Method to fetch expenses filtered by main category and grouped by subcategory
  Future<void> fetchSubcategoryExpenses() async {
    setState(() {
      isLoading = true;
    });

    try {
      final accountId = storage.read('selectedAcc') ?? "";
      if (accountId.isEmpty) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      print(
          "Fetching expenses for account: $accountId and category: ${widget.mainCategory}");

      // First, check if we need to query by main category or subcategories
      final subcategories =
          getSubcategoriesForMainCategory(widget.mainCategory);

      // Query Firestore for expenses
      QuerySnapshot snapshot;

      // Try to find expenses where category is the main category
      snapshot = await FirebaseFirestore.instance
          .collection('expenses')
          .where("accountId", isEqualTo: accountId)
          .where("category", isEqualTo: widget.mainCategory)
          .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      print("Found ${snapshot.docs.length} expenses with main category");

      // If no results, try to find expenses where category is one of the subcategories
      if (snapshot.docs.isEmpty) {
        snapshot = await FirebaseFirestore.instance
            .collection('expenses')
            .where("accountId", isEqualTo: accountId)
            .where("category", whereIn: subcategories)
            .get();

        print("Found ${snapshot.docs.length} expenses with subcategories");
      }

      // Group expenses by subcategory and calculate totals
      final Map<String, double> totals = {};

      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        print("Processing expense: $data");

        // Determine the subcategory
        String subcategory;
        if (data['category'] == widget.mainCategory &&
            data.containsKey('subCategory')) {
          // If the category is the main category, use the subCategory field
          subcategory = data['subCategory'] as String;
        } else {
          // Otherwise, use the category field as the subcategory
          subcategory = data['category'] as String;
        }

        final price = (data['price'] as num).toDouble();
        final quantity = (data['quantity'] as num? ?? 1).toDouble();
        final amount = price * quantity;

        totals[subcategory] = (totals[subcategory] ?? 0) + amount;
      }

      print("Final subcategory totals: $totals");

      setState(() {
        subcategoryTotals = totals;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching subcategory expenses: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  // Helper method to get subcategories for a main category
  List<String> getSubcategoriesForMainCategory(String mainCategory) {
    final Map<String, List<String>> categoryData = {
      "Transport": ["Car", "Train", "Plane"],
      "Food": ["Groceries", "Restaurant", "Snacks", "Drinks"],
      "Utilities": ["Electricity", "Water", "Internet"],
      "Housing": ["Rent", "House Fixing", "Furniture"],
      "Shopping": ['Electronics', 'Clothing', 'Home Goods'],
      "HealthCare": ['Therapy', 'Medicin', 'Doctor Visits'],
      "Education": ['Tuition Fees', 'Courses', 'Books&Supplies'],
    };

    return categoryData[mainCategory] ?? [];
  }

  // Category colors map with visually distinct, accessible colors that work in both light and dark themes
  final Map<String, Color> categoryColors = {
    // Transport subcategories
    'Car': const Color(0xFF42A5F5), // Blue
    'Train': const Color(0xFFEC407A), // Pink
    'Plane': const Color(0xFF66BB6A), // Green
    'Bus': const Color(0xFFFFD54F), // Amber
    'Taxi': const Color(0xFFFF7043), // Deep Orange

    // Food subcategories
    'Groceries': const Color(0xFF26A69A), // Teal
    'Restaurant': const Color(0xFFAB47BC), // Purple
    'Snacks': const Color(0xFFEF5350), // Red
    'Drinks': const Color(0xFF5C6BC0), // Indigo

    // Utilities subcategories
    'Electricity': const Color(0xFFFFCA28), // Amber
    'Water': const Color(0xFF29B6F6), // Light Blue
    'Internet': const Color(0xFFFF8A65), // Deep Orange

    // Housing subcategories
    'Rent': const Color(0xFF7E57C2), // Deep Purple
    'House Fixing': const Color(0xFFFFB74D), // Orange
    'Furniture': const Color(0xFF9CCC65), // Light Green

    // Shopping subcategories
    'Electronics': const Color(0xFF5C6BC0), // Indigo
    'Clothing': const Color(0xFFEC407A), // Pink
    'Home Goods': const Color(0xFF66BB6A), // Green

    // HealthCare subcategories
    'Therapy': const Color(0xFF26A69A), // Teal
    'Medicin': const Color(0xFFEF5350), // Red
    'Doctor Visits': const Color(0xFF42A5F5), // Blue

    // Education subcategories
    'Tuition Fees': const Color(0xFFAB47BC), // Purple
    'Courses': const Color(0xFFFF7043), // Deep Orange
    'Books&Supplies': const Color(0xFF29B6F6), // Light Blue
  };

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SizedBox(
        height: 200, // Maintain the same height as the loaded chart
        child: Center(
          child: Text(
            "Loading...",
            style: TextStyle(
              color: Colors.transparent, // Make text invisible
            ),
          ),
        ),
      );
    }

    // Calculate total expenses
    final totalExpenses =
        subcategoryTotals.values.fold(0.0, (sum, value) => sum + value);

    // Filter out categories with zero expenses
    final nonZeroCategories =
        subcategoryTotals.entries.where((entry) => entry.value > 0).toList();

    if (nonZeroCategories.isEmpty) {
      return SizedBox(
        height: 200, // Maintain consistent height
        child: Center(
          child: Text(
            "No expenses found for ${widget.mainCategory}",
            style: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
              fontFamily: 'Poppins',
            ),
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        touchedIndex = -1;
                        return;
                      }

                      touchedIndex =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;

                      // Get the category name for the touched section
                      if (touchedIndex >= 0 &&
                          touchedIndex < nonZeroCategories.length) {
                        final category = nonZeroCategories[touchedIndex].key;

                        // Toggle selection
                        selectedCategory =
                            selectedCategory == category ? null : category;
                      }
                    });
                  },
                ),
                startDegreeOffset: 0,
                centerSpaceRadius:
                    0, // Add a hole in the center for better appearance
                sectionsSpace: 2,
                sections: List.generate(nonZeroCategories.length, (i) {
                  final isSelected =
                      selectedCategory == nonZeroCategories[i].key;
                  final isTouched = i == touchedIndex;
                  final double fontSize = (isTouched || isSelected) ? 15 : 14;
                  final double radius = (isTouched || isSelected) ? 80 : 75;
                  final entry = nonZeroCategories[i];

                  // Calculate percentage
                  final percentage = totalExpenses > 0
                      ? (entry.value / totalExpenses * 100).round()
                      : 0;

                  // Get color from map or generate a consistent color if not found
                  final Color baseColor = categoryColors[entry.key] ??
                      Color(entry.key.hashCode | 0xFF000000).withOpacity(0.8);

                  return PieChartSectionData(
                    color: baseColor,
                    value: entry.value,
                    title: '$percentage%',
                    titleStyle: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontFamily: "Poppins",
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 2,
                          offset: const Offset(1, 1),
                        ),
                      ],
                    ),
                    radius: radius,
                    titlePositionPercentageOffset: 0.5,
                    borderSide: isSelected || isTouched
                        ? BorderSide(color: Colors.white, width: 2)
                        : BorderSide.none,
                    badgeWidget: isSelected || isTouched
                        ? _Badge(
                            entry.key,
                            '\$${entry.value.toStringAsFixed(2)}',
                            baseColor,
                          )
                        : null,
                    badgePositionPercentageOffset: 1.1,
                  );
                }),
              ),
            ),
          ),
        ),

        SizedBox(width: MediaQuery.of(context).size.width * 0.03),
        // Legend with enhanced interactivity
        Expanded(
          child: Wrap(
            direction: Axis.vertical,
            spacing: 5,
            runSpacing: 8,
            children: List.generate(nonZeroCategories.length, (i) {
              final category = nonZeroCategories[i].key;
              final isSelected = selectedCategory == category;
              final amount = nonZeroCategories[i].value;
              final percentage = totalExpenses > 0
                  ? (amount / totalExpenses * 100).round()
                  : 0;

              // Get color from map or generate a consistent color if not found
              final Color baseColor = categoryColors[category] ??
                  Color(category.hashCode | 0xFF000000).withOpacity(0.8);

              return ZoomIn(
                delay: const Duration(milliseconds: 800),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      // Toggle selection on tap
                      selectedCategory = isSelected ? null : category;
                    });
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? baseColor.withOpacity(0.2)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? baseColor : Colors.transparent,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: isSelected ? 10 : 8,
                          height: isSelected ? 10 : 8,
                          decoration: BoxDecoration(
                            color: baseColor,
                            shape: BoxShape.circle,
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: baseColor.withOpacity(0.5),
                                      blurRadius: 4,
                                      spreadRadius: 1,
                                    )
                                  ]
                                : null,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          category,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontFamily: 'Poppins',
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        const SizedBox(width: 4),
                        if (isSelected)
                          Text(
                            '($percentage%)',
                            style: TextStyle(
                              color: baseColor,
                              fontFamily: 'Poppins',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        )
      ],
    );
  }
}

// Badge widget to show when a section is selected or touched
class _Badge extends StatelessWidget {
  final String category;
  final String amount;
  final Color color;

  const _Badge(this.category, this.amount, this.color);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            category,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),
          ),
          Text(
            amount,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }
}
