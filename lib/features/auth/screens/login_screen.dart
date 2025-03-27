import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_booking_ticket/theme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordHidden = true;

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
                        'Welcome Back!',
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
                        'welcome back we missed you',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: tdWhite70,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    buildLabel("Username"),
                    buildInputField("Username", 'assets/buttons/user-ic.png'),
                    buildLabel("Password"),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TextField(
                        obscureText: _isPasswordHidden,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: tdWhite24,
                          hintText: "Password",
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
                          'Forgot Password?',
                          style: TextStyle(color: tdWhite70),
                        ),
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
                        onPressed: () {
                          context.go('/home');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: ShaderMask(
                          shaderCallback:
                              (bounds) => LinearGradient(
                                colors: [tdWhite, tdWhite70],
                              ).createShader(bounds),
                          child: Text(
                            'Sign in',
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
                            'Or continue with',
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
                    SocialLoginButtons(),
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
                              'Don’t have an account? ',
                              style: GoogleFonts.poppins(color: tdWhite70),
                            ),
                            Text(
                              'Sign Up',
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

class CustomInputField extends StatelessWidget {
  final String hint;

  final Widget icon;
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
        prefixIcon: icon,
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
        socialButton('assets/buttons/google-ic.png'),
        SizedBox(width: 15),
        socialButton('assets/buttons/apple-ic.png'),
        SizedBox(width: 15),
        socialButton('assets/buttons/facebook-ic.png'),
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
        width: 55,
        height: 55,
        child: Center(child: Image.asset(asset, width: 55, height: 55)),
      ),
    );
  }
}
