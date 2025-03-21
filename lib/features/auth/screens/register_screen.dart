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
                    stops: [0.0, 0.3, 0.7, 1.0],
                  ),
                ),
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.7,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [tdBlack, tdGreyDark],
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Get Started Free',
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Free Forever. No Credit Card Needed',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: tdWhite70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    CustomInputField(hint: 'Email Address', icon: Icons.email),
                    const SizedBox(height: 20),
                    CustomInputField(hint: 'Your Name', icon: Icons.person),
                    const SizedBox(height: 20),
                    CustomInputField(
                      hint: 'Password',
                      icon: Icons.lock,
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      label: 'Sign up',
                      onPressed: () {
                        context.go('/');
                      },
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'Or sign up with',
                      style: GoogleFonts.poppins(color: tdWhite70),
                    ),
                    const SizedBox(height: 20),
                    SocialLoginButtons(),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        context.go('/');
                      },
                      child: Text(
                        'Already have an account? Sign In',
                        style: TextStyle(color: tdWhite70),
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
}
