import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_booking_ticket/theme.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController(
    text: 'Huynh Nhon Vlog',
  );
  final TextEditingController _emailController = TextEditingController(
    text: 'huynhnhon@example.com',
  );
  final TextEditingController _phoneController = TextEditingController(
    text: '0123 456 789',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBlack,

      body: SafeArea(
        child: Column(
          children: [
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
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          CircleAvatar(
                            radius: 48,
                            backgroundImage: AssetImage(
                              'assets/images/dora.png',
                            ),
                          ),

                          Positioned(
                            bottom: 0,
                            right: -7,
                            child: GestureDetector(
                              onTap: () {
                                debugPrint('Choosse image');
                              },
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: tdWhite,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  color: tdBlack,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // Full Name
                      _buildTextField(
                        controller: _nameController,
                        labelText: 'Full Name',
                        icon: Icons.person_outline,
                      ),
                      const SizedBox(height: 16),

                      // Email
                      _buildTextField(
                        controller: _emailController,
                        labelText: 'Email',
                        icon: Icons.email_outlined,
                      ),
                      const SizedBox(height: 16),

                      // Phone
                      _buildTextField(
                        controller: _phoneController,
                        labelText: 'Mobile Number',
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 32),

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
                            'Save',
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

  /// Header tùy biến (giống ProfileScreen), không dùng AppBar
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 45, 16, 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              context.go('/profile');
            },
            child: const Icon(Icons.arrow_back, color: tdWhite),
          ),
          const Spacer(),
          const Text(
            'Edit Profile',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: tdWhite,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 24),
        ],
      ),
    );
  }

  /// TextField style nền đen, viền xám, focus cam
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: tdWhite),
      cursorColor: Colors.deepOrange,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.grey.shade400),
        prefixIcon: Icon(icon, color: Colors.grey.shade400),
        filled: true,
        fillColor: Colors.grey.shade900,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
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
