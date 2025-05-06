part of 'auth_bloc.dart';

enum AuthStateStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  verification,
  error,
}

class AuthState {
  final AuthStateStatus status;
  final UserModel? user;
  final String? errorMessage;

  AuthState({
    this.status = AuthStateStatus.initial,
    this.user,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStateStatus? status,
    UserModel? user,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage,
    );
  }
}