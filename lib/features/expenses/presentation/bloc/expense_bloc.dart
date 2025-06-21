// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/expense_entity.dart';
import '../../domain/usecases/usecases.dart';
import 'expense_event.dart';
import 'expense_state.dart';
import '../../domain/services/limit_update_service.dart';
import '../../../spendings_limits/presentation/bloc/limit_bloc.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final AddExpenseUseCase addExpense;
  final UpdateExpenseUseCase updateExpense;
  final DeleteExpenseUseCase deleteExpense;
  final GetExpensesUseCase getExpenses;
  final LimitUpdateService limitUpdateService;
  final LimitBloc limitBloc;

  ExpenseBloc({
    required this.addExpense,
    required this.updateExpense,
    required this.deleteExpense,
    required this.getExpenses,
    required this.limitUpdateService,
    required this.limitBloc,
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
      // Add the expense
      await addExpense(event.expense);
      
      // Find matching limit ID
      final limitId = await limitUpdateService.findMatchingLimitId(event.expense);
      
      // If a matching limit was found, update it
      if (limitId != null) {
        final expenseAmount = event.expense.price * event.expense.quantity;
        print("Updating limit $limitId with amount $expenseAmount");
        limitBloc.add(
          UpdateLimitSpendingEvent(
            id: limitId,
            amount: expenseAmount,
            accountId: event.expense.accountId,
          ),
        );
      }
      
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
  
  // New method to update matching spending limit
  Future<void> _updateMatchingSpendingLimit(ExpenseEntity expense) async {
    try {
      final expenseDate = DateTime.parse(expense.createdAt);
      final expenseAmount = expense.price * expense.quantity;
      
      // Query for active limits matching the expense category
      final limitsSnapshot = await FirebaseFirestore.instance
          .collection('limits')
          .where('category', isEqualTo: expense.category)
          .where('accountId', isEqualTo: expense.accountId)
          .get();
      
      // Check each limit to see if the expense date falls within its date range
      for (var doc in limitsSnapshot.docs) {
        final data = doc.data();
        final startDate = DateTime.parse(data['startDate']);
        final endDate = DateTime.parse(data['endDate']);
        
        // Check if expense date is within limit date range
        if (expenseDate.isAfter(startDate.subtract(const Duration(days: 1))) && 
            expenseDate.isBefore(endDate.add(const Duration(days: 1)))) {
          
          // Found a matching limit, update its spent amount
          await FirebaseFirestore.instance.collection('limits').doc(doc.id).update({
            'spentAmount': (data['spentAmount'] as num).toDouble() + expenseAmount
          });
          
          print("Updated spending limit ${doc.id} for category ${expense.category}");
          break; // Update only the first matching limit
        }
      }
    } catch (e) {
      // Log error but don't throw - we don't want to fail the expense creation
      print("Error updating spending limit: $e");
    }
  }
}








