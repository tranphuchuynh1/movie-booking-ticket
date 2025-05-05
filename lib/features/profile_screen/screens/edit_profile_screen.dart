import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_booking_ticket/theme.dart';
import 'package:movie_booking_ticket/core/models/auth/user_model.dart';

import '../../auth/controllers/save_token_user_service.dart';
import '../components/image_picker_until.dart';
import '../controllers/edit_profile_controller.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  // Khởi tạo controller xử lý token
  late final EditProfileController _controller;

  UserModel? _currentUser;
  File? _selectedImage;
  bool _isLoading = true;
  bool _isSaving = false;
  String? _errorMessage;
  bool _isControllerInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = EditProfileController();
    _initializeAndLoadData();
  }

  Future<void> _initializeAndLoadData() async {
    // Đợi một chút để controller khởi tạo hoàn tất
    await Future.delayed(const Duration(milliseconds: 500));
    _isControllerInitialized = true;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final user = await SaveTokenUserService.getUser();
      setState(() {
        _currentUser = user;
        _nameController.text = user?.fullName ?? '';
        _emailController.text = user?.email ?? '';
        _phoneController.text = user?.phoneNumber ?? '';
        _isLoading = false;
      });

      debugPrint('Đã tải thông tin người dùng:');
      debugPrint('userId: ${user?.userId}');
      debugPrint('userName: ${user?.userName}');
      debugPrint('fullName: ${user?.fullName}');
      debugPrint('email: ${user?.email}');
      debugPrint('phoneNumber: ${user?.phoneNumber}');
      debugPrint('avatarUrl: ${user?.avatarUrl}');
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Không thể tải thông tin người dùng';
      });
      debugPrint('Error loading user data: $e');
    }
  }

  Future<void> _pickImage() async {
    final pickedImage = await ImagePickerUtil.showImagePickerDialog(context);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = pickedImage;
      });
      debugPrint('Đã chọn ảnh mới: ${pickedImage.path}');
    }
  }

  Future<void> _saveProfile() async {
    if (_currentUser == null) {
      debugPrint('Lỗi: _currentUser là null');
      return;
    }
    if (!_isControllerInitialized) {
      debugPrint('Lỗi: Controller chưa được khởi tạo hoàn tất');
      setState(() {
        _errorMessage = 'Đang khởi tạo hệ thống, vui lòng thử lại sau';
      });
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      debugPrint('Đang lưu thông tin hồ sơ:');
      debugPrint('userId: ${_currentUser!.userId}');
      debugPrint('fullName: ${_nameController.text}');
      debugPrint('phoneNumber: ${_phoneController.text}');
      debugPrint('currentAvatarUrl: ${_currentUser!.avatarUrl}');
      debugPrint('newAvatarImage: ${_selectedImage?.path}');

      if (_currentUser!.userId == null || _currentUser!.userId!.isEmpty) {
        setState(() {
          _errorMessage = 'UserId không hợp lệ';
          _isSaving = false;
        });
        return;
      }

      final updatedUser = await _controller.completeProfileUpdate(
        userId: _currentUser!.userId!,
        fullName: _nameController.text,
        phoneNumber: _phoneController.text,
        currentAvatarUrl: _currentUser!.avatarUrl ?? '',
        newAvatarImage: _selectedImage,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Hồ sơ đã được cập nhật thành công'),
          backgroundColor: Colors.green,
        ),
      );
      context.go('/profile');

    } catch (e) {
      setState(() {
        _errorMessage = 'Đã xảy ra lỗi: $e';
        _isSaving = false;
      });
      debugPrint('Error saving profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBlack,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            if (_isLoading)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(color: Colors.deepOrange),
                ),
              )
            else
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          CircleAvatar(
                            radius: 48,
                            backgroundImage: _selectedImage != null
                                ? FileImage(_selectedImage!) as ImageProvider
                                : (_currentUser?.avatarUrl != null && _currentUser!.avatarUrl!.isNotEmpty && _currentUser!.avatarUrl!.startsWith('http'))
                                ? NetworkImage(_currentUser!.avatarUrl!)
                                : AssetImage('assets/images/dora.png') as ImageProvider,
                          ),
                          Positioned(
                            bottom: 0,
                            right: -7,
                            child: GestureDetector(
                              onTap: _pickImage,
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

                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                        ),

                      // Full Name
                      _buildTextField(
                        controller: _nameController,
                        labelText: 'Tên Người Dùng',
                        icon: Icons.person_outline,
                      ),
                      const SizedBox(height: 16),

                      // Email (disabled - email cannot be changed)
                      _buildTextField(
                        controller: _emailController,
                        labelText: 'Email',
                        icon: Icons.email_outlined,
                        enabled: false,
                      ),
                      const SizedBox(height: 16),

                      // Phone
                      _buildTextField(
                        controller: _phoneController,
                        labelText: 'Số Điện Thoại',
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
                          onPressed: _isSaving ? null : _saveProfile,
                          child: _isSaving
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.0,
                            ),
                          )
                              : const Text(
                            'Lưu',
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
            'Chỉnh Sửa Hồ Sơ',
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool enabled = true,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: tdWhite),
      cursorColor: Colors.deepOrange,
      enabled: enabled,
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
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade800),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}