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

  @override
  void onTransition(Transition<ExpenseEvent, ExpenseState> transition) {
    super.onTransition(transition);
    print('ExpenseBloc: ${transition.event} -> ${transition.currentState} -> ${transition.nextState}');
  }

  Future<void> _onLoadExpenses(
      LoadExpensesEvent event, Emitter<ExpenseState> emit) async {
    emit(ExpenseLoading());
    
    try {
      final expenses = await getExpenses(event.accountId);
      emit(ExpenseLoaded(expenses));
    } catch (e) {
      print("Error loading expenses: $e");
      emit(ExpenseError(e.toString()));
    }
  }

  Future<void> _onAddExpense(
      AddExpenseEvent event, Emitter<ExpenseState> emit) async {
    emit(AddExpenseInProgress());
    try {
      await addExpense(event.expense);
      add(LoadExpensesEvent(event.expense.accountId));
      emit(AddExpenseDone());
    } catch (e) {
      print("Error in add expense: $e");
      emit(AddExpenseError('Failed to create expense'));
    }
  }

  Future<void> _onUpdateExpense(
      UpdateExpenseEvent event, Emitter<ExpenseState> emit) async {
    emit(UpdateExpenseInProgress());
    try {
      await updateExpense(event.expense);
      add(LoadExpensesEvent(event.expense.accountId));
      emit(UpdateExpenseDone());
    } catch (e) {
      print("Error in update expense: $e");
      emit(UpdateExpenseError('Failed to update this expense'));
    }
  }

  Future<void> _onDeleteExpense(
      DeleteExpenseEvent event, Emitter<ExpenseState> emit) async {
    emit(DeleteExpenseInProgress());
    try {
      await deleteExpense(event.id);
      emit(DeleteExpenseDone());
    } catch (e) {
      print("Error in delete expense: $e");
      emit(DeleteExpenseError('Failed to delete this expense'));
    }
  }
}


