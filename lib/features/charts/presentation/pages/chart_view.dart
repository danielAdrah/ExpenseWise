import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../../core/components/main_app_bar.dart';

class ChartsPage extends StatelessWidget {
  const ChartsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: theme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
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
            ],
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
    final List<double> expenses = [600, 200, 150, 300, 420, 800, 700];
    final days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return BarChart(
      BarChartData(
        maxY: 1000,
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
              // interval: 1,
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
        barGroups: List.generate(expenses.length, (i) {
          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: expenses[i],
                width: 25,
                borderRadius: BorderRadius.circular(13),
                // color: theme.primary,
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
  }

  Widget _incomeVsExpenseChart(ColorScheme theme) {
    const income = 1300.0;
    const expense = 1200.0;

    return BarChart(
      BarChartData(
        maxY: 3000,
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, _) =>
                  Text(value.toInt() == 0 ? 'Income' : 'Expense'),
            ),
          ),
          leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 50)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
              toY: income,
              width: 40,
              // color:
              gradient: const LinearGradient(
                  colors: [Color(0xFF17a2b8), Color(0xFF0d9488)]),
              borderRadius: BorderRadius.circular(6),
            )
          ]),
          BarChartGroupData(x: 1, barRods: [
            BarChartRodData(
              toY: expense,
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

  Widget _categorySpendingChart(ColorScheme theme) {
    final categories = [
      'Food',
      'Transport',
      'Utilities',
      'Housing',
      'Shopping',
      'HealthCare',
      'Education'
    ];
    List<IconData> icons = [
      Icons.restaurant_menu,
      Icons.airport_shuttle_outlined,
      CupertinoIcons.wrench,
      CupertinoIcons.house,
      CupertinoIcons.cart,
      Icons.monitor_heart,
      CupertinoIcons.lab_flask,
    ];
    final values = [350.0, 280.0, 220.0, 150.0, 600.0, 400.0, 1500.0];

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
              interval: 20,
              getTitlesWidget: (value, _) =>
                  Icon(icons[value.toInt()], size: 22),

              // Text(categories[value.toInt()]),
              reservedSize: 30,
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: theme.surface,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                  '${categories[group.x]} \n \$${values[group.x]}',
                  TextStyle(
                      color: theme.primary,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins'));
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
        barGroups: List.generate(categories.length, (i) {
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
                // color: Colors.grey.shade600,
                borderRadius: BorderRadius.circular(4),
              )
            ],
            // showingTooltipIndicators: [0],
          );
        }),
      ),
    );
  }
}
