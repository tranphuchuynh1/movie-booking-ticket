import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_booking_ticket/theme.dart';
import 'package:movie_booking_ticket/features/auth/bloc/auth_bloc.dart';

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


  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
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
            // hiển thị loading indicator
          } else if (state.status == AuthStateStatus.authenticated) {
            print("log: auth success, navigating to home");
            context.go('/home');
          } else if (state.status == AuthStateStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Registration failed')),
            );
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
                          buildEmailField(),
                          buildLabel("Your Name"),
                          buildUsernameField(),
                          buildLabel("Password"),
                          buildPasswordField(),
                          buildLabel("Confirm Password"),
                          buildConfirmPasswordField(),
                          const SizedBox(height: 20),
                          state.status == AuthStateStatus.loading
                              ? const Center(child: CircularProgressIndicator(color: tdYellow))
                              : buildRegisterButton(context),
                          const SizedBox(height: 20),
                          buildDivider(),
                          const SizedBox(height: 15),
                          buildSocialButtons(),
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
      child: TextField(
        controller: _emailController,
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
        ),
        style: const TextStyle(color: tdWhite),
      ),
    );
  }

  Widget buildUsernameField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: _usernameController,
        decoration: InputDecoration(
          filled: true,
          fillColor: tdWhite24,
          hintText: "Your Name",
          hintStyle: const TextStyle(color: tdWhite54),
          prefixIcon: ImageIcon(
            const AssetImage('assets/buttons/user-ic.png'),
            color: tdWhite70,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        style: const TextStyle(color: tdWhite),
      ),
    );
  }

  Widget buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: _passwordController,
        obscureText: _isPasswordHidden,
        decoration: InputDecoration(
          filled: true,
          fillColor: tdWhite24,
          hintText: "Enter your password!",
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
        ),
        style: const TextStyle(color: tdWhite),
      ),
    );
  }

  Widget buildConfirmPasswordField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: _confirmPasswordController,
        obscureText: _isConfirmPasswordHidden,
        decoration: InputDecoration(
          filled: true,
          fillColor: tdWhite24,
          hintText: "Confirm your password!",
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
        ),
        style: const TextStyle(color: tdWhite),
      ),
    );
  }

  Widget buildRegisterButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final username = _usernameController.text.trim();
        final email = _emailController.text.trim();
        final password = _passwordController.text.trim();
        final confirmPassword = _confirmPasswordController.text.trim();

        // Validate inputs
        if (username.isEmpty || email.isEmpty || password.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please fill in all fields')),
          );
          return;
        }

        if (password != confirmPassword) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Passwords do not match')),
          );
          return;
        }

        print("RegisterScreen: Dispatching RegisterEvent");
        context.read<AuthBloc>().add(
          RegisterEvent(
            username: username,
            email: email,
            password: password,
            confirmPassword: confirmPassword,
          ),
        );
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
          'Sign up',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: tdWhite,
          ),
        ),
      ),
    );
  }

  Widget buildDivider() {
    return Row(
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
    );
  }

  Widget buildSocialButtons() {
    // We need to implement the SocialLoginButtons widget
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildSocialButton('assets/buttons/google-ic.png'),
        const SizedBox(width: 20),
        buildSocialButton('assets/buttons/facebook-ic.png'),
        const SizedBox(width: 20),
        buildSocialButton('assets/buttons/apple-ic.png'),
      ],
    );
  }

  Widget buildSocialButton(String iconPath) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: tdWhite24,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Image.asset(iconPath, width: 24, height: 24),
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
              'Already have an account? ',
              style: GoogleFonts.poppins(color: tdWhite70),
            ),
            Text(
              'Sign In',
              style: GoogleFonts.poppins(color: tdWhite),
            ),
          ],
        ),
      ),
    );
  }
}