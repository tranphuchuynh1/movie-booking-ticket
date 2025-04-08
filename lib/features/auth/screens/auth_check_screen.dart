
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_booking_ticket/features/auth/bloc/auth_bloc.dart';
import 'package:movie_booking_ticket/theme.dart';

class AuthCheckScreen extends StatefulWidget {
  const AuthCheckScreen({Key? key}) : super(key: key);

  @override
  State<AuthCheckScreen> createState() => _AuthCheckScreenState();
}

class _AuthCheckScreenState extends State<AuthCheckScreen> {
  @override
  void initState() {
    super.initState();
    // kích hoạt kiểm tra xác thực ngay khi màn hình được tạo
    // đặt showLoading = false vì màn hình này đã có UI loading
    context.read<AuthBloc>().add(CheckAuthEvent(showLoading: false));
  }


  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStateStatus.authenticated) {
          context.go('/home');
        }
        else if (state.status == AuthStateStatus.unauthenticated) {
          context.go('/');
        }
        else if (state.status == AuthStateStatus.error) {
          context.go('/');
        }
      },
      child: Scaffold(
        backgroundColor: tdBlack,
        body: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(tdYellow),
          ),
        ),
      ),
    );
  }
}
