part of 'limit_bloc.dart';

abstract class LimitEvent extends Equatable {
  const LimitEvent();

  @override
  List<Object> get props => [];
}

class AddLimitEvent extends LimitEvent {
  final LimitEntity limit;

  const AddLimitEvent({required this.limit});

  @override
  List<Object> get props => [limit];
}

class UpdateLimitEvent extends LimitEvent {
  final LimitEntity limit;

  const UpdateLimitEvent({required this.limit});

  @override
  List<Object> get props => [limit];
}

class DeleteLimitEvent extends LimitEvent {
  final String id;
  final String accountId;

  const DeleteLimitEvent({required this.id, required this.accountId});

  @override
  List<Object> get props => [id, accountId];
}

class GetLimitsEvent extends LimitEvent {
  final String accountId;

  const GetLimitsEvent({required this.accountId});

  @override
  List<Object> get props => [accountId];
}

class UpdateLimitSpendingEvent extends LimitEvent {
  final String id;
  final double amount;
  final String accountId;

  const UpdateLimitSpendingEvent({
    required this.id,
    required this.amount,
    required this.accountId,
  });

  @override
  List<Object> get props => [id, amount, accountId];
}