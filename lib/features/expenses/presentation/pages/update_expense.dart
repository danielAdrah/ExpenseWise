// ignore_for_file: unused_local_variable

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/components/custom_button.dart';
import '../../../../core/components/gradient_icon.dart';
import '../../../../core/components/gradient_text.dart';
import '../../../../core/components/inline_nav_bar.dart';
import '../../../../core/components/rounded_textField.dart';

class EditExpense extends StatefulWidget {
  const EditExpense({super.key});

  @override
  State<EditExpense> createState() => _EditExpenseState();
}

class _EditExpenseState extends State<EditExpense> {
  DateTime date = DateTime.now();
  String? selectedCategory;
  String? selectedSubcategory;
  bool showSubcategories = false;

  final Map<String, List<String>> categoryData = {
    "Transport": ["Car", "Train", "Plane"],
    "Food": ["Groceries", "Restaurant", "Snacks"],
    "Utilities": ["Electricity", "Water", "Internet"],
  };

  final Map<String, List<Color>> categoryGradients = {
    "Transport": const [Color(0xFF17a2b8), Color(0xFF0d9488)],
    "Food": [const Color(0xFFFF416C), const Color(0xFFFF4B2B)],
    "Utilities": [const Color(0xFF36D1DC), const Color(0xFF5B86E5)],
  };
  final Map<String, IconData> categoryIcon = {
    "Transport": CupertinoIcons.car_detailed,
    "Food": CupertinoIcons.cart,
    "Utilities": CupertinoIcons.wrench,
  };

  final Map<String, IconData> subcategoryIcon = {
    "Car": CupertinoIcons.car,
    "Train": Icons.train_outlined,
    "Plane": CupertinoIcons.airplane,
    "Groceries": CupertinoIcons.shopping_cart,
    "Restaurant": Icons.restaurant_menu_outlined,
    "Snacks": Icons.food_bank_outlined,
    "Electricity": Icons.electric_bolt_outlined,
    "Water": Icons.water_drop_rounded,
    "Internet": CupertinoIcons.wifi
  };
  final Map<String, List<Color>> subcategoryGradients = {
    "Car": const [Color(0xFFef4444), Color(0xFFfb923c)],
    "Train": [const Color(0xFF6190E8), const Color(0xFFA7BFE8)],
    "Plane": [const Color(0xFF1FA2FF), const Color(0xFF12D8FA)],
    "Groceries": [const Color(0xFF56ab2f), const Color(0xFFA8E063)],
    "Restaurant": [const Color(0xFFf12711), const Color(0xFFf5af19)],
    "Snacks": [const Color(0xFFe96443), const Color(0xFF904e95)],
    "Electricity": [
      const Color.fromARGB(255, 129, 122, 120),
      const Color(0xFFf7b733)
    ],
    "Water": [const Color(0xFF00c6ff), const Color(0xFF0072ff)],
    "Internet": [const Color(0xFF7F00FF), const Color(0xFFE100FF)],
  };

  void _onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
      selectedSubcategory = null;
      showSubcategories = true;
    });
  }

  void _onSubcategorySelected(String subcategory) {
    setState(() {
      selectedSubcategory = subcategory;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    // final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final media = MediaQuery.of(context).size;
    final subcategories =
        selectedCategory != null ? categoryData[selectedCategory] ?? [] : [];

    return Scaffold(
      backgroundColor: theme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const InlineNavBar(title: "Edit Expense"),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    FadeInDown(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.decelerate,
                      child: Text(
                        "Selcet New Category",
                        style: TextStyle(
                          color: theme.inversePrimary,
                          fontFamily: 'Poppins',
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      children: categoryData.keys.map((category) {
                        final gradient = categoryGradients[category]!;
                        final icons = categoryIcon[category]!;
                        return ZoomInDown(
                          duration: const Duration(milliseconds: 700),
                          child: buildGradientChip(
                            label: category,
                            icon: icons,
                            gradientColors: gradient,
                            selected: selectedCategory == category,
                            onTap: () => _onCategorySelected(category),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 400),
                      opacity: showSubcategories ? 1.0 : 0.0,
                      child: showSubcategories
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Select Subcategory",
                                  style: TextStyle(
                                    color: theme.inversePrimary,
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Wrap(
                                  spacing: 8,
                                  children: subcategories.map((subcategory) {
                                    final icons =
                                        subcategoryIcon[subcategory] ??
                                            Icons.add;
                                    final gradient =
                                        subcategoryGradients[subcategory] ??
                                            [Colors.grey, Colors.grey.shade700];
                                    return buildGradientChip(
                                      label: subcategory,
                                      gradientColors: gradient,
                                      icon: icons,
                                      selected:
                                          selectedSubcategory == subcategory,
                                      onTap: () =>
                                          _onSubcategorySelected(subcategory),
                                    );
                                  }).toList(),
                                ),
                              ],
                            )
                          : const SizedBox(),
                    ),
                    const SizedBox(height: 50),
                    FadeInDown(
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.decelerate,
                      child: RoundedTextField(
                          title: "Expense Title",
                          onIconPressed: () {},
                          preIcon: Icons.view_headline_sharp),
                    ),
                    const SizedBox(height: 25),
                    FadeInDown(
                      duration: const Duration(milliseconds: 900),
                      curve: Curves.decelerate,
                      child: RoundedTextField(
                          title: "Expense Quantity",
                          onIconPressed: () {},
                          preIcon: CupertinoIcons.bag_fill_badge_plus),
                    ),
                    const SizedBox(height: 25),
                    FadeInDown(
                      duration: const Duration(milliseconds: 900),
                      curve: Curves.decelerate,
                      child: RoundedTextField(
                          title: "Expense Price",
                          onIconPressed: () {},
                          preIcon: Icons.attach_money_outlined),
                    ),
                    const SizedBox(height: 60),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: ZoomInDown(
                          duration: const Duration(milliseconds: 1000),
                          child:
                              CustomButton(title: "Create", onPressed: () {})),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //========GRADIENT CHIP
  Widget buildGradientChip({
    required String label,
    required IconData icon,
    required List<Color> gradientColors,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradientColors),
          borderRadius: BorderRadius.circular(30),
          boxShadow: selected
              ? [
                  BoxShadow(
                      color: gradientColors.last.withOpacity(0.5),
                      blurRadius: 11)
                ]
              : [],
        ),
        child: Container(
          // margin: EdgeInsets.symmetric(horizontal: 1, vertical: 2),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            // gradient: LinearGradient(colors: gradientColors),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GradientIcon(
                icon: icon,
                size: 15,
                gradient: LinearGradient(colors: gradientColors),
              ),
              const SizedBox(width: 5),
              GradientText(
                label,
                gradient: LinearGradient(colors: gradientColors),
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: "Arvo",
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
