part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}
abstract class AuthActionState extends AuthState{}
final class AuthInitial extends AuthState {}


class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final String uid;
  Authenticated({required this.uid});
}

class UnAuthenticated extends AuthState {}

class AuthError extends AuthActionState {
  final String error;
  AuthError({required this.error});
}