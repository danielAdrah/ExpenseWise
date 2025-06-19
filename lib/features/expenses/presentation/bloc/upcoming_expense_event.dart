import 'package:equatable/equatable.dart';
import '../../domain/entities/upcoming_expense_entity.dart';

abstract class UpcomingExpenseEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadUpcomingExpensesEvent extends UpcomingExpenseEvent {
  final String accountId;
  LoadUpcomingExpensesEvent(this.accountId);
  @override
  List<Object> get props => [accountId];
}

class AddUpcomingExpenseEvent extends UpcomingExpenseEvent {
  final UpcomingExpenseEntity expense;
  AddUpcomingExpenseEvent(this.expense);
  @override
  List<Object> get props => [expense];
}

class UpdateUpcomingExpenseEvent extends UpcomingExpenseEvent {
  final UpcomingExpenseEntity expense;
  UpdateUpcomingExpenseEvent(this.expense);
  @override
  List<Object> get props => [expense];
}

class DeleteUpcomingExpenseEvent extends UpcomingExpenseEvent {
  final String id;
  DeleteUpcomingExpenseEvent(this.id);
  @override
  List<Object> get props => [id];
}