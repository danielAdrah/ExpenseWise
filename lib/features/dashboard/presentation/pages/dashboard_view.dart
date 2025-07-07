// ignore_for_file: avoid_print

import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get_storage/get_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:trackme/core/components/my_list_tile.dart';
import 'package:trackme/features/expenses/presentation/bloc/expense_event.dart';
import '../../../../core/components/main_app_bar.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../expenses/data/models/expense_model.dart';
import '../../../expenses/presentation/bloc/expense_bloc.dart';
import '../../../expenses/presentation/bloc/expense_state.dart';
import '../../../expenses/presentation/bloc/upcoming_expense_bloc.dart';
import '../../../expenses/presentation/bloc/upcoming_expense_event.dart';
import '../../../settings/presentation/bloc/income_bloc.dart';
import '../widgets/total_pie_chart.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView>
    with SingleTickerProviderStateMixin {
  final GetStorage storage = GetStorage();
  String? selectedAccount;
  String? selectedCategory;
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    context.read<AuthBloc>().add(GetAccountsEvent());
    context
        .read<ExpenseBloc>()
        .add(LoadExpensesEvent(storage.read('selectedAcc') ?? ""));
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onCategorySelected(String? category) {
    setState(() {
      selectedCategory = category;
    });
    // Add a small animation when category is selected
    _animationController.reset();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: theme.surface,
      body: SafeArea(
        child: BlocListener<ExpenseBloc, ExpenseState>(
          listener: (context, state) {
            if (state is ExpenseLoaded) {
              final accountId = storage.read('selectedAcc') ?? "";
              context
                  .read<IncomeBloc>()
                  .add(LoadIncomeEvent(accountID: accountId));
            }
          },
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                stretch: true,
                expandedHeight: media.width * 1.1,
                backgroundColor: Colors.transparent,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  background: FadeIn(
                    duration: const Duration(milliseconds: 800),
                    child: Container(
                      height: media.width * 1.1,
                      decoration: BoxDecoration(
                        color: theme.primaryContainer,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: theme.primary.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ListView(
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: media.width * 0.03),
                            child: const MainAppBar(),
                          ),
                          const SizedBox(height: 8),

                          // Pie chart with enhanced animation
                          BlocBuilder<ExpenseBloc, ExpenseState>(
                            builder: (context, state) {
                              if (state is ExpenseLoaded) {
                                final expenseData = state.expenses
                                    .map((exp) => {
                                          'category': exp.category,
                                          'price': exp.price,
                                          'quantity': exp.quantity,
                                        })
                                    .toList();

                                return InteractivePieChart(
                                  expenseData: expenseData,
                                  onCategorySelected: _onCategorySelected,
                                  selectedCategory: selectedCategory,
                                );
                              } else {
                                return InteractivePieChart(
                                  expenseData: const [],
                                  onCategorySelected: (_) {},
                                );
                              }
                            },
                          ),

                          const SizedBox(height: 30),
                          // account dropdown
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 80),
                            child: ZoomInDown(
                              delay: const Duration(milliseconds: 500),
                              child: BlocBuilder<AuthBloc, AuthState>(
                                builder: (context, authState) {
                                  if (authState is GetAccountsLoaded &&
                                      authState.accounts.isNotEmpty) {
                                    final accounts = authState.accounts;
                                    return Container(
                                      decoration: BoxDecoration(
                                        color: theme.surface,
                                        border: Border.all(
                                          color: theme.primary.withOpacity(0.3),
                                          width: 1.5,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                theme.primary.withOpacity(0.05),
                                            blurRadius: 8,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      width: 100,
                                      child: DropdownButton<String>(
                                        borderRadius: BorderRadius.circular(20),
                                        dropdownColor: theme.surface,
                                        icon: Icon(
                                          Icons.arrow_drop_down_circle,
                                          color: theme.primary.withOpacity(0.7),
                                        ),
                                        hint: Text(
                                          storage.read('selectedAcc') ??
                                              "Select an account",
                                          style: TextStyle(
                                            color: theme.inversePrimary,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        items: accounts.map((account) {
                                          return DropdownMenuItem<String>(
                                            value: account.accountName,
                                            child: Row(
                                              children: [
                                                Text(
                                                  account.accountName,
                                                  style: TextStyle(
                                                    color: theme.inversePrimary,
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                        isExpanded: true,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16),
                                        underline: const SizedBox(),
                                        onChanged: (String? val) {
                                          if (val != null) {
                                            setState(() {
                                              selectedAccount = val;
                                              selectedCategory = null;
                                            });
                                            storage.write(
                                                'selectedAcc', selectedAccount);

                                            context
                                                .read<ExpenseBloc>()
                                                .add(LoadExpensesEvent(val));
                                            context
                                                .read<UpcomingExpenseBloc>()
                                                .add(LoadUpcomingExpensesEvent(
                                                    val));
                                            context.read<IncomeBloc>().add(
                                                LoadIncomeEvent(
                                                    accountID: val));
                                          }
                                        },
                                      ),
                                    );
                                  } else {
                                    return const SizedBox.shrink();
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Enhanced category filter indicator
              if (selectedCategory != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: FadeTransition(
                      opacity: _animationController,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.05, 0),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(
                          parent: _animationController,
                          curve: Curves.easeOutCubic,
                        )),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 20),
                          decoration: BoxDecoration(
                            color: theme.primaryContainer,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: theme.primary.withOpacity(0.08),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.filter_list_rounded,
                                size: 18,
                                color: theme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Filtered by: $selectedCategory",
                                style: TextStyle(
                                  color: theme.inversePrimary,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              const Spacer(),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(20),
                                  onTap: () {
                                    setState(() {
                                      selectedCategory = null;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Icon(
                                      Icons.close_rounded,
                                      size: 18,
                                      color:
                                          theme.inversePrimary.withOpacity(0.7),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              // Expense list with enhanced styling
              BlocBuilder<ExpenseBloc, ExpenseState>(
                builder: (context, state) {
                  print("Dashboard expense state: ${state.runtimeType}");

                  if (state is ExpenseLoaded) {
                    final expenses = selectedCategory != null
                        ? state.expenses
                            .where((exp) => exp.category == selectedCategory)
                            .toList()
                        : state.expenses;

                    if (state.expenses.isEmpty) {
                      return SliverToBoxAdapter(
                        child: _buildEmptyState(
                          theme,
                          "There are no expenses to be displayed\nAdd an expense first",
                        ),
                      );
                    } else if (expenses.isEmpty && selectedCategory != null) {
                      return SliverToBoxAdapter(
                        child: _buildEmptyState(
                          theme,
                          "No expenses found for $selectedCategory",
                        ),
                      );
                    } else {
                      return SliverPadding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              var exp = expenses[index];
                              return ZoomInDown(
                                delay:
                                    Duration(milliseconds: 500 + (index * 50)),
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 12.0),
                                  child: Slidable(
                                    endActionPane: ActionPane(
                                      motion: const StretchMotion(),
                                      children: [
                                        SlidableAction(
                                          onPressed: (context) {
                                            _showDeleteDialog(
                                                context, theme, exp);
                                          },
                                          icon: Icons.delete_rounded,
                                          backgroundColor: Colors.red.shade400,
                                          foregroundColor: Colors.white,
                                          label: "Delete",
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          padding: const EdgeInsets.all(4),
                                        ),
                                        SlidableAction(
                                          onPressed: (context) {
                                            context.pushNamed('editExpense',
                                                extra: ExpenseModel(
                                                  name: exp.name,
                                                  quantity: exp.quantity,
                                                  price: exp.price,
                                                  accountId: exp.accountId,
                                                  category: exp.category,
                                                  id: exp.id,
                                                  subCategory: exp.subCategory,
                                                  createdAt: DateTime.now()
                                                      .toIso8601String(),
                                                  userId: FirebaseAuth.instance
                                                      .currentUser!.uid,
                                                ));
                                          },
                                          icon: Icons.edit_rounded,
                                          label: "Edit",
                                          backgroundColor:
                                              Colors.green.shade400,
                                          foregroundColor: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          padding: const EdgeInsets.all(4),
                                        ),
                                      ],
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: theme.primaryContainer,
                                        borderRadius: BorderRadius.circular(16),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                theme.primary.withOpacity(0.05),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: MyListTile(
                                        type: exp.category,
                                        title: exp.name,
                                        price: exp.price.toString(),
                                        date: DateTime.parse(exp.createdAt),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            childCount: expenses.length,
                          ),
                        ),
                      );
                    }
                  } else if (state is ExpenseError) {
                    return SliverToBoxAdapter(
                      child: _buildErrorState(theme, state.message),
                    );
                  } else if (state is ExpenseLoading) {
                    return SliverToBoxAdapter(
                      child: _buildLoadingState(theme),
                    );
                  } else {
                    return const SliverToBoxAdapter(
                      child: SizedBox.shrink(),
                    );
                  }
                },
              ),
              // Add some bottom padding
              const SliverToBoxAdapter(
                child: SizedBox(height: 80),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method for showing delete dialog with enhanced styling
  void _showDeleteDialog(BuildContext context, ColorScheme theme, dynamic exp) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: theme.primaryContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            "Delete Expense",
            style: TextStyle(
              color: theme.inversePrimary,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            "Are you sure you want to delete this expense?",
            style: TextStyle(
              color: theme.inversePrimary,
              fontFamily: 'Poppins',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              style: TextButton.styleFrom(
                foregroundColor: theme.inversePrimary.withOpacity(0.7),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<ExpenseBloc>().add(
                      DeleteExpenseEvent(
                        id: exp.id,
                        expense: exp,
                      ),
                    );
                context.read<ExpenseBloc>().add(
                      LoadExpensesEvent(storage.read('selectedAcc') ?? ""),
                    );
                context.pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primary,
                foregroundColor: theme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  // Helper method for empty state
  Widget _buildEmptyState(ColorScheme theme, String message) {
    return FadeIn(
      duration: const Duration(milliseconds: 800),
      child: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Column(
          children: [
            Icon(
              Icons.receipt_long_rounded,
              size: 70,
              color: theme.primary.withOpacity(0.3),
            ),
            const SizedBox(height: 20),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.inversePrimary,
                fontSize: 17,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method for error state
  Widget _buildErrorState(ColorScheme theme, String message) {
    return FadeIn(
      duration: const Duration(milliseconds: 800),
      child: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Column(
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 70,
              color: Colors.red.withOpacity(0.7),
            ),
            const SizedBox(height: 20),
            Text(
              "Error: $message",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.inversePrimary,
                fontSize: 17,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method for loading state
  Widget _buildLoadingState(ColorScheme theme) {
    return FadeIn(
      duration: const Duration(milliseconds: 800),
      child: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/img/wait.png',
              width: 90,
              height: 90,
            ),
            const SizedBox(height: 15),
            Text(
              "Loading expenses...",
              style: TextStyle(
                color: theme.inversePrimary,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
