import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:animate_do/animate_do.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../../../core/components/custom_button.dart';
import '../../../../core/components/rounded_textField.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/components/methods.dart';
import '../../domain/entities/goal_entity.dart';
import '../bloc/goal_bloc.dart';

class GoalDetail extends StatefulWidget {
  final GoalEntity goal;

  const GoalDetail({super.key, required this.goal});

  @override
  State<GoalDetail> createState() => _GoalDetailState();
}

class _GoalDetailState extends State<GoalDetail> {
  final TextEditingController amountController = TextEditingController();
  late GoalEntity goal;
  final storage = GetStorage();

  @override
  void initState() {
    super.initState();
    goal = widget.goal;
  }

  void _showAddProgressDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          title: Text(
            "Add to Goal",
            style: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
              fontFamily: 'Poppins',
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RoundedTextField(
                title: "Amount",
                controller: amountController,
                preIcon: Icons.attach_money,
                keyboardType: TextInputType.number,
                onIconPressed: () {},
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                if (amountController.text.isEmpty) {
                  final snackBar =
                      Methods().infoSnackBar('Please enter an amount');
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  return;
                }

                final amount = double.parse(amountController.text);

                // Check if goal is already fulfilled
                if (goal.currentAmount >= goal.targetAmount) {
                  context.pop(); // Close dialog
                  final snackBar = Methods().infoSnackBar(
                      'Goal already reached! No need to add more funds.');
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  return;
                }

                // Check if adding this amount would exceed the target
                final remainingAmount = goal.targetAmount - goal.currentAmount;
                if (amount > remainingAmount) {
                  // Show warning dialog
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer,
                      title: Text(
                        "Exceeds Target",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      content: Text(
                        "Adding \$${amount.toStringAsFixed(2)} would exceed your goal target by \$${(amount - remainingAmount).toStringAsFixed(2)}. Would you like to add the exact remaining amount (\$${remainingAmount.toStringAsFixed(2)}) or continue with your entered amount?",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            context.pop(); // Close this dialog
                            context.pop(); // Close the amount dialog

                            // Update with exact remaining amount
                            setState(() {
                              goal = goal.copyWith(
                                currentAmount:
                                    goal.targetAmount, // Set to exact target
                              );
                            });

                            // Send update to backend
                            context.read<GoalBloc>().add(
                                  UpdateGoalProgressEvent(
                                    id: goal.id,
                                    amount: remainingAmount,
                                  ),
                                );

                            amountController.clear();
                          },
                          child: Text(
                            "Add Exact Amount",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            context.pop(); // Close this dialog
                            context.pop(); // Close the amount dialog

                            // Update with full amount as entered
                            setState(() {
                              goal = goal.copyWith(
                                currentAmount: goal.currentAmount + amount,
                              );
                            });

                            // Send update to backend
                            context.read<GoalBloc>().add(
                                  UpdateGoalProgressEvent(
                                    id: goal.id,
                                    amount: amount,
                                  ),
                                );

                            amountController.clear();
                          },
                          child: Text(
                            "Add Full Amount",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                  return;
                }

                // Normal case - amount doesn't exceed target
                context.pop(); // Close dialog

                // Update the goal locally immediately for instant UI feedback
                setState(() {
                  goal = goal.copyWith(
                    currentAmount: goal.currentAmount + amount,
                  );
                });

                // Then send the update to the backend
                context.read<GoalBloc>().add(
                      UpdateGoalProgressEvent(
                        id: goal.id,
                        amount: amount,
                      ),
                    );

                amountController.clear();
              },
              child: Text(
                "Add",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final progress = goal.progressPercentage / 100;
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 0);

    return Scaffold(
      backgroundColor: theme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: FadeInLeft(
          delay: const Duration(milliseconds: 200),
          curve: Curves.decelerate,
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: theme.inversePrimary),
            onPressed: () => context.pop(),
          ),
        ),
        title: FadeInDown(
          delay: const Duration(milliseconds: 230),
          curve: Curves.decelerate,
          child: Text(
            "Goal Details",
            style: TextStyle(
              color: theme.inversePrimary,
              fontFamily: 'Poppins',
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        actions: [
          FadeInRight(
              delay: const Duration(milliseconds: 200),
              curve: Curves.decelerate,
              child:
                  Image.asset("assets/img/logo1.png", width: 60, height: 60)),
        ],
        centerTitle: true,
      ),
      body: BlocConsumer<GoalBloc, GoalState>(
        listener: (context, state) {
          if (state is UpdateGoalProgressSuccess) {
            final snackBar =
                Methods().successSnackBar('Progress updated successfully');
            ScaffoldMessenger.of(context).showSnackBar(snackBar);

            // We don't need to update the state here anymore since we're doing it optimistically
            // in the _showAddProgressDialog method
          } else if (state is UpdateGoalProgressError) {
            final snackBar = Methods().errorSnackBar(state.message);
            ScaffoldMessenger.of(context).showSnackBar(snackBar);

            // If there was an error, we should reload the goal to get the correct data
            context.read<GoalBloc>().add(LoadGoalsEvent(goal.accountId));
          } else if (state is GoalsLoaded) {
            // Find the updated goal in the loaded goals
            final updatedGoal = state.goals.firstWhere(
              (g) => g.id == goal.id,
              orElse: () => goal,
            );

            // Only update if the goal data is different to avoid unnecessary rebuilds
            if (updatedGoal.currentAmount != goal.currentAmount) {
              setState(() {
                goal = updatedGoal;
              });
            }
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
                  child: Hero(
                    tag: goal.id,
                    child: Image.asset(
                      'assets/img/money_goal.png',
                      height: 120,
                      width: 120,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                FadeInDown(
                  duration: const Duration(milliseconds: 600),
                  child: Text(
                    goal.title,
                    style: TextStyle(
                      color: theme.inversePrimary,
                      fontFamily: 'Poppins',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 30),
                FadeInDown(
                  duration: const Duration(milliseconds: 700),
                  child: CircularPercentIndicator(
                    radius: 80.0,
                    lineWidth: 12.0,
                    animation: true,
                    percent: progress,
                    center: Text(
                      "${goal.progressPercentage.toStringAsFixed(0)}%",
                      style: TextStyle(
                        color: theme.inversePrimary,
                        fontFamily: 'Poppins',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: theme.primary,
                    backgroundColor: TColor.primary.withOpacity(0.2),
                  ),
                ),
                const SizedBox(height: 40),
                FadeInDown(
                  duration: const Duration(milliseconds: 800),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Current Balance",
                            style: TextStyle(
                              color: theme.inversePrimary.withOpacity(0.7),
                              fontFamily: 'Poppins',
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            formatter.format(goal.currentAmount),
                            style: TextStyle(
                              color: theme.inversePrimary,
                              fontFamily: 'Poppins',
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Goal",
                            style: TextStyle(
                              color: theme.inversePrimary.withOpacity(0.7),
                              fontFamily: 'Poppins',
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            formatter.format(goal.targetAmount),
                            style: TextStyle(
                              color: theme.inversePrimary,
                              fontFamily: 'Poppins',
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                FadeInDown(
                  duration: const Duration(milliseconds: 900),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.primaryContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Deadline",
                          style: TextStyle(
                            color: theme.inversePrimary.withOpacity(0.7),
                            fontFamily: 'Poppins',
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          goal.deadline,
                          style: TextStyle(
                            color: theme.inversePrimary,
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                state is UpdateGoalProgressInProgress
                    ? SpinKitWave(
                        color: TColor.primary2,
                        size: 30,
                      )
                    : FadeInUp(
                        duration: const Duration(milliseconds: 1000),
                        child: CustomButton(
                          title: "Add to Goal",
                          onPressed: () => _showAddProgressDialog(),
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
