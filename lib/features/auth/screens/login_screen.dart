import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_booking_ticket/features/auth/bloc/auth_bloc.dart';
import 'package:movie_booking_ticket/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  String? _usernameError;
  String? _passwordError;

  @override
  void initState() {
    super.initState();

    // add đoạn này để kiểm tra tự động đăng nhập sau xác thực email
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final prefs = await SharedPreferences.getInstance();
      final autoLoginPending = prefs.getBool('auto_login_pending') ?? false;

      if (autoLoginPending) {
        final username = prefs.getString('verification_username');
        final password = prefs.getString('verification_password');

        if (username != null && password != null && mounted) {
          // Điền thông tin vào form
          _usernameController.text = username;
          _passwordController.text = password;

          // Hiển thị thông báo cho người dùng
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Xác thực email thành công! Đang đăng nhập...'),
              backgroundColor: Colors.green,
            ),
          );

          // Đợi một chút để người dùng thấy thông tin đã được điền
          await Future.delayed(const Duration(milliseconds: 800));

          if (mounted) {
            // Tự động đăng nhập
            context.read<AuthBloc>().add(
              LoginEvent(
                username: username,
                password: password,
              ),
            );
          }

          // Xóa dữ liệu tạm
          await prefs.remove('auto_login_pending');
          await prefs.remove('verification_username');
          await prefs.remove('verification_password');
        }
      }
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _validateLoginForm() {
    bool isValid = true;

    // Reset lỗi
    setState(() {
      _usernameError = null;
      _passwordError = null;
      _errorMessage = null;
    });

    // Validate username
    final username = _usernameController.text.trim();
    if (username.isEmpty) {
      setState(() {
        _usernameError = 'Vui lòng nhập tên đăng nhập';
      });
      isValid = false;
    } else if (username.length < 6) { // Đồng bộ với yêu cầu của backend
      setState(() {
        _usernameError = 'Tên đăng nhập phải có ít nhất 6 ký tự';
      });
      isValid = false;
    }

    // Validate password
    final password = _passwordController.text.trim();
    if (password.isEmpty) {
      setState(() {
        _passwordError = 'Vui lòng nhập mật khẩu';
      });
      isValid = false;
    } else if (password.length < 8) { // Đồng bộ với yêu cầu của backend
      setState(() {
        _passwordError = 'Mật khẩu phải có ít nhất 8 ký tự';
      });
      isValid = false;
    }

    return isValid;
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
                _usernameError = null;
                _passwordError = null;
                _errorMessage = null;
              });
            } else if (state.status == AuthStateStatus.authenticated) {
              setState(() {
                _isLoading = false;
              });
              context.go('/home');
            } else if (state.status == AuthStateStatus.error) {
              setState(() {
                _isLoading = false;

                // In ra lỗi đầy đủ để debug
                print("Lỗi đầy đủ từ backend: ${state.errorMessage}");

                final errorMsg = state.errorMessage?.toLowerCase() ?? '';

                // Xử lý lỗi 401 - Unauthorized (sai tài khoản hoặc mật khẩu)
                if (errorMsg.contains('401') ||
                    errorMsg.contains('unauthorized') ||
                    errorMsg.contains('invalid username or password') ||
                    errorMsg.contains('incorrect') ||
                    errorMsg.contains('wrong')) {
                  _errorMessage = 'Tên đăng nhập hoặc mật khẩu không đúng';
                }
                // Xử lý lỗi tài khoản chưa xác thực
                else if (errorMsg.contains('not verified') ||
                    errorMsg.contains('unverified') ||
                    errorMsg.contains('verify your email')) {
                  _errorMessage = 'Tài khoản chưa được xác thực. Vui lòng kiểm tra email của bạn';
                }
                // Xử lý lỗi tài khoản bị khóa
                else if (errorMsg.contains('locked') ||
                    errorMsg.contains('suspended') ||
                    errorMsg.contains('disabled')) {
                  _errorMessage = 'Tài khoản đã bị khóa. Vui lòng liên hệ hỗ trợ';
                }
                // Xử lý lỗi kết nối
                else if (errorMsg.contains('timeout') ||
                    errorMsg.contains('connection') ||
                    errorMsg.contains('network')) {
                  _errorMessage = 'Lỗi kết nối. Vui lòng kiểm tra lại đường truyền mạng';
                }
                // Lỗi server
                else if (errorMsg.contains('500') ||
                    errorMsg.contains('server error')) {
                  _errorMessage = 'Lỗi hệ thống. Vui lòng thử lại sau';
                }
                // Lỗi tổng quát
                else {
                  _errorMessage = 'Tên đăng nhập hoặc mật khẩu không đúng';
                }
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
                              errorText: _usernameError,
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
                                  errorText: _passwordError,
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
                                  if (_validateLoginForm()) {
                                    final username = _usernameController.text.trim();
                                    final password = _passwordController.text.trim();
                                    context.read<AuthBloc>().add(
                                      LoginEvent(
                                        username: username,
                                        password: password,
                                      ),
                                    );
                                  }
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
        String? errorText,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       CustomInputField(
        hint: hint,
        icon: ImageIcon(AssetImage(iconPath), color: tdWhite70),
        obscureText: isPassword,
        controller: controller,
        errorText: errorText,
          ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 4),
            child: Text(
              errorText,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomInputField extends StatelessWidget {
  final String hint;
  final Widget icon;
  final bool obscureText;
  final TextEditingController? controller;
  final String? errorText;

  const CustomInputField({
    super.key,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.controller,
    this.errorText,
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
        // add style cho trường hợp có lỗi
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: errorText != null
              ? const BorderSide(color: Colors.red, width: 1.0)
              : BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: errorText != null
              ? const BorderSide(color: Colors.red, width: 1.5)
              : const BorderSide(color: tdYellow, width: 1.5),
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