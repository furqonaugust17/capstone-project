import 'package:equatable/equatable.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class AuthRegisterRequested extends AuthEvent {
  final String username;
  final String email;
  final String password;
  final String? displayName;

  const AuthRegisterRequested({
    required this.username,
    required this.email,
    required this.password,
    this.displayName,
  });

  @override
  List<Object?> get props => [username, email, password, displayName];
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

class AuthPointsDeducted extends AuthEvent {
  final int pointsToDeduct;

  const AuthPointsDeducted(this.pointsToDeduct);

  @override
  List<Object?> get props => [pointsToDeduct];
}
