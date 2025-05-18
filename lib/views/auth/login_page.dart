import 'package:flutter/material.dart';
import 'package:pacment/widgets/sosial_button.dart';
import '../../widgets/custom_text_field.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1339),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
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
                    'Access account',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Social Login Buttons
                SosialButton(
                  onFacebookPressed: () {
                    // Handle Facebook login
                  },
                  onGooglePressed: () {
                    // Handle Google login
                  },
                ),
                
                // Email Field
                const Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'example@gmail.com',
                    hintStyle: const TextStyle(color: Colors.white38),
                    filled: true,
                    fillColor: Colors.white10,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                
                // Password Field
                const Text(
                  'Password',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: '••••••',
                    hintStyle: const TextStyle(color: Colors.white38),
                    filled: true,
                    fillColor: Colors.white10,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: Colors.white54,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                
                // Sign In Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() => _isLoading = true);
                        // Handle login
                        // Simulate login process
                        await Future.delayed(const Duration(seconds: 2));
                        setState(() => _isLoading = false);
                        // Navigate to home page
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4461F2),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Register Link
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: const Text.rich(
                      TextSpan(
                        text: "Don't have an account? ",
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
      ),
    );
  }
}