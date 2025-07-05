import 'package:equatable/equatable.dart';
import '../../../expenses/domain/entities/expense_entity.dart';

abstract class StatisticsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class StatisticsInitial extends StatisticsState {}

class StatisticsLoading extends StatisticsState {}

class StatisticsLoaded extends StatisticsState {
  final Map<String, List<ExpenseEntity>> expensesByCategory;
  final Map<String, Map<String, double>> subcategoryBreakdown;

  StatisticsLoaded({
    required this.expensesByCategory,
    required this.subcategoryBreakdown,
  });
}

class StatisticsError extends StatisticsState {
  final String message;

  StatisticsError({required this.message});
}

