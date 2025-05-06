import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_booking_ticket/theme.dart';
import 'package:movie_booking_ticket/features/auth/bloc/auth_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _isPasswordHidden = true;
  bool _isConfirmPasswordHidden = true;

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _usernameError;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? _generalError;

  // add biến để hiển thị thông báo xác thực email
  bool _showEmailVerificationMessage = false;
  // add biến này để theo dõi trạng thái xác thực
  bool _isVerificationSuccess = false;

  @override
  void initState() {
    super.initState();
    // Kiểm tra trạng thái xác thực ngay khi màn hình được tạo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupDeepLinkListener();
    });
  }



  void _setupDeepLinkListener() async {
    // Lấy thông tin từ SharedPreferences để kiểm tra xác thực
    final prefs = await SharedPreferences.getInstance();
    final verificationStatus = prefs.getBool('email_verified') ?? false;
    final username = prefs.getString('verification_username');
    final password = prefs.getString('verification_password');

    if (verificationStatus && username != null && password != null && mounted) {
      setState(() {
        _showEmailVerificationMessage = true;
        _isVerificationSuccess = true;
      });

      // Hiện thông báo thành công
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Xác thực email thành công! Đang đăng nhập...'),
          backgroundColor: Colors.green,
        ),
      );

      // Tự động đăng nhập sau 1 giây
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          context.read<AuthBloc>().add(
            LoginEvent(
              username: username,
              password: password,
            ),
          );
        }
      });

      // Xóa thông tin xác thực đã dùng
      await prefs.remove('email_verified');
      await prefs.remove('verification_username');
      await prefs.remove('verification_password');
    }
  }


  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  // add phương thức validate
  bool _validateRegisterForm() {
    bool isValid = true;

    // Reset lỗi
    setState(() {
      _usernameError = null;
      _emailError = null;
      _passwordError = null;
      _confirmPasswordError = null;
      _generalError = null;
    });

    // Validate username
    final username = _usernameController.text.trim();
    if (username.isEmpty) {
      setState(() {
        _usernameError = 'Vui lòng nhập tên đăng nhập';
      });
      isValid = false;
    } else if (username.length < 6) {
      setState(() {
        _usernameError = 'Tên đăng nhập phải có ít nhất 6 ký tự';
      });
      isValid = false;
    } else if (username.contains(' ')) {
      setState(() {
        _usernameError = 'Tên đăng nhập không được chứa khoảng trắng';
      });
      isValid = false;
    }

    // Validate email
    final email = _emailController.text.trim();
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (email.isEmpty) {
      setState(() {
        _emailError = 'Vui lòng nhập email';
      });
      isValid = false;
    } else if (!emailRegex.hasMatch(email)) {
      setState(() {
        _emailError = 'Email không hợp lệ';
      });
      isValid = false;
    }

    // Validate password với yêu cầu mạnh hơn phù hợp với backend
    final password = _passwordController.text.trim();
    if (password.isEmpty) {
      setState(() {
        _passwordError = 'Vui lòng nhập mật khẩu';
      });
      isValid = false;
    } else if (password.length < 8) { // Sửa từ 6 lên 8 nếu backend yêu cầu 8
      setState(() {
        _passwordError = 'Mật khẩu phải có ít nhất 8 ký tự';
      });
      isValid = false;
    } else if (!password.contains(RegExp(r'[A-Z]'))) {
      // Check chữ in hoa
      setState(() {
        _passwordError = 'Mật khẩu cần có ít nhất một chữ in hoa';
      });
      isValid = false;
    } else if (!password.contains(RegExp(r'[0-9]'))) {
      // Check số
      setState(() {
        _passwordError = 'Mật khẩu cần có ít nhất một chữ số';
      });
      isValid = false;
    } else if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      // Check ký tự đặc biệt
      setState(() {
        _passwordError = 'Mật khẩu cần có ít nhất một ký tự đặc biệt';
      });
      isValid = false;
    }

    // Validate confirm password
    final confirmPassword = _confirmPasswordController.text.trim();
    if (confirmPassword.isEmpty) {
      setState(() {
        _confirmPasswordError = 'Vui lòng xác nhận mật khẩu';
      });
      isValid = false;
    } else if (confirmPassword != password) {
      setState(() {
        _confirmPasswordError = 'Mật khẩu xác nhận không khớp';
      });
      isValid = false;
    }

    return isValid;
  }

  Future<void> _saveCredentials(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pending_username', username);
    await prefs.setString('pending_password', password);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: BlocConsumer<AuthBloc, AuthState>(
        listenWhen: (previous, current) =>
        current.status != previous.status,
        listener: (context, state) {
          if (state.status == AuthStateStatus.loading) {
            // Hiển thị loading indicator
          } else if (state.status == AuthStateStatus.authenticated) {
            print("log: auth success, navigating to home");
            context.go('/home');
          } else if (state.status == AuthStateStatus.verification) {
            // Hiển thị thông báo xác thực email
            setState(() {
              _showEmailVerificationMessage = true;
              _isVerificationSuccess = false; // Chắc chắn rằng trạng thái là chưa xác thực
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Đăng ký thành công! Vui lòng xác thực email của bạn.'),
                backgroundColor: Colors.green,
              ),
            );

            // Lưu thông tin đăng nhập để sau khi xác thực có thể tự động đăng nhập
            final username = _usernameController.text.trim();
            final password = _passwordController.text.trim();
            _saveCredentials(username, password);
          }
          else if (state.status == AuthStateStatus.error) {
            // Parse and display specific error messages based on error text

            print("Lỗi đầy đủ từ backend: ${state.errorMessage}");
            setState(() {
              // Chuyển đổi thông điệp lỗi thành chữ thường để dễ so sánh
              final errorMsg = state.errorMessage?.toLowerCase() ?? '';


              String debugErrorContent = "Debug - Nội dung lỗi: $errorMsg";
              print(debugErrorContent);

              if (errorMsg.contains('email') &&
                  (errorMsg.contains('exists') ||
                      errorMsg.contains('already') ||
                      errorMsg.contains('taken') ||
                      errorMsg.contains('used') ||
                      errorMsg.contains('existed') ||
                      errorMsg.contains('registered') ||
                      errorMsg.contains('đã tồn tại') ||
                      errorMsg.contains('đã được') ||
                      errorMsg.contains('đã sử dụng'))) {
                _emailError = 'Email đã được sử dụng';
              }
              else if (errorMsg.contains('username') &&
                  (errorMsg.contains('exists') ||
                      errorMsg.contains('already') ||
                      errorMsg.contains('taken'))) {
                _usernameError = 'Tên đăng nhập đã tồn tại';
              }

              // Try parsing JSON error messages if possible
              if (errorMsg.contains('400') || errorMsg.contains('bad request')) {
                if (errorMsg.contains('username') &&
                    (errorMsg.contains('exists') || errorMsg.contains('already taken'))) {
                  _usernameError = 'Tên đăng nhập đã tồn tại';
                }
                else if (errorMsg.contains('email') &&
                    (errorMsg.contains('exists') || errorMsg.contains('already taken'))) {
                  _emailError = 'Email đã được sử dụng';
                }
                else if (errorMsg.contains('username') && errorMsg.contains('length')) {
                  _usernameError = 'Tên đăng nhập phải có ít nhất 6 ký tự';
                }
                else if (errorMsg.contains('password')) {
                  if (errorMsg.contains('uppercase') || errorMsg.contains('chữ in hoa')) {
                    _passwordError = 'Mật khẩu cần có ít nhất một chữ in hoa';
                  }
                  else if (errorMsg.contains('digit') || errorMsg.contains('số')) {
                    _passwordError = 'Mật khẩu cần có ít nhất một chữ số';
                  }
                  else if (errorMsg.contains('special') || errorMsg.contains('đặc biệt')) {
                    _passwordError = 'Mật khẩu cần có ít nhất một ký tự đặc biệt';
                  }
                  else if (errorMsg.contains('match') || errorMsg.contains('không khớp')) {
                    _confirmPasswordError = 'Mật khẩu xác nhận không khớp';
                  }
                  else {
                    _passwordError = 'Mật khẩu không hợp lệ';
                  }
                }
                else if (errorMsg.contains('email') &&
                    (errorMsg.contains('invalid') || errorMsg.contains('không hợp lệ'))) {
                  _emailError = 'Email không hợp lệ';
                }
                else {
                  // Lỗi chung khi không xác định được nguyên nhân cụ thể
                  _generalError = 'Đăng ký không thành công, vui lòng kiểm tra lại thông tin';
                }
              }
              else {
                // Lỗi server khác hoặc lỗi kết nối
                _generalError = 'Không thể kết nối đến máy chủ, vui lòng thử lại sau';
              }

              // Hiển thị thông báo lỗi chung nếu không xác định được trường cụ thể
              if (_generalError != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(_generalError!),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            });
          }
        },

        builder: (context, state) {
          return Scaffold(
            body: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Container(
                    decoration: const BoxDecoration(
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
                          stops: const [0.0, 0.2, 0.8, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
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
                          const SizedBox(height: 10),
                          Center(
                            child: Text(
                              'Bắt Đầu Đăng Ký Miễn Phí',
                              style: GoogleFonts.poppins(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              'Miễn phí mãi mãi. Không cần thẻ tín dụng'
                              ,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: tdWhite70,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          buildLabel("Email"),
                          buildEmailField(),
                          buildLabel("Tài Khoản"),
                          buildUsernameField(),
                          buildLabel("Mật Khẩu"),
                          buildPasswordField(),
                          buildLabel("Nhập Lại Mật Khẩu"),
                          buildConfirmPasswordField(),
                          const SizedBox(height: 20),
                          state.status == AuthStateStatus.loading
                              ? const Center(child: CircularProgressIndicator(color: tdYellow))
                              : buildRegisterButton(context,state),
                          const SizedBox(height: 10),
                          buildLoginLink(context),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
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

  Widget buildEmailField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hiển thị thông báo xác thực email
          if (_showEmailVerificationMessage)
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _isVerificationSuccess
                    ? Colors.green.withOpacity(0.3)
                    : Colors.green.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _isVerificationSuccess
                      ? Colors.green.withOpacity(0.7)
                      : Colors.green.withOpacity(0.5),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 16
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _isVerificationSuccess
                          ? 'Bạn đã đăng ký thành công!'
                          : 'Vui lòng vào email của bạn để xác thực tài khoản',
                      style: GoogleFonts.poppins(
                        color: Colors.green,
                        fontSize: 12,
                        fontWeight: _isVerificationSuccess ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              filled: true,
              fillColor: tdWhite24,
              hintText: "yourname@gmail.com",
              hintStyle: const TextStyle(color: tdWhite54),
              prefixIcon: ImageIcon(
                const AssetImage('assets/buttons/mail-ic.png'),
                color: tdWhite70,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              // Thêm style cho trường hợp có lỗi
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: _emailError != null
                    ? const BorderSide(color: Colors.red, width: 1.0)
                    : BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: _emailError != null
                    ? const BorderSide(color: Colors.red, width: 1.5)
                    : const BorderSide(color: tdYellow, width: 1.5),
              ),
            ),
            style: const TextStyle(color: tdWhite),
          ),
          if (_emailError != null)
            Padding(
              padding: const EdgeInsets.only(left: 12, top: 4),
              child: Text(
                _emailError!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildUsernameField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _usernameController,
            decoration: InputDecoration(
              filled: true,
              fillColor: tdWhite24,
              hintText: "Tên tài khoản",
              hintStyle: const TextStyle(color: tdWhite54),
              prefixIcon: ImageIcon(
                const AssetImage('assets/buttons/user-ic.png'),
                color: tdWhite70,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              // Thêm border màu đỏ khi có lỗi
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: _usernameError != null
                    ? const BorderSide(color: Colors.red, width: 1.0)
                    : BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: _usernameError != null
                    ? const BorderSide(color: Colors.red, width: 1.5)
                    : const BorderSide(color: tdYellow, width: 1.5),
              ),
            ),
            style: const TextStyle(color: tdWhite),
          ),
          // Hiển thị thông báo lỗi
          if (_usernameError != null)
            Padding(
              padding: const EdgeInsets.only(left: 12, top: 4),
              child: Text(
                _usernameError!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _passwordController,
            obscureText: _isPasswordHidden,
            decoration: InputDecoration(
              filled: true,
              fillColor: tdWhite24,
              hintText: "Nhập mật khẩu",
              hintStyle: const TextStyle(color: tdWhite54),
              prefixIcon: ImageIcon(
                const AssetImage('assets/buttons/key-ic.png'),
                color: tdWhite70,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordHidden ? Icons.visibility_off : Icons.visibility,
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
              // Thêm border màu đỏ khi có lỗi
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: _passwordError != null
                    ? const BorderSide(color: Colors.red, width: 1.0)
                    : BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: _passwordError != null
                    ? const BorderSide(color: Colors.red, width: 1.5)
                    : const BorderSide(color: tdYellow, width: 1.5),
              ),
            ),
            style: const TextStyle(color: tdWhite),
          ),
          // Hiển thị thông báo lỗi
          if (_passwordError != null)
            Padding(
              padding: const EdgeInsets.only(left: 12, top: 4),
              child: Text(
                _passwordError!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildConfirmPasswordField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _confirmPasswordController,
            obscureText: _isConfirmPasswordHidden,
            decoration: InputDecoration(
              filled: true,
              fillColor: tdWhite24,
              hintText: "Nhập lại mật khẩu",
              hintStyle: const TextStyle(color: tdWhite54),
              prefixIcon: ImageIcon(
                const AssetImage('assets/buttons/key-ic.png'),
                color: tdWhite70,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _isConfirmPasswordHidden ? Icons.visibility_off : Icons.visibility,
                  color: tdWhite70,
                ),
                onPressed: () {
                  setState(() {
                    _isConfirmPasswordHidden = !_isConfirmPasswordHidden;
                  });
                },
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              // Thêm border màu đỏ khi có lỗi
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: _confirmPasswordError != null
                    ? const BorderSide(color: Colors.red, width: 1.0)
                    : BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: _confirmPasswordError != null
                    ? const BorderSide(color: Colors.red, width: 1.5)
                    : const BorderSide(color: tdYellow, width: 1.5),
              ),
            ),
            style: const TextStyle(color: tdWhite),
          ),
          // Hiển thị thông báo lỗi
          if (_confirmPasswordError != null)
            Padding(
              padding: const EdgeInsets.only(left: 12, top: 4),
              child: Text(
                _confirmPasswordError!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildRegisterButton(BuildContext context,AuthState state) {
    return GestureDetector(
      onTap: state.status == AuthStateStatus.loading
          ? null
          : () {
        if (_validateRegisterForm()) {
          final username = _usernameController.text.trim();
          final email = _emailController.text.trim();
          final password = _passwordController.text.trim();
          final confirmPassword = _confirmPasswordController.text.trim();

          print("RegisterScreen: Dispatching RegisterEvent");
          context.read<AuthBloc>().add(
            RegisterEvent(
              username: username,
              email: email,
              password: password,
              confirmPassword: confirmPassword,
            ),
          );
        }
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [tdBrown, tdYellow],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: const Text(
          'Đăng Ký',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: tdWhite,
          ),
        ),
      ),
    );
  }


  Widget buildLoginLink(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () => context.go('/'),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bạn đã có tài khoản? ',
              style: GoogleFonts.poppins(color: tdWhite70),
            ),
            Text(
              'Đăng Nhập',
              style: GoogleFonts.poppins(color: tdWhite),
            ),
          ],
        ),
      ),
    );
  }
}