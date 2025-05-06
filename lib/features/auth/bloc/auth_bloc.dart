import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_booking_ticket/core/dio/dio_client.dart';
import 'package:movie_booking_ticket/features/auth/controllers/auth_controller.dart';
import 'package:movie_booking_ticket/features/auth/controllers/save_token_user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    on<VerifyEmailEvent>(_onVerifyEmail);

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

      // Xử lý lỗi chi tiết hơn
      String errorMessage = e.toString();

      // Nếu lỗi là từ Dio (HTTP errors)
      if (e is DioException) {
        final statusCode = e.response?.statusCode;

        // Đối với lỗi 401 - Unauthorized
        if (statusCode == 401) {
          errorMessage = 'Tên đăng nhập hoặc mật khẩu không đúng';
        }
        // Đối với lỗi 403 - Forbidden (có thể là tài khoản chưa xác thực)
        else if (statusCode == 403) {
          errorMessage = 'Tài khoản chưa được xác thực hoặc bị khóa';
        }
        // Đối với lỗi 404 - Not Found
        else if (statusCode == 404) {
          errorMessage = 'Tài khoản không tồn tại';
        }
        // Đối với lỗi 500 - Server Error
        else if (statusCode == 500) {
          errorMessage = 'Lỗi hệ thống, vui lòng thử lại sau';
        }
        // Đối với các lỗi kết nối
        else if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.sendTimeout) {
          errorMessage = 'Không thể kết nối tới máy chủ, vui lòng kiểm tra kết nối mạng';
        }
      }

      emit(
        state.copyWith(
          status: AuthStateStatus.error,
          errorMessage: errorMessage,
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
      await _authController.register(
        event.username,
        event.email,
        event.password,
        event.confirmPassword,
      );

      // Thay vì tự động đăng nhập, chuyển sang trạng thái verification
      emit(state.copyWith(status: AuthStateStatus.verification));
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

  // Xử lý xác thực email
  Future<void> _onVerifyEmail(VerifyEmailEvent event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStateStatus.loading));

    try {
      // Gọi API xác thực token
      final success = await _authController.verifyEmail(
          event.email,
          event.token
      );

      if (success) {
        // Nếu xác thực thành công, lưu trạng thái để RegisterScreen biết
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('email_verified', true);
        await prefs.setString('verification_username', event.username);

        // Nếu có lưu mật khẩu khi đăng ký
        if (event.password != null) {
          await prefs.setString('verification_password', event.password ?? '');
        }

        // Tự động đăng nhập
        final user = await _authController.login(event.username, event.password ?? "");
        await SaveTokenUserService.saveUser(user);
        emit(state.copyWith(status: AuthStateStatus.authenticated, user: user));
      } else {
        emit(
          state.copyWith(
            status: AuthStateStatus.error,
            errorMessage: "Xác thực email không thành công",
          ),
        );
      }
    } catch (e) {
      print("Email Verification Error: ${e.toString()}");
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
