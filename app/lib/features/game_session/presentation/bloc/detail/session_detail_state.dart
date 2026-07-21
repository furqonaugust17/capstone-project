part of 'session_detail_cubit.dart';

abstract class SessionDetailState extends Equatable {
  const SessionDetailState();

  @override
  List<Object?> get props => [];
}

class SessionDetailInitial extends SessionDetailState {}

class SessionDetailLoading extends SessionDetailState {}

class SessionDetailSuccess extends SessionDetailState {
  final GameSessionEntity session;

  const SessionDetailSuccess({required this.session});

  @override
  List<Object?> get props => [session];
}

class SessionDetailError extends SessionDetailState {
  final String message;

  const SessionDetailError({required this.message});

  @override
  List<Object?> get props => [message];
}
