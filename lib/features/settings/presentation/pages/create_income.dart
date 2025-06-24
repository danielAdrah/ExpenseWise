// ignore_for_file: unused_local_variable, unused_element, non_constant_identifier_names, avoid_print

import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_storage/get_storage.dart';
import 'package:trackme/core/components/date_text_field.dart';

import '../../../../core/components/custom_button.dart';
import '../../../../core/components/gradient_icon.dart';
import '../../../../core/components/gradient_text.dart';
import '../../../../core/components/inline_nav_bar.dart';
import '../../../../core/components/methods.dart';
import '../../../../core/components/rounded_textField.dart';
import '../../../../core/components/rounded_text_area.dart';
import '../../../../core/theme/app_color.dart';
import '../../domain/entity/income_entity.dart';
import '../bloc/income_bloc.dart';

class CreateIncome extends StatefulWidget {
  const CreateIncome({super.key});

  @override
  State<CreateIncome> createState() => _CreateIncomeState();
}

class _CreateIncomeState extends State<CreateIncome> {
  final amount = TextEditingController();
  final date = TextEditingController();
  final note = TextEditingController();
  String? selectedCategory;
  void clearField() {
    amount.clear();
    date.clear();
    note.clear();
  }

  final GetStorage storage = GetStorage();

  bool showSubcategories = false;

  final List<String> incomes = [
    "Salary & Wages",
    "Business Income",
    "Investment",
    "Freelance",
    "Online Earning",
  ];

  final Map<String, List<Color>> categoryGradients = {
    "Salary & Wages": const [Color(0xFF17a2b8), Color(0xFF0d9488)],
    "Business Income": [const Color(0xFFFF416C), const Color(0xFFFF4B2B)],
    "Investment": const [Color(0xFFFFC107), Color(0xFFFF8F00)],
    "Freelance": const [
      Color.fromARGB(255, 104, 68, 223),
      Color.fromARGB(255, 95, 72, 197)
    ],
    "Online Earning": const [Color(0xFFFF5FA2), Color(0xFF8E44AD)],
  };

  final Map<String, IconData> categoryIcon = {
    "Salary & Wages": Icons.attach_money,
    "Business Income": Icons.data_exploration_outlined,
    "Investment": CupertinoIcons.bitcoin_circle,
    "Freelance": CupertinoIcons.device_laptop,
    "Online Earning": CupertinoIcons.creditcard,
  };

  void _onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;

      showSubcategories = true;
    });
  }

  void incomeSumbimt() {
    if (selectedCategory == null || amount.text.isEmpty || date.text.isEmpty) {
      final Snackbar = Methods()
          .infoSnackBar('Please make sure to fill the amount and date fields');
      ScaffoldMessenger.of(context).showSnackBar(Snackbar);
      return;
    }

    try {
      final income = IncomeEntity(
        id: '',
        category: selectedCategory ?? 'Other',
        date: date.text,
        amount: double.tryParse(amount.text) ?? 0.0,
        note: note.text.isNotEmpty ? note.text : "No notes",
        accountID: storage.read('selectedAcc') ?? '',
        userId: FirebaseAuth.instance.currentUser?.uid ?? '',
      );

      context.read<IncomeBloc>().add(AddIncomeEvent(income: income));
      clearField();
    } catch (e) {
      print("Error creating income: $e");
      final Snackbar = Methods().errorSnackBar('Failed to create income: $e');
      ScaffoldMessenger.of(context).showSnackBar(Snackbar);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    // final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: theme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const InlineNavBar(title: "Create Income"),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: BlocConsumer<IncomeBloc, IncomeState>(
                  listener: (context, state) {
                    if (state is IncomeAddSuccess) {
                      // Show success message when income is created
                      final snackBar = Methods().successSnackBar(
                          'Your income has been created successfully');
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else if (state is IncomeAddError) {
                      // Show error message when income creation fails
                      final snackBar = Methods().errorSnackBar(
                          'Failed to create income: ${state.errormessage}');
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  builder: (context, state) {
                    // Debug the current state
                    print("Current income creation state: $state");

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 40),
                        FadeInDown(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.decelerate,
                          child: Text(
                            "Select Income Source",
                            style: TextStyle(
                              color: theme.inversePrimary,
                              fontFamily: 'Poppins',
                              fontSize: 18,
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
                            children: incomes.map((category) {
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
                        const SizedBox(height: 40),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Column(
                            children: [
                              FadeInDown(
                                duration: const Duration(milliseconds: 800),
                                curve: Curves.decelerate,
                                child: RoundedTextField(
                                  title: "Income Amount",
                                  controller: amount,
                                  onIconPressed: () {},
                                  keyboardType: TextInputType.number,
                                  preIcon: Icons.attach_money_outlined,
                                ),
                              ),
                              const SizedBox(height: 25),
                              FadeInDown(
                                duration: const Duration(milliseconds: 900),
                                curve: Curves.decelerate,
                                child: DateTextField(
                                  onTap: showDate,
                                  title: "Income Date",
                                  controller: date,
                                  keyboardType: TextInputType.number,
                                  icon: Icons.date_range_rounded,
                                  onIconPressed: () {},
                                ),
                              ),
                              const SizedBox(height: 25),
                              FadeInDown(
                                duration: const Duration(milliseconds: 900),
                                curve: Curves.decelerate,
                                child: RoundedTextArea(
                                  length: 3,
                                  title: "Enter Some Note",
                                  onIconPressed: () {},
                                  controller: note,
                                  preIcon: Icons.list,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 60),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: state is IncomeAddInProgress
                              ? Center(
                                  child: Column(
                                    children: [
                                      SpinKitWave(
                                        color: TColor.secondaryG50,
                                        size: 40,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        "Creating income...",
                                        style: TextStyle(
                                          color: theme.inversePrimary,
                                          fontFamily: 'Poppins',
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : ZoomInDown(
                                  duration: const Duration(milliseconds: 1000),
                                  child: CustomButton(
                                    title: "Create",
                                    onPressed: () {
                                      // Validate form before submitting
                                      if (selectedCategory == null) {
                                        final snackBar = Methods().infoSnackBar(
                                            'Please select an income category');
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                        return;
                                      }

                                      if (amount.text.isEmpty) {
                                        final snackBar = Methods().infoSnackBar(
                                            'Please enter the income amount');
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                        return;
                                      }

                                      if (date.text.isEmpty) {
                                        final snackBar = Methods().infoSnackBar(
                                            'Please select the income date');
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                        return;
                                      }

                                      // All validations passed, submit the income
                                      incomeSumbimt();
                                    },
                                  ),
                                ),
                        ),

                        // Show error message if there's an error
                        if (state is IncomeAddError)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 20),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: Colors.red.withOpacity(0.3)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.error_outline,
                                      color: Colors.red),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      state.errormessage,
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontFamily: 'Poppins',
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
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
