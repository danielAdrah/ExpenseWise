import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../core/components/main_app_bar.dart';
import '../../../../core/theme/app_color.dart';
import '../../../expenses/presentation/bloc/expense_bloc.dart';
import '../../../expenses/presentation/bloc/expense_event.dart';
import '../../../expenses/presentation/bloc/expense_state.dart';
import '../../../settings/presentation/bloc/income_bloc.dart';

class ChartsPage extends StatefulWidget {
  const ChartsPage({super.key});

  @override
  State<ChartsPage> createState() => _ChartsPageState();
}

class _ChartsPageState extends State<ChartsPage> {
  final GetStorage storage = GetStorage();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reload data when returning to this page in case account changed
    _loadData();
  }

  void _loadData() {
    final accountId = storage.read('selectedAcc') ?? "";
    if (accountId.isNotEmpty) {
      context.read<ExpenseBloc>().add(LoadExpensesEvent(accountId));
      context.read<IncomeBloc>().add(LoadIncomeEvent(accountID: accountId));
    }
  }

  // Method to refresh data when account changes
  void refreshData() {
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: theme.surface,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            _loadData();
            // Wait a bit for the data to load
            await Future.delayed(const Duration(milliseconds: 500));
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const MainAppBar(),
                const SizedBox(height: 20),
                sectionTitle('Daily Expenses', theme),
                const SizedBox(height: 5),
                _buildCard(
                  title: 'Daily Expenses',
                  child: _dailyExpensesChart(theme),
                  theme: theme,
                ),
                const SizedBox(height: 16),
                sectionTitle('Income vs Expense', theme),
                const SizedBox(height: 5),
                _buildCard(
                  title: 'Income vs Expense',
                  child: _incomeVsExpenseChart(theme),
                  theme: theme,
                ),
                const SizedBox(height: 16),
                sectionTitle('Spending by Category', theme),
                const SizedBox(height: 5),
                _buildCard(
                  title: 'Spending by Category',
                  child: _categorySpendingChart(theme),
                  theme: theme,
                ),
                const SizedBox(height: 20), // Extra space at bottom
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget sectionTitle(
    String title,
    ColorScheme theme,
  ) {
    return FadeInLeft(
      delay: const Duration(milliseconds: 500),
      curve: Curves.decelerate,
      child: Text(
        title,
        style: TextStyle(
          color: theme.inversePrimary,
          fontWeight: FontWeight.bold,
          fontSize: 17,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }

  Widget _buildCard(
      {required String title,
      required Widget child,
      required ColorScheme theme}) {
    return ZoomIn(
      curve: Curves.decelerate,
      delay: const Duration(milliseconds: 500),
      child: Card(
        color: theme.primaryContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(height: 220, child: child),
        ),
      ),
    );
  }

  Widget _dailyExpensesChart(ColorScheme theme) {
    return BlocBuilder<ExpenseBloc, ExpenseState>(
      builder: (context, state) {
        if (state is ExpenseLoading) {
          return Center(
              child: SpinKitFoldingCube(
            color: TColor.primary2,
            size: 30,
          ));
        } else if (state is ExpenseError) {
          return Center(
            child: Text(
              'Error loading expenses: ${state.message}',
              style: TextStyle(color: theme.error),
            ),
          );
        } else if (state is ExpenseLoaded) {
          if (state.expenses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: theme.primary,
                    size: 40,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "No spending data available",
                    style: TextStyle(
                      color: theme.inversePrimary,
                      fontFamily: 'Poppins',
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          // Calculate daily expenses
          final dailyData = _calculateDailyExpenses(state.expenses);
          final days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
          final maxY = dailyData.isEmpty
              ? 1000.0
              : (dailyData.reduce((a, b) => a > b ? a : b) * 1.2);

          return BarChart(
            BarChartData(
              maxY: maxY,
              titlesData: FlTitlesData(
                topTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 50)),
                rightTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, _) => Text(days[value.toInt()]),
                  ),
                ),
              ),
              gridData: FlGridData(getDrawingVerticalLine: (value) {
                return const FlLine(
                  color: Colors.transparent,
                );
              }, getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: Colors.grey.withOpacity(0.3),
                  strokeWidth: 1,
                );
              }),
              borderData: FlBorderData(show: false),
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  tooltipBgColor: theme.surface,
                ),
              ),
              barGroups: List.generate(dailyData.length, (i) {
                return BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: dailyData[i],
                      width: 25,
                      borderRadius: BorderRadius.circular(13),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0XFF8B5CF6),
                          Color(0XFF5A31F4),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
          );
        } else {
          return Center(
            child: Text(
              'No expense data available',
              style: TextStyle(color: theme.onSurface),
            ),
          );
        }
      },
    );
  }

  Widget _incomeVsExpenseChart(ColorScheme theme) {
    return BlocBuilder<ExpenseBloc, ExpenseState>(
      builder: (context, expenseState) {
        return BlocBuilder<IncomeBloc, IncomeState>(
          builder: (context, incomeState) {
            if (expenseState is ExpenseLoading ||
                incomeState is IncomeLoading) {
              return Center(
                  child: SpinKitFoldingCube(
                color: TColor.primary2,
                size: 30,
              ));
            } else if (expenseState is ExpenseError) {
              return Center(
                child: Text(
                  'Error loading expenses: ${expenseState.message}',
                  style: TextStyle(color: theme.error),
                ),
              );
            } else if (incomeState is IncomeError) {
              return Center(
                child: Text(
                  'Error loading income: ${incomeState.message}',
                  style: TextStyle(color: theme.error),
                ),
              );
            } else {
              double totalExpenses = 0.0;
              double totalIncome = 0.0;

              if (expenseState is ExpenseLoaded) {
                totalExpenses = _calculateTotalExpenses(expenseState.expenses);
              }

              if (incomeState is IncomeLoaded) {
                totalIncome = _calculateTotalIncome(incomeState.income);
              }

              final maxY =
                  [totalIncome, totalExpenses].reduce((a, b) => a > b ? a : b) *
                      1.2;

              return BarChart(
                BarChartData(
                  maxY: maxY > 0 ? maxY : 3000,
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) =>
                            Text(value.toInt() == 0 ? 'Income' : 'Expense'),
                      ),
                    ),
                    leftTitles: const AxisTitles(
                        sideTitles:
                            SideTitles(showTitles: true, reservedSize: 50)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(getDrawingVerticalLine: (value) {
                    return const FlLine(
                      color: Colors.transparent,
                    );
                  }, getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.3),
                      strokeWidth: 1,
                    );
                  }),
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      tooltipBgColor: theme.surface,
                    ),
                  ),
                  barGroups: [
                    BarChartGroupData(x: 0, barRods: [
                      BarChartRodData(
                        toY: totalIncome,
                        width: 40,
                        gradient: const LinearGradient(
                            colors: [Color(0xFF17a2b8), Color(0xFF0d9488)]),
                        borderRadius: BorderRadius.circular(6),
                      )
                    ]),
                    BarChartGroupData(x: 1, barRods: [
                      BarChartRodData(
                        toY: totalExpenses,
                        width: 40,
                        gradient: const LinearGradient(
                            colors: [Color(0xFFFF416C), Color(0xFFFF4B2B)]),
                        borderRadius: BorderRadius.circular(6),
                      )
                    ]),
                  ],
                ),
              );
            }
          },
        );
      },
    );
  }

  Widget _categorySpendingChart(ColorScheme theme) {
    return BlocBuilder<ExpenseBloc, ExpenseState>(
      builder: (context, state) {
        if (state is ExpenseLoading) {
          return Center(
              child: SpinKitFoldingCube(
            color: TColor.primary2,
            size: 30,
          ));
        } else if (state is ExpenseError) {
          return Center(
            child: Text(
              'Error loading expenses: ${state.message}',
              style: TextStyle(color: theme.error),
            ),
          );
        } else if (state is ExpenseLoaded) {
          final categoryData = _calculateCategorySpending(state.expenses);

          // Define all possible categories with their icons
          final categoryInfo = {
            'Food': Icons.restaurant_menu,
            'Transport': Icons.airport_shuttle_outlined,
            'Utilities': Icons.power,
            'Housing': CupertinoIcons.house,
            'Shopping': CupertinoIcons.cart,
            'HealthCare': Icons.monitor_heart,
            'Education': Icons.school,
          };

          // Filter to only show categories that have data
          final filteredCategories = categoryInfo.keys
              .where((category) =>
                  categoryData.containsKey(category) &&
                  categoryData[category]! > 0)
              .toList();

          if (filteredCategories.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: theme.primary,
                    size: 40,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "'No category spending data available'",
                    style: TextStyle(
                      color: theme.inversePrimary,
                      fontFamily: 'Poppins',
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          final values =
              filteredCategories.map((cat) => categoryData[cat]!).toList();
          final icons =
              filteredCategories.map((cat) => categoryInfo[cat]!).toList();

          return BarChart(
            BarChartData(
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 50)),
                rightTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, _) {
                      final index = value.toInt();
                      if (index >= 0 && index < icons.length) {
                        return Icon(icons[index], size: 22);
                      }
                      return const SizedBox.shrink();
                    },
                    reservedSize: 30,
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              barTouchData: BarTouchData(
                touchTooltipData: BarTouchTooltipData(
                  tooltipBgColor: theme.surface,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final index = group.x;
                    if (index >= 0 && index < filteredCategories.length) {
                      return BarTooltipItem(
                          '${filteredCategories[index]} \n \$${values[index].toStringAsFixed(2)}',
                          TextStyle(
                              color: theme.primary,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins'));
                    }
                    return null;
                  },
                ),
              ),
              gridData: FlGridData(getDrawingVerticalLine: (value) {
                return const FlLine(
                  color: Colors.transparent,
                );
              }, getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: Colors.grey.withOpacity(0.3),
                  strokeWidth: 1,
                );
              }),
              barGroups: List.generate(filteredCategories.length, (i) {
                return BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: values[i],
                      width: 22,
                      gradient: const LinearGradient(
                        colors: [
                          Color(0XFF8B5CF6),
                          Color(0XFF5A31F4),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(4),
                    )
                  ],
                );
              }),
            ),
          );
        } else {
          return Center(
            child: Text(
              'No expense data available',
              style: TextStyle(color: theme.onSurface),
            ),
          );
        }
      },
    );
  }

  // Helper method to calculate daily expenses for the last 7 days
  List<double> _calculateDailyExpenses(List<dynamic> expenses) {
    final now = DateTime.now();
    final List<double> dailyTotals = List.filled(7, 0.0);

    // Calculate expenses for each of the last 7 days
    for (var expense in expenses) {
      try {
        final expenseDate = DateTime.parse(expense.createdAt);

        // Check if the expense is within the last 7 days
        final difference = now.difference(expenseDate).inDays;
        if (difference >= 0 && difference < 7) {
          // Get the weekday (0 = Sunday, 1 = Monday, ..., 6 = Saturday)
          final weekday = expenseDate.weekday %
              7; // Convert to 0-based index where 0 is Sunday
          dailyTotals[weekday] += expense.price * expense.quantity;
        }
      } catch (e) {
        // Silently handle parsing errors
      }
    }

    return dailyTotals;
  }

  // Helper method to calculate total expenses for current month
  double _calculateTotalExpenses(List<dynamic> expenses) {
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month);
    final nextMonth = DateTime(now.year, now.month + 1);

    double total = 0.0;
    for (var expense in expenses) {
      try {
        final expenseDate = DateTime.parse(expense.createdAt);
        if (expenseDate
                .isAfter(currentMonth.subtract(const Duration(days: 1))) &&
            expenseDate.isBefore(nextMonth)) {
          total += expense.price * expense.quantity;
        }
      } catch (e) {
        // Silently handle parsing errors
      }
    }

    return total;
  }

  // Helper method to calculate total income for current month
  double _calculateTotalIncome(List<dynamic> incomes) {
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month);
    final nextMonth = DateTime(now.year, now.month + 1);

    double total = 0.0;
    for (var income in incomes) {
      try {
        final incomeDate = DateTime.parse(income.date);
        if (incomeDate
                .isAfter(currentMonth.subtract(const Duration(days: 1))) &&
            incomeDate.isBefore(nextMonth)) {
          total += income.amount;
        }
      } catch (e) {
        // Silently handle parsing errors
      }
    }

    return total;
  }

  // Helper method to calculate category-wise spending for current month
  Map<String, double> _calculateCategorySpending(List<dynamic> expenses) {
    final now = DateTime.now();
    final currentMonth = DateTime(now.year, now.month);
    final nextMonth = DateTime(now.year, now.month + 1);

    final Map<String, double> categoryTotals = {};

    for (var expense in expenses) {
      try {
        final expenseDate = DateTime.parse(expense.createdAt);
        if (expenseDate
                .isAfter(currentMonth.subtract(const Duration(days: 1))) &&
            expenseDate.isBefore(nextMonth)) {
          final category = expense.category;
          final amount = expense.price * expense.quantity;
          categoryTotals[category] = (categoryTotals[category] ?? 0.0) + amount;
        }
      } catch (e) {
        // Silently handle parsing errors
      }
    }

    return categoryTotals;
  }
}
