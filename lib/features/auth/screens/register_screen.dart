import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_booking_ticket/theme.dart';
import 'login_screen.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.3,
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
                      Colors.black,
                    ],
                    stops: [0.0, 0.3, 0.7, 1.0],
                  ),
                ),
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.8,
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
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        'Get Started Free',
                        style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        'Free Forever. No Credit Card Needed',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: tdWhite70,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    buildLabel("Email Address"),
                    buildInputField(
                      "yourname@gmail.com",
                      'assets/buttons/mail-ic.png',
                    ),
                    buildLabel("Your Name"),
                    buildInputField("Your Name", 'assets/buttons/user-ic.png'),
                    buildLabel("Password"),
                    buildInputField(
                      "Password",
                      'assets/buttons/key-ic.png',
                      isPassword: true,
                    ),
                    buildLabel("Confirm Password"),
                    buildInputField(
                      "Nhập lại một khẩu",
                      'assets/buttons/key-ic.png',
                      isPassword: true,
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () => context.go('/'),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [tdBrown, tdYellow],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Sign up',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        'Or sign up with',
                        style: GoogleFonts.poppins(color: tdWhite70),
                      ),
                    ),
                    const SizedBox(height: 15),
                    SocialLoginButtons(),
                    const SizedBox(height: 10),
                    Center(
                      child: TextButton(
                        onPressed: () => context.go('/'),
                        child: Text(
                          'Already have an account? Sign In',
                          style: GoogleFonts.poppins(color: tdWhite70),
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
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: CustomInputField(
        hint: hint,
        icon: ImageIcon(AssetImage(iconPath), color: tdWhite70),
        obscureText: isPassword,
      ),
    );
  }
}
