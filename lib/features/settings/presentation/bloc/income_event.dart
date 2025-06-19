part of 'income_bloc.dart';

sealed class IncomeEvent extends Equatable {
  const IncomeEvent();

  @override
  List<Object> get props => [];
}

class LoadIncomeEvent extends IncomeEvent {
  final String accountID;

  const LoadIncomeEvent({required this.accountID});
  @override
  List<Object> get props => [accountID];
}

class AddIncomeEvent extends IncomeEvent {
  final IncomeEntity income;

  AddIncomeEvent({required this.income});

  @override
  List<Object> get props => [income];
}

class DeleteIncomeEvent extends IncomeEvent {
  final String accountID;

  const DeleteIncomeEvent({required this.accountID});
  @override
  List<Object> get props => [accountID];
}
