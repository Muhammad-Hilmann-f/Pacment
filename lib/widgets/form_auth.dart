import 'package:flutter/material.dart';

class AuthForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController? confirmPasswordController; // Make optional
  final bool isLoading;
  final bool obscurePassword;
  final bool? obscureConfirmPassword; // Make optional
  final VoidCallback togglePasswordVisibility;
  final VoidCallback? toggleConfirmPasswordVisibility; // Make optional
  final VoidCallback onSubmit;
  final bool isLogin; // Add this to distinguish between login/register

  const AuthForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    this.confirmPasswordController,
    required this.isLoading,
    required this.obscurePassword,
    this.obscureConfirmPassword,
    required this.togglePasswordVisibility,
    this.toggleConfirmPasswordVisibility,
    required this.onSubmit,
    this.isLogin = true, // Default to login form
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
            controller: emailController,
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
            controller: passwordController,
            obscureText: obscurePassword,
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
                  obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white54,
                ),
                onPressed: togglePasswordVisibility,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          
          // Confirm Password Field (only for register)
          if (!isLogin) ...[
            const Text(
              'Confirm Password',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: confirmPasswordController,
              obscureText: obscureConfirmPassword ?? true,
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
                    (obscureConfirmPassword ?? true) ? Icons.visibility_off : Icons.visibility,
                    color: Colors.white54,
                  ),
                  onPressed: toggleConfirmPasswordVisibility ?? () {},
                ),
              ),
              validator: (value) {
                if (value != passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
          ],
          
          // Submit Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: isLoading ? null : onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4461F2),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      isLogin ? 'Login' : 'Sign Up',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}