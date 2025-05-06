import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/auth_bloc.dart';

class VerificationSuccessScreen extends StatelessWidget {
  const VerificationSuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state.status == AuthStateStatus.authenticated) {
            // Nếu xác thực thành công, chuyển đến trang chủ
            context.go('/home');
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 72),
              SizedBox(height: 24),
              Text(
                'Xác thực thành công!',
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'Đang chuyển đến trang chủ...',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              SizedBox(height: 32),
              CircularProgressIndicator(color: Colors.green),
            ],
          ),
        ),
      ),
    );
  }
}