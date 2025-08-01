// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../core/components/date_text_field.dart';
import '../../../../core/components/inline_nav_bar.dart';
import '../../../../core/components/methods.dart';
import '../../../../core/components/rounded_textField.dart';
import '../../../../core/theme/app_color.dart';
import '../../domain/entities/limit_entity.dart';
import '../bloc/limit_bloc.dart';

class EditLimit extends StatefulWidget {
  final LimitEntity limit;
  
  const EditLimit({super.key, required this.limit});

  @override
  State<EditLimit> createState() => _EditLimitState();
}

class _EditLimitState extends State<EditLimit> {
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
  String originalCategory = '';
  final TextEditingController limitAmount = TextEditingController();
  final TextEditingController startDate = TextEditingController();
  final TextEditingController endDate = TextEditingController();
  final storage = GetStorage();
  final _formKey = GlobalKey<FormState>();
  bool _autoValidate = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill form with existing limit data
    selectedCategory = widget.limit.category;
    originalCategory = widget.limit.category; // Store original category
    limitAmount.text = widget.limit.limitAmount.toString();
    startDate.text = widget.limit.startDate;
    endDate.text = widget.limit.endDate;
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

  void updateLimit() {
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

    // Determine if the category has changed
    bool categoryChanged = selectedCategory != widget.limit.category;
  
    // Create the updated limit entity
    final updatedLimit = LimitEntity(
      id: widget.limit.id,
      category: selectedCategory!,
      limitAmount: double.parse(limitAmount.text),
      // Reset spent amount to 0 if category changed, otherwise keep the current value
      spentAmount: categoryChanged ? 0.0 : widget.limit.spentAmount,
      startDate: startDate.text,
      endDate: endDate.text,
      accountId: widget.limit.accountId,
      userId: widget.limit.userId,
      createdAt: widget.limit.createdAt,
    );

    // Add a message to inform the user that the spent amount was reset
    if (categoryChanged) {
      final snackbar = Methods().infoSnackBar(
        "Category changed from '${widget.limit.category}' to '$selectedCategory'. Spent amount has been reset to 0."
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }

    context.read<LimitBloc>().add(UpdateLimitEvent(limit: updatedLimit));
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
        if (state is UpdateLimitSuccess) {
          final snakbar = Methods().successSnackBar("Limit updated successfully");
          ScaffoldMessenger.of(context).showSnackBar(snakbar);
          
        } else if (state is UpdateLimitError) {
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
                    const InlineNavBar(title: "Edit Limit"),
                    
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
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
                                      icon: categoryIcons[category] ?? Icons.category,
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
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                            
                            // Date Range Section
                            FadeInDown(
                              duration: const Duration(milliseconds: 1000),
                              child: Text(
                                "Date Range",
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
                                            startDate.text = picked.toString().substring(0, 10);
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
                                            endDate.text = picked.toString().substring(0, 10);
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
                    
                    // Update Button
                    FadeInUp(
                      duration: const Duration(milliseconds: 1200),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 30, top: 20),
                        child: SizedBox(
                          width: double.infinity,
                          child: state is UpdateLimitInProgress
                              ? Center(
                                  child: SpinKitWave(
                                    color: TColor.primary2,
                                    size: 40,
                                  ),
                                )
                              : ElevatedButton(
                                  onPressed: updateLimit,
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(vertical: 15),
                                    backgroundColor: theme.primary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: Text(
                                    "Update Limit",
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

// Reusing the same widget components from create_limit.dart
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
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
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
              size: 14,
              color: hasAllData ? Colors.white : theme.inversePrimary.withOpacity(0.7),
            ),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  color: hasAllData ? Colors.white : theme.inversePrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}




