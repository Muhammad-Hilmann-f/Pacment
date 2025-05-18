import 'package:flutter/material.dart';

class SosialButton extends StatelessWidget {
  final Function()? onFacebookPressed;
  final Function()? onGooglePressed;
  
  const SosialButton({
    super.key,
    this.onFacebookPressed,
    this.onGooglePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Facebook login button
            Container(
              width: 60,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                icon: const Icon(Icons.facebook, color: Colors.white),
                onPressed: onFacebookPressed,
              ),
            ),
            const SizedBox(width: 16),
            // Google login button
            Container(
              width: 60,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                icon: const Icon(Icons.g_mobiledata, color: Colors.white, size: 36),
                onPressed: onGooglePressed,
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 20),
        // Or login with email
        const Text(
          'or login with email',
          style: TextStyle(
            fontSize: 12,
            color: Colors.white54,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}