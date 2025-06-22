import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/components/inline_nav_bar.dart';
import '../../../../core/theme/app_color.dart';

import '../../../expenses/domain/entities/expense_entity.dart';
import '../../domain/entities/limit_entity.dart';
import '../bloc/limit_bloc.dart';
import '../widgets/blur_card.dart';
import '../widgets/info_row.dart';

class LimitDetail extends StatefulWidget {
  final LimitEntity? limit;

  const LimitDetail({super.key, this.limit});

  @override
  State<LimitDetail> createState() => _LimitDetailState();
}

class _LimitDetailState extends State<LimitDetail> {
  bool showDetails = false;
  late LimitEntity limit;
  bool isLoading = true;
  bool isLoadingTransactions = false;
  List<ExpenseEntity> categoryExpenses = [];
  String? transactionError;

  Future<List<ExpenseEntity>> fetchExpenseByCategory() async {
    // Query Firestore for expenses matching the category
    final snapshot = await FirebaseFirestore.instance
        .collection('expenses')
        .where("category", isEqualTo: limit.category)
        .get();

    // Convert the query snapshot to a list of ExpenseEntity objects
    final expenses = snapshot.docs.map((doc) {
      final data = doc.data();
      return ExpenseEntity(
        id: doc.id,
        name: data['name'] ?? '',
        category: data['category'] ?? '',
        subCategory: data['subCategory'] ?? '',
        price: (data['price'] as num).toDouble(),
        quantity: data['quantity'] ?? 1,
        accountId: data['accountId'] ?? '',
        userId: data['userId'] ?? '',
        createdAt: data['createdAt'] ?? DateTime.now().toIso8601String(),
      );
    }).toList();

    // Filter expenses by date range
    return expenses;
  }

  @override
  void initState() {
    super.initState();
    if (widget.limit != null) {
      limit = widget.limit!;
      isLoading = false;
    } else {
      // If limit is not passed, we need to get it from the bloc
      isLoading = true;
    }
  }

  String formatCurrency(double amount) {
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    return formatter.format(amount);
  }

  String formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMM d, yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: theme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16, right: 16, left: 16),
          child: isLoading
              ? Center(
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
                          "Please wait...",
                          style: TextStyle(
                            color: theme.inversePrimary,
                            fontFamily: 'Poppins',
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      const InlineNavBar(
                        title: "Limit Details",
                      ),
                      const SizedBox(height: 15),

                      // Category Icon
                      BounceInDown(
                        duration: const Duration(milliseconds: 800),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: theme.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _getCategoryIcon(limit.category),
                            size: 60,
                            color: theme.primary,
                          ),
                        ),
                      ),

                      const SizedBox(height: 15),

                      // Category Name
                      FadeInUp(
                        duration: const Duration(milliseconds: 900),
                        child: Text(
                          limit.category,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: theme.inversePrimary,
                            fontFamily: 'Arvo',
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Date Range
                      FadeInUp(
                        duration: const Duration(milliseconds: 950),
                        child: Text(
                          "${formatDate(limit.startDate)} - ${formatDate(limit.endDate)}",
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.inversePrimary.withOpacity(0.7),
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Main Card with Details
                      SlideInUp(
                        duration: const Duration(milliseconds: 1000),
                        child: BlurCard(
                          isMaxedOut: limit.spentAmount >= limit.limitAmount,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Category Badge with different style for maxed-out limits
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: limit.spentAmount >= limit.limitAmount
                                      ? Colors.red.withOpacity(0.2)
                                      : theme.onSecondaryContainer,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      limit.category,
                                      style: TextStyle(
                                          color: limit.spentAmount >=
                                                  limit.limitAmount
                                              ? Colors.red
                                              : theme.inversePrimary,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.bold),
                                    ),
                                    // Add indicator for maxed-out limits
                                    if (limit.spentAmount >=
                                        limit.limitAmount) ...[
                                      const SizedBox(width: 8),
                                      const Icon(
                                        Icons.warning_amber_rounded,
                                        color: Colors.red,
                                        size: 16,
                                      ),
                                    ],
                                  ],
                                ),
                              ),

                              const SizedBox(height: 16),

                              // Progress Bar
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: LinearProgressIndicator(
                                  value: (limit.spentAmount / limit.limitAmount)
                                      .clamp(0.0, 1.0),
                                  minHeight: 10,
                                  backgroundColor:
                                      TColor.primary.withOpacity(0.2),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      _getProgressColor(limit.spentAmount /
                                          limit.limitAmount)),
                                ),
                              ),

                              const SizedBox(height: 6),

                              Text(
                                  "${(limit.spentAmount / limit.limitAmount * 100).toStringAsFixed(0)}% used",
                                  style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 14,
                                      fontFamily: 'Poppins')),

                              const SizedBox(height: 20),

                              // Values
                              InfoRow(
                                  label: "Limit Balance",
                                  value: formatCurrency(limit.limitAmount),
                                  theme: theme),

                              InfoRow(
                                  label: "Spending Amount",
                                  value: formatCurrency(limit.spentAmount),
                                  theme: theme),

                              InfoRow(
                                  label: "Remaining",
                                  value: formatCurrency(
                                      limit.limitAmount - limit.spentAmount),
                                  theme: theme),

                              const Divider(color: Colors.grey),

                              const SizedBox(height: 10),

                              InfoRow(
                                  label: "Start",
                                  value: formatDate(limit.startDate),
                                  theme: theme),

                              InfoRow(
                                  label: "End",
                                  value: formatDate(limit.endDate),
                                  theme: theme),

                              const SizedBox(height: 10),

                              // Transactions section
                              Center(
                                child: TextButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      showDetails = !showDetails;
                                      if (showDetails &&
                                          categoryExpenses.isEmpty) {
                                        _loadCategoryExpenses();
                                      }
                                    });
                                  },
                                  icon: Icon(
                                    showDetails
                                        ? Icons.expand_less
                                        : Icons.expand_more,
                                    color: theme.primary,
                                  ),
                                  label: Text(
                                    showDetails
                                        ? "Hide Transactions"
                                        : "Show Transactions",
                                    style: TextStyle(
                                        color: theme.primary,
                                        fontFamily: 'Poppins'),
                                  ),
                                ),
                              ),

                              // Transactions list (expandable)
                              AnimatedCrossFade(
                                firstChild: const SizedBox(),
                                secondChild: _buildTransactionsSection(theme),
                                crossFadeState: showDetails
                                    ? CrossFadeState.showSecond
                                    : CrossFadeState.showFirst,
                                duration: const Duration(milliseconds: 400),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Action Buttons
                      FadeInUp(
                        duration: const Duration(milliseconds: 1100),
                        child: Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  // Navigate to edit limit page
                                  context.pushNamed('editLimit', extra: limit);
                                },
                                icon: const Icon(Icons.edit),
                                label: const Text("Edit"),
                                style: OutlinedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  side: BorderSide(color: theme.primary),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  _showDeleteConfirmation(context);
                                },
                                icon: const Icon(Icons.delete,
                                    color: Colors.white),
                                label: const Text(
                                  "Delete",
                                  style: TextStyle(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                  backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  void _loadCategoryExpenses() async {
    setState(() {
      isLoadingTransactions = true;
      transactionError = null;
    });

    try {
      final expenses = await fetchExpenseByCategory();

      // Sort expenses by date (newest first)
      // expenses.sort((a, b) =>
      //   DateTime.parse(b.createdAt).compareTo(DateTime.parse(a.createdAt))
      // );

      setState(() {
        categoryExpenses = expenses;
        isLoadingTransactions = false;
      });
    } catch (e) {
      setState(() {
        transactionError = e.toString();
        isLoadingTransactions = false;
      });
    }
  }

  Widget _buildTransactionsSection(ColorScheme theme) {
    if (isLoadingTransactions) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              SpinKitThreeBounce(
                color: theme.primary,
                size: 24,
              ),
              const SizedBox(height: 8),
              Text(
                "Loading transactions...",
                style: TextStyle(
                  color: theme.inversePrimary.withOpacity(0.7),
                  fontFamily: 'Poppins',
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    } else if (transactionError != null) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 40,
            ),
            const SizedBox(height: 8),
            Text(
              "Error loading transactions: $transactionError",
              style: TextStyle(
                color: theme.inversePrimary,
                fontFamily: 'Poppins',
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            TextButton(
              onPressed: _loadCategoryExpenses,
              child: Text(
                "Try Again",
                style: TextStyle(
                  color: theme.primary,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          ],
        ),
      );
    } else if (categoryExpenses.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(
              Icons.info_outline,
              color: theme.primary,
              size: 40,
            ),
            const SizedBox(height: 8),
            Text(
              "No transactions found for this category in the selected date range.",
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
    } else {
      return _buildTransactionsList(theme);
    }
  }

  Widget _buildTransactionsList(ColorScheme theme) {
    return Column(
      children: categoryExpenses.map((expense) {
        return FadeInUp(
          delay: const Duration(milliseconds: 100),
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Icon(_getCategoryIcon(expense.category),
                color: theme.primary, size: 20),
            title: Text(expense.name,
                style:
                    TextStyle(color: theme.inversePrimary, fontFamily: 'Arvo')),
            subtitle: Text(
              formatDate(expense.createdAt),
              style: TextStyle(
                  color: theme.inversePrimary.withOpacity(0.7),
                  fontSize: 12,
                  fontFamily: 'Poppins'),
            ),
            trailing: Text(formatCurrency(expense.price * expense.quantity),
                style: TextStyle(
                    color: theme.inversePrimary,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold)),
          ),
        );
      }).toList(),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: theme.primaryContainer,
          title: Text(
            "Delete Limit",
            style: TextStyle(
              color: theme.inversePrimary,
              fontFamily: 'Arvo',
            ),
          ),
          content: Text(
            "Are you sure you want to delete this spending limit?",
            style:
                TextStyle(color: theme.inversePrimary, fontFamily: 'Poppins'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Cancel",
                style: TextStyle(color: theme.inversePrimary),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Delete the limit
                context.read<LimitBloc>().add(
                      DeleteLimitEvent(
                        id: limit.id,
                        accountId: limit.accountId,
                      ),
                    );
                Navigator.pop(context); // Close dialog
                context.pop(); // Go back to previous screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  IconData _getCategoryIcon(String category) {
    final Map<String, IconData> categoryIcons = {
      "Transport": Icons.directions_car,
      "Food": Icons.restaurant,
      "Utilities": Icons.power,
      "Housing": Icons.home,
      "Shopping": Icons.shopping_bag,
      "HealthCare": Icons.medical_services,
      "Education": Icons.school,
    };

    return categoryIcons[category] ?? Icons.category;
  }

  Color _getProgressColor(double progress) {
    if (progress < 0.5) {
      return Colors.green;
    } else if (progress < 0.75) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
