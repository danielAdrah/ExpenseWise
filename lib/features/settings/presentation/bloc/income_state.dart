part of 'income_bloc.dart';

sealed class IncomeState extends Equatable {
  const IncomeState();

  @override
  List<Object> get props => [];
}

final class IncomeInitial extends IncomeState {}

final class IncomeLoading extends IncomeState {}

final class IncomeLoaded extends IncomeState {
  final List<IncomeEntity> income;

  const IncomeLoaded({required this.income});
  @override
  List<Object> get props => [income];
}

class IncomeError extends IncomeState {
  final String message;
  const IncomeError(this.message);
  @override
  List<Object> get props => [message];
}

//=====

final class IncomeAddInProgress extends IncomeState {}

final class IncomeAddSuccess extends IncomeState {}

final class IncomeAddError extends IncomeState {
  final String errormessage;
  const IncomeAddError(this.errormessage);
  @override
  List<Object> get props => [errormessage];
}

final class IncomeDeleteSuccess extends IncomeState {}

final class IncomeDeleteInProgress extends IncomeState {}
