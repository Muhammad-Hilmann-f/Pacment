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
  
  // Biarkan inisialisasi AuthService seperti ini
  final _authService = AuthService(); // Menggunakan constructor default (tanpa parameter)

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
      
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();
      
      try {
        User? user = await _authService.loginWithEmail(email, password);
        
        if (user != null) {
          print('Login successful: ${user.uid}');
          Navigator.pushReplacementNamed(context, '/dashboard');
        } else {
          // Ini adalah fallback jika loginWithEmail mengembalikan null tanpa Exception
          _showErrorSnackBar('Login failed. Please check your credentials.');
        }
      } catch (e) {
        // Menangkap exception yang dilempar dari AuthService
        _showErrorSnackBar(e.toString()); 
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  // <--- TAMBAHKAN METHOD INI UNTUK GOOGLE SIGN-IN
  void _handleGoogleSignIn() async {
    setState(() => _isLoading = true);
    try {
      User? user = await _authService.signInWithGoogle(); // Panggil method Google Sign-In
      if (user != null) {
        print('Google Sign-In successful: ${user.uid}');
        Navigator.pushReplacementNamed(context, '/dashboard');
      } else {
        print('Google Sign-In cancelled or failed without explicit error.');
        _showErrorSnackBar('Google Sign-In cancelled or failed.'); // Pengguna membatalkan
      }
    } catch (e) {
      print('Google Sign-In error: $e');
      _showErrorSnackBar(e.toString()); // Menampilkan error dari proses Google Sign-In
    } finally {
      setState(() => _isLoading = false);
    }
  }

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
  onGooglePressed: _handleGoogleSignIn,
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