// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:get_storage/get_storage.dart';
import 'package:animate_do/animate_do.dart';
import '../../../../core/components/main_app_bar.dart';
import '../../../../core/components/methods.dart';

import '../../../../core/theme/app_color.dart';
import '../bloc/goal_bloc.dart';
import '../widgets/goal_card.dart';
import '../../domain/entities/goal_entity.dart';

class GoalView extends StatefulWidget {
  const GoalView({super.key});

  @override
  State<GoalView> createState() => _GoalViewState();
}

class _GoalViewState extends State<GoalView> {
  final storage = GetStorage();

  @override
  void initState() {
    super.initState();
    _loadGoals();
  }

  void _loadGoals() {
    final accountId = storage.read('selectedAcc');
    if (accountId != null) {
      context.read<GoalBloc>().add(LoadGoalsEvent(accountId));
    }
  }

  void _deleteGoal(GoalEntity goal) {
    // Store the accountId before deleting the goal
    final accountId = goal.accountId;

    // Just delete the goal - we'll reload in the listener
    context
        .read<GoalBloc>()
        .add(DeleteGoalEvent(id: goal.id, accountId: accountId));

    // Remove the Future.delayed call - we'll handle reloading in the listener
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: theme.surface,
      body: SafeArea(
        child: BlocConsumer<GoalBloc, GoalState>(
          listener: (context, state) {
            if (state is GoalError) {
              final snackBar = Methods().errorSnackBar(state.message);
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else if (state is DeleteGoalSuccess) {
              final snackBar =
                  Methods().successSnackBar('Goal deleted successfully');
              ScaffoldMessenger.of(context).showSnackBar(snackBar);

              // Reload goals after successful deletion
              _loadGoals();
            } else if (state is DeleteGoalError) {
              final snackBar = Methods().errorSnackBar(state.message);
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                const SliverAppBar(
                  stretch: true,
                  expandedHeight: 80,
                  flexibleSpace: FlexibleSpaceBar(
                    background: MainAppBar(),
                  ),
                ),
                if (state is GoalLoading)
                  SliverFillRemaining(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: height * 0.1),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SpinKitWave(
                              color: TColor.primary2,
                              size: 40,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Loading your goals...",
                              style: TextStyle(
                                color: theme.inversePrimary,
                                fontFamily: 'Poppins',
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else if (state is GoalsLoaded)
                  if (state.goals.isEmpty)
                    SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/img/search.png',
                              width: 150,
                              height: 150,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'No goals yet',
                              style: TextStyle(
                                color: theme.inversePrimary,
                                fontSize: 18,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Create a goal to start tracking your progress',
                              style: TextStyle(
                                color: theme.inversePrimary.withOpacity(0.7),
                                fontSize: 14,
                                fontFamily: 'Poppins',
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final goal = state.goals[index];
                          return FadeInUp(
                            delay: Duration(milliseconds: 100 * index),
                            child: GoalCard(
                              tag: goal.id,
                              img: "assets/img/money_goal.png",
                              width: width,
                              height: height,
                              goalName: goal.title,
                              current: goal.currentAmount.toStringAsFixed(0),
                              finalBalance:
                                  goal.targetAmount.toStringAsFixed(0),
                              date: goal.deadline,
                              progress: goal.progressPercentage / 100,
                              onTap: () {
                                context
                                    .pushNamed("goalDetail", extra: goal)
                                    .then((_) => _loadGoals());
                              },
                              onDelete: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      backgroundColor: theme.primaryContainer,
                                      title: Text(
                                        "Delete Goal",
                                        style: TextStyle(
                                          color: theme.inversePrimary,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                      content: Text(
                                        "Are you sure you want to delete this goal?",
                                        style: TextStyle(
                                          color: theme.inversePrimary,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            context.pop();
                                          },
                                          child: Text(
                                            "Cancel",
                                            style: TextStyle(
                                              color: theme.inversePrimary,
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            _deleteGoal(goal);
                                            context.pop();
                                          },
                                          child: Text(
                                            "Delete",
                                            style: TextStyle(
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          );
                        },
                        childCount: state.goals.length,
                      ),
                    )
                else
                  SliverFillRemaining(
                    child: Center(
                      child: Text(
                        '',
                        style: TextStyle(
                          color: theme.inversePrimary,
                          fontSize: 16,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  )
              ],
            );
          },
        ),
      ),
    );
  }
}
