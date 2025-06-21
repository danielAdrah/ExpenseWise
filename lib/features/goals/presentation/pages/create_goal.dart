import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:get_storage/get_storage.dart';
import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../../../../core/components/custom_button.dart';
import '../../../../core/components/rounded_textField.dart';
import '../../../../core/components/date_text_field.dart';
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
              primary: TColor.primary,
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
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FadeInDown(
                  duration: const Duration(milliseconds: 500),
                  child: Image.asset(
                    'assets/img/money_goal.png',
                    height: 150,
                    width: 150,
                  ),
                ),
                const SizedBox(height: 30),
                FadeInDown(
                  duration: const Duration(milliseconds: 600),
                  child: RoundedTextField(
                    title: "Goal Title",
                    controller: titleController,
                    preIcon: Icons.title,
                    onIconPressed: () {},
                  ),
                ),
                const SizedBox(height: 20),
                FadeInDown(
                  duration: const Duration(milliseconds: 700),
                  child: RoundedTextField(
                    title: "Target Amount",
                    controller: targetAmountController,
                    preIcon: Icons.attach_money,
                    keyboardType: TextInputType.number,
                    onIconPressed: () {},
                  ),
                ),
                const SizedBox(height: 20),
                FadeInDown(
                  duration: const Duration(milliseconds: 800),
                  child: RoundedTextField(
                    title: "Initial Amount (Optional)",
                    controller: currentAmountController,
                    preIcon: Icons.savings,
                    keyboardType: TextInputType.number,
                    onIconPressed: () {},
                  ),
                ),
                const SizedBox(height: 20),
                FadeInDown(
                  duration: const Duration(milliseconds: 900),
                  child: DateTextField(
                    title: "Goal Deadline",
                    controller: deadlineController,
                    icon: Icons.calendar_today,
                    onTap: showDate,
                    onIconPressed: () {},
                  ),
                ),
                const SizedBox(height: 40),
                state is AddGoalInProgress
                    ? SpinKitWave(
                        color: TColor.primary2,
                        size: 30,
                      )
                    : FadeInUp(
                        duration: const Duration(milliseconds: 1000),
                        child: CustomButton(
                          title: "Create Goal",
                          onPressed: submitGoal,
                        ),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}
