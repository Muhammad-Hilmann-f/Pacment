import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../widgets/sosial_button.dart';
import '../../widgets/form_auth.dart';
import '../../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService(); // Initialize AuthService
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      // Get email and password
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();
      
      // Login using AuthService
      User? user = await _authService.loginWithEmail(email, password);
      
      if (user != null) {
        print('Login successful: ${user.uid}');
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        print('Login failed');
        // Show error message to user
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login failed. Please check your credentials.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1339),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              // Tombol Back
            IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white,)),
              // Title
              const Center(
                child: Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Subtitle
              const Center(
                child: Text(
                  'Access your account',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Social Login Options
              SosialButton(
                onFacebookPressed: () {
                  // Handle Facebook login
                },
                onGooglePressed: () {
                  // Handle Google login
                },
              ),
              
              // Auth Form
              AuthForm(
                formKey: _formKey,
                emailController: _emailController,
                passwordController: _passwordController,
                isLoading: _isLoading,
                obscurePassword: _obscurePassword,
                togglePasswordVisibility: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
                onSubmit: _handleSubmit,
                isLogin: true,
              ),
              
              const SizedBox(height: 24),
              
              // register Link
              Center(
                child: TextButton(
                  onPressed: () { Navigator.pushNamed(context, '/register'); },
                  child: const Text.rich(
                    TextSpan(
                      text: 'Dont have an account? ',
                      style: TextStyle(color: Colors.white54),
                      children: [
                        TextSpan(
                          text: 'Register',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w600,
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
      ),
    );
  }
}