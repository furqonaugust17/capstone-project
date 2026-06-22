part of 'submit_game_cubit.dart';

abstract class SubmitGameState extends Equatable {
  const SubmitGameState();

  @override
  List<Object?> get props => [];
}

class SubmitGameInitial extends SubmitGameState {}

class SubmitGameLoading extends SubmitGameState {}

class SubmitGameSuccess extends SubmitGameState {
  final GameSessionEntity session;

  const SubmitGameSuccess({required this.session});

  @override
  List<Object?> get props => [session];
}

class SubmitGameError extends SubmitGameState {
  final String message;

  const SubmitGameError({required this.message});

  @override
  List<Object?> get props => [message];
}
