// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable

import 'package:animate_do/animate_do.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_storage/get_storage.dart';
import '../../../../core/components/methods.dart';
import '../../domain/entities/limit_entity.dart';
import '../bloc/limit_bloc.dart';
import '../../../../core/components/date_text_field.dart';
import '../../../../core/components/inline_nav_bar.dart';
import '../../../../core/components/rounded_textField.dart';
import '../../../../core/theme/app_color.dart';

// import 'package:awesome_dialog/awesome_dialog.dart';


class CreateLimit extends StatefulWidget {
  const CreateLimit({super.key});

  @override
  State<CreateLimit> createState() => _CreateLimitState();
}

class _CreateLimitState extends State<CreateLimit> {
  List<String> categories = [
    "Transport",
    "Food",
    "Utilities",
    "Housing",
    "Shopping",
    "HealthCare",
    "Education",
  ];

  Map<String, IconData> categoryIcons = {
    "Transport": Icons.directions_car,
    "Food": Icons.restaurant,
    "Utilities": Icons.power,
    "Housing": Icons.home,
    "Shopping": Icons.shopping_bag,
    "HealthCare": Icons.medical_services,
    "Education": Icons.school,
  };

  String? selectedCategory;
  final TextEditingController limitAmount = TextEditingController();
  final TextEditingController startDate = TextEditingController();
  final TextEditingController endDate = TextEditingController();
  final storage = GetStorage();
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  @override
  void initState() {
    super.initState();
  }

  void clearField() {
    limitAmount.clear();
    startDate.clear();
    endDate.clear();
    setState(() {
      selectedCategory = null;
    });
  }

  String? _validateAmount(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an amount';
    }
    if (double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    if (double.parse(value) <= 0) {
      return 'Amount must be greater than zero';
    }
    return null;
  }

  void createLimit() {
    setState(() {
      _autoValidate = true;
    });

    if (_formKey.currentState?.validate() != true || selectedCategory == null) {
      if (selectedCategory == null) {
        final snakbar = Methods().errorSnackBar("Please select a category");
        ScaffoldMessenger.of(context).showSnackBar(snakbar);
      }
      return;
    }

    final limit = LimitEntity(
      id: '',
      category: selectedCategory!,
      limitAmount: double.parse(limitAmount.text),
      spentAmount: 0.0,
      startDate: startDate.text,
      endDate: endDate.text,
      accountId: storage.read('selectedAcc'),
      userId: FirebaseAuth.instance.currentUser!.uid,
      createdAt: DateTime.now().toIso8601String(),
    );

    context.read<LimitBloc>().add(AddLimitEvent(limit: limit));
  }

  void _setDateRangeToCurrentMonth() {
    final now = DateTime.now();
    final firstDayOfMonth = DateTime(now.year, now.month, 1);
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

    setState(() {
      startDate.text = firstDayOfMonth.toString().substring(0, 10);
      endDate.text = lastDayOfMonth.toString().substring(0, 10);
    });
  }

  void _setDateRangeToNextMonth() {
    final now = DateTime.now();
    final firstDayOfNextMonth = DateTime(now.year, now.month + 1, 1);
    final lastDayOfNextMonth = DateTime(now.year, now.month + 2, 0);

    setState(() {
      startDate.text = firstDayOfNextMonth.toString().substring(0, 10);
      endDate.text = lastDayOfNextMonth.toString().substring(0, 10);
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final theme = Theme.of(context).colorScheme;
    return BlocConsumer<LimitBloc, LimitState>(
      listener: (context, state) {
        if (state is AddLimitSuccess) {
          clearField();
          final snakbar =
              Methods().successSnackBar("Limit created successfully");
          ScaffoldMessenger.of(context).showSnackBar(snakbar);
        } else if (state is AddLimitError) {
          final snakbar = Methods().errorSnackBar(state.message);
          ScaffoldMessenger.of(context).showSnackBar(snakbar);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: theme.surface,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                autovalidateMode: _autoValidate
                    ? AutovalidateMode.always
                    : AutovalidateMode.disabled,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const InlineNavBar(title: "Create Limit"),
                    const SizedBox(height: 20),

                    // Main content
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header
                            FadeInDown(
                              duration: const Duration(milliseconds: 500),
                              child: Text(
                                "Set a new spending limit",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: theme.inversePrimary,
                                  fontFamily: 'Arvo',
                                ),
                              ),
                            ),

                            FadeInDown(
                              duration: const Duration(milliseconds: 600),
                              child: Text(
                                "Track your expenses by category and stay within budget",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: theme.inversePrimary.withOpacity(0.7),
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),

                            const SizedBox(height: 30),

                            // Category Selection
                            FadeInDown(
                              duration: const Duration(milliseconds: 700),
                              child: Text(
                                "Select Category",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: theme.inversePrimary,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),

                            FadeInDown(
                              duration: const Duration(milliseconds: 800),
                              child: SizedBox(
                                height: 100,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: categories.length,
                                  itemBuilder: (context, index) {
                                    final category = categories[index];
                                    return CategoryCard(
                                      category: category,
                                      icon: categoryIcons[category] ??
                                          Icons.category,
                                      isSelected: selectedCategory == category,
                                      onTap: () {
                                        setState(() {
                                          selectedCategory = category;
                                        });
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),

                            const SizedBox(height: 30),

                            // Amount Section
                            FadeInDown(
                              duration: const Duration(milliseconds: 900),
                              curve: Curves.decelerate,
                              child: RoundedTextField(
                                title: "Limit Amount",
                                controller: limitAmount,
                                keyboardType: TextInputType.number,
                                onIconPressed: () {},
                                preIcon: Icons.attach_money_outlined,
                                validator: _validateAmount,
                              ),
                            ),

                            const SizedBox(height: 15),

                            FadeInDown(
                              duration: const Duration(milliseconds: 950),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  AmountPresetButton(
                                    amount: "100",
                                    onTap: () {
                                      setState(() {
                                        limitAmount.text = "100";
                                      });
                                    },
                                  ),
                                  AmountPresetButton(
                                    amount: "500",
                                    onTap: () {
                                      setState(() {
                                        limitAmount.text = "500";
                                      });
                                    },
                                  ),
                                  AmountPresetButton(
                                    amount: "1000",
                                    onTap: () {
                                      setState(() {
                                        limitAmount.text = "1000";
                                      });
                                    },
                                  ),
                                  AmountPresetButton(
                                    amount: "5000",
                                    onTap: () {
                                      setState(() {
                                        limitAmount.text = "5000";
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 30),

                            // Date Section
                            FadeInDown(
                              duration: const Duration(milliseconds: 1000),
                              child: Text(
                                "Time Period",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: theme.inversePrimary,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),

                            FadeInDown(
                              duration: const Duration(milliseconds: 1100),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: DateTextField(
                                      onTap: () async {
                                        DateTime? picked = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(3000),
                                          barrierColor: TColor.gray30,
                                        );
                                        if (picked != null) {
                                          setState(() {
                                            startDate.text = picked
                                                .toString()
                                                .substring(0, 10);
                                          });
                                        }
                                      },
                                      title: "Start Date",
                                      controller: startDate,
                                      keyboardType: TextInputType.number,
                                      icon: Icons.date_range_rounded,
                                      onIconPressed: () {},
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: DateTextField(
                                      onTap: () async {
                                        DateTime? picked = await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(2000),
                                          lastDate: DateTime(3000),
                                          barrierColor: TColor.gray30,
                                        );
                                        if (picked != null) {
                                          setState(() {
                                            endDate.text = picked
                                                .toString()
                                                .substring(0, 10);
                                          });
                                        }
                                      },
                                      title: "End Date",
                                      controller: endDate,
                                      keyboardType: TextInputType.number,
                                      icon: Icons.date_range_rounded,
                                      onIconPressed: () {},
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 15),

                            FadeInDown(
                              duration: const Duration(milliseconds: 1150),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  DateRangePresetButton(
                                    label: "This Month",
                                    onTap: _setDateRangeToCurrentMonth,
                                  ),
                                  const SizedBox(width: 15),
                                  DateRangePresetButton(
                                    label: "Next Month",
                                    onTap: _setDateRangeToNextMonth,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 30),

                            // Summary Card
                            FadeInUp(
                              duration: const Duration(milliseconds: 700),
                              child: LimitSummaryCard(
                                category: selectedCategory,
                                amount: limitAmount.text,
                                startDate: startDate.text,
                                endDate: endDate.text,
                              ),
                            ),

                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),

                    // Create Button
                    FadeInUp(
                      duration: const Duration(milliseconds: 1200),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 30, top: 20),
                        child: SizedBox(
                          width: double.infinity,
                          child: state is AddLimitInProgress
                              ? Center(
                                  child: SpinKitWave(
                                    color: TColor.primary2,
                                    size: 40,
                                  ),
                                )
                              : ElevatedButton(
                                  onPressed: createLimit,
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 15),
                                    backgroundColor: theme.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: Text(
                                    "Create Limit",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}


class CategoryCard extends StatelessWidget {
  final String category;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryCard({
    Key? key,
    required this.category,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? theme.primary.withOpacity(0.2) : theme.tertiary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? theme.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? theme.primary : theme.inversePrimary,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              category,
              style: TextStyle(
                color: isSelected ? theme.primary : theme.inversePrimary,
                fontFamily: 'Poppins',
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LimitSummaryCard extends StatelessWidget {
  final String? category;
  final String amount;
  final String startDate;
  final String endDate;

  const LimitSummaryCard({
    Key? key,
    required this.category,
    required this.amount,
    required this.startDate,
    required this.endDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final hasAllData = category != null &&
        amount.isNotEmpty &&
        startDate.isNotEmpty &&
        endDate.isNotEmpty;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: hasAllData
            ? LinearGradient(
                colors: [
                  Color(0XFF8B5CF6),
                  Color(0XFF5A31F4),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: hasAllData ? null : theme.tertiary.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        boxShadow: hasAllData
            ? [
                BoxShadow(
                  color: Color(0XFF8B5CF6).withOpacity(0.3),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                )
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Limit Summary",
                style: TextStyle(
                  color: hasAllData
                      ? Colors.white
                      : theme.inversePrimary.withOpacity(0.7),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: 'Poppins',
                ),
              ),
              Icon(
                Icons.info_outline,
                color: hasAllData
                    ? Colors.white70
                    : theme.inversePrimary.withOpacity(0.5),
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  context,
                  "Category",
                  category ?? "Not selected",
                  Icons.category,
                  hasAllData,
                ),
              ),
              Expanded(
                child: _buildSummaryItem(
                  context,
                  "Amount",
                  amount.isEmpty ? "Not set" : "\$$amount",
                  Icons.attach_money,
                  hasAllData,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  context,
                  "Start",
                  startDate.isEmpty ? "Not set" : startDate,
                  Icons.calendar_today,
                  hasAllData,
                ),
              ),
              Expanded(
                child: _buildSummaryItem(
                  context,
                  "End",
                  endDate.isEmpty ? "Not set" : endDate,
                  Icons.event_available,
                  hasAllData,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    bool hasAllData,
  ) {
    final theme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: hasAllData
                ? Colors.white70
                : theme.inversePrimary.withOpacity(0.5),
            fontSize: 12,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: hasAllData
                  ? Colors.white
                  : theme.inversePrimary.withOpacity(0.7),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  color: hasAllData ? Colors.white : theme.inversePrimary,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  fontFamily: 'Poppins',
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
}


class AmountPresetButton extends StatelessWidget {
  final String amount;
  final VoidCallback onTap;

  const AmountPresetButton({
    Key? key,
    required this.amount,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: theme.tertiary,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: theme.primary.withOpacity(0.3)),
        ),
        child: Text(
          '\$$amount',
          style: TextStyle(
            color: theme.inversePrimary,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class DateRangePresetButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const DateRangePresetButton({
    Key? key,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: theme.tertiary,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: theme.primary.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.date_range,
              size: 16,
              color: theme.inversePrimary,
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                color: theme.inversePrimary,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
