// ignore_for_file: avoid_print

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entity/income_entity.dart';
import '../../domain/usecases/income_usecases.dart';
part 'income_event.dart';
part 'income_state.dart';

class IncomeBloc extends Bloc<IncomeEvent, IncomeState> {
  final AddIncomeUsecases addIncome;
  final DeleteIncomeUsecases deleteIncome;
  final GetIncomeUsecases getIncomes;
  IncomeBloc(
      {required this.addIncome,
      required this.deleteIncome,
      required this.getIncomes})
      : super(IncomeInitial()) {
    on<LoadIncomeEvent>(_onLoadIncome);
    on<AddIncomeEvent>(_onAddIncome);
    on<DeleteIncomeEvent>(_onDeleteIncome);
  }

  Future<void> _onLoadIncome(
      LoadIncomeEvent event, Emitter<IncomeState> emit) async {
    emit(IncomeLoading());
    print("from income bloc 1");
    try {
      print("rrrrrr incomeaccount rrrrrrrrr ${event.accountID}");
      final incomes = await getIncomes(event.accountID);
      print("from income bloc 2");
      emit(IncomeLoaded(income: incomes));
      print("from income bloc 3");
    } catch (e) {
      print("error in fetch exp bloc $e");
      emit(IncomeError(e.toString()));
    }
  }

  //----

  Future<void> _onAddIncome(
      AddIncomeEvent event, Emitter<IncomeState> emit) async {
    emit(IncomeAddInProgress());
    try {
      print("from addincome bloc 1");
      await addIncome(event.income);
      print("from addincome bloc 2");
      add(LoadIncomeEvent(accountID: event.income.accountID));
      emit(IncomeAddSuccess());
      print("from addincome bloc 3");
    } catch (e) {
      print("error in bloc $e");
      emit(const IncomeAddError('Failed to create income'));
    }
  }

  //---

  Future<void> _onDeleteIncome(
      DeleteIncomeEvent event, Emitter<IncomeState> emit) async {
    emit(IncomeDeleteInProgress());
    try {
      print("from delincome bloc 1");
      await deleteIncome(event.accountID);
      emit(IncomeDeleteSuccess());
      
      // FIXED: Reload incomes after deletion
      final accountId = event.accountID;
      add(LoadIncomeEvent(accountID: accountId));
      
      print("from delincome bloc 2");
    } catch (e) {
      print("error in bloc $e");
      emit(IncomeDeleteError(e.toString()));  // FIXED: Added proper error state
    }
  }
}

