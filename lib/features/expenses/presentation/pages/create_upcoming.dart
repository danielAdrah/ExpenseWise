// ignore_for_file: unused_local_variable, non_constant_identifier_names, avoid_print

import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../core/components/custom_button.dart';
import '../../../../core/components/date_text_field.dart';
import '../../../../core/components/gradient_icon.dart';
import '../../../../core/components/gradient_text.dart';
import '../../../../core/components/inline_nav_bar.dart';
import '../../../../core/components/methods.dart';
import '../../../../core/components/rounded_textField.dart';
import '../../../../core/theme/app_color.dart';
import '../../domain/entities/upcoming_expense_entity.dart';
import '../bloc/upcoming_expense_bloc.dart';
import '../bloc/upcoming_expense_event.dart';
import '../bloc/upcoming_expense_state.dart';

class CreateUpcomingExpense extends StatefulWidget {
  const CreateUpcomingExpense({super.key});

  @override
  State<CreateUpcomingExpense> createState() => _CreateUpcomingExpenseState();
}

class _CreateUpcomingExpenseState extends State<CreateUpcomingExpense>
    with TickerProviderStateMixin {
  // DateTime date = DateTime.now();
  String? selectedCategory;
  String? selectedSubcategory;
  bool showSubcategories = false;
  final GetStorage storage = GetStorage();
  final expTitle = TextEditingController();
  final expQuan = TextEditingController();
  final expPrice = TextEditingController();
  final date = TextEditingController();
  

  void clearField() {
    expTitle.clear();
    expQuan.clear();
    expPrice.clear();
  }

  final Map<String, List<String>> categoryData = {
    "Transportation": ["Car", "Train", "Plane"],
    "Food": ["Groceries", "Restaurant", "Snacks", "Drinks"],
    "Utilities": ["Electricity", "Water", "Internet"],
    "Housing": ["Rent", "House Fixing", "Furniture"],
    "Shopping": ['Electronics', 'Clothing', 'Home Goods'],
    "HealthCare": ['Therapy', 'Medicin', 'Docotr Visits'],
    "Education": ['Tution Fees', 'Courses', 'Books&Supplies'],
  };

  final Map<String, List<Color>> categoryGradients = {
    "Transportation": const [Color(0xFF17a2b8), Color(0xFF0d9488)],
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
    "Transportation": CupertinoIcons.car_detailed,
    "Food": CupertinoIcons.cart,
    "Utilities": CupertinoIcons.wrench,
    "Housing": CupertinoIcons.house,
    "Shopping": CupertinoIcons.bag_fill,
    "HealthCare": Icons.monitor_heart,
    "Education": CupertinoIcons.lab_flask,
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

  void upcomingExpenseSumbimt() {
    if (selectedCategory == null ||
        selectedSubcategory == null ||
        expTitle.text.isEmpty ||
        expQuan.text.isEmpty ||
        expPrice.text.isEmpty) {
      final Snackbar = Methods().infoSnackBar(
          'Please make sure not to leave any of the fields empty'
          );
      ScaffoldMessenger.of(context).showSnackBar(Snackbar);
    } else {
      print('================$selectedCategory ,,,,,,,$selectedSubcategory');
      final expense = UpcomingExpenseEntity(
        id: '',
        category: selectedCategory ?? 'try again',
        subCategory: selectedSubcategory ?? 'again',
        name: expTitle.text,
        quantity: int.parse(expQuan.text),
        price: double.parse(expPrice.text),
        date: date.text,
        accountId: storage.read('selectedAcc'),
        userId: FirebaseAuth.instance.currentUser!.uid,
      );
      print(expense.name);
      print(expense.category);
      print(expense.subCategory);
      print(expense.quantity);
      print(expense.price);
      print(expense.date);
      print(expense.accountId);
      print(expense.id);

      context.read<UpcomingExpenseBloc>().add(AddUpcomingExpenseEvent(expense));
      clearField();
    }
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
          child: BlocConsumer<UpcomingExpenseBloc, UpcomingExpenseState>(
            listener: (context, state) {
              if (state is AddUpcomingExpenseDone) {
                final Snackbar = Methods().successSnackBar(
                    'Your upcoming expense is created successfuly');
                ScaffoldMessenger.of(context).showSnackBar(Snackbar);
              }
            },
            builder: (context, state) {
              return Column(
                children: [
                  const SizedBox(height: 20),
                  const InlineNavBar(title: "Create Upcoming"),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 40),
                        FadeInDown(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.decelerate,
                          child: Text(
                            "Selcet Category",
                            style: TextStyle(
                              color: theme.inversePrimary,
                              fontFamily: 'Poppins',
                              fontSize: 19,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          child: Wrap(
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
                                    SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      physics: const BouncingScrollPhysics(),
                                      child: Wrap(
                                        spacing: 8,
                                        children:
                                            subcategories.map((subcategory) {
                                          final icons =
                                              subcategoryIcon[subcategory] ??
                                                  Icons.add;
                                          final gradient = subcategoryGradients[
                                                  subcategory] ??
                                              [
                                                Colors.grey,
                                                Colors.grey.shade700
                                              ];
                                          return buildGradientChip(
                                            label: subcategory,
                                            gradientColors: gradient,
                                            icon: icons,
                                            selected: selectedSubcategory ==
                                                subcategory,
                                            onTap: () => _onSubcategorySelected(
                                                subcategory),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                )
                              : const SizedBox(),
                        ),
                        const SizedBox(height: 50),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Column(
                            children: [
                              FadeInDown(
                                duration: const Duration(milliseconds: 800),
                                curve: Curves.decelerate,
                                child: RoundedTextField(
                                    title: "Expense Title",
                                    controller: expTitle,
                                    onIconPressed: () {},
                                    preIcon: Icons.view_headline_sharp),
                              ),
                              const SizedBox(height: 25),
                              FadeInDown(
                                duration: const Duration(milliseconds: 900),
                                curve: Curves.decelerate,
                                child: RoundedTextField(
                                    title: "Expense Quantity",
                                    controller: expQuan,
                                    keyboardType: TextInputType.number,
                                    onIconPressed: () {},
                                    preIcon:
                                        CupertinoIcons.bag_fill_badge_plus),
                              ),
                              const SizedBox(height: 25),
                              FadeInDown(
                                duration: const Duration(milliseconds: 900),
                                curve: Curves.decelerate,
                                child: RoundedTextField(
                                    title: "Expense Price",
                                    controller: expPrice,
                                    keyboardType: TextInputType.number,
                                    onIconPressed: () {},
                                    preIcon: Icons.attach_money_outlined),
                              ),
                              const SizedBox(height: 25),
                              FadeInDown(
                                duration: const Duration(milliseconds: 1000),
                                curve: Curves.decelerate,
                                child: DateTextField(
                                  onTap: showDate,
                                  title: "Expense Date",
                                  controller: date,
                                  keyboardType: TextInputType.number,
                                  icon: Icons.date_range_rounded,
                                  onIconPressed: () {},
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 60),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: ZoomInDown(
                              duration: const Duration(milliseconds: 1000),
                              child: CustomButton(
                                  title: "Create",
                                  onPressed: () {
                                    upcomingExpenseSumbimt();
                                  })),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> showDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(3000),
      barrierColor: TColor.gray30,
    );
    if (picked != null) {
      // controller.startDate.text = picked.toString().substring(0, 10);
      date.text = picked.toString().substring(0, 10);
    }
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

