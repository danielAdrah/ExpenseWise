import 'package:equatable/equatable.dart';

abstract class StatisticsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadStatisticsEvent extends StatisticsEvent {
  final String accountId;
  
  LoadStatisticsEvent({required this.accountId});
  
  @override
  List<Object?> get props => [accountId];
}