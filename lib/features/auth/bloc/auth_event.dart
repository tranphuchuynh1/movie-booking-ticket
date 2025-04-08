part of 'auth_bloc.dart';

abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String username;
  final String password;

  LoginEvent({
    required this.username,
    required this.password,
  });
}

class RegisterEvent extends AuthEvent {
  final String username;
  final String email;
  final String password;
  final String confirmPassword;

  RegisterEvent({
    required this.username,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });
}

class CheckAuthEvent extends AuthEvent {
  final bool showLoading;

  CheckAuthEvent({this.showLoading = false});
}

class LogoutEvent extends AuthEvent {}