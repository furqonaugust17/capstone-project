import 'package:equatable/equatable.dart';
import '../../domain/entities/user_statistic_entity.dart';

sealed class StatisticsState extends Equatable {
  const StatisticsState();

  @override
  List<Object> get props => [];
}

class StatisticsInitial extends StatisticsState {}

class StatisticsLoading extends StatisticsState {}

class StatisticsLoaded extends StatisticsState {
  final UserStatisticEntity statistics;

  const StatisticsLoaded(this.statistics);

  @override
  List<Object> get props => [statistics];
}

class StatisticsError extends StatisticsState {
  final String message;

  const StatisticsError(this.message);

  @override
  List<Object> get props => [message];
}
