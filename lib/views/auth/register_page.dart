import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../widgets/sosial_button.dart';
import '../../widgets/form_auth.dart';
import '../../services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _authService = AuthService(); // Initialize AuthService
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Ambil email dan password dari controller
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();

      // Registrasi pengguna menggunakan AuthService
      User? user = await _authService.registerWithEmail(email, password);

      if (user != null) {
        print('Registrasi berhasil: ${user.uid}');
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        print('Registrasi gagal');
        // Show error message to user
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration failed. Please try again.'),
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
                  'Register',
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
                  'Create your account',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Social Register Options
              SosialButton(
                onFacebookPressed: () {
                  // Handle Facebook login
                },
                onGooglePressed: () {
                  // Handle Google login
                },
              ),
              //auth form 
              AuthForm(
                formKey: _formKey,
                emailController: _emailController,
                passwordController: _passwordController,
                confirmPasswordController: _confirmPasswordController,
                isLoading: _isLoading,
                obscurePassword: _obscurePassword,
                obscureConfirmPassword: _obscureConfirmPassword,
                togglePasswordVisibility: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
                toggleConfirmPasswordVisibility: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
                onSubmit: _handleSubmit,
                isLogin: false,
              ),
              const SizedBox(height: 24),
              
              // Login Link
              Center(
                child: TextButton(
                  onPressed: () { Navigator.pushNamed(context, '/login'); },
                  child: const Text.rich(
                    TextSpan(
                      text: 'Already have an account? ',
                      style: TextStyle(color: Colors.white54),
                      children: [
                        TextSpan(
                          text: 'Login',
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