// ignore_for_file: unused_local_variable, avoid_print, non_constant_identifier_names

import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../core/components/gradient_icon.dart';
import '../../../../core/components/gradient_text.dart';
import '../../../../core/components/icon_custom_btn.dart';
import '../../../../core/components/methods.dart';
import '../../../../core/theme/app_color.dart';
import '../../domain/entities/expense_entity.dart';
import '../bloc/expense_bloc.dart';
import '../bloc/expense_event.dart';
import '../bloc/expense_state.dart';

class CreateExpenseView extends StatefulWidget {
  const CreateExpenseView({super.key});

  @override
  State<CreateExpenseView> createState() => _CreateExpenseViewState();
}

class _CreateExpenseViewState extends State<CreateExpenseView> {
  // DateTime date = DateTime.now();
  String? selectedCategory;
  String? selectedSubcategory;
  bool showSubcategories = false;
  final expTitle = TextEditingController();
  final expQuan = TextEditingController();
  final expPrice = TextEditingController();

  void clearField() {
    expTitle.clear();
    expQuan.clear();
    expPrice.clear();
  }

  final GetStorage storage = GetStorage();

  final Map<String, List<String>> categoryData = {
    "Transport": ["Car", "Train", "Plane"],
    "Food": ["Groceries", "Restaurant", "Snacks", "Drinks"],
    "Utilities": ["Electricity", "Water", "Internet"],
    "Housing": ["Rent", "House Fixing", "Furniture"],
    "Shopping": ['Electronics', 'Clothing', 'Home Goods'],
    "HealthCare": ['Therapy', 'Medicin', 'Docotr Visits'],
    "Education": ['Tution Fees', 'Courses', 'Books&Supplies'],
  };

  final Map<String, List<Color>> categoryGradients = {
    "Transport": const [Color(0xFF17a2b8), Color(0xFF0d9488)],
    "Food": [const Color(0xFFFF416C), const Color(0xFFFF4B2B)],
    "Utilities": const [Color(0xFFFFC107), Color(0xFFFF8F00)],
    "Housing": const [Color(0xFFFF6B6B), Color(0xFFFFA17F)],
    "Shopping": const [Color(0xFFFF5FA2), Color(0xFF8E44AD)],
    "HealthCare": const [
      Color.fromARGB(255, 104, 68, 223),
      Color.fromARGB(255, 95, 72, 197)
    ],
    "Education": const [Color(0xFF43C6AC), Color.fromARGB(255, 82, 76, 180)],
  };

  final Map<String, IconData> categoryIcon = {
    "Transport": CupertinoIcons.car_detailed,
    "Food": CupertinoIcons.cart,
    "Utilities": Icons.power,
    "Housing": CupertinoIcons.house,
    "Shopping": CupertinoIcons.bag_fill,
    "HealthCare": Icons.monitor_heart,
    "Education": Icons.school,
  };

  final Map<String, IconData> subcategoryIcon = {
    "Car": CupertinoIcons.car,
    "Train": Icons.train_outlined,
    "Plane": CupertinoIcons.airplane,
    //----
    "Groceries": CupertinoIcons.shopping_cart,
    "Restaurant": Icons.restaurant_menu_outlined,
    "Snacks": Icons.cake_outlined,
    "Drinks": Icons.emoji_food_beverage_rounded,
    //-----
    "Electricity": Icons.electric_bolt_outlined,
    "Water": Icons.water_drop_rounded,
    "Internet": CupertinoIcons.wifi,
    //-----
    "Rent": Icons.other_houses_outlined,
    "House Fixing": Icons.tips_and_updates_outlined,
    "Furniture": Icons.chair,
    //-----
    "Electronics": Icons.electrical_services_rounded,
    "Clothing": CupertinoIcons.eyeglasses,
    "Home Goods": CupertinoIcons.bag_badge_plus,
    //-----
    "Therapy": Icons.transcribe_outlined,
    "Medicin": Icons.medication_rounded,
    "Docotr Visits": Icons.local_hospital,
    //-----
    'Tution Fees': Icons.money,
    "Courses": CupertinoIcons.device_laptop,
    "Books&Supplies": CupertinoIcons.book_circle_fill,
  };

  final Map<String, List<Color>> subcategoryGradients = {
    "Car": const [Color(0xFFef4444), Color(0xFFfb923c)],
    "Train": [const Color(0xFF6190E8), const Color(0xFFA7BFE8)],
    "Plane": [const Color(0xFF1FA2FF), const Color(0xFF12D8FA)],
    "Groceries": [const Color(0xFF56ab2f), const Color(0xFFA8E063)],
    "Restaurant": [const Color(0xFFf12711), const Color(0xFFf5af19)],
    "Snacks": [const Color(0xFFe96443), const Color(0xFF904e95)],
    "Drinks": const [Color(0xFFFF6A3D), Color(0xFFB83227)],
    "Electricity": [
      const Color.fromARGB(255, 129, 122, 120),
      const Color(0xFFf7b733)
    ],
    "Water": [const Color(0xFF00c6ff), const Color(0xFF0072ff)],
    "Internet": [const Color(0xFF7F00FF), const Color(0xFFE100FF)],
    "Rent": const [Color(0xFFFFC107), Color(0xFFFF8F00)],
    "House Fixing": const [Color(0xFF00BCD4), Color(0xFF3F51B5)],
    "Furniture": const [Color(0xFF757F9A), Color(0xFFD7DDE8)],
    "Electronics": const [
      Color.fromARGB(255, 8, 124, 196),
      Color.fromARGB(255, 82, 83, 190)
    ],
    "Clothing": const [Color(0xFFBBD2C5), Color(0xFF536976)],
    "Home Goods": const [Color(0xFFDA4453), Color(0xFF89216B)],
    "Therapy": const [Color(0xFF00B09B), Color(0xFF96C93D)],
    "Medicin": const [Color(0xFFFF6B6B), Color(0xFFFFA17F)],
    "Docotr Visits": const [
      Color(0xFF43C6AC),
      Color.fromARGB(255, 45, 40, 134)
    ],
    "Tution Fees": const [Color(0xFFBBD2C5), Color(0xFF536976)],
    "Courses": const [Color(0xFFC04848), Color.fromARGB(255, 136, 10, 136)],
    "Books&Supplies": const [Color(0xFFFFC107), Color(0xFFFF8F00)],
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

  void expenseSumbimt() {
    if (selectedCategory == null ||
        selectedSubcategory == null ||
        expTitle.text.isEmpty ||
        expQuan.text.isEmpty ||
        expPrice.text.isEmpty) {
      final Snackbar = Methods().infoSnackBar(
          'Please make sure not to leave any of the fields empty');
      ScaffoldMessenger.of(context).showSnackBar(Snackbar);
      return;
    }

    final expense = ExpenseEntity(
      id: '',
      category: selectedCategory ?? 'try again',
      subCategory: selectedSubcategory ?? 'again',
      name: expTitle.text,
      quantity: int.parse(expQuan.text),
      price: double.parse(expPrice.text),
      createdAt: DateTime.now().toIso8601String(),
      accountId: storage.read('selectedAcc'),
      userId: FirebaseAuth.instance.currentUser!.uid,
    );

    // Add the expense - the limit update will happen in the bloc
    context.read<ExpenseBloc>().add(AddExpenseEvent(expense));

    // Remove the listener that was updating the limit again
    // context.read<ExpenseBloc>().stream.listen((state) {
    //   if (state is AddExpenseDone) {
    //     _updateMatchingSpendingLimit(expense);
    //   }
    // });
  }

  // Keep this method for reference but don't call it
  void _updateMatchingSpendingLimit(ExpenseEntity expense) async {
    // Method implementation remains the same but is not used
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final width = MediaQuery.of(context).size.width;
    final media = MediaQuery.of(context).size;
    final subcategories =
        selectedCategory != null ? categoryData[selectedCategory] ?? [] : [];

    return Scaffold(
      backgroundColor: theme.surface,
      body: SafeArea(
        child: BlocConsumer<ExpenseBloc, ExpenseState>(
          listener: (context, state) {
            if (state is AddExpenseDone) {
              final Snackbar = Methods()
                  .successSnackBar('Your expense is created successfuly');
              ScaffoldMessenger.of(context).showSnackBar(Snackbar);
              clearField();
            } else if (state is AddExpenseError) {
              final Snackbar = Methods().errorSnackBar(state.message);
              ScaffoldMessenger.of(context).showSnackBar(Snackbar);
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                // Background design elements
                Positioned(
                  top: -50,
                  right: -50,
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          TColor.primary.withOpacity(0.2),
                          theme.primary.withOpacity(0.1),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -80,
                  left: -80,
                  child: Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          theme.primary.withOpacity(0.2),
                          TColor.primary.withOpacity(0.1),
                        ],
                      ),
                    ),
                  ),
                ),

                // Main content
                CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    // App Bar
                    SliverAppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      floating: true,
                      pinned: false,
                      expandedHeight: 80,
                      flexibleSpace: FlexibleSpaceBar(
                        title: FadeInDown(
                          duration: const Duration(milliseconds: 400),
                          child: const Text(
                            "Create Expense",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Poppins',
                              fontSize: 19,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        centerTitle: true,
                        background: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                TColor.primary,
                                theme.primary.withOpacity(0.7),
                              ],
                            ),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(25),
                              bottomRight: Radius.circular(25),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Main content
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          const SizedBox(height: 20),

                          // Category selection section
                          FadeInDown(
                            duration: const Duration(milliseconds: 500),
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: theme.surface,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              TColor.primary.withOpacity(0.2),
                                              theme.primary.withOpacity(0.5),
                                            ],
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Icon(
                                          Icons.category_rounded,
                                          color: TColor.primary,
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        "Select Category",
                                        style: TextStyle(
                                          color: theme.inversePrimary,
                                          fontFamily: 'Poppins',
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    physics: const BouncingScrollPhysics(),
                                    child: Wrap(
                                      spacing: 8,
                                      children:
                                          categoryData.keys.map((category) {
                                        final gradient =
                                            categoryGradients[category]!;
                                        final icons = categoryIcon[category]!;
                                        return ZoomInDown(
                                          duration:
                                              const Duration(milliseconds: 700),
                                          child: buildGradientChip(
                                            label: category,
                                            icon: icons,
                                            gradientColors: gradient,
                                            selected:
                                                selectedCategory == category,
                                            onTap: () =>
                                                _onCategorySelected(category),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Subcategory selection section
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 400),
                            opacity: showSubcategories ? 1.0 : 0.0,
                            child: showSubcategories
                                ? FadeInDown(
                                    duration: const Duration(milliseconds: 600),
                                    child: Container(
                                      padding: const EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                        color: theme.surface,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.05),
                                            blurRadius: 10,
                                            offset: const Offset(0, 5),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: selectedCategory !=
                                                            null
                                                        ? categoryGradients[
                                                                selectedCategory]!
                                                            .map((c) =>
                                                                c.withOpacity(
                                                                    0.2))
                                                            .toList()
                                                        : [
                                                            TColor.primary
                                                                .withOpacity(
                                                                    0.2),
                                                            TColor.primary2
                                                                .withOpacity(
                                                                    0.2),
                                                          ],
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Icon(
                                                  Icons.style,
                                                  color: selectedCategory !=
                                                          null
                                                      ? categoryGradients[
                                                              selectedCategory]!
                                                          .last
                                                      : TColor.primary,
                                                  size: 20,
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Text(
                                                "Select Subcategory",
                                                style: TextStyle(
                                                  color: theme.inversePrimary,
                                                  fontFamily: 'Poppins',
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 15),
                                          SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            physics:
                                                const BouncingScrollPhysics(),
                                            child: Wrap(
                                              spacing: 8,
                                              children: subcategories
                                                  .map((subcategory) {
                                                final icons = subcategoryIcon[
                                                        subcategory] ??
                                                    Icons.add;
                                                final gradient =
                                                    subcategoryGradients[
                                                            subcategory] ??
                                                        [
                                                          Colors.grey,
                                                          Colors.grey.shade700
                                                        ];
                                                return buildGradientChip(
                                                  label: subcategory,
                                                  gradientColors: gradient,
                                                  icon: icons,
                                                  selected:
                                                      selectedSubcategory ==
                                                          subcategory,
                                                  onTap: () =>
                                                      _onSubcategorySelected(
                                                          subcategory),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                          ),

                          const SizedBox(height: 25),

                          // Form fields section
                          FadeInDown(
                            duration: const Duration(milliseconds: 700),
                            child: Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: theme.surface,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              TColor.primary.withOpacity(0.2),
                                              theme.primary.withOpacity(0.5),
                                            ],
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Icon(
                                          Icons.edit_note,
                                          color: TColor.primary,
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        "Expense Details",
                                        style: TextStyle(
                                          color: theme.inversePrimary,
                                          fontFamily: 'Poppins',
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),

                                  // form fields
                                  _buildEnhancedTextField(
                                    controller: expTitle,
                                    icon: Icons.view_headline_sharp,
                                    label: "Expense Title",
                                    hint: "What did you spend on?",
                                    theme: theme,
                                  ),

                                  const SizedBox(height: 15),

                                  _buildEnhancedTextField(
                                    controller: expQuan,
                                    icon: CupertinoIcons.bag_fill_badge_plus,
                                    label: "Quantity",
                                    hint: "How many items?",
                                    keyboardType: TextInputType.number,
                                    theme: theme,
                                  ),

                                  const SizedBox(height: 15),

                                  _buildEnhancedTextField(
                                    controller: expPrice,
                                    icon: Icons.attach_money_outlined,
                                    label: "Price",
                                    hint: "How much did it cost?",
                                    keyboardType: TextInputType.number,
                                    theme: theme,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),

                          // Submit button
                          state is AddExpenseInProgress
                              ? Center(
                                  child: SpinKitWave(
                                    color: TColor.primary2,
                                    size: 40,
                                  ),
                                )
                              : FadeInUp(
                                  duration: const Duration(milliseconds: 800),
                                  child: IconCustomBtn(
                                    label: 'create expense',
                                    icon: Icons.add_circle_outline,
                                    onTap: expenseSumbimt,
                                  ),
                                ),

                          const SizedBox(height: 30),
                        ]),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Enhanced gradient chip with improved visual feedback
  Widget buildGradientChip({
    required String label,
    required IconData icon,
    required List<Color> gradientColors,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: gradientColors),
          borderRadius: BorderRadius.circular(30),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: gradientColors.last.withOpacity(0.5),
                    blurRadius: 11,
                    offset: const Offset(0, 3),
                  )
                ]
              : [],
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GradientIcon(
                icon: icon,
                size: 16,
                gradient: LinearGradient(colors: gradientColors),
              ),
              const SizedBox(width: 8),
              GradientText(
                label,
                gradient: LinearGradient(colors: gradientColors),
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Arvo",
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                  fontSize: selected ? 14 : 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Enhanced text field with modern styling
  Widget _buildEnhancedTextField({
    required TextEditingController controller,
    required IconData icon,
    required String label,
    required String hint,
    required ColorScheme theme,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5, bottom: 8),
          child: Text(
            label,
            style: TextStyle(
              color: theme.inversePrimary.withOpacity(0.8),
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: theme.surface,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: theme.inversePrimary.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: TextStyle(
              color: theme.inversePrimary,
              fontFamily: 'Poppins',
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: theme.inversePrimary.withOpacity(0.4),
                fontFamily: 'Poppins',
                fontSize: 14,
              ),
              prefixIcon: Icon(
                icon,
                color: theme.primary.withOpacity(0.7),
                size: 20,
              ),
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            ),
          ),
        ),
      ],
    );
  }
}
