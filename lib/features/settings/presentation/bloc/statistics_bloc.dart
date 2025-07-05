// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../expenses/domain/entities/expense_entity.dart';
import '../../../expenses/domain/usecases/usecases.dart';
import 'statistics_event.dart';
import 'statistics_state.dart';
import 'package:flutter/cupertino.dart';

class StatisticsBloc extends Bloc<StatisticsEvent, StatisticsState> {
  final GetExpensesUseCase getExpenses;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Category structure with subcategories and icons
  final Map<String, Map<String, IconData>> categoryData = {
    "Transport": {
      "Car": CupertinoIcons.car_detailed,
      "Train": CupertinoIcons.tram_fill,
      "Plane": CupertinoIcons.airplane,
      "Bus": CupertinoIcons.bus,
      "Taxi": CupertinoIcons.car_fill,
    },
    "Food": {
      "Groceries": CupertinoIcons.cart_fill,
      "Restaurant": Icons.restaurant_menu_outlined,
      "Snacks": CupertinoIcons.flame_fill,
      "Drinks": Icons.local_drink,
    },
    "Utilities": {
      "Electricity": CupertinoIcons.bolt_fill,
      "Water": CupertinoIcons.drop_fill,
      "Internet": CupertinoIcons.wifi,
    },
    "Housing": {
      "Rent": CupertinoIcons.house_fill,
      "House Fixing": CupertinoIcons.hammer_fill,
      "Furniture": CupertinoIcons.bed_double_fill,
    },
    "Shopping": {
      'Electronics': CupertinoIcons.bolt,
      'Clothing': CupertinoIcons.tag_fill,
      'Home Goods': CupertinoIcons.gift_fill,
    },
    "HealthCare": {
      'Therapy': CupertinoIcons.heart_fill,
      'Medicin': CupertinoIcons.bandage_fill,
      'Doctor Visits': CupertinoIcons.person_crop_circle_fill_badge_plus,
    },
    "Education": {
      'Tuition Fees': CupertinoIcons.money_dollar_circle_fill,
      'Courses': CupertinoIcons.book_fill,
      'Books&Supplies': CupertinoIcons.pencil,
    },
    "Other": {}
  };

  StatisticsBloc({required this.getExpenses}) : super(StatisticsInitial()) {
    on<LoadStatisticsEvent>(_onLoadStatistics);
  }

  Future<void> _onLoadStatistics(
      LoadStatisticsEvent event, Emitter<StatisticsState> emit) async {
    emit(StatisticsLoading());
    try {
      final expenses = await getExpenses(event.accountId);

      // Group expenses by main category
      final Map<String, List<ExpenseEntity>> expensesByCategory = {};

      // Group expenses by subcategory within each main category
      final Map<String, Map<String, double>> subcategoryBreakdown = {};

      for (var expense in expenses) {
        final mainCategory = determineMainCategory(expense.category);

        // Add to expenses by category
        if (!expensesByCategory.containsKey(mainCategory)) {
          expensesByCategory[mainCategory] = [];
        }
        expensesByCategory[mainCategory]!.add(expense);

        // Add to subcategory breakdown
        if (!subcategoryBreakdown.containsKey(mainCategory)) {
          subcategoryBreakdown[mainCategory] = {};
        }

        final amount = expense.price * expense.quantity;
        final subcategory = expense.category;

        subcategoryBreakdown[mainCategory]![subcategory] =
            (subcategoryBreakdown[mainCategory]![subcategory] ?? 0) + amount;
      }

      emit(StatisticsLoaded(
        expensesByCategory: expensesByCategory,
        subcategoryBreakdown: subcategoryBreakdown,
      ));
    } catch (e) {
      emit(StatisticsError(message: e.toString()));
    }
  }

  // Determine which main category a subcategory belongs to
  String determineMainCategory(String subcategory) {
    for (var entry in categoryData.entries) {
      if (entry.value.containsKey(subcategory)) {
        return entry.key;
      }
    }
    return "Other"; // Default category if not found
  }

  // Get icon for a specific subcategory
  IconData getIconForCategory(String mainCategory, String subCategory) {
    if (categoryData.containsKey(mainCategory) &&
        categoryData[mainCategory]!.containsKey(subCategory)) {
      return categoryData[mainCategory]![subCategory]!;
    }
    // Default icon if not found
    return CupertinoIcons.money_dollar_circle;
  }

  // Get total spending for a category
  double getTotalSpendingForCategory(
      String category, Map<String, Map<String, double>> subcategoryBreakdown) {
    if (!subcategoryBreakdown.containsKey(category)) {
      return 0.0;
    }

    return subcategoryBreakdown[category]!
        .values
        .fold(0.0, (sum, amount) => sum + amount);
  }
}
