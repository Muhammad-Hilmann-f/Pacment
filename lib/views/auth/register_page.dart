import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import '../../widgets/sosial_button.dart';
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

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      // ✅ FIXED: Use registerWithEmail instead of loginWithEmail
      User? user = await _authService.registerWithEmail(email, password);

      if (user != null) {
        // ✅ Registration successful, show success message
        print('Registration successful: ${user.uid}');
        _showSuccessSnackBar('Registration successful! Please check your email for verification.');
        
        // Navigate back to login page instead of dashboard
        // since email needs to be verified first
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        // Fallback if registerWithEmail returns null without error
        _showErrorSnackBar('Registration failed. Please try again.');
      }
    } catch (e) {
      // ❌ Handle and display error to user
      _showErrorSnackBar(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }
}

// Add this helper method for success messages
void _showSuccessSnackBar(String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
      duration: const Duration(seconds: 4),
    ),
  );
}
  // // <--- TAMBAHKAN METHOD INI UNTUK GOOGLE SIGN-IN
  // void _handleGoogleSignIn() async {
  //   setState(() => _isLoading = true);
  //   try {
  //     User? user = await _authService.signInWithGoogle(); // Panggil method Google Sign-In
  //     if (user != null) {
  //       print('Google Sign-In successful: ${user.uid}');
  //       Navigator.pushReplacementNamed(context, '/dashboard');
  //     } else {
  //       print('Google Sign-In cancelled or failed without explicit error.');
  //       _showErrorSnackBar('Google Sign-In cancelled or failed.'); // Pengguna membatalkan
  //     }
  //   } catch (e) {
  //     print('Google Sign-In error: $e');
  //     _showErrorSnackBar(e.toString()); // Menampilkan error dari proses Google Sign-In
  //   } finally {
  //     setState(() => _isLoading = false);
  //   }
  // }

  // Helper untuk menampilkan SnackBar
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
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
              // SosialButton(
              //   onGooglePressed: _handleGoogleSignIn, // <--- PANGGIL METHOD INI
              // ),
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