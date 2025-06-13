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
  final AddUpcomingExpenseUseCase addUpcomingExpense;
  final UpdateUpcomingExpenseUseCase updateUpcomingExpense;
  final DeleteUpcomingExpenseUseCase deleteUpcomingExpense;
  final GetUpcomingExpensesUseCase getUpcomingExpense;

  ExpenseBloc({
    required this.addExpense,
    required this.updateExpense,
    required this.deleteExpense,
    required this.getExpenses,
    required this.addUpcomingExpense,
    required this.updateUpcomingExpense,
    required this.deleteUpcomingExpense,
    required this.getUpcomingExpense,
  }) : super(ExpenseInitial()) {
    on<LoadExpensesEvent>(_onLoadExpenses);
    on<AddExpenseEvent>(_onAddExpense);
    on<UpdateExpenseEvent>(_onUpdateExpense);
    on<DeleteExpenseEvent>(_onDeleteExpense);
    on<LoadUpcomingExpensesEvent>(_onLoadUpcomingExpense);
    on<AddUpcomingExpenseEvent>(_onAddUpcomingExpense);
    on<UpdateUpcomingExpenseEvent>(_onUpdateUpcomingExpense);
    on<DeleteUpcomingExpenseEvent>(_onDeleteUpcomingExpense);
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
      print("from exp bloc 3");
    } catch (e) {
      print("error in fetch exp bloc $e");
      emit(ExpenseError(e.toString()));
    }
  }

  //----
  Future<void> _onLoadUpcomingExpense(
      LoadUpcomingExpensesEvent event, Emitter<ExpenseState> emit) async {
    emit(UpcomingExpenseLoading());
    print("from upexp bloc 1");
    try {
      print("rrrrrrrrrrrrrrr ${event.accountId}");
      final expenses = await getUpcomingExpense(event.accountId);
      print("from upexp bloc 2");
      emit(UpcomingExpenseLoaded(expenses));
      print("from upexp bloc 3");
    } catch (e) {
      print("error in fetch upexp bloc $e");
      emit(UpcomingExpenseError(e.toString()));
    }
  }

//===================================================
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

  //---
  Future<void> _onAddUpcomingExpense(
      AddUpcomingExpenseEvent event, Emitter<ExpenseState> emit) async {
    emit(AddUpcomingExpenseInProgress());
    try {
      print("from addupexp bloc 1");
      await addUpcomingExpense(event.expense);
      print("from addupexp bloc 2");
      add(LoadUpcomingExpensesEvent(event.expense.accountId));
      emit(AddUpcomingExpenseDone());
      print("from addupexp bloc 3");
    } catch (e) {
      print("error inup bloc $e");
      // emit(AddExpenseError('Failed to create expense'));
    }
  }
//===================================================

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

  //---
  Future<void> _onUpdateUpcomingExpense(
      UpdateUpcomingExpenseEvent event, Emitter<ExpenseState> emit) async {
    emit(UpdateUpcomingExpenseInProgress());
    try {
      print("from upupexp bloc 1");
      await updateUpcomingExpense(event.expense);
      print("from upupexp bloc 2");
      emit(UpdateUpcomingExpenseDone());
      add(LoadUpcomingExpensesEvent(event.expense.accountId));
      print("from uuppexp bloc 3");
    } catch (e) {
      print("error in bloc $e");
      // emit(UpdateExpenseError('Failed to update this expense'));
    }
  }

//====================================================
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
  }

  //---
  Future<void> _onDeleteUpcomingExpense(
      DeleteUpcomingExpenseEvent event, Emitter<ExpenseState> emit) async {
    emit(DeleteUpcomingExpenseInProgress());
    try {
      print("from delupexp bloc 1");
      await deleteUpcomingExpense(event.id);
      emit(DeleteUpcomingExpenseDone());

      print("from delupexp bloc 2");
    } catch (e) {
      print("error in bloc $e");
      // emit(DeleteExpenseError('Failed to delete this expense'));
    }
  }
}
