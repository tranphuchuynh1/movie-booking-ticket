import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_booking_ticket/theme.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: SafeArea(
        child: Column(
          children: [
            // Header tùy biến, không dùng AppBar
            _buildHeader(),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 24,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 60),
                      _buildPasswordField(
                        label: 'Change Password',
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
                        label: 'New Password',
                        controller: _newPasswordController,
                        obscureText: _obscureNew,
                        onToggle: () {
                          setState(() {
                            _obscureNew = !_obscureNew;
                          });
                        },
                      ),
                      const SizedBox(height: 26),

                      // Confirm Password
                      _buildPasswordField(
                        label: 'Confirm Password',
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
                          onPressed: () {},
                          child: const Text(
                            'Change Password',
                            style: TextStyle(color: tdWhite, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 45, 16, 16),
      child: Row(
        children: [
          // Nút back
          GestureDetector(
            onTap: () {
              context.go('/profile');
            },
            child: const Icon(Icons.arrow_back, color: tdWhite),
          ),
          const Spacer(),
          const Text(
            'Change Password',
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
