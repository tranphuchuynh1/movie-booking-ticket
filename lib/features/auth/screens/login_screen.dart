import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_booking_ticket/features/auth/screens/register_screen.dart';
import 'package:movie_booking_ticket/theme.dart';
import '../../select_seat_movie/screens/select_seat_movie_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
                      'Welcome Back!',
                      style: GoogleFonts.poppins(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: tdWhite,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'welcome back we missed you',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: tdWhite70,
                      ),
                    ),
                    const SizedBox(height: 40),
                    CustomInputField(hint: 'Username', icon: Icons.person),
                    const SizedBox(height: 20),
                    CustomInputField(
                      hint: 'Password',
                      icon: Icons.lock,
                      obscureText: true,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(color: tdWhite70),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      label: 'Sign in',
                      onPressed: () {
                        context.go('/home');
                      },
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'Or continue with',
                      style: GoogleFonts.poppins(color: tdWhite70),
                    ),
                    const SizedBox(height: 20),
                    SocialLoginButtons(),
                    Spacer(),
                    TextButton(
                      onPressed: () {
                        context.go('/register');
                      },
                      child: Text(
                        'Don’t have an account? Sign Up',
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

class CustomInputField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final bool obscureText;

  const CustomInputField({
    super.key,
    required this.hint,
    required this.icon,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      decoration: InputDecoration(
        filled: true,
        fillColor: tdWhite24,
        hintText: hint,
        hintStyle: const TextStyle(color: tdWhite54),
        prefixIcon: Icon(icon, color: tdWhite70),
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
      width: double.infinity,
      height: 45,
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
              fontSize: 18,
              fontWeight: FontWeight.bold,
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
        socialButton('assets/images/google.png'),
        SizedBox(width: 15),
        socialButton('assets/images/apple.png'),
        SizedBox(width: 15),
        socialButton('assets/images/facebook.png'),
      ],
    );
  }

  Widget socialButton(String asset) {
    return GestureDetector(
      onTapDown: (details) {},
      onTap: () {
        print("Clicked: $asset");
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 150),
        width: 45,
        height: 40,
        decoration: BoxDecoration(
          color: tdWhite.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: tdGreyDark.withOpacity(0.3),
              blurRadius: 4,
              spreadRadius: 0.5,
              offset: Offset(2, 2),
            ),
          ],
          border: Border.all(color: tdWhite.withOpacity(0.1)),
        ),
        child: Center(child: Image.asset(asset, width: 28, height: 28)),
      ),
    );
  }
}
