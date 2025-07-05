// ignore_for_file: avoid_print

import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../core/theme/app_color.dart';
import '../../../expenses/domain/entities/expense_entity.dart';
import '../widgets/subPiechart.dart';

class StatisticsView extends StatefulWidget {
  const StatisticsView({super.key});

  @override
  State<StatisticsView> createState() => _StatisticsViewState();
}

class _StatisticsViewState extends State<StatisticsView> {
  // Separate boolean flags for each category section
  Map<String, bool> showDetailsMap = {
    'Transport': false,
    'Food': false,
    'Utilities': false,
    'Housing': false,
    'Shopping': false,
    'HealthCare': false,
    'Education': false,
  };

  bool isLoadingExpenses = false;
  bool isLoadingCharts = true;

  // Store expenses for each category
  Map<String, List<Map<String, dynamic>>> categoryExpenses = {
    'Transport': [],
    'Food': [],
    'Utilities': [],
    'Housing': [],
    'Shopping': [],
    'HealthCare': [],
    'Education': [],
  };

  // Track which categories have data
  Map<String, bool> categoriesWithData = {
    'Transport': false,
    'Food': false,
    'Utilities': false,
    'Housing': false,
    'Shopping': false,
    'HealthCare': false,
    'Education': false,
  };

  // List of all possible categories
  final List<String> allCategories = [
    'Transport',
    'Food',
    'Utilities',
    'Housing',
    'Shopping',
    'HealthCare',
    'Education'
  ];

  final GetStorage storage = GetStorage();

  @override
  void initState() {
    super.initState();
    _loadAllChartsData();
  }

  // Method to load all charts data simultaneously
  Future<void> _loadAllChartsData() async {
    setState(() {
      isLoadingCharts = true;
    });

    try {
      final accountId = storage.read('selectedAcc') ?? "";
      if (accountId.isEmpty) {
        print("No account ID found in storage");
        setState(() {
          isLoadingCharts = false;
        });
        return;
      }

      // Check each category for data
      for (String category in allCategories) {
        final expenses = await fetchExpenseByCategory(category);
        categoriesWithData[category] = expenses.isNotEmpty;
        print("Category $category has data: ${categoriesWithData[category]}");
      }

      setState(() {
        isLoadingCharts = false;
      });
    } catch (e) {
      print("Error loading charts data: $e");
      setState(() {
        isLoadingCharts = false;
      });
    }
  }

  // Method to fetch expenses for a specific category and update the UI
  Future<void> fetchCategoryExpenses(String category) async {
    setState(() {
      isLoadingExpenses = true;
    });

    try {
      print("Fetching expenses for category: $category");

      // Use your existing method to fetch expenses by category
      final expenses = await fetchExpenseByCategory(category);

      print("Found ${expenses.length} expenses for category: $category");

      // Convert ExpenseEntity objects to the map format used by your UI
      final expenseMaps = expenses
          .map((exp) => {
                'id': exp.id,
                'name': exp.name,
                'amount': '\$${(exp.price * exp.quantity).toStringAsFixed(2)}',
                'category': exp.category,
                'subCategory': exp.subCategory,
                'date': exp.createdAt,
              })
          .toList();

      setState(() {
        categoryExpenses[category] = expenseMaps;
        isLoadingExpenses = false;
      });

      print("Updated UI with ${expenseMaps.length} expenses for $category");
    } catch (e) {
      print("Error fetching category expenses: $e");
      setState(() {
        isLoadingExpenses = false;
      });
    }
  }

  Future<List<ExpenseEntity>> fetchExpenseByCategory(String category) async {
    final accountId = storage.read('selectedAcc') ?? "";
    if (accountId.isEmpty) {
      print("No account ID found in storage");
      return [];
    }

    print(
        "Fetching expenses for category: $category, accountId: $accountId, userId: ${FirebaseAuth.instance.currentUser!.uid}");

    // Query Firestore for expenses matching the category, user ID, and account ID
    final snapshot = await FirebaseFirestore.instance
        .collection('expenses')
        .where("category", isEqualTo: category)
        .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where("accountId", isEqualTo: accountId)
        .get();

    print("Query returned ${snapshot.docs.length} documents");

    // If no results with exact category match, try a case-insensitive search
    if (snapshot.docs.isEmpty) {
      print("No exact matches, trying case-insensitive search");
      final allSnapshot = await FirebaseFirestore.instance
          .collection('expenses')
          .where("accountId", isEqualTo: accountId)
          .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      // Filter manually for case-insensitive match
      final filteredDocs = allSnapshot.docs.where((doc) {
        final data = doc.data();
        final expCategory = (data['category'] as String?)?.toLowerCase() ?? '';
        return expCategory == category.toLowerCase();
      }).toList();

      print("Case-insensitive search found ${filteredDocs.length} matches");

      // Convert filtered docs to ExpenseEntity objects
      return filteredDocs.map((doc) {
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
    }

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

    return expenses;
  }

  // Helper method to get subcategories for a main category
  List<String> getSubcategoriesForMainCategory(String mainCategory) {
    final Map<String, List<String>> categoryData = {
      "Transport": ["Car", "Train", "Plane"],
      "Food": ["Groceries", "Restaurant", "Snacks", "Drinks"],
      "Utilities": ["Electricity", "Water", "Internet"],
      "Housing": ["Rent", "House Fixing", "Furniture"],
      "Shopping": ['Electronics', 'Clothing', 'Home Goods'],
      "HealthCare": ['Therapy', 'Medicin', 'Doctor Visits'],
      "Education": ['Tuition Fees', 'Courses', 'Books&Supplies'],
    };

    return categoryData[mainCategory] ?? [];
  }

  // Get icon for a specific subcategory
  IconData getCategoryIcon(String category, String? subCategory) {
    final Map<String, IconData> subcategoryIcons = {
      "Car": CupertinoIcons.car,
      "Train": Icons.train_outlined,
      "Plane": CupertinoIcons.airplane,
      "Groceries": CupertinoIcons.shopping_cart,
      "Restaurant": Icons.restaurant_menu_outlined,
      "Snacks": Icons.cake_outlined,
      "Drinks": Icons.emoji_food_beverage_rounded,
      "Electricity": Icons.electric_bolt,
      "Water": Icons.water_drop,
      "Internet": Icons.wifi,
      "Rent": Icons.home,
      "House Fixing": Icons.handyman,
      "Furniture": Icons.chair,
      "Electronics": Icons.devices,
      "Clothing": Icons.checkroom,
      "Home Goods": Icons.home_work,
      "Therapy": Icons.psychology,
      "Medicin": Icons.medication,
      "Doctor Visits": Icons.medical_services,
      "Tuition Fees": Icons.school,
      "Courses": Icons.book,
      "Books&Supplies": Icons.menu_book,
    };

    final Map<String, IconData> categoryIcons = {
      "Transport": CupertinoIcons.car_detailed,
      "Food": CupertinoIcons.cart,
      "Utilities": Icons.power,
      "Housing": CupertinoIcons.house,
      "Shopping": CupertinoIcons.bag_fill,
      "HealthCare": Icons.monitor_heart,
      "Education": Icons.school,
    };

    // First check if we have a subcategory icon
    if (subCategory != null &&
        subCategory.isNotEmpty &&
        subcategoryIcons.containsKey(subCategory)) {
      return subcategoryIcons[subCategory]!;
    }

    // Then check if the category itself has an icon in the subcategory map
    if (subcategoryIcons.containsKey(category)) {
      return subcategoryIcons[category]!;
    }

    // Finally, use the main category icon
    return categoryIcons[category] ?? CupertinoIcons.money_dollar_circle;
  }

  // Build a category section with its expenses
  Widget buildCategorySection(String category, ColorScheme theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: theme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.primary.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SubPireChart(mainCategory: category),
          ),
          // More Details button with improved styling
          Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: theme.primaryContainer.withOpacity(0.2),
                borderRadius: BorderRadius.circular(30),
              ),
              child: InkWell(
                onTap: () {
                  setState(() {
                    showDetailsMap[category] = !showDetailsMap[category]!;
                    if (showDetailsMap[category]! &&
                        categoryExpenses[category]!.isEmpty) {
                      fetchCategoryExpenses(category);
                    }
                  });
                },
                borderRadius: BorderRadius.circular(30),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      showDetailsMap[category]!
                          ? "Hide Details"
                          : "More Details",
                      style: TextStyle(
                        color: theme.primary,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    AnimatedRotation(
                      turns: showDetailsMap[category]! ? 0.5 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        color: theme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Rest of the content with improved animations
          AnimatedCrossFade(
            firstChild: const SizedBox(),
            secondChild: isLoadingExpenses && showDetailsMap[category]!
                ? _buildLoadingIndicator(theme)
                : categoryExpenses[category]!.isEmpty
                    ? _buildEmptyState(theme)
                    : _buildTransactionsList(category, theme),
            crossFadeState: showDetailsMap[category]!
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 400),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator(ColorScheme theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SpinKitPulse(
              color: theme.primary,
              size: 40,
            ),
            const SizedBox(height: 12),
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
  }

  Widget _buildEmptyState(ColorScheme theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.primaryContainer.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.receipt_long_outlined,
                color: theme.primary,
                size: 32,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "No transactions found",
              style: TextStyle(
                color: theme.inversePrimary,
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Transactions in this category will appear here",
              style: TextStyle(
                color: theme.inversePrimary.withOpacity(0.7),
                fontFamily: 'Poppins',
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionsList(String category, ColorScheme theme) {
    return Column(
      children: [
        const Divider(height: 1, thickness: 1, indent: 16, endIndent: 16),
        ...categoryExpenses[category]!.map((expense) {
          return FadeInUp(
            delay: const Duration(milliseconds: 50),
            duration: const Duration(milliseconds: 300),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: theme.surfaceVariant.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.primaryContainer.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    getCategoryIcon(
                        expense['category'], expense['subCategory']),
                    color: theme.primary,
                    size: 20,
                  ),
                ),
                title: Text(
                  expense['name'],
                  style: TextStyle(
                    color: theme.inversePrimary,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: theme.primaryContainer.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    expense['amount'],
                    style: TextStyle(
                      color: theme.primary,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
        const SizedBox(height: 8),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    // Get list of categories that have data
    final categoriesWithContent = allCategories
        .where((category) => categoriesWithData[category] == true)
        .toList();

    return Scaffold(
      backgroundColor: theme.surface,
      appBar: AppBar(
        elevation: 0.0,
        title: ZoomIn(
          delay: const Duration(milliseconds: 200),
          curve: Curves.decelerate,
          child: Text(
            "Statistics",
            style: TextStyle(
                color: theme.inversePrimary,
                fontSize: 24,
                fontFamily: "Poppins",
                fontWeight: FontWeight.bold),
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: FadeInLeft(
          duration: const Duration(milliseconds: 200),
          curve: Curves.decelerate,
          child: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: theme.primaryContainer.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: theme.inversePrimary,
                  size: 16,
                ),
              )),
        ),
        actions: [
          FadeInRight(
              duration: const Duration(milliseconds: 200),
              curve: Curves.decelerate,
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child:
                    Image.asset("assets/img/logo1.png", width: 55, height: 55),
              )),
        ],
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: isLoadingCharts
            ? _buildLoadingState(theme)
            : categoriesWithContent.isEmpty
                ? _buildEmptyDataState(theme)
                : _buildContentState(categoriesWithContent, theme),
      ),
      floatingActionButton: !isLoadingCharts
          ? FloatingActionButton.extended(
              onPressed: _loadAllChartsData,
              tooltip: "Refresh statistics",
              icon: const Icon(Icons.refresh),
              label: const Text("Refresh"),
              elevation: 4,
            )
          : null,
    );
  }

  Widget _buildLoadingState(ColorScheme theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SpinKitFoldingCube(
            color: TColor.primary2,
            size: 50,
          ),
          const SizedBox(height: 24),
          Text(
            "Loading your statistics...",
            style: TextStyle(
              color: theme.inversePrimary,
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "We're crunching your numbers",
            style: TextStyle(
              color: theme.inversePrimary.withOpacity(0.7),
              fontFamily: 'Poppins',
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyDataState(ColorScheme theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.primaryContainer.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.bar_chart,
              color: theme.primary,
              size: 64,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "No expense data available",
            style: TextStyle(
              color: theme.inversePrimary,
              fontFamily: 'Poppins',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              "Add some expenses to see your statistics and track your spending habits",
              style: TextStyle(
                color: theme.inversePrimary.withOpacity(0.7),
                fontFamily: 'Poppins',
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.add),
            label: const Text("Add Expense"),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentState(
      List<String> categoriesWithContent, ColorScheme theme) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: FadeInUp(
        delay: const Duration(milliseconds: 300),
        curve: Curves.decelerate,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ZoomInDown(
                delay: const Duration(milliseconds: 200),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: theme.primaryContainer,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.insights,
                        color: theme.primary,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Zoom Into Your Spendings",
                          style: TextStyle(
                            color: theme.inversePrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Poppins",
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Dynamically build only categories with data
            ...categoriesWithContent
                .expand((category) => [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        child: _buildSectionHeader(category, theme),
                      ),
                      buildCategorySection(category, theme),
                      const SizedBox(height: 24),
                    ])
                .toList(),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String category, ColorScheme theme) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.primaryContainer.withOpacity(0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            getCategoryIcon(category, null),
            color: theme.primary,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          category,
          style: TextStyle(
            color: theme.inversePrimary,
            fontFamily: 'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
