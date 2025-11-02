import 'package:pdsolucoes_front_end/domain/entities/user_entity.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final UserEntity user;
  final String token;

  AuthAuthenticated({
    required this.user,
    required this.token,
  });
}

class AuthError extends AuthState {
  final String message;

  AuthError({required this.message});
}

class ForgotPasswordSuccess extends AuthState {
  final String message;

  ForgotPasswordSuccess({required this.message});
}




