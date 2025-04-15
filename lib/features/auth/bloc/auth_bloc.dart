import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_booking_ticket/core/dio/dio_client.dart';
import 'package:movie_booking_ticket/features/auth/controllers/auth_controller.dart';
import 'package:movie_booking_ticket/features/auth/controllers/save_token_user_service.dart';

import '../../../core/models/auth/user_model.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthController _authController = AuthController(
    dio: DioClient.instance,
  );

  AuthBloc({bool checkAuthOnInit = true}) : super(AuthState()) {
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<LogoutEvent>(_onLogout);
    on<CheckAuthEvent>(_onCheckAuth);

    if (checkAuthOnInit) {
      add(CheckAuthEvent(showLoading: false));
    }
  }

  Future<void> _onCheckAuth(
    CheckAuthEvent event,
    Emitter<AuthState> emit,
  ) async {
    if (event.showLoading) {
      emit(state.copyWith(status: AuthStateStatus.loading));
    }

    try {
      final isLoggedIn = await SaveTokenUserService.isLoggedIn();
      print("CheckAuth: isLoggedIn = $isLoggedIn");

      if (isLoggedIn) {
        final user = await SaveTokenUserService.getUser();
        emit(state.copyWith(status: AuthStateStatus.authenticated, user: user));
      } else {
        emit(state.copyWith(status: AuthStateStatus.unauthenticated));
      }
    } catch (e) {
      print("CheckAuth Error: ${e.toString()}");
      emit(
        state.copyWith(
          status: AuthStateStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onLogin(LoginEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStateStatus.loading));
    print("Login: Attempting login for ${event.username}");

    try {
      final user = await _authController.login(event.username, event.password);

      // Lưu thông tin user
      await SaveTokenUserService.saveUser(user);
      print("Login: User data saved");

      emit(state.copyWith(status: AuthStateStatus.authenticated, user: user));
    } catch (e) {
      print("Login Error: ${e.toString()}");
      emit(
        state.copyWith(
          status: AuthStateStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStateStatus.loading));
    print(
      "Register: Attempting register for ${event.username}, email: ${event.email}",
    );

    try {
      final user = await _authController.register(
        event.username,
        event.email,
        event.password,
        event.confirmPassword,
      );

      await SaveTokenUserService.saveUser(user);
      print("Register: User data saved");

      emit(state.copyWith(status: AuthStateStatus.authenticated, user: user));
    } catch (e) {
      print("Register Error: ${e.toString()}");
      emit(
        state.copyWith(
          status: AuthStateStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    print("Logout: Clearing user data");
    await SaveTokenUserService.clearUser();
    emit(AuthState());
  }
}
