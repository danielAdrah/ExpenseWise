// ignore_for_file: avoid_print

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/usecases.dart';
import 'expense_event.dart';
import 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final AddExpenseUseCase addExpense;
  final UpdateExpenseUseCase updateExpense;
  final DeleteExpenseUseCase deleteExpense;
  final GetExpensesUseCase getExpenses;

  ExpenseBloc({
    required this.addExpense,
    required this.updateExpense,
    required this.deleteExpense,
    required this.getExpenses,
  }) : super(ExpenseInitial()) {
    on<LoadExpensesEvent>(_onLoadExpenses);
    on<AddExpenseEvent>(_onAddExpense);
    on<UpdateExpenseEvent>(_onUpdateExpense);
    on<DeleteExpenseEvent>(_onDeleteExpense);
  }

  Future<void> _onLoadExpenses(
      LoadExpensesEvent event, Emitter<ExpenseState> emit) async {
    emit(ExpenseLoading());
    print("from exp bloc 1");
    try {
      print("rrrrrrrrrrrrrrr ${event.accountId}");
      final expenses = await getExpenses(event.accountId);
      print("from exp bloc 2");
      emit(ExpenseLoaded(expenses));
    } catch (e) {
      print("error in fetch exp bloc $e");
      emit(ExpenseError(e.toString()));
    }
  }

  Future<void> _onAddExpense(
      AddExpenseEvent event, Emitter<ExpenseState> emit) async {
    emit(AddExpenseInProgress());
    try {
      print("from addexp bloc 1");
      await addExpense(event.expense);
      print("from addexp bloc 2");
      add(LoadExpensesEvent(event.expense.accountId));
      emit(AddExpenseDone());
      print("from addexp bloc 3");
    } catch (e) {
      print("error in bloc $e");
      emit(AddExpenseError('Failed to create expense'));
    }
  }

  Future<void> _onUpdateExpense(
      UpdateExpenseEvent event, Emitter<ExpenseState> emit) async {
    emit(UpdateExpenseInProgress());
    try {
      print("from upexp bloc 1");
      await updateExpense(event.expense);
      print("from upexp bloc 2");
      add(LoadExpensesEvent(event.expense.accountId));
      emit(UpdateExpenseDone());
      print("from upexp bloc 3");
    } catch (e) {
      print("error in bloc $e");
      emit(UpdateExpenseError('Failed to update this expense'));
    }
  }

  Future<void> _onDeleteExpense(
      DeleteExpenseEvent event, Emitter<ExpenseState> emit) async {
    emit(DeleteExpenseInProgress());
    try {
      print("from delexp bloc 1");
      await deleteExpense(event.id);
      emit(DeleteExpenseDone());
      
      print("from delexp bloc 2");
    } catch (e) {
      print("error in bloc $e");
      emit(DeleteExpenseError('Failed to delete this expense'));
    }

    // You can reload current account's expenses if you save currentAccountId in state
  }
}
