import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:get_storage/get_storage.dart';
import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../../../../core/components/icon_custom_btn.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/components/methods.dart';
import '../../domain/entities/goal_entity.dart';
import '../bloc/goal_bloc.dart';

class CreateGoal extends StatefulWidget {
  const CreateGoal({super.key});

  @override
  State<CreateGoal> createState() => _CreateGoalState();
}

class _CreateGoalState extends State<CreateGoal> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController targetAmountController = TextEditingController();
  final TextEditingController currentAmountController = TextEditingController();
  final TextEditingController deadlineController = TextEditingController();
  final storage = GetStorage();

  void clearFields() {
    titleController.clear();
    targetAmountController.clear();
    currentAmountController.clear();
    deadlineController.clear();
  }

  @override
  void dispose() {
    titleController.dispose();
    targetAmountController.dispose();
    currentAmountController.dispose();
    deadlineController.dispose();
    super.dispose();
  }

  void showDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Colors.white,
              surface: Theme.of(context).colorScheme.surface,
              onSurface: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        deadlineController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void submitGoal() {
    if (titleController.text.isEmpty ||
        targetAmountController.text.isEmpty ||
        deadlineController.text.isEmpty) {
      final snackBar = Methods()
          .infoSnackBar('Please make sure to fill all required fields');
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    final accountId = storage.read('selectedAcc');
    if (accountId == null) {
      final snackBar = Methods().errorSnackBar('No account selected');
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    final goal = GoalEntity(
      id: '',
      title: titleController.text,
      targetAmount: double.parse(targetAmountController.text),
      currentAmount: currentAmountController.text.isEmpty
          ? 0.0
          : double.parse(currentAmountController.text),
      deadline: deadlineController.text,
      accountId: accountId,
      userId: FirebaseAuth.instance.currentUser!.uid,
      createdAt: DateTime.now().toIso8601String(),
    );

    context.read<GoalBloc>().add(AddGoalEvent(goal: goal));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    // final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: theme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: theme.inversePrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          "Create Goal",
          style: TextStyle(
            color: theme.inversePrimary,
            fontFamily: 'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<GoalBloc, GoalState>(
        listener: (context, state) {
          if (state is AddGoalSuccess) {
            final snackBar =
                Methods().successSnackBar('Goal created successfully');
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            clearFields();
          } else if (state is AddGoalError) {
            final snackBar = Methods().errorSnackBar(state.message);
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              // Background gradient elements
              Positioned(
                top: -50,
                right: -50,
                child: Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: TColor.primary.withOpacity(0.1),
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
                    color: TColor.primary.withOpacity(0.1),
                  ),
                ),
              ),

              // Main content
              SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Header section with image and title
                    FadeInDown(
                      duration: const Duration(milliseconds: 500),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: theme.primaryContainer.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/img/money_goal.png',
                              height: 120,
                              width: 120,
                            ),
                            const SizedBox(height: 15),
                            Text(
                              "Set Your Financial Goal",
                              style: TextStyle(
                                color: theme.inversePrimary,
                                fontFamily: 'Poppins',
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Define clear targets to achieve your dreams",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: theme.inversePrimary.withOpacity(0.7),
                                fontFamily: 'Poppins',
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Progress steps indicator
                    FadeInDown(
                      duration: const Duration(milliseconds: 550),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildStepIndicator(1, true, theme),
                          _buildStepConnector(theme),
                          _buildStepIndicator(
                              2,
                              titleController.text.isNotEmpty &&
                                  targetAmountController.text.isNotEmpty,
                              theme),
                          _buildStepConnector(theme),
                          _buildStepIndicator(
                              3, deadlineController.text.isNotEmpty, theme),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Form fields with enhanced styling
                    FadeInDown(
                      duration: const Duration(milliseconds: 600),
                      child: _buildFormField(
                        title: "Goal Title",
                        controller: titleController,
                        icon: Icons.title,
                        hint: "What are you saving for?",
                        theme: theme,
                      ),
                    ),

                    const SizedBox(height: 20),

                    FadeInDown(
                      duration: const Duration(milliseconds: 700),
                      child: _buildFormField(
                        title: "Target Amount",
                        controller: targetAmountController,
                        icon: Icons.attach_money,
                        hint: "How much do you need?",
                        keyboardType: TextInputType.number,
                        theme: theme,
                      ),
                    ),

                    const SizedBox(height: 20),

                    FadeInDown(
                      duration: const Duration(milliseconds: 800),
                      child: _buildFormField(
                        title: "Initial Amount (Optional)",
                        controller: currentAmountController,
                        icon: Icons.savings,
                        hint: "Starting amount (if any)",
                        keyboardType: TextInputType.number,
                        theme: theme,
                        isOptional: true,
                      ),
                    ),

                    const SizedBox(height: 20),

                    FadeInDown(
                      duration: const Duration(milliseconds: 900),
                      child: _buildDateField(
                        title: "Goal Deadline",
                        controller: deadlineController,
                        icon: Icons.calendar_today,
                        hint: "When do you want to achieve this?",
                        theme: theme,
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Submit button with loading state
                    state is AddGoalInProgress
                        ? SpinKitWave(
                            color: TColor.primary2,
                            size: 30,
                          )
                        : FadeInUp(
                            duration: const Duration(milliseconds: 1000),
                            child: IconCustomBtn(
                              label: 'Create Goal',
                              icon: Icons.flag,
                              onTap: submitGoal,
                            ),
                          ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Helper method to build step indicator
  Widget _buildStepIndicator(int step, bool isActive, ColorScheme theme) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: isActive ? theme.primary : theme.surface,
        shape: BoxShape.circle,
        border: Border.all(
          color:
              isActive ? theme.primary : theme.inversePrimary.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          step.toString(),
          style: TextStyle(
            color:
                isActive ? Colors.white : theme.inversePrimary.withOpacity(0.5),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Helper method to build step connector
  Widget _buildStepConnector(ColorScheme theme) {
    return Container(
      width: 20,
      height: 2,
      color: theme.inversePrimary.withOpacity(0.3),
    );
  }

  // Helper method to build form fields with enhanced styling
  Widget _buildFormField({
    required String title,
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    required ColorScheme theme,
    TextInputType keyboardType = TextInputType.text,
    bool isOptional = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: theme.surface,
        borderRadius: BorderRadius.circular(15),
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
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 15, bottom: 5),
            child: Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: theme.inversePrimary,
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (isOptional)
                  Text(
                    " (Optional)",
                    style: TextStyle(
                      color: theme.inversePrimary.withOpacity(0.5),
                      fontFamily: 'Poppins',
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
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
                  color: theme.inversePrimary.withOpacity(0.5),
                  fontFamily: 'Poppins',
                ),
                prefixIcon: Icon(
                  icon,
                  color: theme.primary,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to build date field with enhanced styling
  Widget _buildDateField({
    required String title,
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    required ColorScheme theme,
  }) {
    return GestureDetector(
      onTap: showDate,
      child: Container(
        decoration: BoxDecoration(
          color: theme.surface,
          borderRadius: BorderRadius.circular(15),
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
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 15, bottom: 5),
              child: Text(
                title,
                style: TextStyle(
                  color: theme.inversePrimary,
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: controller,
                enabled: false,
                style: TextStyle(
                  color: theme.inversePrimary,
                  fontFamily: 'Poppins',
                ),
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: TextStyle(
                    color: theme.inversePrimary.withOpacity(0.5),
                    fontFamily: 'Poppins',
                  ),
                  prefixIcon: Icon(
                    icon,
                    color: theme.primary,
                  ),
                  suffixIcon: Icon(
                    Icons.arrow_drop_down,
                    color: theme.primary,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
