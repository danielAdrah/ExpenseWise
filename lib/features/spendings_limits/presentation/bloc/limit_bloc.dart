import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/limit_entity.dart';
import '../../domain/usecases/add_limit_usecase.dart';
import '../../domain/usecases/delete_limit_usecase.dart';
import '../../domain/usecases/get_limits_usecase.dart';
import '../../domain/usecases/update_limit_usecase.dart';
import '../../domain/usecases/update_limit_spending_usecase.dart';

part 'limit_event.dart';
part 'limit_state.dart';

class LimitBloc extends Bloc<LimitEvent, LimitState> {
  final AddLimitUseCase addLimit;
  final UpdateLimitUseCase updateLimit;
  final DeleteLimitUseCase deleteLimit;
  final GetLimitsUseCase getLimits;
  final UpdateLimitSpendingUseCase updateLimitSpending;

  LimitBloc({
    required this.addLimit,
    required this.updateLimit,
    required this.deleteLimit,
    required this.getLimits,
    required this.updateLimitSpending,
  }) : super(LimitInitial()) {
    on<AddLimitEvent>(_onAddLimit);
    on<UpdateLimitEvent>(_onUpdateLimit);
    on<DeleteLimitEvent>(_onDeleteLimit);
    on<GetLimitsEvent>(_onGetLimits);
    on<UpdateLimitSpendingEvent>(_onUpdateLimitSpending);
  }

  Future<void> _onAddLimit(AddLimitEvent event, Emitter<LimitState> emit) async {
    emit(AddLimitInProgress());
    try {
      await addLimit(event.limit);
      emit(AddLimitSuccess());
      add(GetLimitsEvent(accountId: event.limit.accountId));
    } catch (e) {
      emit(AddLimitError(e.toString()));
    }
  }

  Future<void> _onUpdateLimit(UpdateLimitEvent event, Emitter<LimitState> emit) async {
    emit(UpdateLimitInProgress());
    try {
      await updateLimit(event.limit);
      emit(UpdateLimitSuccess());
      add(GetLimitsEvent(accountId: event.limit.accountId));
    } catch (e) {
      emit(UpdateLimitError(e.toString()));
    }
  }

  Future<void> _onDeleteLimit(DeleteLimitEvent event, Emitter<LimitState> emit) async {
    emit(DeleteLimitInProgress());
    try {
      await deleteLimit(event.id);
      emit(DeleteLimitSuccess());
      add(GetLimitsEvent(accountId: event.accountId));
    } catch (e) {
      emit(DeleteLimitError(e.toString()));
    }
  }

  Future<void> _onGetLimits(GetLimitsEvent event, Emitter<LimitState> emit) async {
    emit(LimitLoading());
    try {
      final limits = await getLimits(event.accountId);
      emit(LimitsLoaded(limits));
    } catch (e) {
      emit(LimitError(e.toString()));
    }
  }

  Future<void> _onUpdateLimitSpending(UpdateLimitSpendingEvent event, Emitter<LimitState> emit) async {
    emit(UpdateLimitSpendingInProgress());
    try {
      await updateLimitSpending(event.id, event.amount);
      emit(UpdateLimitSpendingSuccess());
      add(GetLimitsEvent(accountId: event.accountId));
    } catch (e) {
      emit(UpdateLimitSpendingError(e.toString()));
    }
  }
}