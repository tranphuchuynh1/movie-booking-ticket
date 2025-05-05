import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_booking_ticket/theme.dart';
import 'package:dio/dio.dart';

import '../../auth/controllers/save_token_user_service.dart';
import '../controllers/change_password_controller.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  bool _isLoading = false;
  String? _errorMessage;

  final ChangePasswordController _controller = ChangePasswordController(


    providedDio: Dio(
      BaseOptions(
        connectTimeout: const Duration(milliseconds: 30000),
        receiveTimeout: const Duration(milliseconds: 30000),
        headers: {
          'Content-Type': 'application/json',

        },
      ),
    ),
  );

  Future<void> _changePassword() async {
    // Validate form first
    if (!_validateForm()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Get current user from local storage
      final currentUser = await SaveTokenUserService.getUser();
      if (currentUser == null) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Không thể xác định người dùng hiện tại';
        });
        return;
      }

      // Call API to change password
      final success = await _controller.changePassword(
        userId: currentUser.userId ?? '',
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
      );

      if (success) {
        if (!mounted) return;

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Mật khẩu đã được thay đổi thành công'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate back to profile
        context.go('/profile');
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        if (_errorMessage!.startsWith('Exception: ')) {
          _errorMessage = _errorMessage!.substring(11); // Remove 'Exception: ' prefix
        }
      });

      // Xử lý trường hợp phiên đăng nhập hết hạn
      if (_errorMessage != null && _errorMessage!.contains('Phiên đăng nhập hết hạn')) {
        if (!mounted) return;

        // Hiển thị dialog xác nhận đăng nhập lại
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.black,
            title: const Text(
              'Phiên đăng nhập hết hạn',
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              'Vui lòng đăng nhập lại để tiếp tục.',
              style: TextStyle(color: Colors.white70),
            ),
            actions: [
              TextButton(
                child: const Text(
                  'Đăng nhập',
                  style: TextStyle(color: Colors.deepOrange),
                ),
                onPressed: () {
                  // Xóa thông tin người dùng hiện tại
                  SaveTokenUserService.clearUser();
                  // Chuyển đến màn hình đăng nhập
                  context.go('/');
                },
              ),
            ],
          ),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool _validateForm() {
    // Reset error message
    setState(() {
      _errorMessage = null;
    });

    // Validate current password
    if (_currentPasswordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Vui lòng nhập mật khẩu hiện tại';
      });
      return false;
    }

    // Validate new password
    final newPasswordError = _controller.validatePassword(_newPasswordController.text);
    if (newPasswordError != null) {
      setState(() {
        _errorMessage = newPasswordError;
      });
      return false;
    }

    // Validate confirm password
    final confirmPasswordError = _controller.validateConfirmPassword(
        _newPasswordController.text,
        _confirmPasswordController.text
    );
    if (confirmPasswordError != null) {
      setState(() {
        _errorMessage = confirmPasswordError;
      });
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header tùy biến, không dùng AppBar
            _buildHeader(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 60),

                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),

                    // Current Password
                    _buildPasswordField(
                      label: 'Mật Khẩu Hiện Tại',
                      controller: _currentPasswordController,
                      obscureText: _obscureCurrent,
                      onToggle: () {
                        setState(() {
                          _obscureCurrent = !_obscureCurrent;
                        });
                      },
                    ),
                    const SizedBox(height: 26),

                    // New Password
                    _buildPasswordField(
                      label: 'Mật Khẩu Mới',
                      controller: _newPasswordController,
                      obscureText: _obscureNew,
                      onToggle: () {
                        setState(() {
                          _obscureNew = !_obscureNew;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildPasswordRequirements(),
                    const SizedBox(height: 2),

                    // Confirm New Password
                    _buildPasswordField(
                      label: 'Xác Nhận Mật Khẩu Mới',
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirm,
                      onToggle: () {
                        setState(() {
                          _obscureConfirm = !_obscureConfirm;
                        });
                      },
                    ),
                    const SizedBox(height: 52),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: _isLoading ? null : _changePassword,
                        child: _isLoading
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.0,
                          ),
                        )
                            : const Text(
                          'Lưu Thay Đổi',
                          style: TextStyle(color: tdWhite, fontSize: 16),
                        ),
                      ),
                    ),
                    // Add padding at the bottom to ensure the button is not covered by keyboard
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              context.go('/profile');
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                shape: BoxShape.circle,
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.arrow_back, color: Colors.white, size: 20),
              ),
            ),
          ),
          const Spacer(),
          const Text(
            'Đổi Mật Khẩu',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: tdWhite,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 24),
        ],
      ),
    );
  }

  Widget _buildPasswordRequirements() {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade800.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade700),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Yêu cầu mật khẩu:',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '• Ít nhất 8 ký tự\n'
                '• Ít nhất 1 chữ cái thường (a-z)\n'
                '• Ít nhất 1 chữ cái in hoa (A-Z)\n'
                '• Ít nhất 1 chữ số (0-9)\n'
                '• Ít nhất 1 ký tự đặc biệt (!@#\$%^&*(),.?":{}|<>)',
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }


  Widget _buildPasswordField({
    required String label,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback onToggle,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: tdWhite),
      cursorColor: Colors.deepOrange,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey.shade400),
        filled: true,
        fillColor: Colors.grey.shade900,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
        prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
          onPressed: onToggle,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade700),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.deepOrange),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}