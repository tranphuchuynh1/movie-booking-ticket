import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_booking_ticket/features/auth/bloc/auth_bloc.dart';
import 'package:movie_booking_ticket/theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordHidden = true;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => AuthBloc(),
      child: BlocConsumer<AuthBloc, AuthState>(

      listener: (context, state) {
      if (state.status == AuthStateStatus.loading) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
        });
      }   else if (state.status == AuthStateStatus.authenticated) {
        setState(() {
      _isLoading = false;
      });
        context.go('/home');
      } else if (state.status == AuthStateStatus.error) {
      setState(() {
      _isLoading = false;
      _errorMessage = state.errorMessage ?? 'Đăng nhập thất bại';
       });
     }
    },
        builder: (context, state) {
        bool isLoading = state.status == AuthStateStatus.loading;
          return Scaffold(
              body: Stack(
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/maleficent.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.2),
                              Colors.black.withOpacity(0.8),
                              Colors.black.withOpacity(1),
                            ],
                            stops: [0.0, 0.2, 0.8, 1.0],
                          ),
                        ),
                      ),
                    ),
                  ),

                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.7,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [tdBlack, tdGreyDark],
                        ),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(30),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Center(
                              child: Text(
                                'Chào Mừng Quay Trở Lại!',
                                style: GoogleFonts.poppins(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: tdWhite,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Center(
                              child: Text(
                                'Rất Vui Khi Gặp Bạn',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: tdWhite70,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            buildLabel("Tài Khoản"),
                            buildInputField(
                              "Tên tài khoản",
                              'assets/buttons/user-ic.png',
                              controller: _usernameController,
                            ),
                            buildLabel("Mật Khẩu"),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: TextField(
                                controller: _passwordController,
                                obscureText: _isPasswordHidden,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: tdWhite24,
                                  hintText: "Mật Khẩu",
                                  hintStyle: const TextStyle(color: tdWhite54),
                                  prefixIcon: ImageIcon(
                                    AssetImage('assets/buttons/key-ic.png'),
                                    color: tdWhite70,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isPasswordHidden
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: tdWhite70,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordHidden = !_isPasswordHidden;
                                      });
                                    },
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                style: const TextStyle(color: tdWhite),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {},
                                child: const Text(
                                  'Quên Mật Khẩu?',
                                  style: TextStyle(color: tdWhite70),
                                ),
                              ),
                            ),
                            if (_errorMessage != null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Text(
                                  _errorMessage!,
                                  style: TextStyle(color: Colors.red),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            const SizedBox(height: 10),
                            Container(
                              height: 50,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [tdBrown, tdYellow],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ElevatedButton(
                                onPressed: _isLoading
                                    ? null
                                    : () {
                                  final username = _usernameController.text.trim();
                                  final password = _passwordController.text.trim();

                                  if (username.isEmpty || password.isEmpty) {
                                    setState(() {
                                      _errorMessage = 'Vui lòng nhập đầy đủ tên đăng nhập và mật khẩu';
                                    });
                                    return;
                                  }

                                  context.read<AuthBloc>().add(
                                    LoginEvent(
                                      username: username,
                                      password: password,
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: _isLoading
                                    ? CircularProgressIndicator(color: tdWhite)
                                    : ShaderMask(
                                  shaderCallback: (bounds) => LinearGradient(
                                    colors: [tdWhite, tdWhite70],
                                  ).createShader(bounds),
                                  child: Text(
                                    'Đăng Nhập',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: tdWhite,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [Colors.transparent, Colors.white24],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    'Đăng nhập với',
                                    style: GoogleFonts.poppins(color: tdWhite70),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    height: 1,
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [Colors.white24, Colors.transparent],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            const SocialLoginButtons(),

                            const SizedBox(height: 10),
                            Center(
                              child: TextButton(
                                onPressed: () {
                                  context.go('/register');
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Bạn chưa có tài khoản? ',
                                      style: GoogleFonts.poppins(color: tdWhite70),
                                    ),
                                    Text(
                                      'Đăng Ký',
                                      style: GoogleFonts.poppins(color: tdWhite),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ));
        }, )
    );
  }



  Widget buildLabel(String text) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(top: 10, bottom: 4),
      child: Text(
        text,
        style: GoogleFonts.poppins(fontSize: 13, color: Colors.white),
      ),
    );
  }

  Widget buildInputField(
      String hint,
      String iconPath, {
        bool isPassword = false,
        TextEditingController? controller,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: CustomInputField(
        hint: hint,
        icon: ImageIcon(AssetImage(iconPath), color: tdWhite70),
        obscureText: isPassword,
        controller: controller,
      ),
    );
  }
}

class CustomInputField extends StatelessWidget {
  final String hint;
  final Widget icon;
  final bool obscureText;
  final TextEditingController? controller;

  const CustomInputField({
    super.key,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        filled: true,
        fillColor: tdWhite24,
        hintText: hint,
        hintStyle: const TextStyle(color: tdWhite54),
        prefixIcon: icon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      style: const TextStyle(color: tdWhite),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const CustomButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [tdBrown, tdYellow],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(vertical: 16),
        ),
        child: ShaderMask(
          shaderCallback:
              (bounds) => LinearGradient(
            colors: [tdWhite, tdWhite70],
          ).createShader(bounds),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: tdWhite,
            ),
          ),
        ),
      ),
    );
  }
}

class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _socialButton(
          asset: 'assets/buttons/google-ic.png',
          onTap: () => print('Clicked Google'),
        ),
        const SizedBox(width: 15),
        _socialButton(
          asset: 'assets/buttons/apple-ic.png',
          onTap: () => print('Clicked Apple'),
        ),
        const SizedBox(width: 15),
        _socialButton(
          asset: 'assets/buttons/facebook-ic.png',
          onTap: () => print('Clicked Facebook'),
        ),
      ],
    );
  }

  Widget _socialButton({required String asset, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 58,
        height: 44,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF2B2B2B), Color(0xFF000000)],
          ),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade800),
        ),
        child: Center(child: Image.asset(asset, width: 20, height: 20)),
      ),
    );
  }
}