import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_booking_ticket/core/widgets/bottom_nav_bar.dart';
import 'package:movie_booking_ticket/theme.dart';

import '../../auth/bloc/auth_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Tạo các biến trạng thái cho từng menu có sub menu
  bool _isAccountExpanded = false;
  bool _isSettingsExpanded = false;
  bool _isAboutExpanded = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => AuthBloc(),
    child:  Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildProfileInfo(),
            const SizedBox(height: 20),
            _buildMenuItems(),
            const Spacer(),
            const BottomNavBar(selectedIndex: 3),
          ],
        ),
      ),
    ));
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 45, 16, 36),
      child: Row(
        children: const [
          Expanded(
            child: Text(
              'My Profile',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Column(
      children: [
        const CircleAvatar(
          radius: 40,
          backgroundImage: AssetImage('assets/images/dora.png'),
        ),
        const SizedBox(height: 12),
        const Text(
          'Huynh Nhon Vlog',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildMenuItems() {
    return Column(
      children: [
        _buildMenuItem(
          icon: Icons.person_outline,
          title: 'Account',
          subtitle: 'Edit Profile\nChange Password',
          isExpanded: _isAccountExpanded,
          onTap: () {
            setState(() {
              _isAccountExpanded = !_isAccountExpanded;
              // _isSettingsExpanded = false;
              // _isAboutExpanded = false;
            });
          },
        ),
        const SizedBox(height: 16),
        _buildMenuItem(
          icon: Icons.settings_outlined,
          title: 'Settings',
          subtitle: 'Themes\nPermissions',
          isExpanded: _isSettingsExpanded,
          onTap: () {
            setState(() {
              _isSettingsExpanded = !_isSettingsExpanded;
              // _isAccountExpanded = false;
              // _isAboutExpanded = false;
            });
          },
        ),
        const SizedBox(height: 16),
        _buildMenuItem(
          icon: Icons.info_outline,
          title: 'About',
          subtitle: 'About Movies\nMore',
          isExpanded: _isAboutExpanded,
          onTap: () {
            setState(() {
              _isAboutExpanded = !_isAboutExpanded;
              // _isAccountExpanded = false;
              // _isSettingsExpanded = false;
            });
          },
        ),
        const SizedBox(height: 16),
        _buildLogoutItem(),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isExpanded,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Tile chính
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: tdBlack,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade800),
                  ),
                  child: Icon(icon, color: tdWhite, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: tdWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (!isExpanded)
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
                AnimatedRotation(
                  turns: isExpanded ? 0.25 : 0.0,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.only(left: 56.0, right: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
                  subtitle.split('\n').map((subItem) {
                    return GestureDetector(
                      onTap: () {
                        if (title == 'Account' && subItem == 'Edit Profile') {
                          context.go('/edit_profile');
                        }
                        if (title == 'Account' &&
                            subItem == 'Change Password') {
                          context.go('/change_password');
                        }
                        // if (title == 'Settings' && subItem == 'Themes') {
                        //   context.go('/themes');
                        // }
                        // if (title == 'Settings' &&
                        //     subItem == 'Permissions') {
                        //   context.go('/permissions');
                        // }
                        // if (title == 'About' && subItem == 'About Movies') {
                        //   context.go('/about_movies');
                        // }
                        // if (title == 'About' && subItem == 'More') {
                        //   context.go('/more');
                        // }
                        else {
                          debugPrint('Item selected: $subItem');
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          subItem,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
      ],
    );
  }

  Widget _buildLogoutItem() {
    return GestureDetector(
      onTap: () => _showLogoutDialog(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade800),
              ),
              child: const Icon(Icons.logout, color: Colors.red, size: 20),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Text(
                'Logout',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.red, size: 20),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            width: 280,
            height: 192,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade800, width: 1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                const CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 20,
                  child: Icon(
                    Icons.question_mark,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Are you sure you want to\nlog out?',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 16),
                Container(height: 1, color: Colors.grey.shade800),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          child: Text(
                            'Cancel',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.deepOrange,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 48,
                      color: Colors.grey.shade800,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          context.read<AuthBloc>().add(LogoutEvent());
                          context.go('/');
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 14),
                          child: Text(
                            'OK',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.deepOrange,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
